//
//  FCFBaseDataItem.h
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickActionHandler)(id obj);

@interface FCFBaseDataItem : NSObject

@property (nonatomic, assign) NSMutableArray<NSValue *> * clickableFrames;
@property (nonatomic, copy) ClickActionHandler clickActionHandler;

// 将frame添加进数组
- (void)addFrame:(CGRect)frame;
// 判断是否存在frame包含当前point
- (BOOL)containsPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
