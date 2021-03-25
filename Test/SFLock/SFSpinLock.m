//
//  SFSpinLock.m
//  Test
//
//  Created by 黄山锋 on 2021/3/24.
//

#import "SFSpinLock.h"

@interface SFSpinLock ()
@property (nonatomic, strong) NSThread *currentThread;
@end

@implementation SFSpinLock

#pragma mark - public funcs
- (void)lock {
    [self _checkLock];
}
- (void)unlock {
    self.currentThread = nil;
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
    while (self.currentThread != nil) {
        NSLog(@"busy-waiting");
    }
    self.currentThread = [NSThread currentThread];
}

@end
