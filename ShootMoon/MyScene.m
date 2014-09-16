//
//  MyScene.m
//  ShootMoon
//
//  Created by apple on 16/9/14.
//  Copyright (c) 2014年 ___GWH___. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

bool isStart=0;
int timeIntevel=0;
int moveSpeed=1;
float moveX=1;
float moveY=1;

int hitTimes=0;
SKSpriteNode *sprite;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.physicsWorld.contactDelegate=self;
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame)+100);;
        sprite.size=CGSizeMake(80, 80);
        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:0]]];
        [self addChild:sprite];
        sprite.name=@"Spaceship";

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
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKPhysicsBody *body=[self.physicsWorld bodyAtPoint:location];
        if ([body.node.name isEqualToString:@"Start"]) {
            NSLog(@"Start");
            [self enumerateChildNodesWithName:@"Start" usingBlock:^(SKNode *node, BOOL *stop){
                SKAction *startAction=[SKAction fadeOutWithDuration:2];
                self.physicsWorld.gravity = CGVectorMake(0,-1);
                [node runAction:startAction completion:^{
                    [node removeFromParent];
                    
                    [self directionInit];
                    isStart=1;
                    
                    if (moveX<0) {
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
                    }else{
                        [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
                    }
                }];
            }];
        }
        if (isStart==1) {
            if ([touch locationInNode:self].y<100) {
                SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
                sprite.position = location;
                sprite.size=CGSizeMake(50, 50);
                [self addChild:sprite];
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
            sprite.position = CGPointMake(sprite.position.x+moveX,
                                          sprite.position.y+moveY);;
        }
    }
}

- (void)didSimulatePhysics{

    [self enumerateChildNodesWithName:@"Spaceship" usingBlock:^(SKNode *node, BOOL *stop){

        if (node.position.y<100|node.position.y>self.view.bounds.size.height) {
            sprite.position = CGPointMake(sprite.position.x,
                                          sprite.position.y-moveY);;
            moveY=-moveY;
        }else if (node.position.x<0|node.position.x>self.view.bounds.size.width){
            sprite.position = CGPointMake(sprite.position.x-moveX,
                                          sprite.position.y);;
            moveX=-moveX;
            NSLog(@"%f",moveX);
            if (moveX<0) {
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:1]]];
            }else{
                [sprite runAction:[SKAction repeatActionForever:[self myAnimation:2]]];
            }

        }
        
    }];
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
    
    if (animationNumber==0) {
        return eatAction;
    }else if (animationNumber==1){
        return moveLeftAction;
    }else if (animationNumber==2){
        return moveRightAction;
    }
    else{
        NSLog(@"nil");
        return nil;
    }
    
}

@end
