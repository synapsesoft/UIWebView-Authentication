//
//  RootViewController.m
//  UIWebViewAuthentication
//
//  Copyright (c) 2013 Synapsesoft Inc. All rights reserved.
//

#import "RootViewController.h"

#import "UWAWebView.h"

@interface RootViewController ()
@property(nonatomic) UWAWebView* webView;
@end

@implementation RootViewController

- (void)loadView
{
  self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.webView = [[UWAWebView alloc] initWithFrame:self.view.frame];
  //self.webView.authentication.persistence = NSURLCredentialPersistenceForSession;
  [self.view addSubview:self.webView];
  
  NSString* url = @"http://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx";
  NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [self.webView loadRequest:request];
}

@end
