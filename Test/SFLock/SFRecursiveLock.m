//
//  SFRecursiveLock.m
//  Test
//
//  Created by 黄山锋 on 2021/3/25.
//

#import "SFRecursiveLock.h"

// 递归锁的核心在于，同一线程可以对同一把锁进行重复加锁，而不会产生死锁。

@interface SFRecursiveLock ()
@property (nonatomic, strong) NSThread *currentThread;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) NSInteger lockCount;
@end

@implementation SFRecursiveLock

- (instancetype)init {
    if (self = [super init]) {
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - public funcs
- (void)lock {
    [self _checkLock];
}
- (void)unlock {
    if ([self.currentThread isEqual:[NSThread currentThread]]) {
        return;
    }
    self.currentThread = nil;
    // 让信号量的值加1
    dispatch_semaphore_signal(self.semaphore);
}
- (BOOL)tryLock {
    BOOL canLock = NO;
    if (!self.currentThread) {
        canLock = YES;
    }
    if (canLock) {
        [self lock];
    }
    return canLock;
}

#pragma mark - private funcs
- (void)_checkLock {
    if ([self.currentThread isEqual:[NSThread currentThread]]) {
        return;
    }
    // 让信号量的值减1，如果信号量的值 <= 0，就会休眠等待
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    self.currentThread = [NSThread currentThread];
}

@end
