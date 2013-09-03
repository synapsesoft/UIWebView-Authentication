//
//  UWAInjector.m
//  UIWebViewAuthentication
//
//  Copyright (c) 2013 Synapsesoft Inc. All rights reserved.
//

#import "UWAHandler.h"

#import <UIKit/UIKit.h>
#import "SGURLProtocol.h"

@interface UWAHandler() <SGHTTPAuthDelegate>
@property(nonatomic, weak) UIWebView* webView;
@property(nonatomic) UIAlertView* alertView;
@property(nonatomic) NSURLAuthenticationChallenge* authenticationChallenge;
@property(nonatomic) NSURLCredential* challengedCredential;
@end

@implementation UWAHandler

#pragma mark - public

- (id)initWithWebView:(UIWebView *)webView
{
  self = [super init];
  if(self){
    _webView = webView;
    _alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authentication Required", nil)
                                            message:@""
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  otherButtonTitles:NSLocalizedString(@"Log In", nil), nil];
    _persistence = NSURLCredentialPersistencePermanent;
    [SGHTTPURLProtocol registerProtocol];
    [SGHTTPURLProtocol setAuthDelegate:self];
  }
  return self;
}

- (void)cleanup
{
  [SGHTTPURLProtocol unregisterProtocol];
  [SGHTTPURLProtocol setAuthDelegate:nil];
}

- (void)dealloc
{
  [self cleanup];
}

#pragma mark - SGHTTPAuthDelegate

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  NSURLCredential* credential = [[NSURLCredentialStorage sharedCredentialStorage] defaultCredentialForProtectionSpace:challenge.protectionSpace];
  if(credential && challenge.previousFailureCount == 1){
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    return;
  }
  
  self.authenticationChallenge = challenge;
  [self showAlert];
}

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveResponse:(NSURLResponse *)response
{
  if([(NSHTTPURLResponse *)response statusCode] != 200){
    DLog(@"HTTP %d", [(NSHTTPURLResponse *)response statusCode]);
  }
  
  if([self.authenticationChallenge.protectionSpace.protocol isEqualToString:response.URL.scheme] &&
     [self.authenticationChallenge.protectionSpace.host isEqualToString:response.URL.host]){
    
    if(self.challengedCredential && self.authenticationChallenge && [(NSHTTPURLResponse *)response statusCode] == 200){
      [[NSURLCredentialStorage sharedCredentialStorage] setCredential:self.challengedCredential forProtectionSpace:self.authenticationChallenge.protectionSpace];
    }
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if(buttonIndex == alertView.cancelButtonIndex){
    [self.authenticationChallenge.sender cancelAuthenticationChallenge:self.authenticationChallenge];
    return;
  }
  
  NSString* user = [[alertView textFieldAtIndex:0] text];
  NSString* password = [[alertView textFieldAtIndex:1] text];
  if(!user.length || !password.length){
    [self showAlert];
    return;
  }
  
  [self setupCredential:user password:password];
}

#pragma mark - private

- (void)setupCredential:(NSString *)user password:(NSString *)password
{
  self.challengedCredential = [NSURLCredential credentialWithUser:user password:password persistence:self.persistence];
  [self.authenticationChallenge.sender useCredential:self.challengedCredential forAuthenticationChallenge:self.authenticationChallenge];
  [self.webView reload];
}

- (void)showAlert
{
  if(self.alertView.isVisible){
    return;
  }
  
  __weak UWAHandler* bSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    bSelf.alertView.message = bSelf.authenticationChallenge.protectionSpace.host ?: @"";
    bSelf.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[bSelf.alertView textFieldAtIndex:1] setText:@""]; // Clear password
    [bSelf.alertView show];
  });
}

@end
