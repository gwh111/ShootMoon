//
//  ShareWeibo.m
//  ShootMoon
//
//  Created by apple on 29/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import "ShareWeibo.h"

@implementation ShareWeibo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)shareButtonPressed
{
    
    NSLog(@"isanzhuanglema");
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];

//        message.text = @"测试通过WeiboSDK发送文字到微博!";
//
//        WBImageObject *image = [WBImageObject object];
//        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
//        message.imageObject = image;
        message.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Weibo"]];
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = @"打鲨鱼";
        webpage.description = [NSString stringWithFormat:@"打鲨鱼"];
        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"120" ofType:@"png"]];
        webpage.webpageUrl = @"https://itunes.apple.com/us/app/shoot-fish/id923811726?l=zh&ls=1&mt=8";
        message.mediaObject = webpage;
    
    return message;
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
