//
//  ImageTextData.h
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "ImageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, strong) NSMutableArray<ImageItem *> *images;
@property (nonatomic, strong) NSMutableAttributedString *attributeString;

@end

NS_ASSUME_NONNULL_END
