//
//  IndexdTableView.h
//  UI视图Demo
//
//  Created by 冯才凡 on 2019/5/10.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IndexdTableViewDataSource <NSObject>

- (NSArray<NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView;

@end


@interface IndexdTableView : UITableView

@property (nonatomic, weak) id<IndexdTableViewDataSource> indexedDataSource;

@end





