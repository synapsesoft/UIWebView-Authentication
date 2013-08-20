#import <SenTestingKit/SenTestingKit.h>

#import "UWAHandler.h"

@interface UWAHandlerTests : SenTestCase
@property(nonatomic) UWAHandler* handler;
@end

@implementation UWAHandlerTests

- (void)setUp
{
  [super setUp];
  
  self.handler = [UWAHandler new];
}

- (void)tearDown
{
  [self.handler cleanup];
  
  [super tearDown];
}

- (void)testInstance
{
  STAssertNotNil(self.handler, nil);
}

@end
