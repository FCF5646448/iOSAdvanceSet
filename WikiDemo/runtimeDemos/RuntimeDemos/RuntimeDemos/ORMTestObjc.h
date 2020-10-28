//
//  ORMTestObjc.h
//  RuntimeDemos
//
//  Created by 冯才凡 on 2019/1/22.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ORMTestObjc : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL gender;
@property (nonatomic, copy) NSArray<NSNumber *> * arr;

+ (instancetype)objectWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
