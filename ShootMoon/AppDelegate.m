//
//  AppDelegate.m
//  ShootMoon
//
//  Created by apple on 16/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    [WXApi registerApp:@"wx94ec6a3b38f8c595"];
    
     [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BestScore"]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"0"] forKey:@"BestScore"];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"return");
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user.
 
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Finish" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                      [alert show];
                                  }];
    [WeiboSDK handleOpenURL:url delegate:self];
    
    [WXApi handleOpenURL:url delegate:self];
    
    return urlWasHandled;
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{NSLog(@"didReceiveWeiboRequest");
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {

    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{NSLog(@"didReceiveWeiboResponse");
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *message;
        if (response.statusCode==0) {
            message=[NSString stringWithFormat:@"分享成功！"];
        }else{
            message=[NSString stringWithFormat:@"分享失败！请检查网络……"];
        }
//        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg;
        if (resp.errCode==0) {
            strMsg = [NSString stringWithFormat:@"分享成功！"];
        }else{
            strMsg = [NSString stringWithFormat:@"分享失败！请检查网络……"];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
