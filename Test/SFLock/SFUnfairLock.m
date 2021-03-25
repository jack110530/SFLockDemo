//
//  SFUnfairLock.m
//  Test
//
//  Created by 黄山锋 on 2021/3/24.
//

#import "SFUnfairLock.h"

@interface SFUnfairLock ()
@property (nonatomic, strong) NSThread *currentThread;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation SFUnfairLock

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
    // 让信号量的值减1，如果信号量的值 <= 0，就会休眠等待
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    self.currentThread = [NSThread currentThread];
}

@end
