//
//  MyScene.m
//  ShootMoon
//
//  Created by apple on 16/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import "MyScene.h"

static const uint32_t fishCategory     =  0x1 << 0;
static const uint32_t rockCategory        =  0x1 << 1;

@implementation MyScene

bool isStart=0;
bool moveStop=0;
int timeIntevel=0;
int moveSpeed=1;
float moveX=1;
float moveY=1;

int hitTimes=0;
SKSpriteNode *sprite;
UIButton *restartButton;

bool isPased=0;
int shortTime=0;
int t,tt;

SKLabelNode *scoreNode;
SKLabelNode *bestNode;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor clearColor];
        self.physicsWorld.contactDelegate=self;
        self.physicsWorld.gravity = CGVectorMake(0,0);
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
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = @"Tap To Start";
        myLabel.fontSize = 20;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)-100);
        
        myLabel.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(200, 50)];
        myLabel.name=@"Start";
        SKAction *fadeOutAction=[SKAction fadeAlphaTo:0.1 duration:2];
        SKAction *fadeInAction=[SKAction fadeAlphaTo:1 duration:2];
        [myLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                              fadeOutAction,
                                                                              fadeInAction]]]];
        
        sprite = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(1, 1)];
        sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));;
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
        sprite.physicsBody.dynamic=NO;
        
        bestNode=[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        bestNode.text=@"Best: 0";
        bestNode.fontSize=15;
        bestNode.position=CGPointMake(250, 20);
        [self addChild:bestNode];
        

    }
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
            scoreNode=[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            scoreNode.text=@"Score: 0";
            scoreNode.fontSize=15;
            scoreNode.position=CGPointMake(50, 20);
            [self addChild:scoreNode];
            scoreNode.alpha=0;
            SKAction *moveUpAction=[SKAction fadeAlphaTo:1 duration:1];
            [scoreNode runAction:moveUpAction];
            
            [self enumerateChildNodesWithName:@"Start" usingBlock:^(SKNode *node, BOOL *stop){
                self.physicsWorld.gravity = CGVectorMake(0,-3);
                SKAction *startAction=[SKAction fadeOutWithDuration:1.7];
                SKAction *scaleToSmall=[SKAction scaleTo:80 duration:1.7];
                [sprite runAction:[SKAction group:@[
                                                   [self myAnimation:0],
                                                   scaleToSmall]]];
                

                
                [node runAction:startAction completion:^{
                    [node removeFromParent];
//                    self.physicsWorld.gravity = CGVectorMake(0,0);
                    
                    [self directionInit];
                    isStart=1;
                    isPased=1;
                    moveStop=0;
                    
                    restartButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    restartButton.frame=CGRectMake(10, 10, 30, 30);
                    [restartButton setBackgroundImage:[UIImage imageNamed:@"reload-04.png"] forState:UIControlStateNormal];
                    [self.view addSubview:restartButton];
                    [restartButton addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
                    restartButton.alpha=0.6;
                    
                    
                    if (moveX<0) {
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                    }else{
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                    }
                    

                }];
            }];
        }
        
        if (isStart==1&moveStop==0) {
            if ([touch locationInNode:self].y<100) {
                self.physicsWorld.gravity = CGVectorMake(0,1);
                SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
                sprite.position = location;
                sprite.size=CGSizeMake(50, 50);
                [self addChild:sprite];
                sprite.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
                sprite.physicsBody.categoryBitMask=rockCategory;
                sprite.physicsBody.contactTestBitMask=fishCategory;
                sprite.name=@"Spaceship";
            }

        }
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (isStart==1) {
        timeIntevel++;
        if (timeIntevel==moveSpeed) {
            timeIntevel=0;
            if (moveStop==0) {
                
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
                
//                int i=arc4random_uniform(200);
//                if (i==1) {
//                    moveStop=1;
//                    if (moveX<0) {
//                        [sprite runAction:[self myAnimation:10]completion:^{
//                            moveStop=0;
//                        }];
//                    }else{
//                        [sprite runAction:[self myAnimation:11]completion:^{
//                            moveStop=0;
//                        }];
//                    }
//                }
            }
            
        }
    }
}

- (void)didSimulatePhysics{
//NSLog(@"movex=%fmovey=%f",moveX,moveY);
    
    [self enumerateChildNodesWithName:@"fish" usingBlock:^(SKNode *node, BOOL *stop){

//        NSLog(@"node%f",node.position.y);
        if (node.position.y<150|node.position.y>self.view.bounds.size.height-40) {
            moveY=-moveY;
            
        }else if (node.position.x<40|node.position.x>self.view.bounds.size.width-40){
            moveX=-moveX;
            
            NSLog(@"%f",moveX);
            if (moveX<0) {
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
            }else{
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
            }
                
        }
        
    }];
    
    [self enumerateChildNodesWithName:@"Spaceship" usingBlock:^(SKNode *node, BOOL *stop){
        if (node.position.y>self.view.bounds.size.height) {
            [node removeFromParent];
            NSLog(@"remove");
            moveStop=1;
            if (moveX<0) {
                [sprite runAction:[self myAnimation:4]completion:^{
                    moveStop=0;
                }];
            }else{
                [sprite runAction:[self myAnimation:5]completion:^{
                    moveStop=0;
                }];
            }
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
        [self enumerateChildNodesWithName:@"Spaceship" usingBlock:^(SKNode *node, BOOL *stop){
                [node removeFromParent];
        }];
        isStart=0;
        isPased=1;
//        SKAction *shakeLeftFirst=[SKAction moveToX:sprite.position.x-5 duration:0.01];
//        SKAction *shakeRight=[SKAction moveToX:sprite.position.x+10 duration:0.02];
//        SKAction *shakeLeft=[SKAction moveToX:sprite.position.x-10 duration:0.02];
//        SKAction *shakeRightAfter=[SKAction moveToX:sprite.position.x+5 duration:0.01];
//        SKAction *shakeAction=[SKAction sequence:@[
//                                                   shakeLeftFirst,
//                                                   [SKAction repeatAction:[SKAction sequence:@[
//                                                                                               shakeRight,
//                                                                                               shakeLeft]] count:1],
//                                                   shakeRightAfter]];
        SKAction *shakeUp=[SKAction moveToY:sprite.position.y+12 duration:0.2];
        SKAction *shakeUp2=[SKAction moveToY:sprite.position.y+3 duration:0.1];
        SKAction *shakeDown=[SKAction moveToY:sprite.position.y-15 duration:0.2];
        SKAction *shakeAction=[SKAction sequence:@[
                                                   shakeUp,shakeUp2,shakeDown]];
        [sprite removeAllActions];
        if (moveX<0) {
            [sprite runAction:[SKAction group:@[
                                                [self myAnimation:8],
                                                shakeAction]] completion:^{
                isStart=1;
                moveStop=0;
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
//                if (moveX<0) {
//                    [sprite runAction:[self myAnimation:6]completion:^{
//                        moveStop=0;
//                    }];
//                }else{
//                    [sprite runAction:[self myAnimation:7]completion:^{
//                        moveStop=0;
//                    }];
//                }
                
                
            }];
        }else{
            [sprite runAction:[SKAction group:@[
                                                [self myAnimation:9],
                                                shakeAction]] completion:^{
                isStart=1;
                moveStop=0;
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
//                if (moveX<0) {
//                    [sprite runAction:[self myAnimation:6]completion:^{
//                        moveStop=0;
//                    }];
//                }else{
//                    [sprite runAction:[self myAnimation:7]completion:^{
//                        moveStop=0;
//                    }];
//                }
                
                
            }];
        }
        
        
    }
}

- (void)directionInit{
    int i=arc4random_uniform(7);
    NSLog(@"%d",i);
    switch (i) {
        case 0:
            moveX=1;
            moveY=1;
            break;
        case 1:
            moveX=1;
            moveY=-1;
        case 2:
            moveX=-1;
            moveY=1;
        case 3:
            moveX=-1;
            moveY=-1;
        case 4:
            moveX=1;
            moveY=1.5;
        case 5:
            moveX=1;
            moveY=-1.5;
        case 6:
            moveX=-1;
            moveY=1.5;
        case 7:
            moveX=-1;
            moveY=-1.5;
            
        default:
            break;
    }
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
    }
    else{
        NSLog(@"nil");
        return nil;
    }
    
}

- (void)reStart{
    isStart=0;
    moveStop=1;
    [sprite removeFromParent];
    [restartButton removeFromSuperview];
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
    self.physicsWorld.gravity = CGVectorMake(0,0);
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    myLabel.text = @"Tap To Start";
    myLabel.fontSize = 20;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame)-100);
    [self addChild:myLabel];
    myLabel.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(200, 50)];
    myLabel.name=@"Start";
    SKAction *fadeOutAction=[SKAction fadeAlphaTo:0.1 duration:2];
    SKAction *fadeInAction=[SKAction fadeAlphaTo:1 duration:2];
    [myLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                          fadeOutAction,
                                                                          fadeInAction]]]];
    SKAction *moveUpAction=[SKAction fadeAlphaTo:0 duration:1];
    [scoreNode runAction:moveUpAction completion:^{
        [scoreNode removeFromParent];
    }];
}

@end
