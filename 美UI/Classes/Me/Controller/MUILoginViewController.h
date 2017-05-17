//
//  MUILoginViewController.h
//  美UI
//
//  Created by Lee on 16-3-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUILoginViewController : UIViewController

/** block*/
@property (nonatomic, copy) void(^dismiss)();
@property (nonatomic, copy) void(^cancelBlock)();

@end
