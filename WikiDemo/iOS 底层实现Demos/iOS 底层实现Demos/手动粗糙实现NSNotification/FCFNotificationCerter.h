//
//  FCFNotificationCerter.h
//  iOS 底层实现Demos
//
//  Created by 冯才凡 on 2019/11/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCFNotificationCerter : NSObject

@property (class, strong) FCFNotificationCerter * defaultCenter;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject;

- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;


@end

NS_ASSUME_NONNULL_END
