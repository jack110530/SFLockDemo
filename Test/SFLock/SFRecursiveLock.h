//
//  SFRecursiveLock.h
//  Test
//
//  Created by 黄山锋 on 2021/3/25.
//

#import "SFUnfairLock.h"
#import "SFLocking.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFRecursiveLock : SFUnfairLock<SFLocking>

@end

NS_ASSUME_NONNULL_END
