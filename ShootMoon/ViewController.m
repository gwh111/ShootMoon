//
//  ViewController.m
//  ShootMoon
//
//  Created by apple on 16/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

GADBannerView *banner;
GADInterstitial *bigBanner;

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor yellowColor];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    
    // Present the scene.
    [skView presentScene:scene];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(ad:) name:@"adShow" object:nil];
    
    banner = [[GADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    banner.adUnitID = @"ca-app-pub-5564518885724507/7940241272";
    banner.rootViewController = self;
    [self.view addSubview:banner];
    [banner loadRequest:[GADRequest request]];
    //    GADRequest *request;
    //    request.testDevices = @[ GAD_SIMULATOR_ID, @"MY_TEST_DEVICE_ID" ];
    banner.delegate=self;
    banner.hidden=YES;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
}

- (void)ad:(NSNotification*)notification{
    id obj = [notification object];
    if ([obj isEqualToString:@"adShow"]){
        banner.hidden=NO;
    }else if ([obj isEqualToString:@"adHide"]){
        banner.hidden=YES;
    }else if ([obj isEqualToString:@"adLarge"]){
        NSLog(@"large");
        bigBanner=[[GADInterstitial alloc]init];
        bigBanner.adUnitID=@"ca-app-pub-5564518885724507/9416974471";
        [bigBanner loadRequest:[GADRequest request]];
        bigBanner.delegate=self;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
