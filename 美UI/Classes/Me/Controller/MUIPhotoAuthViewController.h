//
//  MUIPhotoAuthViewController.h
//  美UI
//
//  Created by Lee on 16-4-20.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    MUIPhotoAuthViewControllerTypePhotoLibraryAuth,
    MUIPhotoAuthViewControllerTypeCameraAuth
}MUIPhotoAuthViewControllerType;

@interface MUIPhotoAuthViewController : UIViewController

@property (nonatomic, assign) MUIPhotoAuthViewControllerType type;
@property (nonatomic, assign, getter=isModal) BOOL modal;

@end
