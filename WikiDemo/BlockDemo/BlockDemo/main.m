//
//  main.m
//  BlockDemo
//
//  Created by 冯才凡 on 2020/10/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCFPerson.h"


//struct __main_block_desc_0 {
//   size_t reserved;
//   size_t Block_size;
//};
//
//struct __block_impl {
//  void *isa;
//  int Flags;
//  int Reserved;
//  void *FuncPtr;
//};
//
//struct __main_block_impl_3 {
//    struct __block_impl impl;
//    struct __main_block_desc_3* Desc;
//    int age;
//  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
//    impl.isa = &_NSConcreteStackBlock;
//    impl.Flags = flags;
//    impl.FuncPtr = fp;
//    Desc = desc;
//  }
//};


int _age = 10;
static int _height = 10;
void (^block4)(void);
void test() {
    int age = 10;
    static int height = 10;
    block4 = ^{
        NSLog(@"age is %d, height is %d", age, height);
        NSLog(@"_age is %d, _height is %d", _age, _height);
    };
    age = 20;
    height = 20;
    _age = 20;
    _height = 20;
    block4();
}// 执行到这里 age 就会被销毁。但是height不会销毁。

void practice() {
    test();
    //执行到这里时，block里面又得访问age和height。而此时age已经销毁了。所以在block内部，得优先把age的值存起来，所以使用值传递就可以了。而height是静态变量，其仍旧存储在内存中，仍然可以访问到height的地址，所以使用值传递，而无需开辟新的空间。
    block4();
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        /*
         下面的age变量最终编译成了一个结构体：
         struct __Block_byref_age_0 {
           void *__isa;
         __Block_byref_age_0 *__forwarding; 
          int __flags;
          int __size;
          int age;
         };
         下面FCFPerson对象也被编译成了一个结构体：
         struct __Block_byref_p_1 {
           void *__isa;
         __Block_byref_p_1 *__forwarding;
          int __flags;
          int __size;
          void (*__Block_byref_id_object_copy)(void*, void*);
          void (*__Block_byref_id_object_dispose)(void*);
          FCFPerson *p;
         };

         下面行最终编译成：
         __Block_byref_age_0 age = {
                    0,
                    &age,
                    0,
                    sizeof(__Block_byref_age_0),
                    10
         };
         */
        __block int age = 10;
        __block FCFPerson * p = [FCFPerson new];
        p.name = @"fcf";
        void (^block)(void) = ^{
            // (age->__forwarding->age) = 20;
            age = 20;
            /*
             下面一行被编译成：
            p = {0,&p, 33554432, sizeof(__Block_byref_p_1), __Block_byref_id_object_copy_131, __Block_byref_id_object_dispose_131, ((objc_msgSend)(objc_getClass("FCFPerson"), sel_registerName("new"))};
             */
            p = [FCFPerson new];
            p.name = @"fcf1";
            NSLog(@"age=%d, name=%@",age, p.name);
        };
        block();
        NSLog(@"%d",age);
    }
    return 0;
}

//void test2() {
//    {
//        FCFPerson * p = [FCFPerson new];
//        p.name = @"fcf";
//    } //代码 块作用域结束，p就被释放了。
//    NSLog(@"-----");
//
//    void (^block)(void);
//    {
//        FCFPerson * p = [FCFPerson new];
//        p.name = @"fcf";
//        block = ^{
//            NSLog(@"p.naem = %@",p.name);
//        };
//    } //代码块作用域结束，p没有被释放了。
//    NSLog(@"-----");
//
//    {
//        FCFPerson * p = [FCFPerson new];
//        p.name = @"fcf";
//        __weak FCFPerson * weakp = p;
//        block = ^{
//            NSLog(@"p.naem = %@",weakp.name);
//        };
//    } //代码块作用域结束，p被释放了。
//    NSLog(@"-----");
//}

void test1() {
    //说明block是一个对象
    void (^block0)(void) = ^ {
        NSLog(@"xxxxxx");
    };
    NSLog(@"%@", [block0 class]); //__NSGlobalBlock__
    NSLog(@"%@", [[block0 class] superclass]); //__NSGlobalBlock
    NSLog(@"%@", [[[block0 class] superclass] superclass]); //NSBlock
    NSLog(@"%@", [[[[block0 class] superclass] superclass] superclass]); //NSObject
    
    void (^block)(void) = ^{
        NSLog(@"hello");
    };
    
    int age = 10;
    void (^block2)(void) =^{
        NSLog(@"hello -- %d", age);
    };
    
    NSLog(@"%@\n%@\n%@",
          [block class],        //__NSGlobalBlock__
          [block2 class],       //__NSMallocBlock__
          [^{
        NSLog(@"%d", age);
    } class]);            //__NSStackBlock__
    
}

void test0() {
    /*
     ^{
     NSLog(@"这是一个block");
     };
     
     void (^block)(void) = ^{
     NSLog(@"这又是一个block");
     };
     
     block();
     
     void (^block2)(int, NSString *) = ^(int a, NSString * b){
     NSLog(@"这是一个带参数的block");
     NSLog(@"%d", a);
     NSLog(@"%@", b);
     };
     
     block2(1,@"a");
     
     int age = 20;
     void (^block3)(void) = ^ {
     NSLog(@"age is %d", age); //打印出来的是10
     };
     
     age = 30;
     
     struct __main_block_impl_3 * blockStruct = (__bridge struct __main_block_impl_3 *)block3;
     
     block3();
     */
    
    /*
     下面block 编译后的代码。
     struct __main_block_impl_0 {
     struct __block_impl impl;
     struct __main_block_desc_0* Desc;
     int age;
     int *height;
     FCFPerson *p;
     __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _age, int *_height, FCFPerson *_p, int flags=0) : age(_age), height(_height), p(_p) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
     }
     };
     
     从age、height、p两个变量可知，这两个局部变量都会被block捕获。
     */
    
    auto int age = 10;
    static int height = 10;
    FCFPerson * p = [FCFPerson new];
    p.name = @"fcf";
    void (^block)(void) = ^{
        NSLog(@"age is %d, height is %d, person name is %@", age, height, p.name);
    };
    age = 20;
    height = 20;
    p.name = @"fcf2";
    
    block();
}
