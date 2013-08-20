UIWebViewAuthentication
=======================

Basic and Digest Access Authentication support for iOS UIWebView.

![Screenshot](https://qiita-image-store.s3.amazonaws.com/0/28357/01453073-0f26-e013-444d-e3e55525c25c.png)

```objc```
// #import <UIWebViewAuthentication/UWAWebView.h>
- (void)viewDidLoad
{
  [super viewDidLoad];

  self.webView = [[UWAWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:self.webView];

  NSString* url = @"http://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx";
  NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  [self.webView loadRequest:request];
}
```

Installation
-------------

http://cocoapods.org/

```
# Podfile
platform :ios, '5.0'

pod 'UIWebViewAuthentication', :git => 'https://github.com/synapsesoft/UIWebViewAuthentication.git'
```
