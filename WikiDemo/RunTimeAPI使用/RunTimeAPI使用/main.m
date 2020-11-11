//
//  main.m
//  RunTimeAPI使用
//
//  Created by 冯才凡 on 2020/11/11.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Person.h"
#import "Car.h"

void useClassAPI(void);
void useClassIvarAPI(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        useClassAPI();
        useClassIvarAPI();
        
    }
    return 0;
}

// 使用类相关API
void useClassAPI() {
    Person * p = [[Person alloc] init];
    [p run]; //-[Person run]
    
    // 1、object_getClass: 获取isa指向。
    // 这里打印的结构都是类对象的地址。可以发现实例对象无论调用多少次class，得到的结果都是类对象。实例对象调用class和类名调用class的结果是一样的。因为他们的本质都是去拿到类（Person）的isa指针去NSObject里调用class方法。isa指针一样，结果就是一样的
    NSLog(@"%p %p %p %p %p %p",
          object_getClass(p),
          [p class],
          [[[p class] class] class],
          [[[[[p class] class] class] class] class],
          [[[Person class] class] class],
          [[[[[Person class] class] class] class] class]); //0x1000012b8 0x1000012b8 0x1000012b8 0x1000012b8 0x1000012b8 0x1000012b8
    
    // 这里打印的结果都是元类的地址。因为本质都是通过拿到Person类里的isa指针后，再通过object_getClass去获取isa指针所指向的类。这里也就是元类。
    NSLog(@"%p %p %p %p",
          object_getClass([p class]),
          object_getClass([Person class]),
          object_getClass([[p class] class]),
          object_getClass([[Person class] class])); //0x100001290 0x100001290 0x100001290 0x100001290
    
    // 2、object_setClass: 设置isa指向的class
    object_setClass(p, [Car class]);
    [p run]; // -[Car run]
    
    // 3、object_isClass: 判断是否为class
    // 第1个是实例对象，不是class，第2个是类对象, 第3个是元类，所以后两个是class
    NSLog(@"%d, %d, %d",
          object_isClass(p),
          object_isClass([p class]),
          object_isClass(object_getClass([p class]))); //0、1、1
    
    
    /*
     4、
     objc_allocateClassPair: 动态创建类,参数：类、类名、xxx
     objc_registerClassPair: 注册类;
     主要动态添加的类，如果要给其添加方法或成员变量，需要在register函数之前
     */
    Class newclass = objc_allocateClassPair([Car class], "RedCar", 0);
    objc_registerClassPair(newclass);
    id car = [[newclass alloc] init];
    NSLog(@"%@", car); //<RedCar: 0x100747a10>
}


//使用成员变量API
void useClassIvarAPI(void) {
    Class newclass = objc_allocateClassPair([Car class], "NewCar", 0);
    
    // 5、class_addIvar: 添加成员变量；参数：类、变量名、类型所占字节、对齐、类型
    class_addIvar(newclass, "_age", 4, 1, @encode(int));
    class_addIvar(newclass, "_name", 16, 1, @encode(NSMutableString));
    
    
    objc_registerClassPair(newclass);
    id car = [[newclass alloc] init];
    NSLog(@"%@", car); //<NewCar: 0x100747a10>
    NSLog(@"%zd", class_getInstanceSize(newclass)); //32
    
    [car setValue:@10 forKey:@"_age"];
    [car setValue:@"宝马" forKey:@"_name"];
    
    NSLog(@"%@", [car valueForKey:@"_age"]);
    NSLog(@"%@", [car valueForKey:@"_name" ]);
}
