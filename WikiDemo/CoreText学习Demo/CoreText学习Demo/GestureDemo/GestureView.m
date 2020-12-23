//
//  GestureView.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "GestureView.h"
#import <CoreText/CoreText.h>
#import "FCFDrawView.h"
#import <BlocksKit+UIKit.h>

@implementation GestureView

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
    
    CGRect frame = CGRectMake(0, 100, self.bounds.size.width, 400);
    FCFDrawView *textDrawView = [[FCFDrawView alloc] initWithFrame:frame];
    textDrawView.backgroundColor = [UIColor whiteColor];
    
    // 添加普通的文本
    [textDrawView addString:@"Hello World " attribute:[self defaultTextAttributes] clickActionHandler:^(id  _Nonnull obj) {
        
    }];
    
    // 添加链接
    [textDrawView addLink:@"http://www.baidu.com" clickActionHandler:^(id obj) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"链接点击" message:[NSString stringWithFormat:@"点击对象%@", obj] preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
        [self.parentVC presentViewController:alert animated:YES completion:nil];
    }];
    
    // 添加图片
    [textDrawView addImage:[UIImage imageNamed:@"tata_img_hottopicdefault"] size:CGSizeMake(30, 30) clickActionHandler:^(id obj) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"图片点击" message:[NSString stringWithFormat:@"点击对象%@", obj] preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
        [self.parentVC presentViewController:alert animated:YES completion:nil];
    }];
    
    // 添加链接
    [textDrawView addLink:@"http://www.baidu.com" clickActionHandler:^(id obj) {
        
    }];
    
    // 添加普通的文本
    [textDrawView addString:@"这是一个最好的时代，也是一个最坏的时代；" attribute:[self defaultTextAttributes] clickActionHandler:^(id obj) {
        
    }];
    
    // 添加链接
    [textDrawView addLink:@" 这是明智的时代，这是愚昧的时代；这是信任的纪元，这是怀疑的纪元；这是光明的季节，这是黑暗的季节；这是希望的春日，这是失望的冬日； " clickActionHandler:^(id obj) {
        
    }];
    
    // 添加自定义的View，默认是底部对其
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    customView.backgroundColor = [UIColor colorWithRed:1 green:0.7 blue:1 alpha:0.51];
    [customView bk_whenTapped:^{
        NSLog(@"customView Tapped");
    }];
    UILabel *labelInCustomView = [UILabel new];
    labelInCustomView.frame = customView.bounds;
    labelInCustomView.textAlignment = NSTextAlignmentCenter;
    labelInCustomView.font = [UIFont systemFontOfSize:12];
    labelInCustomView.text = @"可点击的自定义的View";
    [customView addSubview:labelInCustomView];
//    [labelInCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(customView);
//    }];
    [textDrawView addView:customView size:customView.frame.size clickActionHandler:nil];
    
    // 添加普通的文本
    [textDrawView addString:@" Hello " attribute:self.defaultTextAttributes clickActionHandler:nil];

    
    // 添加居中对其的自定义的View
    UIView *unClickableCustomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    unClickableCustomView.backgroundColor = [UIColor colorWithRed:1 green:0.7 blue:1 alpha:0.51];
    UILabel *labelInUnClickableCustomView = [UILabel new];
    labelInUnClickableCustomView.frame = unClickableCustomView.bounds;
    labelInUnClickableCustomView.textAlignment = NSTextAlignmentCenter;
    labelInUnClickableCustomView.font = [UIFont systemFontOfSize:12];
    labelInUnClickableCustomView.text = @"居中对其自定义的View";
    [unClickableCustomView addSubview:labelInUnClickableCustomView];
//    [labelInUnClickableCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(unClickableCustomView);
//    }];
    [textDrawView addView:unClickableCustomView size:unClickableCustomView.frame.size align:(FCFAttachmentAlignTypeCenter) clickActionHandler:nil];

    // 添加普通的文本
    [textDrawView addString:@" 我们面前应有尽有，我们面前一无所有； " attribute:self.defaultTextAttributes clickActionHandler:nil];
    
    // 添加自定义的按钮，默认是底部对其
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:@"我是按钮" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [button bk_addEventHandler:^(id sender) {
        NSLog(@"button Clicked");
    } forControlEvents:UIControlEventTouchUpInside];
    [textDrawView addView:button size:button.frame.size clickActionHandler:nil];
    
    [textDrawView addString:@" " attribute:self.defaultTextAttributes clickActionHandler:nil];
    
    // 添加顶部对其按钮
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 90, 30);
    [button setTitle:@"顶部对其按钮" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//    [button bk_addEventHandler:^(id sender) {
//        NSLog(@"button Clicked");
//    } forControlEvents:UIControlEventTouchUpInside];
    [textDrawView addView:button size:button.frame.size align:(FCFAttachmentAlignTypeTop) clickActionHandler:nil];
    
    // 添加普通的文本
    [textDrawView addString:@" 我们都将直上天堂，我们都将直下地狱。 " attribute:self.defaultTextAttributes clickActionHandler:nil];
    
    [self addSubview:textDrawView];
    
    
}

// MARK: - Config
- (NSDictionary *)defaultTextAttributes {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor blackColor]
                                 };
    return attributes;
}

- (NSDictionary *)boldHighlightedTextAttributes {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24],
                                 NSForegroundColorAttributeName: [UIColor redColor],
                                 };
    return attributes;
}

- (NSDictionary *)linkTextAttributes {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor blueColor],
                                 NSUnderlineStyleAttributeName: @1,
                                 NSUnderlineColorAttributeName: [UIColor blueColor],
                                 };
    return attributes;
}

@end
