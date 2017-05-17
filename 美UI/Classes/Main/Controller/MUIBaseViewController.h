//
//  MUIBaseViewController.h
//  美UI
//
//  Created by Lee on 16-2-29.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUICollectionView.h"

@interface MUIBaseViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,retain) MUICollectionView *collectView;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, assign) CGRect finalCellRect;
@property (nonatomic, assign, getter=isShowNavigationBar) BOOL showNavigationBar;

@end
