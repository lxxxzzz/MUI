//
//  MUIUserInfoEditCell.h
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUIUserInfoEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
