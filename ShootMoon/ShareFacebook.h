//
//  ShareFacebook.h
//  ShootMoon
//
//  Created by apple on 29/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareFacebook : UIButton{
    NSString *contentString;
}

@property (nonatomic,retain) NSString *contentString;

- (id)initWithFrame:(CGRect)frame string:(NSString*)string;
- (void)setString:(NSString*)string;

@end
