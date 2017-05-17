//
//  MUISearchHeaderView.h
//  美UI
//
//  Created by Lee on 16-1-8.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUISearchHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *line;

+ (instancetype)searchHeaderView;

@end
