//
//  MUIMessage.h
//  美UI
//
//  Created by Lee on 15-12-30.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUIMessage : NSObject

@property (nonatomic , copy) NSString *messageType;
@property (nonatomic , assign) NSTimeInterval messageTime;
@property (nonatomic , copy) NSString *messageContent;
@property (nonatomic , copy) NSString *messageImage;
@property (nonatomic, assign) NSInteger messageId;

- (NSString *)stringWithTimeInterval;

@end
