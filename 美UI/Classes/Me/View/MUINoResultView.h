//
//  MUINoResultView.h
//  美UI
//
//  Created by Lee on 16-3-22.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUINoResultView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

+ (instancetype)noView;

@end
