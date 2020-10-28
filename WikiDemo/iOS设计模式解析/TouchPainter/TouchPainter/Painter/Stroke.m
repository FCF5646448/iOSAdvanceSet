//
//  Stroke.m
//  TouchPainter
//
//  Created by 冯才凡 on 2020/7/21.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Stroke.h"

@interface Stroke()
@property (nonatomic, strong) NSMutableArray<id<Mark>> * children;
@end

@implementation Stroke

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.children = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)setLocation:(CGPoint)location {
    //
}

- (CGPoint)location {
    //返回第一个子节点的位置
    if (self.children.count > 0) {
        return [[self.children objectAtIndex:0] location];
    }
    return CGPointZero;
}

- (void) addMark:(id<Mark>) mark {
    [self.children addObject:mark];
}

- (void) removeMark:(id<Mark>) mark {
    //如mark正好在这一层，则移除，否则子节点去遍历查找
    if ([self.children containsObject:mark]) {
        [self.children removeObject:mark];
    }else{
        //makeObjectsPerformSelector 简介：让数组中的每个元素 都调用 aMethod 并把 withObject 后边的 oneObject 对象做为参数传给方法aMethod
        [self.children makeObjectsPerformSelector:@selector(removeMark:) withObject:mark];
    }
}

- (id<Mark>) childMarkAtIndex:(NSUInteger) index {
    if (index >= [_children count]) {
        return nil;
    }
    return [_children objectAtIndex:index];
}

- (id<Mark>)lastChild {
    return [_children lastObject];
}

- (NSUInteger)count {
    return [_children count];
}

//复制 将数组里的节点也复制一遍。
- (id) copyWithZone:(NSZone *)zone {
    Stroke * strokeCopy = [[[self class] allocWithZone:zone] init];
    
    [strokeCopy setColor:[UIColor colorWithCGColor:[_color CGColor]]];
    
    [strokeCopy setSize:_size];
    
    for (id<Mark> child in _children) {
        id<Mark> childCopy = [child copy];
        [strokeCopy addMark:childCopy];
    }
    
    return strokeCopy;
}

@end
