//
//  MUIUserInfoHeadCell.m
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIUserInfoHeadCell.h"

@implementation MUIUserInfoHeadCell

- (void)awakeFromNib {
    self.iconImage.layer.cornerRadius = 25;
    self.iconImage.layer.masksToBounds = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"head";
    MUIUserInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MUIUserInfoHeadCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
