//
//  MUISearchTableCell.h
//  美UI
//
//  Created by Lee on 15-12-25.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTableCellDelegate <NSObject>

@optional

- (void)searchTableCellDeleteItem:(NSString *)title;

@end

@interface MUISearchTableCell : UITableViewCell

@property (weak, nonatomic) id <SearchTableCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *title;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
