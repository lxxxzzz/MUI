//
//  MUIMessageCell.h
//  美UI
//
//  Created by Lee on 15-12-30.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MUIMessage;

@interface MUIMessageCell : UITableViewCell

@property (nonatomic, strong) MUIMessage *message;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
