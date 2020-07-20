//
//  Mark.h
//  TouchPainter
//
//  Created by 冯才凡 on 2020/7/20.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#ifndef Mark_h
#define Mark_h

#import <UIKit/UIKit.h>

//节点协议
@protocol Mark <NSObject>

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign, readonly) NSUInteger count; //子节点个数
@property (nonatomic, assign, readonly) id<Mark> lastChild;

- (id) copy;
- (void) addMark:(id<Mark>) mark;
- (void) removeMark:(id<Mark>) mark;
- (id<Mark>) childMarkAtIndex:(NSUInteger) index;

@end



#endif /* Mark_h */
