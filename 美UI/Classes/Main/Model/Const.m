#import <Foundation/Foundation.h>

NSString *const MUIDidLoginNotification                 = @"MUIDidLoginNotification";
NSString *const MUIUserDidLogoutNotification            = @"MUIUserDidLogoutNotification";

NSString *const MUICollectUpNotificationObject          = @"MUICollectUpNotificationObject";
NSString *const MUICollectDownNotificationObject        = @"MUICollectDownNotificationObject";;

CGFloat   const MUINavgationBarHeight                   = 44;
CGFloat   const MUIStatusBarHeight                      = 20;
CGFloat   const MUINavgationBarHeightAndStatusBarHeight = 64;
//NSString *const MUIBaseUrl                              = @"http://meiui.me/api/index/";
//NSString *const MUIBaseUrl                              = @"http://test.meiui.me/api/index/";
#ifdef DEBUG
    NSString *const MUIBaseUrl                              = @"http://test.meiui.me/api/index/";
#else
    NSString *const MUIBaseUrl                              = @"http://meiui.me/api/index/";
#endif

#ifdef DEBUG
    NSString *const kURL                              = @"http://test.meiui.me/api/index";
#else
    NSString *const kURL                              = @"http://meiui.me/api/index";
#endif

CGFloat   const MUITagMargin                            = 10;
CGFloat   const MUITagHeight                            = 28;

NSString *const MUIDefaultTitle                             = @"点击头像登陆";

double    const authCodeInterval                            = 60;
