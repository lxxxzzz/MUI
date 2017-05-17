//
//  MUISearchTableCell.m
//  美UI
//
//  Created by Lee on 15-12-25.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUISearchTableCell.h"

@implementation MUISearchTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"search";
    MUISearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MUISearchTableCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)delete
{
    if ([self.delegate respondsToSelector:@selector(searchTableCellDeleteItem:)])
    {
        [self.delegate searchTableCellDeleteItem:self.title.text];
    }
}

@end
