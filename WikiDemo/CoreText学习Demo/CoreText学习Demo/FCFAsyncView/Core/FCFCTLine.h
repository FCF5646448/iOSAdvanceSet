//
//  FCFCTLine.h
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCFCTLine : NSObject

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CTLineRef ctLine;

@end

NS_ASSUME_NONNULL_END
