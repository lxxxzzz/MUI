//
//  MUIUserInfoNameEditViewController.h
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUIUserInfoNameEditViewController : UITableViewController

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) void(^updateNameBlock)(NSString *name);

@end
