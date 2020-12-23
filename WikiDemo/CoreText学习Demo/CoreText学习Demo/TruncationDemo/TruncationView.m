//
//  TruncationView.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/23.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "TruncationView.h"
#import "FCFDrawView.h"

@implementation TruncationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void) initUI {
    self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    CGRect frame = CGRectMake(0, 100, self.bounds.size.width, 100);
    FCFDrawView *textDrawView = [[FCFDrawView alloc] initWithFrame:frame];
    textDrawView.backgroundColor = [UIColor whiteColor];
    textDrawView.numOfLines = 3;
    [textDrawView addString:@"这是一个最好的时代，也是一个最坏的时代；这是明智的时代，这是愚昧的时代；这是信任的纪元，这是怀疑的纪元；这是光明的季节，这是黑暗的季节；这是希望的春日，这是失望的冬日；我们面前应有尽有，我们面前一无所有；我们都将直上天堂，我们都将直下地狱。" attribute:self.defaultTextAttributes clickActionHandler:^(id obj) {
    }];
    [self addSubview:textDrawView];
    
    NSAttributedString * truncationToken = [[NSAttributedString alloc] initWithString:@"查看更多" attributes:[self truncationTextAttributes]];
    frame = CGRectMake(0, 220, self.bounds.size.width, 100);
    textDrawView = [[FCFDrawView alloc] initWithFrame:frame];
    textDrawView.backgroundColor = [UIColor whiteColor];
    textDrawView.numOfLines = 2;
    textDrawView.trunToken = truncationToken;
    [textDrawView addString:@"这是一个最好的时代，也是一个最坏的时代；这是明智的时代，这是愚昧的时代；这是信任的纪元，这是怀疑的纪元；这是光明的季节，这是黑暗的季节；这是希望的春日，这是失望的冬日；我们面前应有尽有，我们面前一无所有；我们都将直上天堂，我们都将直下地狱。" attribute:self.defaultTextAttributes clickActionHandler:^(id obj) {
    }];
    __weak typeof(textDrawView) weakDrawView = textDrawView;
    textDrawView.trunActionHandler = ^(id obj) {
        NSLog(@"点击查看更多");
        weakDrawView.numOfLines = 0;
    };
    [self addSubview:textDrawView];
    
}

// MARK: - Config
- (NSDictionary *)defaultTextAttributes {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor blackColor]
                                 };
    return attributes;
}

- (NSDictionary *)truncationTextAttributes {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor blueColor]
                                 };
    return attributes;
}

@end
