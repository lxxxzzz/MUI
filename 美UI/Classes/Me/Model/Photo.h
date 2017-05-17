//
//  Photo.h
//  美UI
//
//  Created by Lee on 17/2/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALAsset;

@interface Photo : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
