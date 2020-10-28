//
//  MObject.h
//  OC语言特性
//
//  Created by 冯才凡 on 2019/5/14.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MObject : NSObject
@property (nonatomic, assign) int value;

- (void)increase;

@end

NS_ASSUME_NONNULL_END
