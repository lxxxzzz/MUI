//
//  MUIUserInfoItem.h
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MUIUserInfoItemOption)();

@interface MUIUserInfoItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) MUIUserInfoItemOption option;
@property (nonatomic, strong) UIImage *icon;


+ (instancetype)itemWithTitle:(NSString *)title name:(NSString *)name icon:(UIImage *)icon option:(MUIUserInfoItemOption)option;

@end
