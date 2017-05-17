//
//  MUIHttpParams.h
//  美UI
//
//  Created by Lee on 16-3-29.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUIHttpParams : NSObject
/**
 *  function
 */
@property (nonatomic, copy) NSString *function;

/**
 *  mac
 */
@property (nonatomic, copy) NSString *mac;

/**
 *  token
 */

@property (nonatomic, copy) NSString *token;
/**
 *  page
 */
@property (nonatomic, assign) int page;

+ (NSMutableDictionary *)homeParams;
+ (NSMutableDictionary *)searchParams;
+ (NSMutableDictionary *)createTagParams;
+ (NSMutableDictionary *)searchResultParams;
+ (NSMutableDictionary *)collectParams;
+ (NSMutableDictionary *)feedbackParams;
+ (NSMutableDictionary *)weixinParams;
+ (NSMutableDictionary *)registerParams;
+ (NSMutableDictionary *)registerMessageParams;
+ (NSMutableDictionary *)resetPasswordParams;
+ (NSMutableDictionary *)editNameParams;
+ (NSMutableDictionary *)editIconParams;
+ (NSMutableDictionary *)detailParams;

@end
