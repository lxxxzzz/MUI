//
//  MUIMyCollectViewController.m
//  美UI
//
//  Created by Lee on 16-3-10.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIMyCollectViewController.h"
#import "MUIMeCollectItem.h"
#import "MUIHomeItem.h"


@interface MUIMyCollectViewController ()

@end

@implementation MUIMyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.collect.category;

    self.view.backgroundColor = [UIColor redColor];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (MUIHomeItem *item in self.collect.items) {
        [arrM addObject:item];
    }
    
    self.items = arrM;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    self.tabBarController.tabBar.hidden = NO;
}

@end
