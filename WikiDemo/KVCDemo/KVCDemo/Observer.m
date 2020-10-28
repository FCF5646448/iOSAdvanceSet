//
//  Observer.m
//  KVCDemo
//
//  Created by 冯才凡 on 2020/10/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Observer.h"

@implementation Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath：%@", change);
}
@end
