//
//  ViewController.m
//  RuntimeDemos
//
//  Created by 冯才凡 on 2018/12/15.
//  Copyright © 2018年 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "TestObjc.h"
#import "ORMTestObjc.h"
#import <objc/runtime.h>
#import <objc/message.h>

@protocol TestProtocol <NSObject>
@property (nonatomic, copy)NSString * protocol;
@end

@interface TestObj : NSObject
@property (nonatomic, assign)NSInteger num;
- (void)testMethod;
- (void)testMethod:(NSString *)text;
@end

@interface TestObj()<TestProtocol>
@property (nonatomic, copy)NSString * text;
@end

@implementation TestObj
- (void)testMethod {
    NSLog(@"TestObj testMethod:%p", @selector(testMethod));
}
- (void)testMethod:(NSString *)text {
    NSLog(@"IMP TEST %@",text);
    _text = text;
}

@synthesize protocol;

@end


@interface Test2 : NSObject
@property (nonatomic, copy)NSString * name;

@end

@implementation Test2

- (void)test2 {
    NSLog(@"name: %@",self.name);
}

- (void)testMethod {
    NSLog(@"Test2 testMethod:%p", @selector(testMethod));
}



@end

typedef void(^Block)(void);

@interface ViewController ()
@property (nonatomic, copy)Block block;
@property (nonatomic, assign)int a;
@property (nonatomic, assign) int age;
@end

@interface NSObject(category)
+ (void)foo;
@end

@implementation NSObject(category)
- (void)foo {
    NSLog(@"hhhhhhhheheheheheh");
}
@end

@interface Test2(category)
+ (void)too;
@end

@implementation Test2(category)
- (void)too {
    NSLog(@"xxxx");
}
@end

@interface Test3 : NSObject
@property (nonatomic, copy)NSString * name;
@end

@implementation Test3
- (void)test3 {
    NSLog(@"test3 xxx");
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view = nil;
//    [self test];
    
//    id t = [Test2 class];
//    void * obj = &t;
//    [(__bridge id)obj test2];
//    [[Test2 new] test2];

    
//    [[TestObj new] testMethod];
//    [[Test2 new] testMethod];
    
//    [self test]; //ViewController (category03)
    
    //调用所有的category方法
    
//    [self callCategorys];
    
//    [self resolveMethod];
    
//    [self blockTest];
//    self.age = 1;
    
    [self classClusters];
    
//    [self interview];
    
    
}


//面试题
- (void)interview {
    //2
//    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
//    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
//    BOOL res3 = [(id)[Test2 class] isKindOfClass:[Test2 class]];
//    BOOL res4 = [(id)[Test2 class] isMemberOfClass:[Test2 class]];
//
//    BOOL res5 = [[NSObject new] isKindOfClass:[NSObject class]];
//    BOOL res6 = [[NSObject new] isMemberOfClass:[NSObject class]];
//    BOOL res7 = [[Test2 new] isKindOfClass:[Test2 class]];
//    BOOL res8 = [[Test2 new] isMemberOfClass:[Test2 class]];
    
    //3
//    [NSObject foo];
//    [Test2 foo];
    
    //4
    id cls = [Test3 class];
    void * obj = &cls;
    [(__bridge id)obj test3];
    
    id cls2 = [Test3 alloc];
    [cls2 test3];
    
    id cls3 = [[Test3 alloc] init];
    [cls3 test3];
    
}


//ORM
- (void)orm {
    NSDictionary *dict = @{@"name" : @"lxz",
                           @"age" : @18,
                           @"gender" : @YES,
                           @"arr" : @[@1,@2,@3],
                           };
    
    ORMTestObjc * obj = [ORMTestObjc objectWithDict:dict];
    NSLog(@"%@",obj);
}

//类簇
- (void)classClusters {
    id obj1 = [NSArray alloc];//(__NSPlaceholderArray *) obj1 = 0x0000600002084080
    id obj2 = [NSMutableArray alloc];//(__NSPlaceholderArray *) obj2 = 0x0000600002084070
    id obj3 = [obj1 init];//__NSArray0 0x6000020840a0
    id obj4 = [obj2 init];//__NSArrayM 0x600002cd11a0
    
    
    NSArray * arr = @[@(1),@(2),@(3),@(4),@(5)];
    NSLog(@"%@",[arr objectAtIndex:0]);
    
    NSLog(@"%@",[arr objectAtIndex:6]);
    NSLog(@"%@",arr[7]);
    
    NSMutableArray * marr = [NSMutableArray arrayWithObjects:@[@(1),@(2),@(3),@(4),@(5)], nil];
    NSLog(@"%@",[marr objectAtIndex:0]);
    
    NSLog(@"%@",[marr objectAtIndex:6]);
    NSLog(@"%@",marr[7]);
    
}


- (void)setAge:(int)age {
    _age = age;
}
//__block   __weak

static int b = 0;

- (void)blockTest {
//    __block int a = 0;
    NSLog(@"a:%d b:%d",self.a,b);
    void (^block)(void) = ^{
        self.a = 1;
        b = 1;
        NSLog(@"a:%d b:%d",self.a,b);
    };
    block();
    self.a = 2;
    b = 2;
    NSLog(@"a:%d b:%d",self.a,b);
    
    int (^sum)(int a1, int b1) = ^(int a1, int b1) {
        return a1 + b1;
    };
    
    int result = sum(1,2);
    NSLog(@"%d",result);
}



#pragma mark -- 消息转发
void dynamicResoleMethod(id sf,SEL _cmd) {
    NSLog(@"xxxxxxx");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(resolveMethod)) {
        return NO;
        const char * types = sel_getName(sel);
        class_addMethod([self class], sel, (IMP)dynamicResoleMethod, types);
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(resolveMethod)) {
        return nil;
        return [TestObjc new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (aSelector == @selector(resolveMethod)){
        return [TestObjc instanceMethodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (class_respondsToSelector([TestObjc class], @selector(resolveMethod))) {
        [anInvocation invokeWithTarget:[TestObjc new]];
    }
}

//category
- (void)callCategorys {
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList([self class], &methodCount);
    for (NSUInteger i=0; i<methodCount; i++) {
        Method method = methodList[i];
        NSString * methodName = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
        if ([@"test" isEqualToString:methodName]) {
            typedef void(*fn)(id, SEL);
            IMP imp = method_getImplementation(method);
            SEL sel = method_getName(method);
            fn f = (fn)imp;
            f(self,sel);
        }
    }
}

- (void)test{
    NSLog(@"viewDidLoad");
}

// 方法调用
- (void)callFunc {
    //
    IMP func1 = [[TestObj class] instanceMethodForSelector:@selector(testMethod)];
    func1();
    
    //
    TestObj * obj = [[TestObj alloc] init];
    IMP func2 = [obj methodForSelector:@selector(testMethod)];
    func2();
}


- (void)funcpoint {
    //实现消息调用优化
    TestObj * obj = [[TestObj alloc] init];
    void (*func)(id, SEL) = (void(*)(id, SEL))class_getMethodImplementation([TestObj class],@selector(testMethod));
    func(obj, @selector(testMethod));
}

//使用block拦截函数具体实现
- (void)blockFunc {
    TestObj * obj = [[TestObj alloc] init];
    IMP function = imp_implementationWithBlock(^(id self,NSString * text){
        NSLog(@"callback block: %@",text);
    });
    const char * types = sel_getName(@selector(testMethod:));
    //替换掉方法
    class_replaceMethod([TestObj class], @selector(testMethod:), function, types);
    
    [obj testMethod:@"fcf"];

}

// 获取属性、方法、变量、协议列表
- (void)getProperty {
    //获取实例对象属性列表和协议属性列表
    unsigned int count = 0;
    // 获取属性列表
    objc_property_t * propertylists = class_copyPropertyList([TestObj class],&count);
    for (int i =0; i<count; i++) {
        const char * pname = property_getName(propertylists[i]);
        NSLog(@"property name:%s",pname);
    }
    
    // 获取方法列表
    Method * methodList = class_copyMethodList([TestObj class], &count);
    for (int i =0; i<count; i++) {
        NSString * mname = NSStringFromSelector(method_getName(methodList[i]));
        NSLog(@"method name:%@",mname);
    }
    
    // 获取变量列表
    Ivar * ivarList = class_copyIvarList([TestObj class], &count);
    for (int i=0; i<count; i++) {
        const char * iname = ivar_getName(ivarList[i]);
        NSLog(@"ivar name:%@", [NSString stringWithUTF8String:iname]);
    }
    
    // 遵循的协议列表
    __unsafe_unretained Protocol ** protocolList = class_copyProtocolList([TestObj class], &count);
    for (int i =0; i<count; i++) {
        Protocol * p = protocolList[i];
        const char * pname = protocol_getName(p);
        NSLog(@"protocol name:%@",[NSString stringWithUTF8String:pname]);
    }
}

// isa
- (void)printClass {
    NSLog(@"self %@",[self class]);
    NSLog(@"super %@",[super class]);
}

//消息转发机制
- (void)msgSendTest {
    
}






@end
