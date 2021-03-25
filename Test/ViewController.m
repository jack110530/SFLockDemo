//
//  ViewController.m
//  Test
//
//  Created by 黄山锋 on 2021/1/22.
//

#import "ViewController.h"
#import "SFSpinLock.h"
#import "SFUnfairLock.h"
#import "SFRecursiveLock.h"
#import "SFConditionLock.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segView;
@property (nonatomic, assign) int tickets;
@property (nonatomic, strong) SFSpinLock *spinLock;
@property (nonatomic, strong) SFUnfairLock *unfairLock;
@property (nonatomic, strong) SFRecursiveLock *recursiveLock;
@property (nonatomic, strong) SFConditionLock *conditionLock;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spinLock = [[SFSpinLock alloc]init];
    self.unfairLock = [[SFUnfairLock alloc]init];
    self.recursiveLock = [[SFRecursiveLock alloc]init];
    self.conditionLock = [[SFConditionLock alloc]initWithCondition:1];
    self.serialQueue = dispatch_queue_create("com.test", DISPATCH_QUEUE_SERIAL);
}

#pragma mark - 点击屏幕开始测试
- (IBAction)startTestEvent:(UIButton *)sender {
    switch (self.segView.selectedSegmentIndex) {
        case 0:
        {
            [self testSpinLockDemo];
        }
            break;
        case 1:
        {
            [self testUnfairLockDemo];
        }
            break;
        case 2:
        {
            [self testRecursiveLockDemo];
        }
            break;
        case 3:
        {
            [self testConditionLockDemo];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - 自旋锁模拟测试
- (void)testSpinLockDemo {
    self.tickets = 30;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithSpinLock];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithSpinLock];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithSpinLock];
        }
    });
}
- (void)saleTicketWithSpinLock {
    [self.spinLock lock];
    int oldTicketsCount = self.tickets;
    sleep(.2);
    oldTicketsCount--;
    self.tickets = oldTicketsCount;
    NSLog(@"【自旋锁测试】剩余票数：%d 线程：%@", oldTicketsCount, [NSThread currentThread]);
    [self.spinLock unlock];
}


#pragma mark - 互斥锁模拟测试
- (void)testUnfairLockDemo {
    self.tickets = 30;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithUnfairLock];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithUnfairLock];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithUnfairLock];
        }
    });
}
- (void)saleTicketWithUnfairLock {
    [self.unfairLock lock];
    int oldTicketsCount = self.tickets;
    sleep(.2);
    oldTicketsCount--;
    self.tickets = oldTicketsCount;
    NSLog(@"【互斥锁测试】剩余票数：%d 线程：%@", oldTicketsCount, [NSThread currentThread]);
    [self.unfairLock unlock];
}


#pragma mark - 递归锁模拟测试
- (void)testRecursiveLockDemo {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i= 0; i<100; i++) {
        dispatch_async(queue, ^{
            static void (^testMethod)(int);
            [self.recursiveLock lock];
            testMethod = ^(int value){
                if (value > 0) {
                  NSLog(@"【递归锁测试】current value = %d",value);
                  testMethod(value - 1);
                }
                [self.recursiveLock unlock];
            };
            testMethod(10);
        });
    }
}



#pragma mark - 条件锁模拟测试
- (void)testConditionLockDemo {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self stepOne];
    });
    dispatch_async(queue, ^{
        [self stepTwo];
    });
    dispatch_async(queue, ^{
        [self stepThree];
    });
}
- (void)stepOne {
    [self.conditionLock lockWhenCondition:1];
    NSLog(@"【条件锁测试】%s", __func__);
    sleep(1);
    [self.conditionLock unlockWithCondition:2];
}
- (void)stepTwo {
    [self.conditionLock lockWhenCondition:2];
    NSLog(@"【条件锁测试】%s", __func__);
    sleep(1);
    [self.conditionLock unlockWithCondition:3];
}
- (void)stepThree {
    [self.conditionLock lockWhenCondition:3];
    NSLog(@"【条件锁测试】%s", __func__);
    sleep(1);
    [self.conditionLock unlockWithCondition:4];
}

#pragma mark - GCD同步串行队列也可达到线程同步的效果
- (IBAction)GCDSerialQueueDemoEvent:(UIButton *)sender {
    self.tickets = 30;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithGcd];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithGcd];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicketWithGcd];
        }
    });
}
- (void)saleTicketWithGcd {
    dispatch_sync(self.serialQueue, ^{
        int oldTicketsCount = self.tickets;
        sleep(.2);
        oldTicketsCount--;
        self.tickets = oldTicketsCount;
        NSLog(@"【GCD】剩余票数：%d 线程：%@", oldTicketsCount, [NSThread currentThread]);
    });
}

@end
