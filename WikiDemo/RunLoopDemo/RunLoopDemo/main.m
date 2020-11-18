//
//  main.m
//  RunLoopDemo
//
//  Created by 冯才凡 on 2020/11/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        //另一种创建Observable的方式
//        CFRunLoopObserverRef observer2 = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//            CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
//            switch (activity) {
//                case kCFRunLoopEntry:
//                    NSLog(@"block__kCFRunLoopEntry__%@", mode);
//                    break;
//                case kCFRunLoopExit:
//                    NSLog(@"block__kCFRunLoopExit__%@", mode);
//                    break;
//                default:
//                    break;
//            }
//            CFRelease(mode);
//        });
//        CFRunLoopAddObserver(CFRunLoopGetMain(), observer2, kCFRunLoopCommonModes);
//        CFRelease(observer2);
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
