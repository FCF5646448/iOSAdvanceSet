//
//  IndexdTableView.m
//  UI视图Demo
//
//  Created by 冯才凡 on 2019/5/10.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "IndexdTableView.h"
#import "ViewReusePool.h"

@interface IndexdTableView()
{
    UIView * containerView;
    ViewReusePool * reusePool;
}
@end


@implementation IndexdTableView
- (void)reloadData {
    [super reloadData];
    //
    if (containerView == nil) {
        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.backgroundColor = [UIColor whiteColor];
        
        //
        [self.superview insertSubview:containerView aboveSubview:self]; //最上层
    }
    
    if (reusePool == nil) {
        reusePool = [[ViewReusePool alloc] init];
    }
    
    //标记所有视图为可重用状态
    [reusePool reset];
    
    //reload
    [self reloadIndexBar];
    
}

- (void)reloadIndexBar {
    //获取字母索引条的显示内容
    NSArray <NSString *> * arratTitles = nil;
    if ([self.indexedDataSource respondsToSelector:@selector(indexTitlesForIndexTableView:)]) {
        arratTitles = [self.indexedDataSource indexTitlesForIndexTableView:self];
    }

    if (!arratTitles || arratTitles.count <= 0) {
        [containerView setHidden:YES];
        return;
    }
    
    NSUInteger count = arratTitles.count;
    CGFloat buttonWidth = 60;
    CGFloat buttonHeight = self.frame.size.height / count;
    
    for (int i = 0; i < arratTitles.count; i++) {
        NSString * title = [arratTitles objectAtIndex:i];
        
        //
        UIButton * btn = (UIButton *)[reusePool dequeuereusebleView];
        if (btn == nil) {
            btn = [[UIButton alloc] initWithFrame:CGRectZero];
            btn.backgroundColor = UIColor.whiteColor;
            
            [reusePool addUsingView:btn];
            NSLog(@"新建了");
        }else{
            NSLog(@"重用了");
        }
        
        
        //添加到父控件
        [containerView addSubview:btn];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn setFrame:CGRectMake(0, i*buttonHeight, buttonWidth, buttonHeight)];
    }
    
    [containerView setHidden:NO];
    containerView.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - buttonWidth, self.frame.origin.y, buttonWidth, self.frame.size.height);
    
}


@end
