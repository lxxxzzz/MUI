//
//  MUIMessageCell.m
//  美UI
//
//  Created by Lee on 15-12-30.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUIMessageCell.h"
#import "MUIMessage.h"
#import "UIImageView+WebCache.h"
#import "NSURL+chinese.h"

@interface MUIMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageType;
@property (weak, nonatomic) IBOutlet UILabel *messageTime;
@property (weak, nonatomic) IBOutlet UILabel *messageContent;
@property (weak, nonatomic) IBOutlet UIImageView *messageImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraints;

@end

@implementation MUIMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"message";
    MUIMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MUIMessageCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setMessage:(MUIMessage *)message {
    _message = message;
//    if ([message.messageType isEqualToString:@"1"]) {
//        self.messageType.text = @"未处理";
//    } else if ([message.messageType isEqualToString:@"2"]) {
//        self.messageType.text = @"已处理";
//    } else if ([message.messageType isEqualToString:@"3"]) {
//        self.messageType.text = @"审核失败";
//    } else {
//        self.messageType.text = @"";
//    }
    self.messageType.text = @"系统消息";
    self.messageTime.text = [message stringWithTimeInterval];
    self.messageContent.text = message.messageContent;
    NSURL *url = [NSURL xx_URLWithString:message.messageImage];
    [self.messageImage sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"%@   %@",image, message);
        if (image) {
            self.widthConstraints.constant = self.messageImage.frame.size.height * image.size.width / image.size.height;
        } else {
            self.widthConstraints.constant = self.messageImage.frame.size.height * 100 / 50;
        }

    }];
}

@end
