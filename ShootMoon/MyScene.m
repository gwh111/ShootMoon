//
//  MyScene.m
//  ShootMoon
//
//  Created by apple on 16/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import "MyScene.h"

#import "ShareFacebook.h"
#import "ShareWeibo.h"
#import "ShareWeixin.h"

static const uint32_t fishCategory     =  0x1 << 0;
static const uint32_t rockCategory        =  0x1 << 1;
static const uint32_t redFishCategory        =  0x1 << 2;
static const uint32_t redFishCategory2        =  0x1 << 3;
static const uint32_t redFishCategory3        =  0x1 << 4;

@implementation MyScene

bool isStart=0;
bool moveStop=0;
int timeIntevel=0;
int moveSpeed=2;
float moveX=1;
float moveY=1;

float moveX_fish=-1;
float moveY_fish=1;

float moveX_fish2=-1;
float moveY_fish2=1;

float moveX_fish3=-1;
float moveY_fish3=1;

int hitTimes=0;
SKSpriteNode *sprite;
UIButton *restartButton;

bool isPased=0;
int shortTime=0;
int t,tt;

SKLabelNode *scoreNode;
SKLabelNode *bestNode;

bool canShoot=1;
float fishSpeed1=2,fishSpeed2=3;

SKSpriteNode *lineSprite;
SKLabelNode *noticeNode;

int currentScore=0, currentMaxScore=0, bestScore;

int adCount=0;

int heartCount=0;
int lives=0;

int rocketSpeed;

AVAudioPlayer *audioPlayer;

ShareFacebook *shareFacebook;
ShareWeibo *shareWeibo;
ShareWeixin *shareWeixin;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor clearColor];
        self.physicsWorld.contactDelegate=self;
        self.physicsWorld.gravity = CGVectorMake(0,0.5);
        SKSpriteNode *backgroundNode=[SKSpriteNode spriteNodeWithImageNamed:@"desk_480.jpg"];
        backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        NSLog(@"%f",self.scene.size.height);
        if (self.scene.size.height==480) {
            backgroundNode.texture=[SKTexture textureWithImageNamed:@"desk_480.jpg"];
            backgroundNode.size=CGSizeMake(320, 480);
        }else if (self.scene.size.height==568){
            backgroundNode.texture=[SKTexture textureWithImageNamed:@"desk_568.jpg"];
            backgroundNode.size=CGSizeMake(320, 568);
        }else if (self.scene.size.height==667){
            backgroundNode.texture=[SKTexture textureWithImageNamed:@"desk_375667.jpg"];
            backgroundNode.size=CGSizeMake(375, 667);
        }else if (self.scene.size.height==736){
            backgroundNode.texture=[SKTexture textureWithImageNamed:@"desk_414736.jpg"];
            backgroundNode.size=CGSizeMake(414, 736);
        }
        [self addChild:backgroundNode];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
        myLabel.text = @"Tap To Start";
        myLabel.fontSize = 20;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)-100);
        
        myLabel.name=@"Start";
        SKAction *fadeOutAction=[SKAction fadeAlphaTo:0.1 duration:2];
        SKAction *fadeInAction=[SKAction fadeAlphaTo:1 duration:2];
        [myLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                              fadeOutAction,
                                                                              fadeInAction]]]];
        
        sprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(1, 1)];
        sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:3]]];
        SKAction *zoomOut=[SKAction scaleTo:100 duration:1];
        [sprite runAction:zoomOut completion:^{
            [self addChild:myLabel];
        }];
        [self addChild:sprite];
        sprite.name=@"fish";
        sprite.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:0.3];
        sprite.physicsBody.categoryBitMask=fishCategory;
        sprite.physicsBody.contactTestBitMask=rockCategory;
        sprite.physicsBody.collisionBitMask=rockCategory;
        sprite.physicsBody.dynamic=NO;
        
        bestNode=[SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
        bestNode.text=[NSString stringWithFormat:@"Best: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"BestScore"]];
        bestNode.fontSize=15;
        bestNode.position=CGPointMake(250, 20);
        [self addChild:bestNode];
        
        SKAction *makeRocks=    [SKAction sequence:@[
                                                     [SKAction performSelector:@selector(addRock) onTarget:self],
                                                     [SKAction waitForDuration:0.4],
                                                     [SKAction performSelector:@selector(addRock) onTarget:self],
                                                     [SKAction waitForDuration:0.9],
                                                     [SKAction performSelector:@selector(addRock) onTarget:self],
                                                     [SKAction waitForDuration:0.6],
                                                     [SKAction performSelector:@selector(addRock) onTarget:self],
                                                     [SKAction waitForDuration:0.8],
                                                     [SKAction performSelector:@selector(addRock) onTarget:self],
                                                     [SKAction waitForDuration:1]]];
        [self runAction:[SKAction repeatActionForever:makeRocks]];
    }

    
//    [self gameoverPushView];
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKPhysicsBody *body=[self.physicsWorld bodyAtPoint:location];
        NSLog(@"%@",body.node.name);
        SKNode *node=[self nodeAtPoint:location];
        if ([node.name isEqualToString:@"Start"]) {
            NSLog(@"Start");
            
//            NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"ReadyGo"
//                                                                  ofType:@"wav"];
//            NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
//            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL
//                                                                 error:nil];
//            [audioPlayer setDelegate:self];
//            [audioPlayer prepareToPlay];
//            [audioPlayer play];

            [self runAction:[SKAction playSoundFileNamed:@"ReadyGo.wav" waitForCompletion:NO]];
            
            SKLabelNode *rocketSpeedNode;
            rocketSpeedNode=[SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
            rocketSpeedNode.fontSize=15;
            rocketSpeedNode.alpha=0.8;
            rocketSpeedNode.fontColor=[SKColor orangeColor];
            rocketSpeedNode.position=CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+100);
            [self addChild:rocketSpeedNode];
            
            int x= arc4random_uniform(3);
            if (x==0) {
                rocketSpeed=15;
                rocketSpeedNode.text=@"Rocket Speed: SSS";
            }else if(x==1){
                rocketSpeed=10;
                rocketSpeedNode.text=@"Rocket Speed: SS";
            }else{
                rocketSpeed=5;
                rocketSpeedNode.text=@"Rocket Speed: S";
            }
            
            [rocketSpeedNode runAction:[SKAction sequence:@[
                                                            [SKAction scaleTo:2 duration:2]]]completion:^{
                [rocketSpeedNode removeFromParent];
            }];
            
            scoreNode=[SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
            scoreNode.text=@"Score: 0";
            scoreNode.fontSize=15;
            scoreNode.position=CGPointMake(50, 20);
            scoreNode.fontColor=[SKColor yellowColor];
            [self addChild:scoreNode];
            scoreNode.alpha=0;
            SKAction *moveUpAction=[SKAction fadeAlphaTo:1 duration:1];
            [scoreNode runAction:moveUpAction];
            
            lineSprite=[SKSpriteNode spriteNodeWithImageNamed:@"line.png"];
            lineSprite.position=CGPointMake(self.scene.size.width/2, 150);
            lineSprite.size=CGSizeMake(1, 30);
            [self addChild:lineSprite];
            SKAction *scaletoLarge=[SKAction scaleXTo:320 duration:2];
            SKAction *alpha1=[SKAction fadeAlphaTo:0.2 duration:1];
            SKAction *alpha2=[SKAction fadeAlphaTo:0.6 duration:1];
            SKAction *scale1=[SKAction scaleYTo:3 duration:1];
            SKAction *scale2=[SKAction scaleYTo:1 duration:1];
            [lineSprite runAction:scaletoLarge completion:^{
               [lineSprite runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                                       [SKAction group:@[alpha1,scale1]],
                                                                                       [SKAction group:@[alpha2,scale2]]]]]completion:^{
                   
               }];
            }];
            
            noticeNode=[SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
            noticeNode.text=@"Tap To Shoot";
            noticeNode.fontSize=25;
            noticeNode.alpha=0.5;
            noticeNode.fontColor=[SKColor whiteColor];
            noticeNode.position=CGPointMake(CGRectGetMidX(self.frame),80);
            [self addChild:noticeNode];
            [noticeNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                                    [SKAction waitForDuration:2],
                                                                                    [SKAction fadeAlphaTo:0 duration:2],
                                                                                    [SKAction waitForDuration:3],
                                                                                    [SKAction fadeAlphaTo:0.5 duration:2],
                                                                                    [SKAction waitForDuration:0.5]]]]];
            
            [self enumerateChildNodesWithName:@"Start" usingBlock:^(SKNode *node, BOOL *stop){
               
                [node removeFromParent];

                SKAction *scaleToSmall=[SKAction scaleTo:80 duration:1.7];
                [sprite runAction:[SKAction group:@[
                                                   [self myAnimation:0],
                                                   scaleToSmall]]completion:^{
                    [self directionInit];
                    isStart=1;
                    isPased=1;
                    canShoot=1;
                    moveStop=0;
                    
                    restartButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    restartButton.frame=CGRectMake(10, 10, 40, 40);
                    [restartButton setBackgroundImage:[UIImage imageNamed:@"reload-04.png"] forState:UIControlStateNormal];
                    [self.view addSubview:restartButton];
                    [restartButton addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
                    restartButton.alpha=0.6;

                    SKSpriteNode *heartNode=[SKSpriteNode spriteNodeWithImageNamed:@"heart_0"];
                    heartNode.position=CGPointMake(self.scene.size.width-30, self.scene.size.height-30);
                    heartNode.size=CGSizeMake(40, 40);
                    heartNode.name=@"heart";
                    [self addChild:heartNode];
                    
                    if (moveX<0) {
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                    }else{
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                    }

                }];

            }];
        }
        
        if ([node.name isEqualToString:@"Restart"]) {
            [self enumerateChildNodesWithName:@"GameOverViewNode" usingBlock:^(SKNode *node, BOOL *stop){
                [node removeFromParent];
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"adShow"object:@"adHide"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareShow"object:@"shareHidden"];
            [self reStart];
        }
        NSLog(@"isstart=%dmovestop=%dtouchlocation=%f",isStart,moveStop,[touch locationInNode:self].y);
        if (isStart==1&moveStop==0) {
            if ([touch locationInNode:self].y<120) {
                if (canShoot==1) {
                    NSLog(@"can%d",canShoot);
                    SKSpriteNode *sprite1 = [SKSpriteNode spriteNodeWithImageNamed:@"rocket1"];
                    sprite1.position = location;
                    sprite1.size=CGSizeMake(50, 50);
                    [self addChild:sprite1];
                    sprite1.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:sprite1.size];
                    sprite1.physicsBody.categoryBitMask=rockCategory;
                    sprite1.physicsBody.contactTestBitMask=fishCategory|redFishCategory|redFishCategory2|redFishCategory3;
                    sprite1.physicsBody.collisionBitMask=fishCategory|redFishCategory|redFishCategory2|redFishCategory3;
                    sprite1.name=@"Spaceship";
                    sprite1.physicsBody.affectedByGravity=NO;
                    sprite1.physicsBody.density=100;
                    canShoot=0;
                    [sprite1 runAction:[SKAction repeatActionForever:[self myAnimation:16]]];
                    
                    SKEmitterNode *myEmitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle2" ofType:@"sks"]];
                    myEmitterNode.position = CGPointMake(0, -25);
                    myEmitterNode.name=@"Spaceship_Fire";
                    [sprite1 addChild:myEmitterNode];
                    
                }
                
            }

        }
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    timeIntevel++;
    if (timeIntevel==moveSpeed) {
        timeIntevel=0;
        if (currentMaxScore>currentScore) {
            currentScore++;
            scoreNode.text=[NSString stringWithFormat:@"Score: %d",currentScore];
        }
        
    }
    
    if (isStart==1) {
        
        if (moveStop==0) {
            
            [self enumerateChildNodesWithName:@"fish" usingBlock:^(SKNode *node, BOOL *stop){
                
                //        NSLog(@"node%f",node.position.y);
                if (node.position.y<200) {
                    moveY=-moveY;
                    sprite.position = CGPointMake(sprite.position.x,
                                                  200);
                    
                }
                if (node.position.y>self.scene.size.height-40) {
                    moveY=-moveY;
                    sprite.position = CGPointMake(sprite.position.x,
                                                  self.scene.size.height-40);
                    
                }
                if (node.position.x<40|node.position.x>self.scene.size.width-40){
                    moveX=-moveX;
                    sprite.position = CGPointMake(sprite.position.x+moveX,
                                                  sprite.position.y);
                    
                    NSLog(@"%f",moveX);
                    if (moveX<0) {
                        [sprite removeAllActions];
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                    }else{
                        [sprite removeAllActions];
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                    }
                }
                
            }];
            
            if (isPased==1) {
                shortTime=currentTime;
                isPased=0;
                t=arc4random() % 15+5;
            }else{
                sprite.position = CGPointMake(sprite.position.x+moveX,
                                              sprite.position.y+moveY);
                tt=currentTime-shortTime;
                if (tt==t) {
                    
                    moveStop=1;
                    if (moveX<0) {
                        [sprite runAction:[self myAnimation:10]completion:^{
                            moveStop=0;
                            isPased=1;
                        }];
                    }else{
                        [sprite runAction:[self myAnimation:11]completion:^{
                            moveStop=0;
                            isPased=1;
                        }];
                    }
                    
                }
            }
            
        }
        
        [self enumerateChildNodesWithName:@"Spaceship" usingBlock:^(SKNode *node, BOOL *stop){
            if (node.position.y>self.scene.size.height) {
                
                [node removeFromParent];
                
                if (lives==1) {
                    lives=0;
                    heartCount=0;
                    [self enumerateChildNodesWithName:@"heart" usingBlock:^(SKNode *node, BOOL *stop){
                        [node removeFromParent];
                    }];
                    SKSpriteNode *heartNode=[SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"heart_%d",heartCount]];
                    heartNode.position=CGPointMake(self.scene.size.width-30, self.scene.size.height-30);
                    heartNode.size=CGSizeMake(40, 40);
                    heartNode.name=@"heart";
                    [self addChild:heartNode];
                    
                    [heartNode runAction:[SKAction sequence:@[
                                                              [SKAction scaleTo:2 duration:0.2],
                                                              [SKAction scaleTo:1 duration:0.2]]]completion:^{
                        moveStop=0;
                        canShoot=1;
                    }];
                    
                }else{
                    NSLog(@"remove");
                    moveStop=1;
                    canShoot=1;
                    if (moveX<0) {
                        [sprite runAction:[self myAnimation:4]completion:^{
                            [self gameoverPushView];
                            moveStop=0;
                        }];
                    }else{
                        [sprite runAction:[self myAnimation:5]completion:^{
                            [self gameoverPushView];
                            moveStop=0;
                        }];
                    }
                }
                
            }else{
                node.position=CGPointMake(node.position.x, node.position.y+rocketSpeed);
            }
        }];

        [self enumerateChildNodesWithName:@"RedFish1" usingBlock:^(SKNode *node, BOOL *stop){
            
            if (node.position.y<190|node.position.y>self.scene.size.height-30) {
                moveY_fish=-moveY_fish;
                node.position = CGPointMake(node.position.x,
                                            node.position.y+moveY_fish);
                
            }
            
            if (node.position.x<30|node.position.x>self.scene.size.width-30){
                moveX_fish=-moveX_fish;
                node.position = CGPointMake(node.position.x+moveX_fish,
                                            node.position.y);
                
                if (moveX_fish<0) {
                    [node removeAllActions];
                    [node runAction:[SKAction repeatActionForever:[self myAnimation:14]]];
                }else{
                    [node removeAllActions];
                    [node runAction:[SKAction repeatActionForever:[self myAnimation:15]]];
                }
                
            }
            node.position = CGPointMake(node.position.x+moveX_fish,
                                        node.position.y+moveY_fish);
            
            
        }];
        
        [self enumerateChildNodesWithName:@"RedFish2" usingBlock:^(SKNode *node, BOOL *stop){
            
            if (node.position.y<190|node.position.y>self.scene.size.height-30) {
                moveY_fish2=-moveY_fish2;
                node.position = CGPointMake(node.position.x,
                                            node.position.y+moveY_fish2);
                
            }
            
            if (node.position.x<30|node.position.x>self.scene.size.width-30){
                moveX_fish2=-moveX_fish2;
                node.position = CGPointMake(node.position.x+moveX_fish2,
                                            node.position.y);
                
                if (moveX_fish2<0) {
                    [node removeAllActions];
                    [node runAction:[SKAction repeatActionForever:[self myAnimation:14]]];
                }else{
                    [node removeAllActions];
                    [node runAction:[SKAction repeatActionForever:[self myAnimation:15]]];
                }
                
            }
            
            node.position = CGPointMake(node.position.x+moveX_fish2,
                                        node.position.y+moveY_fish2);
            
        }];
        
        [self enumerateChildNodesWithName:@"RedFish3" usingBlock:^(SKNode *node, BOOL *stop){
            
            if (node.position.y<190|node.position.y>self.scene.size.height-30) {
                moveY_fish3=-moveY_fish3;
                node.position = CGPointMake(node.position.x,
                                            node.position.y+moveY_fish3);
                
            }
            
            if (node.position.x<30|node.position.x>self.scene.size.width-30){
                moveX_fish3=-moveX_fish3;
                node.position = CGPointMake(node.position.x+moveX_fish3,
                                            node.position.y);
                
                if (moveX_fish3<0) {
                    [node removeAllActions];
                    [node runAction:[SKAction repeatActionForever:[self myAnimation:14]]];
                }else{
                    [node removeAllActions];
                    [node runAction:[SKAction repeatActionForever:[self myAnimation:15]]];
                }
                
            }
            
            node.position = CGPointMake(node.position.x+moveX_fish3,
                                        node.position.y+moveY_fish3);
            
        }];
        
    }
}

- (void)didSimulatePhysics{
//NSLog(@"movex=%fmovey=%f",moveX,moveY);
    
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop){
        if (node.position.y>self.scene.size.height) {
            [node removeFromParent];
        }else{
            node.position=CGPointMake(node.position.x, node.position.y+4);
        }
    }];
}
- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if (firstBody.categoryBitMask==fishCategory&secondBody.categoryBitMask==rockCategory) {
        NSLog(@"hitFish");

//        isStart=0;
//        isPased=1;

        isStart=0;
        isPased=0;
        moveStop=1;
        hitTimes++;
        
        SKAction *shakeUp=[SKAction moveToY:sprite.position.y+12 duration:0.2];
        SKAction *shakeUp2=[SKAction moveToY:sprite.position.y+3 duration:0.1];
        SKAction *shakeDown=[SKAction moveToY:sprite.position.y duration:0.2];
        SKAction *shakeAction=[SKAction sequence:@[
                                                   shakeUp,shakeUp2,shakeDown]];
        
        SKLabelNode *hitLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        float myHeight=self.scene.size.height;
        if (sprite.position.y<250) {
            hitLabel.text = @"1";
            currentMaxScore=currentScore+1;
        }else if (sprite.position.y>=250&sprite.position.y<250+(myHeight-250)/10){
            hitLabel.text = @"2";
            currentMaxScore=currentScore+2;
        }else if (sprite.position.y>=250+(myHeight-250)/10&sprite.position.y<250+2*(myHeight-250)/10){
            hitLabel.text = @"3";
            currentMaxScore=currentScore+3;
        }else if (sprite.position.y>=250+2*(myHeight-250)/10&sprite.position.y<250+3*(myHeight-250)/10){
            hitLabel.text = @"4";
            currentMaxScore=currentScore+4;
        }else if (sprite.position.y>=250+3*(myHeight-250)/10&sprite.position.y<250+4*(myHeight-250)/10){
            hitLabel.text = @"5";
            currentMaxScore=currentScore+5;
        }else if (sprite.position.y>=250+4*(myHeight-250)/10&sprite.position.y<250+5*(myHeight-250)/10){
            hitLabel.text = @"6";
            currentMaxScore=currentScore+6;
        }else if (sprite.position.y>=250+5*(myHeight-250)/10&sprite.position.y<250+6*(myHeight-250)/10){
            hitLabel.text = @"7";
            currentMaxScore=currentScore+7;
        }else if (sprite.position.y>=250+6*(myHeight-250)/10&sprite.position.y<250+7*(myHeight-250)/10){
            hitLabel.text = @"8";
            currentMaxScore=currentScore+8;
        }else if (sprite.position.y>=250+7*(myHeight-250)/10&sprite.position.y<250+8*(myHeight-250)/10){
            hitLabel.text = @"9";
            currentMaxScore=currentScore+9;
        }else if (sprite.position.y>=250+8*(myHeight-250)/10){
            hitLabel.text = @"10";
            currentMaxScore=currentScore+10;
        }
        
        if (sprite.position.y>=250+6*(myHeight-250)/10) {
            [self enumerateChildNodesWithName:@"heart" usingBlock:^(SKNode *node, BOOL *stop){
                [node removeFromParent];
                if (heartCount<3) {
                    heartCount++;
                    if (heartCount==3) {
                        lives=1;
                        SKEmitterNode *myEmitterNode=[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle6" ofType:@"sks"]];
                        myEmitterNode.position = node.position;
                        [self addChild:myEmitterNode];
                        [node removeFromParent];
                        
                        SKAction *fadeOutAction=[SKAction fadeAlphaTo:0 duration:0.8];
                        SKAction *scaleTo=[SKAction scaleTo:3 duration:0.8];
                        [myEmitterNode runAction:[SKAction group:@[
                                                                   fadeOutAction,
                                                                   scaleTo]] completion:^{
                            
                            [myEmitterNode removeFromParent];
                        }];
                        
                    }
                }
                
                SKSpriteNode *heartNode=[SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"heart_%d",heartCount]];
                heartNode.position=CGPointMake(self.scene.size.width-30, self.scene.size.height-30);
                heartNode.size=CGSizeMake(40, 40);
                heartNode.name=@"heart";
                [self addChild:heartNode];
                
                [heartNode runAction:[SKAction sequence:@[
                                                         [SKAction scaleTo:2 duration:0.2],
                                                         [SKAction scaleTo:1 duration:0.2]]]];
                
                if (lives==1) {
                    [heartNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                                           [SKAction fadeAlphaTo:0.5 duration:0.5],
                                                                                           [SKAction fadeAlphaTo:1 duration:0.6]]]]];
                }
            }];
        }
        
        hitLabel.fontSize = 20;
        hitLabel.position = CGPointMake(sprite.position.x,
                                        sprite.position.y-55);
        hitLabel.fontColor=[SKColor colorWithRed:1 green:1 blue:0.1 alpha:0.8];
        hitLabel.name=@"HitLabel";
        [self addChild:hitLabel];
        SKAction *wait=[SKAction waitForDuration:1];
        SKAction *toSmallAction=[SKAction scaleYTo:0 duration:0.3];
        [hitLabel runAction:[SKAction sequence:@[
                                                 wait,
                                                 toSmallAction]] completion:^{
            [hitLabel removeFromParent];
        }];
        
        [self enumerateChildNodesWithName:@"Spaceship" usingBlock:^(SKNode *node, BOOL *stop){
            
            SKEmitterNode *myEmitterNode;
            if (currentMaxScore-6>currentScore) {
                myEmitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle4" ofType:@"sks"]];
            }else{
                myEmitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"]];
            }
            
            myEmitterNode.position = node.position;
            [self addChild:myEmitterNode];
            
            [node removeFromParent];
            SKAction *fadeOutAction=[SKAction fadeAlphaTo:0 duration:0.4];
            [myEmitterNode runAction:fadeOutAction completion:^{
                
                [myEmitterNode removeFromParent];
            }];
            
        }];
        
        [sprite removeAllActions];
        
        if (hitTimes%3==0) {
            NSLog(@"+1");
            int t=arc4random_uniform(2);
            if (t==0) {
                if (moveY<0) {
                    moveY--;
                }else{
                    moveY++;
                }
            }else{
                if (moveX<0) {
                    moveX--;
                }else{
                    moveX++;
                }
            }

        }
        
        if (moveX<0) {
            
            if (sprite.position.y<250+2*(myHeight-250)/10) {
                [sprite runAction:[SKAction group:@[
                                                    [self myAnimation:6],
                                                    shakeAction]] completion:^{
                    if (hitTimes==4) {
                        [self addRedFish:1];
                        
                    }else if (hitTimes==8){
                        [self addRedFish:2];
                        
                    }else if (hitTimes==12){
                        [self addRedFish:3];
                        
                    }else{
                        isStart=1;
                        isPased=1;
                        moveStop=0;
                        canShoot=1;
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                    }
                    
                }];
            }else{
                [sprite runAction:[SKAction group:@[
                                                    [self myAnimation:8],
                                                    shakeAction]] completion:^{
                    if (hitTimes==4) {
                        [self addRedFish:1];
                        
                    }else if (hitTimes==8){
                        [self addRedFish:2];
                        
                    }else if (hitTimes==12){
                        [self addRedFish:3];
                        
                    }else{
                        isStart=1;
                        isPased=1;
                        moveStop=0;
                        canShoot=1;
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                    }
                    
                }];
            }
            
            
        }else{
            
            if (sprite.position.y<250+2*(myHeight-250)/10) {
                [sprite runAction:[SKAction group:@[
                                                    [self myAnimation:7],
                                                    shakeAction]] completion:^{
                    if (hitTimes==4) {
                        [self addRedFish:1];
                        
                    }else if (hitTimes==8){
                        [self addRedFish:2];
                        
                    }else if (hitTimes==12){
                        [self addRedFish:3];
                        
                    }else{
                        isStart=1;
                        isPased=1;
                        moveStop=0;
                        canShoot=1;
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                    }
                    
                }];
            }else{
                [sprite runAction:[SKAction group:@[
                                                    [self myAnimation:9],
                                                    shakeAction]] completion:^{
                    if (hitTimes==4) {
                        [self addRedFish:1];
                        
                    }else if (hitTimes==8){
                        [self addRedFish:2];
                        
                    }else if (hitTimes==12){
                        [self addRedFish:3];
                        
                    }else{
                        isStart=1;
                        isPased=1;
                        moveStop=0;
                        canShoot=1;
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                    }
                    
                }];
            }
            
        }
        
        
    }
    
    if (firstBody.categoryBitMask==rockCategory&secondBody.categoryBitMask==redFishCategory) {
        NSLog(@"hitRedFish");
        
        moveStop=1;
        canShoot=0;
        if (moveX<0) {
            [sprite runAction:[self myAnimation:17]completion:^{
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:17]]];

            }];
        }else{
            [sprite runAction:[self myAnimation:18]completion:^{
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:18]]];

            }];
        }
        
        if (lives==1) {
            lives=0;
            heartCount=0;
            [self enumerateChildNodesWithName:@"heart" usingBlock:^(SKNode *node, BOOL *stop){
                [node removeFromParent];
            }];
            SKSpriteNode *heartNode=[SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"heart_%d",heartCount]];
            heartNode.position=CGPointMake(self.scene.size.width-30, self.scene.size.height-30);
            heartNode.size=CGSizeMake(40, 40);
            heartNode.name=@"heart";
            [self addChild:heartNode];
            
            [heartNode runAction:[SKAction sequence:@[
                                                      [SKAction scaleTo:2 duration:0.2],
                                                      [SKAction scaleTo:1 duration:0.2]]]completion:^{
                if (moveX<0) {
                    [sprite removeAllActions];
                    [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                }else{
                    [sprite removeAllActions];
                    [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                }
                
                moveStop=0;
                canShoot=1;
            }];
        }else{
            [self enumerateChildNodesWithName:@"RedFish1" usingBlock:^(SKNode *node, BOOL *stop){
                
                SKEmitterNode *myEmitterNode=[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle5" ofType:@"sks"]];
                myEmitterNode.position = node.position;
                [self addChild:myEmitterNode];
                [node removeFromParent];
                
                SKAction *fadeOutAction=[SKAction fadeAlphaTo:0 duration:0.8];
                SKAction *scaleTo=[SKAction scaleTo:3 duration:0.8];
                [myEmitterNode runAction:[SKAction group:@[
                                                           fadeOutAction,
                                                           scaleTo]] completion:^{
                    
                    [myEmitterNode removeFromParent];
                    [self gameoverPushView];
                }];
                
            }];
        }
        
        [self enumerateChildNodesWithName:@"Spaceship" usingBlock:^(SKNode *node, BOOL *stop){
            [node removeFromParent];
        }];
    }
    
    if (firstBody.categoryBitMask==rockCategory&secondBody.categoryBitMask==redFishCategory2) {
        NSLog(@"hitRedFish2");
        
        moveStop=1;
        canShoot=0;
        if (moveX<0) {
            [sprite runAction:[self myAnimation:17]completion:^{
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:17]]];
                
            }];
        }else{
            [sprite runAction:[self myAnimation:18]completion:^{
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:18]]];
                
            }];
        }
        
        if (lives==1) {
            lives=0;
            heartCount=0;
            [self enumerateChildNodesWithName:@"heart" usingBlock:^(SKNode *node, BOOL *stop){
                [node removeFromParent];
            }];
            SKSpriteNode *heartNode=[SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"heart_%d",heartCount]];
            heartNode.position=CGPointMake(self.scene.size.width-30, self.scene.size.height-30);
            heartNode.size=CGSizeMake(40, 40);
            heartNode.name=@"heart";
            [self addChild:heartNode];
            
            [heartNode runAction:[SKAction sequence:@[
                                                      [SKAction scaleTo:2 duration:0.2],
                                                      [SKAction scaleTo:1 duration:0.2]]]completion:^{
                if (moveX<0) {
                    [sprite removeAllActions];
                    [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                }else{
                    [sprite removeAllActions];
                    [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                }
                
                moveStop=0;
                canShoot=1;
            }];
        }else{
            [self enumerateChildNodesWithName:@"RedFish2" usingBlock:^(SKNode *node, BOOL *stop){
                SKEmitterNode *myEmitterNode=[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle5" ofType:@"sks"]];
                myEmitterNode.position = node.position;
                [self addChild:myEmitterNode];
                [node removeFromParent];
                
                SKAction *fadeOutAction=[SKAction fadeAlphaTo:0 duration:0.8];
                SKAction *scaleTo=[SKAction scaleTo:3 duration:0.8];
                [myEmitterNode runAction:[SKAction group:@[
                                                           fadeOutAction,
                                                           scaleTo]] completion:^{
                    
                    [myEmitterNode removeFromParent];
                    [self gameoverPushView];
                }];
            }];
        }
        
        [self enumerateChildNodesWithName:@"Spaceship" usingBlock:^(SKNode *node, BOOL *stop){
            [node removeFromParent];
        }];
    }
    
    if (firstBody.categoryBitMask==rockCategory&secondBody.categoryBitMask==redFishCategory3) {
        NSLog(@"hitRedFish3");
        
        moveStop=1;
        canShoot=0;
        if (moveX<0) {
            [sprite runAction:[self myAnimation:17]completion:^{
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:17]]];
                
            }];
        }else{
            [sprite runAction:[self myAnimation:18]completion:^{
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:18]]];
                
            }];
        }
        
        if (lives==1) {
            lives=0;
            heartCount=0;
            [self enumerateChildNodesWithName:@"heart" usingBlock:^(SKNode *node, BOOL *stop){
                [node removeFromParent];
            }];
            SKSpriteNode *heartNode=[SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"heart_%d",heartCount]];
            heartNode.position=CGPointMake(self.scene.size.width-30, self.scene.size.height-30);
            heartNode.size=CGSizeMake(40, 40);
            heartNode.name=@"heart";
            [self addChild:heartNode];
            
            [heartNode runAction:[SKAction sequence:@[
                                                      [SKAction scaleTo:2 duration:0.2],
                                                      [SKAction scaleTo:1 duration:0.2]]]completion:^{
                if (moveX<0) {
                    [sprite removeAllActions];
                    [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                }else{
                    [sprite removeAllActions];
                    [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                }
                
                moveStop=0;
                canShoot=1;
            }];
        }else{
            [self enumerateChildNodesWithName:@"RedFish3" usingBlock:^(SKNode *node, BOOL *stop){
                SKEmitterNode *myEmitterNode=[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle5" ofType:@"sks"]];
                myEmitterNode.position = node.position;
                [self addChild:myEmitterNode];
                [node removeFromParent];
                
                SKAction *fadeOutAction=[SKAction fadeAlphaTo:0 duration:0.8];
                SKAction *scaleTo=[SKAction scaleTo:3 duration:0.8];
                [myEmitterNode runAction:[SKAction group:@[
                                                           fadeOutAction,
                                                           scaleTo]] completion:^{
                    
                    [myEmitterNode removeFromParent];
                    [self gameoverPushView];
                }];
            }];
        }
        
        [self enumerateChildNodesWithName:@"Spaceship" usingBlock:^(SKNode *node, BOOL *stop){
            [node removeFromParent];
        }];
    }
}

- (void)directionInit{
    int i=arc4random_uniform(7);
    NSLog(@"%d",i);
    switch (i) {
        case 0:
            moveX=fishSpeed1;
            moveY=fishSpeed1;
            break;
        case 1:
            moveX=fishSpeed1;
            moveY=-fishSpeed1;
            break;
        case 2:
            moveX=-fishSpeed1;
            moveY=fishSpeed1;
            break;
        case 3:
            moveX=-fishSpeed1;
            moveY=-fishSpeed1;
            break;
        case 4:
            moveX=fishSpeed1;
            moveY=fishSpeed2;
            break;
        case 5:
            moveX=fishSpeed1;
            moveY=-fishSpeed2;
            break;
        case 6:
            moveX=-fishSpeed1;
            moveY=fishSpeed2;
            break;
        case 7:
            moveX=-fishSpeed1;
            moveY=-fishSpeed2;
            break;
            
        default:
            break;
    }
    NSLog(@"movex=%fmovey=%f",moveX,moveY);
}

- (SKAction *)myAnimation:(int)animationNumber{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"fishEat"];
    SKTexture *temp1 = [atlas textureNamed:@"fishEat1.png"];
    SKTexture *temp2 = [atlas textureNamed:@"fishEat2.png"];
    SKTexture *temp3 = [atlas textureNamed:@"fishEat3.png"];
    SKTexture *temp4 = [atlas textureNamed:@"fishEat4.png"];
    SKTexture *temp5 = [atlas textureNamed:@"fishEat5.png"];
    SKTexture *temp6 = [atlas textureNamed:@"fishEat6.png"];
    SKTexture *temp7 = [atlas textureNamed:@"fishEat7.png"];
    SKTexture *temp8 = [atlas textureNamed:@"fishEat8.png"];
    SKTexture *temp9 = [atlas textureNamed:@"fishEat9.png"];
    SKTexture *temp10 = [atlas textureNamed:@"fishEat10.png"];
    SKTexture *temp11 = [atlas textureNamed:@"fishEat11.png"];
    SKTexture *temp12 = [atlas textureNamed:@"fishEat12.png"];
    SKTexture *temp13 = [atlas textureNamed:@"fishEat13.png"];
    SKTexture *temp14 = [atlas textureNamed:@"fishEat14.png"];
    SKTexture *temp15 = [atlas textureNamed:@"fishEat15.png"];
    SKTexture *temp16 = [atlas textureNamed:@"fishEat16.png"];
    SKTexture *temp17 = [atlas textureNamed:@"fishEat17.png"];
    NSArray *eatArray=@[temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10,temp11,temp12,temp13,temp14,temp15,temp16,temp17];
    SKAction *eatAction=[SKAction animateWithTextures:eatArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas1 = [SKTextureAtlas atlasNamed:@"fishMoveLeft"];
    SKTexture *temp1_1 = [atlas1 textureNamed:@"fishMoveLeft1.png"];
    SKTexture *temp1_2 = [atlas1 textureNamed:@"fishMoveLeft2.png"];
    SKTexture *temp1_3 = [atlas1 textureNamed:@"fishMoveLeft3.png"];
    SKTexture *temp1_4 = [atlas1 textureNamed:@"fishMoveLeft4.png"];
    SKTexture *temp1_5 = [atlas1 textureNamed:@"fishMoveLeft5.png"];
    SKTexture *temp1_6 = [atlas1 textureNamed:@"fishMoveLeft6.png"];
    SKTexture *temp1_7 = [atlas1 textureNamed:@"fishMoveLeft7.png"];
    SKTexture *temp1_8 = [atlas1 textureNamed:@"fishMoveLeft8.png"];
    SKTexture *temp1_9 = [atlas1 textureNamed:@"fishMoveLeft9.png"];
    NSArray *moveLeftArray=@[temp1_1,temp1_2,temp1_3,temp1_4,temp1_5,temp1_6,temp1_7,temp1_8,temp1_9];
    SKAction *moveLeftAction=[SKAction animateWithTextures:moveLeftArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas2 = [SKTextureAtlas atlasNamed:@"fishMoveRight"];
    SKTexture *temp2_1 = [atlas2 textureNamed:@"fishMoveRight1.png"];
    SKTexture *temp2_2 = [atlas2 textureNamed:@"fishMoveRight2.png"];
    SKTexture *temp2_3 = [atlas2 textureNamed:@"fishMoveRight3.png"];
    SKTexture *temp2_4 = [atlas2 textureNamed:@"fishMoveRight4.png"];
    SKTexture *temp2_5 = [atlas2 textureNamed:@"fishMoveRight5.png"];
    SKTexture *temp2_6 = [atlas2 textureNamed:@"fishMoveRight6.png"];
    SKTexture *temp2_7 = [atlas2 textureNamed:@"fishMoveRight7.png"];
    SKTexture *temp2_8 = [atlas2 textureNamed:@"fishMoveRight8.png"];
    SKTexture *temp2_9 = [atlas2 textureNamed:@"fishMoveRight9.png"];
    NSArray *moveRightArray=@[temp2_1,temp2_2,temp2_3,temp2_4,temp2_5,temp2_6,temp2_7,temp2_8,temp2_9];
    SKAction *moveRightAction=[SKAction animateWithTextures:moveRightArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas3 = [SKTextureAtlas atlasNamed:@"fishSleep"];
    SKTexture *temp3_1 = [atlas3 textureNamed:@"fishSleep1.png"];
    SKTexture *temp3_2 = [atlas3 textureNamed:@"fishSleep2.png"];
    SKTexture *temp3_3 = [atlas3 textureNamed:@"fishSleep3.png"];
    SKTexture *temp3_4 = [atlas3 textureNamed:@"fishSleep4.png"];
    SKTexture *temp3_5 = [atlas3 textureNamed:@"fishSleep5.png"];
    SKTexture *temp3_6 = [atlas3 textureNamed:@"fishSleep6.png"];
    SKTexture *temp3_7 = [atlas3 textureNamed:@"fishSleep7.png"];
    SKTexture *temp3_8 = [atlas3 textureNamed:@"fishSleep8.png"];
    SKTexture *temp3_9 = [atlas3 textureNamed:@"fishSleep9.png"];
    SKTexture *temp3_10 = [atlas3 textureNamed:@"fishSleep10.png"];
    NSArray *sleepArray=@[temp3_1,temp3_2,temp3_3,temp3_4,temp3_5,temp3_6,temp3_7,temp3_8,temp3_9,temp3_10];
    SKAction *sleepAction=[SKAction animateWithTextures:sleepArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas4 = [SKTextureAtlas atlasNamed:@"hideTongeLeft"];
    SKTexture *temp4_1 = [atlas4 textureNamed:@"hideTongeLeft1.png"];
    SKTexture *temp4_2 = [atlas4 textureNamed:@"hideTongeLeft2.png"];
    SKTexture *temp4_3 = [atlas4 textureNamed:@"hideTongeLeft3.png"];
    SKTexture *temp4_4 = [atlas4 textureNamed:@"hideTongeLeft4.png"];
    SKTexture *temp4_5 = [atlas4 textureNamed:@"hideTongeLeft5.png"];
    SKTexture *temp4_6 = [atlas4 textureNamed:@"hideTongeLeft6.png"];
    SKTexture *temp4_7 = [atlas4 textureNamed:@"hideTongeLeft7.png"];
    SKTexture *temp4_8 = [atlas4 textureNamed:@"hideTongeLeft8.png"];
    SKTexture *temp4_9 = [atlas4 textureNamed:@"hideTongeLeft9.png"];
    SKTexture *temp4_10 = [atlas4 textureNamed:@"hideTongeLeft10.png"];
    SKTexture *temp4_11 = [atlas4 textureNamed:@"hideTongeLeft11.png"];
    SKTexture *temp4_12 = [atlas4 textureNamed:@"hideTongeLeft12.png"];
    SKTexture *temp4_13 = [atlas4 textureNamed:@"hideTongeLeft13.png"];
    SKTexture *temp4_14 = [atlas4 textureNamed:@"hideTongeLeft14.png"];
    SKTexture *temp4_15 = [atlas4 textureNamed:@"hideTongeLeft15.png"];
    NSArray *tongeLeftArray=@[temp4_1,temp4_2,temp4_3,temp4_4,temp4_5,temp4_6,temp4_7,temp4_8,temp4_9,temp4_10,temp4_11,temp4_12,temp4_13,temp4_14,temp4_15];
    SKAction *tongeLeftAction=[SKAction animateWithTextures:tongeLeftArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas5 = [SKTextureAtlas atlasNamed:@"hideTongeRight"];
    SKTexture *temp5_1 = [atlas5 textureNamed:@"hideTongeRight1.png"];
    SKTexture *temp5_2 = [atlas5 textureNamed:@"hideTongeRight2.png"];
    SKTexture *temp5_3 = [atlas5 textureNamed:@"hideTongeRight3.png"];
    SKTexture *temp5_4 = [atlas5 textureNamed:@"hideTongeRight4.png"];
    SKTexture *temp5_5 = [atlas5 textureNamed:@"hideTongeRight5.png"];
    SKTexture *temp5_6 = [atlas5 textureNamed:@"hideTongeRight6.png"];
    SKTexture *temp5_7 = [atlas5 textureNamed:@"hideTongeRight7.png"];
    SKTexture *temp5_8 = [atlas5 textureNamed:@"hideTongeRight8.png"];
    SKTexture *temp5_9 = [atlas5 textureNamed:@"hideTongeRight9.png"];
    SKTexture *temp5_10 = [atlas5 textureNamed:@"hideTongeRight10.png"];
    SKTexture *temp5_11 = [atlas5 textureNamed:@"hideTongeRight11.png"];
    SKTexture *temp5_12 = [atlas5 textureNamed:@"hideTongeRight12.png"];
    SKTexture *temp5_13 = [atlas5 textureNamed:@"hideTongeRight13.png"];
    SKTexture *temp5_14 = [atlas5 textureNamed:@"hideTongeRight14.png"];
    SKTexture *temp5_15 = [atlas5 textureNamed:@"hideTongeRight15.png"];
    NSArray *tongeRightArray=@[temp5_1,temp5_2,temp5_3,temp5_4,temp5_5,temp5_6,temp5_7,temp5_8,temp5_9,temp5_10,temp5_11,temp5_12,temp5_13,temp5_14,temp5_15];
    SKAction *tongeRightAction=[SKAction animateWithTextures:tongeRightArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas6 = [SKTextureAtlas atlasNamed:@"cryLeft"];
    SKTexture *temp6_1 = [atlas6 textureNamed:@"cryLeft1.png"];
    SKTexture *temp6_2 = [atlas6 textureNamed:@"cryLeft2.png"];
    SKTexture *temp6_3 = [atlas6 textureNamed:@"cryLeft3.png"];
    SKTexture *temp6_4 = [atlas6 textureNamed:@"cryLeft4.png"];
    SKTexture *temp6_5 = [atlas6 textureNamed:@"cryLeft5.png"];
    SKTexture *temp6_6 = [atlas6 textureNamed:@"cryLeft6.png"];
    SKTexture *temp6_7 = [atlas6 textureNamed:@"cryLeft7.png"];
    SKTexture *temp6_8 = [atlas6 textureNamed:@"cryLeft8.png"];
    SKTexture *temp6_9 = [atlas6 textureNamed:@"cryLeft9.png"];
    SKTexture *temp6_10 = [atlas6 textureNamed:@"cryLeft10.png"];
    SKTexture *temp6_11 = [atlas6 textureNamed:@"cryLeft11.png"];
    SKTexture *temp6_12 = [atlas6 textureNamed:@"cryLeft12.png"];
    SKTexture *temp6_13 = [atlas6 textureNamed:@"cryLeft13.png"];
    SKTexture *temp6_14 = [atlas6 textureNamed:@"cryLeft14.png"];
    SKTexture *temp6_15 = [atlas6 textureNamed:@"cryLeft15.png"];
    SKTexture *temp6_16 = [atlas6 textureNamed:@"cryLeft16.png"];
    SKTexture *temp6_17 = [atlas6 textureNamed:@"cryLeft17.png"];
    SKTexture *temp6_18 = [atlas6 textureNamed:@"cryLeft18.png"];
    SKTexture *temp6_19 = [atlas6 textureNamed:@"cryLeft19.png"];
    SKTexture *temp6_20 = [atlas6 textureNamed:@"cryLeft20.png"];
    SKTexture *temp6_21 = [atlas6 textureNamed:@"cryLeft21.png"];
    SKTexture *temp6_22 = [atlas6 textureNamed:@"cryLeft22.png"];
    NSArray *cryLeftArray=@[temp6_1,temp6_2,temp6_3,temp6_4,temp6_5,temp6_6,temp6_7,temp6_8,temp6_9,temp6_10,temp6_11,temp6_12,temp6_13,temp6_14,temp6_15,temp6_16,temp6_17,temp6_18,temp6_19,temp6_20,temp6_21,temp6_22];
    SKAction *cryLeftAction=[SKAction animateWithTextures:cryLeftArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas7 = [SKTextureAtlas atlasNamed:@"cryRight"];
    SKTexture *temp7_1 = [atlas7 textureNamed:@"cryRight1.png"];
    SKTexture *temp7_2 = [atlas7 textureNamed:@"cryRight2.png"];
    SKTexture *temp7_3 = [atlas7 textureNamed:@"cryRight3.png"];
    SKTexture *temp7_4 = [atlas7 textureNamed:@"cryRight4.png"];
    SKTexture *temp7_5 = [atlas7 textureNamed:@"cryRight5.png"];
    SKTexture *temp7_6 = [atlas7 textureNamed:@"cryRight6.png"];
    SKTexture *temp7_7 = [atlas7 textureNamed:@"cryRight7.png"];
    SKTexture *temp7_8 = [atlas7 textureNamed:@"cryRight8.png"];
    SKTexture *temp7_9 = [atlas7 textureNamed:@"cryRight9.png"];
    SKTexture *temp7_10 = [atlas7 textureNamed:@"cryRight10.png"];
    SKTexture *temp7_11 = [atlas7 textureNamed:@"cryRight11.png"];
    SKTexture *temp7_12 = [atlas7 textureNamed:@"cryRight12.png"];
    SKTexture *temp7_13 = [atlas7 textureNamed:@"cryRight13.png"];
    SKTexture *temp7_14 = [atlas7 textureNamed:@"cryRight14.png"];
    SKTexture *temp7_15 = [atlas7 textureNamed:@"cryRight15.png"];
    SKTexture *temp7_16 = [atlas7 textureNamed:@"cryRight16.png"];
    SKTexture *temp7_17 = [atlas7 textureNamed:@"cryRight17.png"];
    SKTexture *temp7_18 = [atlas7 textureNamed:@"cryRight18.png"];
    SKTexture *temp7_19 = [atlas7 textureNamed:@"cryRight19.png"];
    SKTexture *temp7_20 = [atlas7 textureNamed:@"cryRight20.png"];
    SKTexture *temp7_21 = [atlas7 textureNamed:@"cryRight21.png"];
    SKTexture *temp7_22 = [atlas7 textureNamed:@"cryRight22.png"];
    NSArray *cryRightArray=@[temp7_1,temp7_2,temp7_3,temp7_4,temp7_5,temp7_6,temp7_7,temp7_8,temp7_9,temp7_10,temp7_11,temp7_12,temp7_13,temp7_14,temp7_15,temp7_16,temp7_17,temp7_18,temp7_19,temp7_20,temp7_21,temp7_22];
    SKAction *cryRightAction=[SKAction animateWithTextures:cryRightArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas8 = [SKTextureAtlas atlasNamed:@"yunLeft"];
    SKTexture *temp8_1 = [atlas8 textureNamed:@"yunLeft1.png"];
    SKTexture *temp8_2 = [atlas8 textureNamed:@"yunLeft2.png"];
    SKTexture *temp8_3 = [atlas8 textureNamed:@"yunLeft3.png"];
    SKTexture *temp8_4 = [atlas8 textureNamed:@"yunLeft4.png"];
    SKTexture *temp8_5 = [atlas8 textureNamed:@"yunLeft5.png"];
    SKTexture *temp8_6 = [atlas8 textureNamed:@"yunLeft6.png"];
    SKTexture *temp8_7 = [atlas8 textureNamed:@"yunLeft7.png"];
    SKTexture *temp8_8 = [atlas8 textureNamed:@"yunLeft8.png"];
    SKTexture *temp8_9 = [atlas8 textureNamed:@"yunLeft9.png"];
    SKTexture *temp8_10 = [atlas8 textureNamed:@"yunLeft10.png"];
    NSArray *yunLeftArray=@[temp8_1,temp8_2,temp8_3,temp8_4,temp8_5,temp8_6,temp8_7,temp8_8,temp8_9,temp8_10];
    SKAction *yunLeftAction=[SKAction animateWithTextures:yunLeftArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas9 = [SKTextureAtlas atlasNamed:@"yunRight"];
    SKTexture *temp9_1 = [atlas9 textureNamed:@"yunRight1.png"];
    SKTexture *temp9_2 = [atlas9 textureNamed:@"yunRight2.png"];
    SKTexture *temp9_3 = [atlas9 textureNamed:@"yunRight3.png"];
    SKTexture *temp9_4 = [atlas9 textureNamed:@"yunRight4.png"];
    SKTexture *temp9_5 = [atlas9 textureNamed:@"yunRight5.png"];
    SKTexture *temp9_6 = [atlas9 textureNamed:@"yunRight6.png"];
    SKTexture *temp9_7 = [atlas9 textureNamed:@"yunRight7.png"];
    SKTexture *temp9_8 = [atlas9 textureNamed:@"yunRight8.png"];
    SKTexture *temp9_9 = [atlas9 textureNamed:@"yunRight9.png"];
    SKTexture *temp9_10 = [atlas9 textureNamed:@"yunRight10.png"];
    NSArray *yunRightArray=@[temp9_1,temp9_2,temp9_3,temp9_4,temp9_5,temp9_6,temp9_7,temp9_8,temp9_9,temp9_10];
    SKAction *yunRightAction=[SKAction animateWithTextures:yunRightArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas10 = [SKTextureAtlas atlasNamed:@"questionLeft"];
    SKTexture *temp10_1 = [atlas10 textureNamed:@"questionLeft1.png"];
    SKTexture *temp10_2 = [atlas10 textureNamed:@"questionLeft2.png"];
    SKTexture *temp10_3 = [atlas10 textureNamed:@"questionLeft3.png"];
    SKTexture *temp10_4 = [atlas10 textureNamed:@"questionLeft4.png"];
    SKTexture *temp10_5 = [atlas10 textureNamed:@"questionLeft5.png"];
    SKTexture *temp10_6 = [atlas10 textureNamed:@"questionLeft6.png"];
    SKTexture *temp10_7 = [atlas10 textureNamed:@"questionLeft7.png"];
    SKTexture *temp10_8 = [atlas10 textureNamed:@"questionLeft8.png"];
    SKTexture *temp10_9 = [atlas10 textureNamed:@"questionLeft9.png"];
    SKTexture *temp10_10 = [atlas10 textureNamed:@"questionLeft10.png"];
    SKTexture *temp10_11 = [atlas10 textureNamed:@"questionLeft11.png"];
    SKTexture *temp10_12 = [atlas10 textureNamed:@"questionLeft12.png"];
    NSArray *questionLeftArray=@[temp10_1,temp10_2,temp10_3,temp10_4,temp10_5,temp10_6,temp10_7,temp10_8,temp10_9,temp10_10,temp10_11,temp10_12];
    SKAction *questionLeftAction=[SKAction animateWithTextures:questionLeftArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas11 = [SKTextureAtlas atlasNamed:@"questionRight"];
    SKTexture *temp11_1 = [atlas11 textureNamed:@"questionRight1.png"];
    SKTexture *temp11_2 = [atlas11 textureNamed:@"questionRight2.png"];
    SKTexture *temp11_3 = [atlas11 textureNamed:@"questionRight3.png"];
    SKTexture *temp11_4 = [atlas11 textureNamed:@"questionRight4.png"];
    SKTexture *temp11_5 = [atlas11 textureNamed:@"questionRight5.png"];
    SKTexture *temp11_6 = [atlas11 textureNamed:@"questionRight6.png"];
    SKTexture *temp11_7 = [atlas11 textureNamed:@"questionRight7.png"];
    SKTexture *temp11_8 = [atlas11 textureNamed:@"questionRight8.png"];
    SKTexture *temp11_9 = [atlas11 textureNamed:@"questionRight9.png"];
    SKTexture *temp11_10 = [atlas11 textureNamed:@"questionRight10.png"];
    SKTexture *temp11_11 = [atlas11 textureNamed:@"questionRight11.png"];
    SKTexture *temp11_12 = [atlas11 textureNamed:@"questionRight12.png"];
    NSArray *questionRightArray=@[temp11_1,temp11_2,temp11_3,temp11_4,temp11_5,temp11_6,temp11_7,temp11_8,temp11_9,temp11_10,temp11_11,temp11_12];
    SKAction *questionRightAction=[SKAction animateWithTextures:questionRightArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas12 = [SKTextureAtlas atlasNamed:@"angaryLeft"];
    NSArray *angaryLeftArray=[[NSArray alloc]init];
    for (int i=1; i<8; i++) {
        SKTexture *temp=[atlas12 textureNamed:[NSString stringWithFormat:@"angaryLeft%d.png",i]];
        angaryLeftArray=[angaryLeftArray arrayByAddingObject:temp];
    }
    SKAction *angaryLeftAction=[SKAction animateWithTextures:angaryLeftArray timePerFrame:0.2];
    
    SKTextureAtlas *atlas13 = [SKTextureAtlas atlasNamed:@"angaryRight"];
    NSArray *angaryRightArray=[[NSArray alloc]init];
    for (int i=1; i<8; i++) {
        SKTexture *temp=[atlas13 textureNamed:[NSString stringWithFormat:@"angaryRight%d.png",i]];
        angaryRightArray=[angaryRightArray arrayByAddingObject:temp];
    }
    SKAction *angaryRightAction=[SKAction animateWithTextures:angaryRightArray timePerFrame:0.2];
    
    SKTextureAtlas *atlas14 = [SKTextureAtlas atlasNamed:@"redFishLeft"];
    NSArray *redFishLeftArray=[[NSArray alloc]init];
    for (int i=1; i<4; i++) {
        SKTexture *temp=[atlas14 textureNamed:[NSString stringWithFormat:@"redFishLeft%d.png",i]];
        redFishLeftArray=[redFishLeftArray arrayByAddingObject:temp];
    }
    SKAction *redFishLeftAction=[SKAction animateWithTextures:redFishLeftArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas15 = [SKTextureAtlas atlasNamed:@"redFishRight"];
    NSArray *redFishRightArray=[[NSArray alloc]init];
    for (int i=1; i<4; i++) {
        SKTexture *temp=[atlas15 textureNamed:[NSString stringWithFormat:@"redFishRight%d.png",i]];
        redFishRightArray=[redFishRightArray arrayByAddingObject:temp];
    }
    SKAction *redFishRightAction=[SKAction animateWithTextures:redFishRightArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas16=[SKTextureAtlas atlasNamed:@"rocket"];
    NSArray *rocketArray=[[NSArray alloc]init];
    for (int i=1; i<3; i++) {
        SKTexture *temp=[atlas16 textureNamed:[NSString stringWithFormat:@"rocket%d.png",i]];
        rocketArray=[rocketArray arrayByAddingObject:temp];
    }
    SKAction *rocketAction=[SKAction animateWithTextures:rocketArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas17 = [SKTextureAtlas atlasNamed:@"fishLauchLeft"];
    NSArray *fishLauchLeftArray=[[NSArray alloc]init];
    for (int i=1; i<4; i++) {
        SKTexture *temp=[atlas17 textureNamed:[NSString stringWithFormat:@"fishLauchLeft%d.png",i]];
        fishLauchLeftArray=[fishLauchLeftArray arrayByAddingObject:temp];
    }
    SKAction *fishLauchLeftAction=[SKAction animateWithTextures:fishLauchLeftArray timePerFrame:0.1];
    
    SKTextureAtlas *atlas18=[SKTextureAtlas atlasNamed:@"fishLauchRight"];
    NSArray *fishLauchRightArray=[[NSArray alloc]init];
    for (int i=1; i<4; i++) {
        SKTexture *temp=[atlas18 textureNamed:[NSString stringWithFormat:@"fishLauchRight%d.png",i]];
        fishLauchRightArray=[fishLauchRightArray arrayByAddingObject:temp];
    }
    SKAction *fishLauchRightAction=[SKAction animateWithTextures:fishLauchRightArray timePerFrame:0.1];
    
    if (animationNumber==0) {
        return eatAction;
    }else if (animationNumber==1){
        return moveLeftAction;
    }else if (animationNumber==2){
        return moveRightAction;
    }else if (animationNumber==3){
        return sleepAction;
    }else if (animationNumber==4){
        return tongeLeftAction;
    }else if (animationNumber==5){
        return tongeRightAction;
    }else if (animationNumber==6){
        return cryLeftAction;
    }else if (animationNumber==7){
        return cryRightAction;
    }else if (animationNumber==8){
        return yunLeftAction;
    }else if (animationNumber==9){
        return yunRightAction;
    }else if (animationNumber==10){
        return questionLeftAction;
    }else if (animationNumber==11){
        return questionRightAction;
    }else if (animationNumber==12){
        return angaryLeftAction;
    }else if (animationNumber==13){
        return angaryRightAction;
    }else if (animationNumber==14){
        return redFishLeftAction;
    }else if (animationNumber==15){
        return redFishRightAction;
    }else if (animationNumber==16){
        return rocketAction;
    }else if (animationNumber==17){
        return fishLauchLeftAction;
    }else if (animationNumber==18){
        return fishLauchRightAction;
    }
    else{
        NSLog(@"nil");
        return nil;
    }
    
}

- (void)reStart{
    isStart=0;
    isPased=0;
    moveStop=1;
    hitTimes=0;
    heartCount=0;
    lives=0;
    currentMaxScore=0;
    currentScore=0;
    [sprite removeFromParent];
    [noticeNode removeFromParent];
    [restartButton removeFromSuperview];
    [self enumerateChildNodesWithName:@"Notice" usingBlock:^(SKNode *node, BOOL *stop){
        [node removeFromParent];
    }];
    
    sprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(1, 1)];
    sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame));
    sprite.name=@"fish";
    sprite.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:0.3];
    sprite.physicsBody.categoryBitMask=fishCategory;
    sprite.physicsBody.contactTestBitMask=rockCategory;
    sprite.physicsBody.dynamic=NO;
    [self addChild:sprite];
    SKAction *scaleToSmall=[SKAction scaleXTo:100 y:100 duration:1];
    [sprite runAction:scaleToSmall];
    [sprite runAction:[SKAction repeatActionForever:[self myAnimation:3]]];
    
    SKAction *moveUpAction=[SKAction fadeAlphaTo:0 duration:1];
    SKAction *scaleToZero=[SKAction scaleXTo:1 duration:1];
    [scoreNode runAction:moveUpAction completion:^{
        [scoreNode removeFromParent];
    }];
    [lineSprite runAction:[SKAction group:@[
                                            moveUpAction,
                                            scaleToZero]] completion:^{
        [lineSprite removeFromParent];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
        myLabel.text = @"Tap To Start";
        myLabel.fontSize = 20;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)-100);
        [self addChild:myLabel];
        myLabel.name=@"Start";
        SKAction *fadeOutAction=[SKAction fadeAlphaTo:0.1 duration:2];
        SKAction *fadeInAction=[SKAction fadeAlphaTo:1 duration:2];
        [myLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                              fadeOutAction,
                                                                              fadeInAction]]]];
    }];
    
    [self enumerateChildNodesWithName:@"RedFish1" usingBlock:^(SKNode *node, BOOL *stop){
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"RedFish2" usingBlock:^(SKNode *node, BOOL *stop){
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"RedFish3" usingBlock:^(SKNode *node, BOOL *stop){
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"heart" usingBlock:^(SKNode *node, BOOL *stop){
        [node removeFromParent];
    }];
}

static inline CGFloat skRandf() {
    return arc4random()/2 / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addRock{
    
    SKSpriteNode *rock=[[SKSpriteNode alloc]initWithImageNamed:@"bubble1.png"];
    int a=arc4random_uniform(4);
    if (a==0) {
        rock.texture=[SKTexture textureWithImageNamed:@"bubble2.png"];
    }else if (a==1){
        rock.texture=[SKTexture textureWithImageNamed:@"bubble3.png"];
    }else if (a==2){
        rock.texture=[SKTexture textureWithImageNamed:@"bubble4.png"];
    }
    int b=arc4random_uniform(4);
    if (b==0) {
        rock.size=CGSizeMake(10, 10);
    }else if (b==1){
        rock.size=CGSizeMake(15, 15);
    }else if (b==2){
        rock.size=CGSizeMake(8, 8);
    }else if (b==3){
        rock.size=CGSizeMake(5, 5);
    }else{
        rock.size=CGSizeMake(12, 12);
    }
    rock.position=CGPointMake(skRand(0, self.size.width), 0);
    rock.name=@"rock";
//    rock.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
//    rock.physicsBody.usesPreciseCollisionDetection=YES;
//    rock.physicsBody.density=0;
    [self addChild:rock];
    
}

- (void)addRedFish:(int)theNumber{
    noticeNode.text=@"Do Not Hit Bomb Fish";
    
    SKEmitterNode *myEmitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle3" ofType:@"sks"]];
    myEmitterNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:myEmitterNode];
    
    SKSpriteNode *sprite1 = [SKSpriteNode spriteNodeWithImageNamed:@"redFishLeft1.png"];
    sprite1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));;
    sprite1.size=CGSizeMake(5, 5);
    [self addChild:sprite1];
    sprite1.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:0.3];
    
    sprite1.physicsBody.contactTestBitMask=rockCategory;
    sprite1.physicsBody.collisionBitMask=rockCategory;
    if (theNumber==1) {
        sprite1.name=@"RedFish1";
        sprite1.physicsBody.categoryBitMask=redFishCategory;
    }else if (theNumber==2){
        sprite1.name=@"RedFish2";
        sprite1.physicsBody.categoryBitMask=redFishCategory2;
    }else{
        sprite1.name=@"RedFish3";
        sprite1.physicsBody.categoryBitMask=redFishCategory3;
    }
    
    sprite1.physicsBody.affectedByGravity=NO;
    SKAction *makeLarge=[SKAction scaleTo:10 duration:1];
    
    int x=arc4random_uniform(3);
    int pluse;
    SKAction *addRed;
    if (x==0) {
        addRed=[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1 duration:0.2];
        pluse=2;
    }else if (x==1){
        addRed=[SKAction colorizeWithColor:[SKColor purpleColor] colorBlendFactor:1 duration:0.2];
        pluse=1;
    }else{
        addRed=[SKAction colorizeWithColor:[SKColor yellowColor] colorBlendFactor:1 duration:0.2];
        pluse=0;
    }
    
    if (moveX<0) {
        [sprite runAction:[self myAnimation:12] completion:^{
            SKAction *fadeOut=[SKAction fadeAlphaTo:0 duration:1];
            [myEmitterNode runAction:fadeOut completion:^{
                [myEmitterNode removeFromParent];
            }];
            isStart=1;
            isPased=1;
            moveStop=0;
            canShoot=1;
            [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
        }];
    }else{
        [sprite runAction:[self myAnimation:13] completion:^{
            SKAction *fadeOut=[SKAction fadeAlphaTo:0 duration:1];
            [myEmitterNode runAction:fadeOut completion:^{
                [myEmitterNode removeFromParent];
            }];
            isStart=1;
            isPased=1;
            moveStop=0;
            canShoot=1;
            [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
        }];
    }
    
    int t=arc4random_uniform(4);
    if (theNumber==1) {
        if (t==0) {
            moveX_fish=1+pluse;
            moveY_fish=1+pluse;
        }else if (t==1){
            moveX_fish=-1-pluse;
            moveY_fish=1+pluse;
        }else if (t==2){
            moveX_fish=1+pluse;
            moveY_fish=-1-pluse;
        }else{
            moveX_fish=-1-pluse;
            moveY_fish=-1-pluse;
        }
        if (moveX_fish<0) {
            
            [sprite1 runAction:[SKAction group:@[
                                                 [SKAction repeatAction:[self myAnimation:14] count:3],
                                                 makeLarge,
                                                 addRed]]completion:^{
                [sprite1 runAction:[SKAction repeatActionForever:[self myAnimation:14]]];
            }];
        }else{
            
            [sprite1 runAction:[SKAction group:@[
                                                 [SKAction repeatAction:[self myAnimation:15] count:3],
                                                 makeLarge,
                                                 addRed]]completion:^{
                [sprite1 runAction:[SKAction repeatActionForever:[self myAnimation:15]]];
            }];
        }

    }else if (theNumber==2){
        if (t==0) {
            moveX_fish2=1+pluse;
            moveY_fish2=1+pluse;
        }else if (t==1){
            moveX_fish2=-1-pluse;
            moveY_fish2=1+pluse;
        }else if (t==2){
            moveX_fish2=1+pluse;
            moveY_fish2=-1-pluse;
        }else{
            moveX_fish2=-1-pluse;
            moveY_fish2=-1-pluse;
        }
        if (moveX_fish2<0) {
            
            [sprite1 runAction:[SKAction group:@[
                                                 [SKAction repeatAction:[self myAnimation:14] count:3],
                                                 makeLarge,
                                                 addRed]]completion:^{
                [sprite1 runAction:[SKAction repeatActionForever:[self myAnimation:14]]];
            }];
        }else{
            
            [sprite1 runAction:[SKAction group:@[
                                                 [SKAction repeatAction:[self myAnimation:15] count:3],
                                                 makeLarge,
                                                 addRed]]completion:^{
                [sprite1 runAction:[SKAction repeatActionForever:[self myAnimation:15]]];
            }];
        }

    }else if (theNumber==3){
        if (t==0) {
            moveX_fish3=1+pluse;
            moveY_fish3=1+pluse;
        }else if (t==1){
            moveX_fish3=-1-pluse;
            moveY_fish3=1+pluse;
        }else if (t==2){
            moveX_fish3=1+pluse;
            moveY_fish3=-1-pluse;
        }else{
            moveX_fish3=-1-pluse;
            moveY_fish3=-1-pluse;
        }
        if (moveX_fish3<0) {
            
            [sprite1 runAction:[SKAction group:@[
                                                 [SKAction repeatAction:[self myAnimation:14] count:3],
                                                 makeLarge,
                                                 addRed]]completion:^{
                [sprite1 runAction:[SKAction repeatActionForever:[self myAnimation:14]]];
            }];
        }else{
            
            [sprite1 runAction:[SKAction group:@[
                                                 [SKAction repeatAction:[self myAnimation:15] count:3],
                                                 makeLarge,
                                                 addRed]]completion:^{
                [sprite1 runAction:[SKAction repeatActionForever:[self myAnimation:15]]];
            }];
        }

    }
    
    
    
}

- (void)gameoverPushView{
    [restartButton removeFromSuperview];
    [noticeNode removeFromParent];
    adCount++;
    if (adCount==5) {
        adCount=0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adShow"object:@"adLarge"];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adShow"object:@"adShow"];
    }
    
    
    canShoot=0;
    SKSpriteNode *gameoverBackViewNode=[SKSpriteNode spriteNodeWithImageNamed:@"gameover.png"];
    gameoverBackViewNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                                CGRectGetMidY(self.frame));
    gameoverBackViewNode.size=CGSizeMake(250, 300);
    gameoverBackViewNode.name=@"GameOverViewNode";
    [self addChild:gameoverBackViewNode];
    
    SKLabelNode *scoreLabel=[SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
    scoreLabel.text=@"Your Score:";
    scoreLabel.fontSize=15;
    scoreLabel.fontColor=[SKColor purpleColor];
    scoreLabel.position=CGPointMake(0, 40);
    [gameoverBackViewNode addChild:scoreLabel];
    
    SKLabelNode *scoreNumLabel=[SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
    scoreNumLabel.text=[NSString stringWithFormat:@"%d",currentScore];
    scoreNumLabel.fontSize=35;
    scoreNumLabel.fontColor=[SKColor orangeColor];
    scoreNumLabel.position=CGPointMake(0, -10);
    [gameoverBackViewNode addChild:scoreNumLabel];
    
    SKLabelNode *restartLabel=[SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
    restartLabel.text=@"Restart";
    restartLabel.name=@"Restart";
    restartLabel.fontSize=20;
    restartLabel.fontColor=[SKColor blackColor];
    restartLabel.position=CGPointMake(0, -50);
    [gameoverBackViewNode addChild:restartLabel];
    restartLabel.alpha=0.8;
    
    SKAction *fadeOut=[SKAction fadeAlphaTo:0.5 duration:1];
    SKAction *fadeIn=[SKAction fadeAlphaTo:0.8 duration:1];
    [restartLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                               fadeOut,
                                                                               fadeIn]]]];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"BestScore"]integerValue]<currentScore) {
        NSLog(@"newrecord");
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",currentScore] forKey:@"BestScore"];
        
        SKLabelNode *newRecordLabel=[SKLabelNode labelNodeWithFontNamed:@"Noteworthy-Bold"];
        newRecordLabel.text=@"New Record";
        newRecordLabel.fontSize=25;
        newRecordLabel.fontColor=[SKColor redColor];
        newRecordLabel.position=CGPointMake(0, 70);
        [gameoverBackViewNode addChild:newRecordLabel];
        
        [newRecordLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                                   [SKAction fadeAlphaTo:0.1 duration:1],
                                                                                   [SKAction fadeAlphaTo:0.9 duration:1]]]]];
        bestNode.text=[NSString stringWithFormat:@"Best: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"BestScore"]];
        
         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"I Got %d Score In Shoot The Fish!",currentScore] forKey:@"Facebook"];
         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"我在打鲨鱼中获得了%d分！",currentScore] forKey:@"Weibo"];
         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"我在打鲨鱼中获得了%d分！",currentScore] forKey:@"Weixin"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shareShow"object:@"shareShow"];
        gameoverBackViewNode.size=CGSizeMake(250, 400);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (buttonIndex==1) {
        if (version<7) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=923811726"]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id923811726"]];
        }
    }
}

//播放完后

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag{
    
    NSLog(@"ffff");
    
}

@end
