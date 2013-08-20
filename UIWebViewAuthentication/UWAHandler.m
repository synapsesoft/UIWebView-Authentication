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
@property(nonatomic) UIWebView* webView;
@property(nonatomic) NSURLAuthenticationChallenge* authenticationChallenge;
@end

@implementation UWAHandler

#pragma mark - public

- (id)init
{
  self = [super init];
  if(self){
    _persistence = NSURLCredentialPersistencePermanent;
  }
  return self;
}

- (void)bindWebView:(UIWebView *)webView
{
  self.webView = webView;
  [SGHTTPURLProtocol registerProtocol];
  [SGHTTPURLProtocol setAuthDelegate:self];
}

- (void)cleanup
{
  [SGHTTPURLProtocol unregisterProtocol];
  [SGHTTPURLProtocol setAuthDelegate:nil];
  self.webView = nil;
}

- (void)dealloc
{
  [self cleanup];
}

#pragma mark - private

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(buttonIndex == alertView.cancelButtonIndex){
    return;
  }
  
  NSString* user = [[alertView textFieldAtIndex:0] text];
  NSString* password = [[alertView textFieldAtIndex:1] text];
  [self setupCredential:user password:password];
  
  [self.webView loadRequest:[NSURLRequest requestWithURL:self.authenticationChallenge.failureResponse.URL]];
}

- (void)setupCredential:(NSString *)user password:(NSString *)password
{
  NSURLCredential *credential = [NSURLCredential credentialWithUser:user password:password persistence:self.persistence];
  [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:self.authenticationChallenge.protectionSpace];
  [self.authenticationChallenge.sender useCredential:credential forAuthenticationChallenge:self.authenticationChallenge];
}

#pragma mark - SGHTTPAuthDelegate

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  self.authenticationChallenge = challenge;
  dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authentication Required", nil)
                                                    message:challenge.protectionSpace.host
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Log In", nil), nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
  });
}

@end
