//
//  Stroke.h
//  TouchPainter
//
//  Created by 冯才凡 on 2020/7/21.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mark.h"

/*划线*/
@interface Stroke : NSObject <Mark, NSCopying>
@property (nonatomic, strong) UIColor * color;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign, readonly) NSUInteger count; //子节点个数
@property (nonatomic, assign, readonly) id<Mark> lastChild;

- (void) addMark:(id<Mark>) mark;
- (void) removeMark:(id<Mark>) mark;
- (id<Mark>) childMarkAtIndex:(NSUInteger) index;
- (id) copyWithZone:(NSZone *)zone;

@end
