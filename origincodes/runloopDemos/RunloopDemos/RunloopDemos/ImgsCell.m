//
//  ImgsCell.m
//  RunloopDemos
//
//  Created by 冯才凡 on 2019/1/31.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import "ImgsCell.h"

@implementation ImgsCell

+(instancetype)cellWithTableView:(UITableView *)tableview {
    ImgsCell * cell = [tableview dequeueReusableCellWithIdentifier:@"ImgsCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ImgsCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor lightGrayColor];
    self.img1.layer.cornerRadius = 4;
    self.img1.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
