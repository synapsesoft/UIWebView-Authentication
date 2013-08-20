//
//  UWAWebView.h
//  UIWebViewAuthentication
//
//  Copyright (c) 2013 Synapsesoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UWAHandler;
@interface UWAWebView : UIWebView
@property (nonatomic) UWAHandler* authentication;
@end
