//
//  Student.m
//  RuntimeDemos
//
//  Created by 冯才凡 on 2020/11/8.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Student.h"

@implementation Student

/*
static void _I_Student_run(Student * self, SEL _cmd) {
    ((void (*)(__rw_objc_super *, SEL))(void *)objc_msgSendSuper)((__rw_objc_super){(id)self, (id)class_getSuperclass(objc_getClass("Student"))}, sel_registerName("run"));
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_st_tcbt2p654cbdkmj6q00fnzn40000gn_T_Student_82fc44_mi_0, __func__);
}
*/

- (void)run {
    
    [super run];
    NSLog(@"%s", __func__);
}
@end
