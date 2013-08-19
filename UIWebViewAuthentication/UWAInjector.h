//
//  UWAInjector.h
//  UIWebViewAuthentication
//
//  Copyright (c) 2013 Synapsesoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIWebView;
@interface UWAInjector : NSObject
@property (nonatomic) NSURLCredentialPersistence persistence;
- (void)bindWebView:(UIWebView *)webView;
- (void)cleanup;
@end
