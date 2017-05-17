//
//  MUIHomeItem.h
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MUIHomeItem : NSObject

/**
 *  图片的URL
 */
@property (nonatomic, copy) NSString *url;

/**
 *  描述
 */
@property (nonatomic, copy) NSString *desc;

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *userIcon;

/**
 *  app名字
 */
@property (nonatomic, copy) NSString *appName;

/**
 *  标签
 */
@property (nonatomic, strong) NSMutableArray *tags;

/**
 *  我的标签
 */
@property (nonatomic, strong) NSMutableArray *user_tag;

/**
 *  宽
 */
@property(nonatomic,assign) CGFloat w;

/**
 *  高
 */
@property(nonatomic,assign) CGFloat h;

/**
 *  图片id
 */
@property (nonatomic, copy) NSString *pic_id;


/**
 *  image的高度
 */
@property (nonatomic, assign) CGFloat imageHeight;
/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) UIImage *placeholderImage;

/**
 *  用户标签
 */
@property (nonatomic, strong) NSArray *user_tag_history;

+ (instancetype)itemWithDict:(NSDictionary *)dict;
+ (instancetype)itemWithJSON:(NSDictionary *)json withUrl:(NSString *)url;

@end
