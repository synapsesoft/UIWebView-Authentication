//
//  RootViewController.m
//  UIWebViewAuthentication
//
//  Copyright (c) 2013 Synapsesoft Inc. All rights reserved.
//

#import "RootViewController.h"

#import "UWAInjector.h"

@interface RootViewController ()
@property(nonatomic, weak) IBOutlet UIWebView* webView;
@property(nonatomic) UWAInjector* injector;
@end

@implementation RootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.injector = [UWAInjector new];
  [self.injector bindWebView:self.webView];
  
  self.injector.persistence = NSURLCredentialPersistenceForSession;
  
  NSString* url = @"http://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx";
  NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [self.webView loadRequest:request];
}

@end
