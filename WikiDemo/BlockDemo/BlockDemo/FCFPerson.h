//
//  FCFPerson.h
//  BlockDemo
//
//  Created by 冯才凡 on 2020/10/29.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FCFBlock)(void);

@interface FCFPerson : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) FCFBlock block;

- (void)test;
- (void)test2;
@end

NS_ASSUME_NONNULL_END
