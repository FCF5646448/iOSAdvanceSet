//
//  FCFNotificationModel.h
//  iOS 底层实现Demos
//
//  Created by 冯才凡 on 2019/11/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCFNotificationModel : NSObject

@property (strong, nonatomic) id observer;
@property (assign) SEL aSelector;
@property (copy, nonatomic) NSString * aName;
@property (strong, nonatomic) id anObject;

@end

NS_ASSUME_NONNULL_END
