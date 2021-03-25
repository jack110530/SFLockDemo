//
//  SFConditionLock.m
//  Test
//
//  Created by 黄山锋 on 2021/3/25.
//

#import "SFConditionLock.h"

@interface SFConditionLock ()
@property (nonatomic, assign) NSInteger condition;
@end

@implementation SFConditionLock

#pragma mark - init
- (instancetype)initWithCondition:(NSInteger)condition {
    if (self = [super init]) {
        self.condition = condition;
    }
    return self;
}

#pragma mark - public funcs
- (void)lockWhenCondition:(NSInteger)condition {
    if (self.condition == condition) {
        [self lock];
    }
}
- (void)unlockWithCondition:(NSInteger)condition {
    [self unlock];
    self.condition = condition;
}
- (void)tryLockWhenCondition:(NSInteger)condition {
    if (self.condition == condition) {
        [self tryLock];
    }
}

@end
