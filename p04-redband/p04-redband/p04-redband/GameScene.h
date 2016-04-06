//
//  GameScene.h
//  p04-redband
//

//  Copyright (c) 2016 Timothy Redband. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
//@property (nonatomic,strong) SKAction *exAnimation;
//@property (nonatomic, strong) SKSpriteNode *exSprite;

-(void)addAsteroid;
-(int)genNum:(int)length;

@end

