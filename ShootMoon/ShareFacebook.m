//
//  ShareFacebook.m
//  ShootMoon
//
//  Created by apple on 29/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import "ShareFacebook.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation ShareFacebook

@synthesize contentString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame string:(NSString*)string{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
        [self setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        contentString=[NSString stringWithFormat:@"%@",string];
        self.alpha=0.8;
    }
    return self;
}

- (void)share{
    
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"http://itunes.apple.com/cn/app/wei-bo/id350962117?mt=8"];
    params.name = contentString;
    
    BOOL can=[FBDialogs presentShareDialogWithParams:params
                                         clientState:nil
                                             handler:NULL] != nil;
    NSLog(@"share=%d",can);
    if (can==0) {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please Download Facebook App To Use This Function." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alt show];
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
