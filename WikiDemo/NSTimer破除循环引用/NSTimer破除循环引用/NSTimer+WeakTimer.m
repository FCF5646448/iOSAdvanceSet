//
//  NSTimer+WeakTimer.m
//  NSTimer破除循环引用
//
//  Created by 冯才凡 on 2019/5/16.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "NSTimer+WeakTimer.h"

@interface TimerWeakObjct : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;
- (void)fire:(NSTimer *)timer;
@end

@implementation TimerWeakObjct

- (void)fire:(NSTimer *)timer {
    if (self.target) {
        if ([self.target respondsToSelector:@selector(selector)]) {
            [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0];
        }
    }else{
        [self.timer invalidate];
    }
}
@end


@implementation NSTimer (WeakTimer)
//+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
//                                     target:(id)aTarget
//                                   selector:(SEL)aSelector
//                                   userInfo:(id)userInfo
//                                    repeats:(BOOL)yesOrNo {
//    
//    TimerWeakObjct * obj = [[TimerWeakObjct alloc] init];
//    obj.target = aTarget;
//    obj.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:obj selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
//    
//    return obj.timer;
//}
@end
