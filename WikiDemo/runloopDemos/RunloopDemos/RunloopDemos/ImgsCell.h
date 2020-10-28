//
//  ImgsCell.h
//  RunloopDemos
//
//  Created by 冯才凡 on 2019/1/31.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

+(instancetype)cellWithTableView:(UITableView *)tableview;
@end

NS_ASSUME_NONNULL_END
