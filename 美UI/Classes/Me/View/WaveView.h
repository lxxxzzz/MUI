//
//  WaveView.h
//  美UI
//
//  Created by Lee on 17/3/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaveView;
@protocol WaveViewDeleagate <NSObject>

@optional
- (void)waveView:(WaveView *)waveView didMoveToPoint:(CGPoint)point;

@end

@interface WaveView : UIView

@property (nonatomic, copy) void(^block)(CGPoint point);
@property (nonatomic, weak) id<WaveViewDeleagate> delegate;

@end
