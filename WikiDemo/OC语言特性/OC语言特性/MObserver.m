//
//  MObserver.m
//  OC语言特性
//
//  Created by 冯才凡 on 2019/5/14.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "MObserver.h"
#import "MObject.h"

@implementation MObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[MObject class]] && [keyPath isEqualToString:@"value"]) {
        //
        NSNumber *value = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"value is %@",value);
    }
}

- (void)a {
    [self willChangeValueForKey:@"keyPath"];
    
    [self didChangeValueForKey:@"keyPath"];
}



@end
