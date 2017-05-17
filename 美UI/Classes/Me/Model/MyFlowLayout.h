//
//  MyFlowLayout.h
//  美UI
//
//  Created by Lee on 17/3/15.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooter;

@class MyFlowLayout;

@protocol MyFlowLayoutDelegate <NSObject>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MyFlowLayout *)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@optional
//section header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(MyFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//section footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(MyFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface MyFlowLayout : UICollectionViewLayout

@property(nonatomic, assign)UIEdgeInsets sectionInset; //sectionInset
@property(nonatomic, assign)CGFloat lineSpacing;  //line space
@property(nonatomic, assign)CGFloat itemSpacing; //item space
@property(nonatomic, assign)CGFloat colCount; //column count
@property(nonatomic,weak) id <MyFlowLayoutDelegate> delegate;

@end
