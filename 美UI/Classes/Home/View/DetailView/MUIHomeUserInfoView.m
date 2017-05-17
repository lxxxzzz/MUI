//
//  MUIHomeUserInfoView.m
//  美UI
//
//  Created by Lee on 16-1-22.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIHomeUserInfoView.h"
#import "Item.h"
#import "UIImageView+WebCache.h"

@interface MUIHomeUserInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

@end

@implementation MUIHomeUserInfoView

+ (instancetype)userView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MUIHomeUserInfoView" owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)awakeFromNib
{
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width * 0.5;
    self.userIcon.layer.masksToBounds = YES;
    
    self.topLine.constant = 0.5f;
    self.bottomLine.constant = 0.5f;
}

- (void)setItem:(Item *)item
{
    _item = item;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:item.user_pic]];
    self.userName.text = item.user_name;
    self.appName.text = item.app_name;
}

@end
