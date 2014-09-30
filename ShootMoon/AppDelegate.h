//
//  AppDelegate.h
//  ShootMoon
//
//  Created by apple on 16/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@end


//fenxiang weixin facebook//通知是否分享按钮出现，结束出现，开始取消。

//多一条命 三次 10+

//rate button

