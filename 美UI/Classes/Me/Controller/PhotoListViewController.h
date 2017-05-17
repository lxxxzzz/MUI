//
//  PhotoListViewController.h
//  美UI
//
//  Created by Lee on 17/2/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoGroup, PHAssetCollection, PhotoGroupViewController;

@interface PhotoListViewController : UIViewController

@property (nonatomic, strong) PhotoGroup *group;
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, strong) PhotoGroupViewController *groupVC;

@end
