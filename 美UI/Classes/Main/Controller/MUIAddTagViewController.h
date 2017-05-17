//
//  MUIAddTagViewController.h
//  美UI
//
//  Created by Lee on 16-4-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUIAddTagViewController : UIViewController

@property (nonatomic, copy) void (^tagsBlock)(NSArray *tags);
@property (nonatomic, strong) NSArray *myTags;
@property (nonatomic, strong) NSArray *myAllTags;
@property (nonatomic, strong) NSArray *recommendTag;
/**
 *  图片id，用于发送网络请求新建标签
 */
@property (nonatomic, copy) NSString *pic_id;
@property (nonatomic, copy) void(^backEvent)();
@property (nonatomic, copy) void(^finishBlock)(NSArray *tags);

@end
