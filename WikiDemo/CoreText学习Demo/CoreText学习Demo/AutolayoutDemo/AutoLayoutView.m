//
//  AutoLayoutView.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/23.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "AutoLayoutView.h"
#import "FCFDrawView.h"
#import <Masonry.h>

@implementation AutoLayoutView

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
    
    {
        CGRect frame = CGRectMake(0, 20, self.bounds.size.width, 100);
        FCFDrawView *textDrawView = [[FCFDrawView alloc] initWithFrame:frame];
        textDrawView.backgroundColor = [UIColor whiteColor];
        textDrawView.text = @"手动布局手动计算高度：\n这是一个最好的时代，也是一个最坏的时代；这是明智的时代，这是愚昧的时代；这是信任的纪元，这是怀疑的纪元；这是光明的季节，这是黑暗的季节；这是希望的春日，这是失望的冬日；我们面前应有尽有，我们面前一无所有；我们都将直上天堂，我们都将直下地狱。";
        textDrawView.textColor = [UIColor redColor];
        textDrawView.font = [UIFont systemFontOfSize:16];
        CGSize size = [textDrawView sizeThatFits:CGSizeMake(frame.size.width, MAXFLOAT)];
        textDrawView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), size.width, size.height);
        [self addSubview:textDrawView];
    }
    
    {
        FCFDrawView *textDrawView = [[FCFDrawView alloc] initWithFrame:CGRectZero];
        textDrawView.backgroundColor = [UIColor whiteColor];
        textDrawView.text = @"自动布局自动计算高度：\n这是一个最好的时代，也是一个最坏的时代；这是明智的时代，这是愚昧的时代；这是信任的纪元，这是怀疑的纪元；这是光明的季节，这是黑暗的季节；这是希望的春日，这是失望的冬日；我们面前应有尽有，我们面前一无所有；我们都将直上天堂，我们都将直下地狱。";
        textDrawView.textColor = [UIColor redColor];
        textDrawView.font = [UIFont systemFontOfSize:16];
        textDrawView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        [self addSubview:textDrawView];
        [textDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(200);
        }];
    }
    
    {
        FCFDrawView *textDrawView = [[FCFDrawView alloc] initWithFrame:CGRectZero];
        textDrawView.backgroundColor = [UIColor whiteColor];
        textDrawView.text = @"自动布局限制高度：\n这是一个最好的时代，也是一个最坏的时代；这是明智的时代，这是愚昧的时代；这是信任的纪元，这是怀疑的纪元；这是光明的季节，这是黑暗的季节；这是希望的春日，这是失望的冬日；我们面前应有尽有，我们面前一无所有；我们都将直上天堂，我们都将直下地狱。";
        textDrawView.textColor = [UIColor redColor];
        textDrawView.font = [UIFont systemFontOfSize:16];
        // 这一步很重要，需要传递一个frame，其实在自动布局模式下只要用到width,其它值为0即可
        textDrawView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        [self addSubview:textDrawView];
        [textDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(400);
            make.height.mas_equalTo(64);
        }];
    }
}

@end
