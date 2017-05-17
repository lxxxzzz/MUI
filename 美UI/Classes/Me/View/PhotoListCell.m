//
//  PhotoListCell.m
//  美UI
//
//  Created by Lee on 17/2/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoListCell.h"
#import "Photo.h"
#import "UIImage+Stretch.h"

@interface PhotoListCell ()

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation PhotoListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
        
//        self.selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 23, 5, 18, 18)];
//        [self.selectedBtn setImage:[UIImage imageNamed:@"gallery_chs_normal"] forState:UIControlStateNormal];
//        [self.selectedBtn setImage:[UIImage imageNamed:@"gallery_chs_seleceted"] forState:UIControlStateSelected];
//        self.selectedBtn.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setPhoto:(Photo *)photo {
    _photo = photo;
    self.imageView.image = photo.image;
//    self.selectedBtn.selected = photo.isSelected;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = [image getSubImage:CGRectMake(0, 0, image.size.width, image.size.width)];
}

@end
