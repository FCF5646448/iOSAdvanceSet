//
//  Dot.m
//  TouchPainter
//
//  Created by 冯才凡 on 2020/7/21.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Dot.h"

@implementation Dot
- (id) copyWithZone:(NSZone *)zone {
    Dot * dotCopy = [[[self class] allocWithZone:zone] initWithLocation:self.location];
    //
    [dotCopy setColor:[UIColor colorWithCGColor:[self.color_ CGColor]]];
    //
    [dotCopy setSize:self.size_];
    return dotCopy;
}

@end
