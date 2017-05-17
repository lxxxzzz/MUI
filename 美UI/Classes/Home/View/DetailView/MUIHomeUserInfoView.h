//
//  MUIHomeUserInfoView.h
//  美UI
//
//  Created by Lee on 16-1-22.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item;

@interface MUIHomeUserInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (nonatomic, strong) Item *item;

+ (instancetype)userView;

@end
