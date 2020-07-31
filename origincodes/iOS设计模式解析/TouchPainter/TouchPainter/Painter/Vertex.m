//
//  Vertex.m
//  TouchPainter
//
//  Created by 冯才凡 on 2020/7/20.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Vertex.h"

@interface Vertex()
@end

@implementation Vertex
- (id) initWithLocation:(CGPoint)alocation {
    if (self = [super init]) {
        [self setLocation:alocation];
    }
    return self;
}
- (void) addMark:(id<Mark>) mark {
    
}
- (void) removeMark:(id<Mark>) mark {
    
}
- (id<Mark>) childMarkAtIndex:(NSUInteger) index {
    return nil;
}
//这里之所以用[self class]是为了让子类也能够直接继承使用
- (id) copyWithZone:(NSZone *)zone {
    Vertex * vertexCopy = [[[self class] allocWithZone:zone] initWithLocation:self.location];
    return vertexCopy;
}
@end
