//
//  SFLocking.h
//  Test
//
//  Created by 黄山锋 on 2021/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SFLocking <NSObject>
- (void)lock;
- (void)unlock;
- (BOOL)tryLock;
@end

NS_ASSUME_NONNULL_END
