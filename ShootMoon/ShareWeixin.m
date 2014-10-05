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
        message.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"Weixin"];
        message.description = @"";
        [message setThumbImage:[UIImage imageNamed:@"120.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"https://itunes.apple.com/us/app/shoot-fish/id923811726?l=zh&ls=1&mt=8";
        
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
