//
//  MUIUserInfoEditCell.m
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIUserInfoEditCell.h"

@implementation MUIUserInfoEditCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"edit";
    MUIUserInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MUIUserInfoEditCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
