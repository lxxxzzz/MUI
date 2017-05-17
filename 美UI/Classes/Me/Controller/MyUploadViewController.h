//
//  MyUploadViewController.h
//  美UI
//
//  Created by Lee on 17/3/13.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^scrollowToPosition)(CGFloat offsetY);

@interface MyUploadViewController : UIViewController

@property (nonatomic, copy) scrollowToPosition point;

@end
