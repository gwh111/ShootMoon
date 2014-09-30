//
//  ShareWeixin.m
//  ShootMoon
//
//  Created by apple on 30/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import "ShareWeixin.h"

@implementation ShareWeixin

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(sendLinkContent) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) sendLinkContent
{
    int is=[WXApi isWXAppInstalled];
    if (is==0) {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"抱歉" message:@"您没有安装微信，请安装后再分享" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alt show];
    }else{
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"这种消息只有App自己才能理解，由App指定打开方式！";
        message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
        [message setThumbImage:[UIImage imageNamed:@"facebook.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"http://itunes.apple.com/cn/app/wei-bo/id350962117?mt=8";
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
