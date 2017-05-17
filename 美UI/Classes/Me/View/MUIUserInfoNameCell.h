//
//  MUIUserInfoNameCell.h
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUIUserInfoNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
