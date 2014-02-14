//
//  TestDUVersion.m
//  DevedUpKit
//
//  Created by David Casserly on 14/02/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DUVersion.h"

@interface TestDUVersion : XCTestCase
@property (nonatomic, retain) DUVersion *lower;
@property (nonatomic, retain) DUVersion *higher;
@end

@implementation TestDUVersion

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.lower = nil;
    self.higher = nil;
    [super tearDown];
}

#pragma mark - Testing Major Version

- (void) testMajorHigher_expectSuccess {
    self.lower = [DUVersion.alloc initWithVersionString:@"1.2.3"];
    self.higher = [DUVersion.alloc initWithVersionString:@"2.2.3"];
    XCTAssertTrue([self.lower isBeforeVersion:self.higher], @"lower should be before higher");
}

- (void) testMajorLower_expectFail {
    self.lower = [DUVersion.alloc initWithVersionString:@"3.2.3"];
    self.higher = [DUVersion.alloc initWithVersionString:@"2.2.3"];
    XCTAssertFalse([self.lower isBeforeVersion:self.higher ], @"lower should NOT be before higher");
}

#pragma mark - Test Equal Versions

- (void) testEqual_expectFail {
    self.lower = [DUVersion.alloc initWithVersionString:@"1.2.3"];
    self.higher = [DUVersion.alloc initWithVersionString:@"1.2.3"];
    XCTAssertFalse([self.lower isBeforeVersion:self.higher ], @"lower should NOT be before higher");
}

#pragma mark - Test Minor Version

- (void) testMinorHigher_expectSuccess {
    self.lower = [DUVersion.alloc initWithVersionString:@"1.2.3"];
    self.higher = [DUVersion.alloc initWithVersionString:@"1.3.3"];
    XCTAssertTrue([self.lower isBeforeVersion:self.higher ], @"lower should be before higher");
}

- (void) testMinorLower_expectFail {
    self.lower = [DUVersion.alloc initWithVersionString:@"1.3.3"];
    self.higher = [DUVersion.alloc initWithVersionString:@"1.2.3"];
    XCTAssertFalse([self.lower isBeforeVersion:self.higher ], @"lower should NOT be before higher");
}

#pragma mark - Test Revision Version

- (void) testRevisionHigher_expectSuccess {
    self.lower = [DUVersion.alloc initWithVersionString:@"1.2.3"];
    self.higher = [DUVersion.alloc initWithVersionString:@"1.2.4"];
    XCTAssertTrue([self.lower isBeforeVersion:self.higher ], @"lower should be before higher");
}

- (void) testRevisionLower_expectFail {
    self.lower = [DUVersion.alloc initWithVersionString:@"1.2.4"];
    self.higher = [DUVersion.alloc initWithVersionString:@"1.2.3"];
    XCTAssertFalse([self.lower isBeforeVersion:self.higher ], @"lower should NOT be before higher");
}

@end
