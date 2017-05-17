//
//  MUIMessage.m
//  美UI
//
//  Created by Lee on 15-12-30.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUIMessage.h"

@implementation MUIMessage

- (NSString *)stringWithTimeInterval {
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = 24 * 60 * 60 * 1; //1天
    NSDate *startDate = [nowDate initWithTimeIntervalSinceNow:+interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:startDate];
}

@end
