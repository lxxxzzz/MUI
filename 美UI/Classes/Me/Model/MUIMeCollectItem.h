//
//  MUIMeCollectItem.h
//  美UI
//
//  Created by Lee on 16-1-6.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUIMeCollectItem : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) NSArray *items;

+ (instancetype)itemWithDict:(NSDictionary *)dict withTag:(NSArray *)tags;

@end
