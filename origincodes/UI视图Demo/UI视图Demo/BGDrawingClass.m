//
//  BGDrawingClass.m
//  UI视图Demo
//
//  Created by 冯才凡 on 2019/5/13.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "BGDrawingClass.h"


@interface BGDrawingClass() {
    CGImageRef bgImage;
}

@end

@implementation BGDrawingClass

- (void)awakeFromNib {
//    self.layer.delegate = self;
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
}

@end
