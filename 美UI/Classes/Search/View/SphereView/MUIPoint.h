//
//  MUIPoint.h
//  美UI
//
//  Created by Lee on 16-1-7.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#ifndef _UI_MUIPoint_h
#define _UI_MUIPoint_h

struct MUIPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct MUIPoint MUIPoint;


MUIPoint MUIPointMake(CGFloat x, CGFloat y, CGFloat z) {
    MUIPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

#endif
