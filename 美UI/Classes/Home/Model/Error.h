//
//  Error.h
//  美UI
//
//  Created by Lee on 17/3/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ErrorType) {
    ErrorTypeNodata,
    ErrorTypeRequest,
    ErrorTypeNetwork
};

@interface Error : NSObject

@property (nonatomic, assign) ErrorType type;
@property (nonatomic, copy) NSString *message;

+ (instancetype)errorWithType:(ErrorType)type;

@end
