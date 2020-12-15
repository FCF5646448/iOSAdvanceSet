//
//  ImageItem.h
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageItem : NSObject
@property (nonatomic, strong) NSString * imgName;
@property (nonatomic, assign) CGRect frame;

- (instancetype)initWithImageName:(NSString *)name frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
