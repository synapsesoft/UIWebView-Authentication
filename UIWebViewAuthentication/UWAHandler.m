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
@property(nonatomic) UIAlertView* alertView;
@property(nonatomic) NSURLAuthenticationChallenge* authenticationChallenge;
@property(nonatomic) NSURLCredential* challengedCredential;
@end

@implementation UWAHandler

#pragma mark - public

- (id)init
{
  self = [super init];
  if(self){
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

#pragma mark - private

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(buttonIndex == alertView.cancelButtonIndex){
    return;
  }
  
  NSString* user = [[alertView textFieldAtIndex:0] text];
  NSString* password = [[alertView textFieldAtIndex:1] text];
  [self setupCredential:user password:password];
}

- (void)setupCredential:(NSString *)user password:(NSString *)password
{
  self.challengedCredential = [NSURLCredential credentialWithUser:user password:password persistence:self.persistence];
  [self.authenticationChallenge.sender useCredential:self.challengedCredential forAuthenticationChallenge:self.authenticationChallenge];
}

#pragma mark - SGHTTPAuthDelegate

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{  
  NSURLCredential* credential = [[NSURLCredentialStorage sharedCredentialStorage] defaultCredentialForProtectionSpace:challenge.protectionSpace];
  if(credential){
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    return;
  }
  
  if(self.alertView.isVisible){
    return;
  }
  
  self.authenticationChallenge = challenge;
  dispatch_async(dispatch_get_main_queue(), ^{
    self.alertView.message = challenge.protectionSpace.host;
    self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [self.alertView show];
  });
}

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveResponse:(NSURLResponse *)response
{
  if([self.authenticationChallenge.protectionSpace.protocol isEqualToString:response.URL.scheme] &&
     [self.authenticationChallenge.protectionSpace.host isEqualToString:response.URL.host]){
   
    if(self.challengedCredential && self.authenticationChallenge && [(NSHTTPURLResponse *)response statusCode] == 200){
      [[NSURLCredentialStorage sharedCredentialStorage] setCredential:self.challengedCredential forProtectionSpace:self.authenticationChallenge.protectionSpace];
    }
    
  }
}

@end
