#import <SenTestingKit/SenTestingKit.h>

#import "UWAWebView.h"

@interface UWAWebViewTests : SenTestCase
@property(nonatomic) UWAWebView* webview;
@end

@implementation UWAWebViewTests

- (void)setUp
{
  [super setUp];

  self.webview = [UWAWebView new];
}

- (void)tearDown
{
  [super tearDown];
}

- (void)testInstance
{
  STAssertNotNil(self.webview, nil);
}

@end
