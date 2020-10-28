//
//  FCFNotificationCerter.m
//  iOS 底层实现Demos
//
//  Created by 冯才凡 on 2019/11/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "FCFNotificationCerter.h"
#import "FCFNotificationModel.h"

/*
 注：重点：
 Notification底层就是由一个散列表组成，key是name，值是一个链表，链表里是所有observer及相关参数内容组成的model。
 */

@interface FCFNotificationCerter()

@property (strong, nonatomic) NSMutableDictionary * notifiDic; //用于存储通知

@end

@implementation FCFNotificationCerter


static FCFNotificationCerter * _defalultCenter = nil;

+ (void)setDefaultCenter:(FCFNotificationCerter *)defaultCenter {
    if (self.defaultCenter) {
        _defalultCenter = defaultCenter;
    }
}

+ (FCFNotificationCerter *)defaultCenter {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _defalultCenter = [FCFNotificationCerter new];
        _defalultCenter.notifiDic = [NSMutableDictionary dictionary];
    });
    return _defalultCenter;
}


- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject {
    FCFNotificationModel * model = [FCFNotificationModel new];
    model.observer = observer;
    model.aSelector = aSelector;
    model.aName = aName;
    model.anObject = anObject;
    
    [self addObserver:model];
    
}

//先不管aUserInfo
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo {
    NSMutableDictionary * dic = FCFNotificationCerter.defaultCenter.notifiDic;
    if ([dic objectForKey:aName]) {
        NSMutableArray * tempA = [dic objectForKey:aName];
        for (FCFNotificationModel * model in tempA) {
            if ( model.anObject == nil || [model.anObject isEqual:anObject]) {
                [model.observer performSelector:model.aSelector withObject:model.anObject];
            }
        }
    }
}


- (void)addObserver:(FCFNotificationModel *)observer {
    
    NSMutableDictionary * dic = FCFNotificationCerter.defaultCenter.notifiDic;
    @synchronized (dic) {
        NSString * key = observer.aName;
        if ([dic objectForKey:key]) {
            NSMutableArray * tempA = [dic objectForKey:key];
            [tempA addObject:observer];
        }else{
            NSMutableArray * newA = [NSMutableArray new];
            [newA addObject:observer];
            [dic setValue:newA forKey:key];
        }
    }
    
}

@end
