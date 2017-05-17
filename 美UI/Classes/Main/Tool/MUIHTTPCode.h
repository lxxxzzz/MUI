//
//  MUIHTTPCode.h
//  美UI
//
//  Created by Lee on 16-3-18.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUIHTTPCode : NSObject

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) int page;
@property (nonatomic, copy) NSString *error;

+ (instancetype)codeWithJSON:(NSDictionary *)dict;

@end
