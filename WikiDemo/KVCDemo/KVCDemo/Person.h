//
//  Person.h
//  KVCDemo
//
//  Created by 冯才凡 on 2020/10/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Cat : NSObject
@property (nonatomic, assign) int weight;
@end

@interface Person : NSObject{
    int _age;
    int _isAge;
    int isAge;
    int age;
}
//@property (nonatomic, assign) int age;
@property (nonatomic, strong) Cat * cat;
@end

NS_ASSUME_NONNULL_END
