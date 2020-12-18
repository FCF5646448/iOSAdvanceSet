//
//  NSMutableAttributedString+SetAttribute.h
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (SetAttribute)

- (void)fcf_setTextColor:(UIColor*)color;
- (void)fcf_setTextColor:(UIColor*)color range:(NSRange)range;

- (void)fcf_setFont:(UIFont*)font;
- (void)fcf_setFont:(UIFont*)font range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
