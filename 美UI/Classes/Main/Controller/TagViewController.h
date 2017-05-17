//
//  TagViewController.h
//  美UI
//
//  Created by Lee on 17/2/19.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TagViewController;

@protocol TagViewControllerDelegate <NSObject>

@optional
- (void)tagViewController:(TagViewController *)viewController didSelectTags:(NSArray *)tags;

@end

@interface TagViewController : UIViewController

@property (nonatomic, copy) void (^tagsBlock)(NSArray *tags);
@property (nonatomic, strong) NSArray *myTags;
@property (nonatomic, copy) void(^backEvent)();
@property (nonatomic, weak) id <TagViewControllerDelegate> delegate;

@end
