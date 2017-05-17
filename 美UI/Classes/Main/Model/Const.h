//
//  Const.h
//  美UI
//
//  Created by Lee on 16-3-28.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MUINotificationCenter [NSNotificationCenter defaultCenter]

#define RGB(r,g,b) [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f)blue:((float) b / 255.0f) alpha:1.0f]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define FONT(size) [UIFont systemFontOfSize:(size)]

#define IMAGE(name) [UIImage imageNamed:name]
// 全局背景色
#define BG_COLOR RGB(248, 248, 248)
// collectView背景色
#define COLLECT_VIEW_COLOR RGB(219, 219, 219)

//------导航栏相关------//
#ifdef __IPHONE_8_4
    #define NAV_BAR_FONT  [UIFont fontWithName:@"PingFangSC-Regular" size:17.0f]
#else
    #define NAV_BAR_FONT  [UIFont systemFontOfSize:17.0f]
#endif

#define NAV_BAR_COLOR RGB(255, 223, 97)
#define NAV_BAR_TITILE_COLOR RGB(0, 0, 0)

#define TAG_TEXT_COLOR RGB(79, 189, 160)

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define USER [User sharedUser]

#ifdef DEBUG
    #define BASEURL @"http://test.meiui.me/api/index/"
#else
    #define BASEURL @"http://meiui.me/api/index/"
#endif

#ifdef DEBUG
    #define Log(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
    #define Log(...)
#endif

UIKIT_EXTERN NSString *const MUIDidLoginNotification;
//UIKIT_EXTERN NSString *const MUICollectHeightDidChangeNotification;
UIKIT_EXTERN NSString *const MUIUserDidLogoutNotification;
UIKIT_EXTERN NSString *const MUICollectUpNotificationObject;
UIKIT_EXTERN NSString *const MUICollectDownNotificationObject;

UIKIT_EXTERN CGFloat   const MUINavgationBarHeight;
UIKIT_EXTERN CGFloat   const MUIStatusBarHeight;
UIKIT_EXTERN CGFloat   const MUINavgationBarHeightAndStatusBarHeight;
UIKIT_EXTERN NSString *const MUIBaseUrl;
UIKIT_EXTERN NSString *const kURL;

/**标签-标签间距 */
UIKIT_EXTERN CGFloat   const MUITagMargin;
/**标签-标签高度 */
UIKIT_EXTERN CGFloat   const MUITagHeight;

UIKIT_EXTERN NSString *const MUIDefaultTitle;

UIKIT_EXTERN double    const authCodeInterval;

