//
//  Person.h
//  内存管理二刷_MRC
//
//  Created by 冯才凡 on 2020/11/26.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject {
    Dog * _dog;
}

- (void)setDog:(Dog *)dog;

- (Dog *)dog;

@end

NS_ASSUME_NONNULL_END
