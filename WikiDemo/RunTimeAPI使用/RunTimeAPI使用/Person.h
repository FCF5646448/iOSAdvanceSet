//
//  Person.h
//  RunTimeAPI使用
//
//  Created by 冯才凡 on 2020/11/11.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, copy) NSString * name;

- (void)run;
@end

NS_ASSUME_NONNULL_END
