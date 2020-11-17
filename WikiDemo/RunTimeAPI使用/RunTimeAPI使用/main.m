//
//  main.m
//  RunTimeAPI使用
//
//  Created by 冯才凡 on 2020/11/11.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+Json.h"
#import "Person.h"
#import "Car.h"

void useClassAPI(void);
void useClassIvarAPI(void);
void run(id self, SEL _cmd);
void useClassIvarAPI2(void);
void objectWithJson(void);
void useMethodApi(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        useClassAPI();
//        useClassIvarAPI();
//        useClassIvarAPI2();
//        objectWithJson();
        useMethodApi();
        
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
    objc_disposeClassPair(newclass);
}


//使用成员变量API
void useClassIvarAPI(void) {
    Class newclass = objc_allocateClassPair([Car class], "NewCar", 0);
    
    // 5、class_addIvar: 添加成员变量；参数：类、变量名、类型所占字节、对齐、类型
    class_addIvar(newclass, "_age", sizeof(int), log2(sizeof(int)), @encode(int));
    class_addIvar(newclass, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    
    // 6、class_addMethod: 添加函数；
    class_addMethod(newclass, @selector(run), (IMP)run, "v@:");
    
    // 成员变量只能在注册函数之前动态添加，不能再objc_registerClassPair之后添加。方法可以在注册之后添加。（因为成员变量是放在ro里面的，方法是放在rw里面的）
    objc_registerClassPair(newclass);
    
    id car = [[newclass alloc] init];
    NSLog(@"%@", car); //<NewCar: 0x100747a10>
    NSLog(@"%zd", class_getInstanceSize(newclass)); //32
    
    [car setValue:@10 forKey:@"_age"];
    [car setValue:@"宝马" forKey:@"_name"];
    
    NSLog(@"%@", [car valueForKey:@"_age"]);
    NSLog(@"%@", [car valueForKey:@"_name" ]);
    [car run];
    
    Person * p = [Person new];
    object_setClass(p, newclass);
    [p run]; // 这里调用的确实是Person的run方法，但是打印出来的p
    
    objc_disposeClassPair(newclass);
}

void run(id self, SEL _cmd) {
    NSLog(@"_____ %@ _ %@ 123", self, NSStringFromSelector(_cmd));
}


//ivar API
void useClassIvarAPI2(void) {
    // 8、class_getInstanceVariable: 获取一个实例变量信息
    Ivar ageIvar = class_getInstanceVariable([Person class], "_age");
    // 9、ivar_getName: 获取名称; ivar_getTypeEncoding: 获取typecoding
    NSLog(@"__ %s __ %s __", ivar_getName(ageIvar), ivar_getTypeEncoding(ageIvar));
    
    Person * p = [Person new];
    Ivar nameIvar = class_getInstanceVariable([p class], "_name");
    // 10、object_setIvar：给对象类型赋值，注意是对象类型，如果这里的ivar换成上面的age则不行。
    object_setIvar(p, nameIvar, @"123");
    object_setIvar(p, ageIvar, (__bridge id)(void * )10);
    NSLog(@"__ %@ __ %@ __ %d ", p.name, object_getIvar(p, nameIvar), p.age);
    
    
    
    // 11、class_copyIvarList：获取当前类所有的成员变量
    unsigned int count;
    Ivar * ivarList =  class_copyIvarList([p class], &count);
    for (int i=0; i<count; i++) {
        //
        Ivar ivar = ivarList[i];
        NSLog(@"__ %s __ %s __", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    // 所有包含copy关键字的c函数api都得调用free释放
    free(ivarList);
    
}

// 字典转模型
void objectWithJson(void) {
    NSDictionary * dic = @{
        @"age": @20,
        @"weight": @60,
        @"name":@"fcf",
    };
    
    Person * p = [Person fcf_objectWithJson:dic];
    NSLog(@"%@", p);
}



void run1(id self, SEL _cmd) {
    NSLog(@"_____ %@ _ %@ 123", self, NSStringFromSelector(_cmd));
}

void test(id self, SEL _cmd) {
    NSLog(@"_____ %@ _ %@ 123", self, NSStringFromSelector(_cmd));
}

// runtime 方法相关 API
void useMethodApi() {
    Person * p = [Person new];
    
    // 12、class_replaceMethod: 方法替换
    class_replaceMethod([Person class], @selector(run), (IMP)run, "v@:");
    [p run];
    
    // 13、imp_implementationWithBlock: 使用block实现方法
    class_replaceMethod([p class], @selector(run), imp_implementationWithBlock(^{
        NSLog(@"123456");
    }),  "v@:");
    
    [p run];
    
    // 14、method_exchangeImplementations：方法交换
    Method runMethod = class_getInstanceMethod([Person class], @selector(run));
    Method testMethod = class_getInstanceMethod([Car class], @selector(test));
    method_exchangeImplementations(runMethod, testMethod);
    
    [p run];
}
