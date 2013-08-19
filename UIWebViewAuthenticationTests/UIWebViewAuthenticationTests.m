#import <SenTestingKit/SenTestingKit.h>

#import "UWAInjector.h"

@interface UIWebViewAuthenticationTests : SenTestCase
@property(nonatomic) UWAInjector* injector;
@end

@implementation UIWebViewAuthenticationTests

- (void)setUp
{
  [super setUp];
  
  self.injector = [UWAInjector new];
}

- (void)tearDown
{
  [self.injector cleanup];
  
  [super tearDown];
}

- (void)testInstance
{
  STAssertNotNil(self.injector, nil);
}

@end
