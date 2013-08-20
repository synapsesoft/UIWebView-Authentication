//
//  UWAWebView.m
//  UIWebViewAuthentication
//
//  Copyright (c) 2013 Synapsesoft Inc. All rights reserved.
//

#import "UWAWebView.h"

#import "UWAHandler.h"

@interface UWAWebView ()
@end

@implementation UWAWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.authentication = [UWAHandler new];
      [self.authentication bindWebView:self];
    }
    return self;
}

- (void)dealloc
{
  [self.authentication cleanup];
}

@end
