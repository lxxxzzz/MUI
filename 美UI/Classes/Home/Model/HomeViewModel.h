//
//  HomeViewModel.h
//  美UI
//
//  Created by Lee on 17/3/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Error;

@interface HomeViewModel : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
- (void)dataWithSuccess:(void(^)(NSArray *datas))success failure:(void(^)(Error *error))failure;

@end
