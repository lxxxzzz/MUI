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
    self.messageType.text = message.messageType;
    self.messageTime.text = [message stringWithTimeInterval];
    self.messageContent.text = message.messageContent;
    [self.messageImage sd_setImageWithURL:[NSURL URLWithString:message.messageImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.widthConstraints.constant = self.messageImage.frame.size.height * image.size.width / image.size.height;
    }];
}

@end
