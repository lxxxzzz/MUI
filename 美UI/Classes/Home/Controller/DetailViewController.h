//
//  DetailViewController.h
//  美UI
//
//  Created by Lee on 16/11/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeViewModel;

@interface DetailViewController : UIViewController

@property(nonatomic,strong) NSMutableArray *items;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) HomeViewModel *model;

@end
