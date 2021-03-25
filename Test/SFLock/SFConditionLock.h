//
//  SFConditionLock.h
//  Test
//
//  Created by 黄山锋 on 2021/3/25.
//

#import "SFUnfairLock.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFConditionLock : SFUnfairLock

- (instancetype)initWithCondition:(NSInteger)condition;
- (void)lockWhenCondition:(NSInteger)condition;
- (void)unlockWithCondition:(NSInteger)condition;
- (void)tryLockWhenCondition:(NSInteger)condition;

@end

NS_ASSUME_NONNULL_END
