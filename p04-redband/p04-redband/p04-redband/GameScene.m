//
//  GameScene.m
//  p04-redband
//
//  Created by Timothy Redband on 2/16/16.
//  Copyright (c) 2016 Timothy Redband. All rights reserved.
//

#import "GameScene.h"
#import "ShipObject.h"

@implementation GameScene


BOOL firstTouchFlag = true; //first touch will be treated as ship movement vector
ShipObject* ship = NULL;
SKSpriteNode* player;
SKSpriteNode *LaserIcon;
SKSpriteNode *bgImage;
double vel;// = 4.5;
CGVector velVec = { 10.0, 0.0 };
double shipAngle;
NSMutableArray* Lasers;
NSMutableArray *explosion_array;
SKLabelNode *myLabel;
NSMutableArray *clever_labels;

-(void)didMoveToView:(SKView *)view {
    Lasers =[[NSMutableArray alloc] init];
    clever_labels = [[NSMutableArray alloc] init];
    [self insertCleverLabels:clever_labels];
    [self initExplosionArray];
    /* Setup your scene here */
    myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"simplifiedplanet"];
    bgImage.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    [bgImage setZPosition:-1.0];
    [self addChild:bgImage];
    
    LaserIcon = [SKSpriteNode spriteNodeWithImageNamed:@"laser"];
    double div = 10.0;
    LaserIcon.size = CGSizeMake(self.frame.size.width / div, self.frame.size.height / div);
    double LasCornDist = 20.0;
    LaserIcon.position =
    CGPointMake(LasCornDist + ([LaserIcon size].width / 2), LasCornDist + ([LaserIcon size].height / 4));
    //LaserIcon.physicsBody = [SKPhysicsBody bodyWithTexture:LaserIcon.texture size:LaserIcon.texture.size];
    [LaserIcon setZPosition:2.0];
    [self addChild:LaserIcon];
    
    //int rand_text_index = rand() % clever_labels.count;
    myLabel.text = @"Asteroids";
    myLabel.fontSize = 45;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [myLabel setZPosition:0.0];
    [self addChild:myLabel];
    
    vel = CGRectGetWidth(self.frame) / 50.0;
    
    //ship = [[ShipObject alloc] init];
    //[ship addToView:self :myLabel.position];
    
    player = [SKSpriteNode spriteNodeWithImageNamed:@"fighter"];
    player.name = @"P";
    player.xScale = 0.1;
    player.yScale = 0.1;
	//player.alpha = 1.0;
    player.position = myLabel.position;
    [player setZPosition:1.0];
    //
    //    SKAction *action = [SKAction rotateToAngle: -M_PI / 2 duration:1];
    shipAngle = - M_PI / 2;
    [player runAction: [SKAction rotateToAngle: shipAngle duration: 1]];
    [self addChild:player];
    
    id wait = [SKAction waitForDuration:(1/10.0)];
    id run = [SKAction runBlock:^{
        double excess = [player size].height / 10.0;
        double buffer = 1.1 * excess;   //bigger than 1 or problems
        if (player.position.x < CGRectGetMinX(self.frame) - buffer){
            [player runAction:[SKAction moveToX:CGRectGetMaxX(self.frame)+excess duration:0.0]];
        }else if(player.position.x > CGRectGetMaxX(self.frame) + buffer){
            [player runAction:[SKAction moveToX:CGRectGetMinX(self.frame)-excess duration:0.0]];
        }
        if(player.position.y < CGRectGetMinY(self.frame) - buffer){
            [player runAction:[SKAction moveToY:CGRectGetMaxY(self.frame)+excess duration:0.0]];
        }else if (player.position.y > CGRectGetMaxY(self.frame) + buffer){
            [player runAction:[SKAction moveToY:CGRectGetMinY(self.frame)-excess duration:0.0]];
        }
    }];
    //[player runAction:[SKAction sequence:@[wait, run]]];
    [player runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, run]]]];
    
    id bgWait = [SKAction waitForDuration:(1/10.0)];
    id bgRun = [SKAction runBlock:^{
        
    }];
    
    [bgImage runAction:[SKAction repeatActionForever:[SKAction sequence:@[bgWait, bgRun]]]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if(player.hidden == false){
    	for (UITouch *touch in touches) {
    	    CGPoint location = [touch locationInNode:self];
        
    	    //actions for Laser
    	    if ([LaserIcon containsPoint:location]){
    	        SKSpriteNode* Laser = [SKSpriteNode spriteNodeWithImageNamed:@"laser"];
    	        Laser.size = CGSizeMake(20, 15);
    	        [Laser setPosition: player.position];
				Laser.name = @"L";
				double laserSpeed = vel;
				//double xcomp = velVec.dx;
				//double ycomp = velVec.dy;
				double lasRot = player.zRotation;
				double xcomp = -vel*sin(lasRot);
				double ycomp = vel*cos(lasRot);
				SKAction* frst =
					[SKAction
						repeatAction:[SKAction
							moveByX:xcomp*laserSpeed y:ycomp*laserSpeed duration: 0.5
						]
						count: 5
					];
            	SKAction* act = [SKAction sequence:@[frst, [SKAction removeFromParent]]];
	            [Laser runAction:[SKAction repeatAction:act count:1]];
				SKAction* rot = [SKAction rotateToAngle:lasRot - (M_PI / 2) duration:0];
				[Laser runAction:rot];
				[Lasers addObject:Laser];
				[self addChild:Laser];
				[self runAction:[SKAction playSoundFileNamed:@"laser_sound.mp3" waitForCompletion:YES]];
			}else{
				//trig logic for ship velocity
				velVec.dx = location.x - player.position.x;
				velVec.dy = location.y - player.position.y;
				double hyp = sqrt(velVec.dx*velVec.dx + velVec.dy*velVec.dy);
				velVec.dx = (vel*velVec.dx) / hyp;
				velVec.dy = (vel*velVec.dy) / hyp;
				SKAction* act = [SKAction moveBy:velVec duration:3.0];
				[player runAction:[SKAction repeatAction:act count:1]];
				//trig logic for ship angle
				shipAngle = atan(velVec.dy / velVec.dx) - (M_PI / 2);
				if(velVec.dx < 0){
					shipAngle += M_PI;
				}
				double delta = (shipAngle - player.zRotation);
				while(delta > M_PI){
					delta -= (2 * M_PI);
				}
				while(delta < -M_PI){
					delta += (2 * M_PI);
				}
				delta += player.zRotation;
				[player runAction:[SKAction rotateToAngle: delta duration: 1]];
			}
		}
	}
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesBegan:touches withEvent:event];
}


-(void)addAsteroid{
    int random = rand() % 6 + 1;
    NSString *string_num = [NSString stringWithFormat:@"%d", random];
    NSString *asteroid_n = @"asteroid_";
    NSString *n_string = [asteroid_n stringByAppendingString:string_num];
    SKSpriteNode * asteroid = [SKSpriteNode spriteNodeWithImageNamed:n_string];
    asteroid.name = @"A";
    
    int minY = asteroid.size.height / 2;
    int maxY = self.frame.size.height - asteroid.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    int randY = (arc4random() % rangeY) + minY;
    
    int minX = asteroid.size.width / 2;
    int maxX = self.frame.size.width - asteroid.size.height / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    int randX = (arc4random() % rangeX) + minX;
    
    int rand2 = rand() % 4;
    
    int minDuration = 4.0;
    int maxDuration = 16.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    int x_val = [self genNum:(int)self.frame.size.width];//x off screen
    int y_val = [self genNum:(int)self.frame.size.height];//y off screen
    
    if(rand2 == 0){//come from left
        asteroid.position = CGPointMake(-asteroid.size.width / 2, actualY);
        [self addChild:asteroid];
        SKAction * actionMove = [SKAction moveTo:CGPointMake(abs(x_val), y_val) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [asteroid runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    } else if(rand2 == 1){ // come from bottom
        asteroid.position = CGPointMake(actualX, -asteroid.size.width / 2);
        [self addChild:asteroid];
        SKAction * actionMove = [SKAction moveTo:CGPointMake(x_val, abs(y_val)) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [asteroid runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    } else if(rand2 == 2){ // come from right
        asteroid.position = CGPointMake(self.frame.size.width + asteroid.size.width/2, actualY);
        [self addChild:asteroid];
        SKAction * actionMove = [SKAction moveTo:CGPointMake(x_val, randY) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [asteroid runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    } else{//top
        asteroid.position = CGPointMake(actualX, self.frame.size.height + asteroid.size.width / 2);
        [self addChild:asteroid];
        if(y_val > 0){
            y_val *= -1;
        }
        SKAction * actionMove = [SKAction moveTo:CGPointMake(randX, y_val) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [asteroid runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    }
}

//pulled from monster demo
-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addAsteroid];
    }
}

//pulled from monster demo
-(void)update:(NSTimeInterval)currentTime {
	//TODO: change and rename asset for explosion sounds
	NSString *explosionSound = @"explosion.wav";
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    NSMutableArray* removeList = [[NSMutableArray alloc] init];
    for(SKSpriteNode *L in Lasers){
        NSArray* nodes = [self nodesAtPoint:L.position];
        BOOL collision = false;
        for(SKSpriteNode *S in nodes){
            if([S.name isEqualToString:@"A"]|| [S.name isEqualToString:@"a"]){	//if asteroid under laser then delete asteroid
                [S runAction:[SKAction removeFromParent]];
                collision = true;
                SKSpriteNode *exSprite = [SKSpriteNode spriteNodeWithImageNamed:@"explosions_15.png"];
                exSprite.position = CGPointMake(S.position.x, S.position.y);
                [self addChild: exSprite];
                //SKAction *repeat_once = [SKAction repeatAction:self.exAnimation count:1];
                SKAction *exAnimation = [SKAction animateWithTextures:explosion_array timePerFrame:0.2];
                [exSprite runAction:exAnimation completion:^{
                    [exSprite removeFromParent];
                }];
            }
        }
        if(collision || false == [bgImage containsPoint:L.position]){	//if laser offscreen or collided, then remove
			[removeList addObject:L];
			if(collision){
				[self runAction:[SKAction playSoundFileNamed:explosionSound waitForCompletion:YES]];
			}
        }
    }
	for (SKSpriteNode* L in removeList){
		[Lasers removeObject:L];
		[L runAction:[SKAction removeFromParent]];
	}
	removeList = NULL;	//drop array to avoid memory retention, garbage collection will pick it up
	
	if(player.isHidden == false){
    	NSArray *asteroid_nodes = [self nodesAtPoint:player.position];
    	for(SKSpriteNode *S in asteroid_nodes){
    	    if([S.name isEqualToString:@"A"] || [S.name isEqualToString:@"a"]){
    	        SKSpriteNode *exSprite = [SKSpriteNode spriteNodeWithImageNamed:@"explosions_15.png"];
				[self runAction:[SKAction playSoundFileNamed:explosionSound waitForCompletion:YES]];
				exSprite.position = player.position;
				[self addChild:exSprite];
				SKAction *exAnimation = [SKAction animateWithTextures:explosion_array timePerFrame:0.2];
				[exSprite runAction:exAnimation completion:^{
					[exSprite removeFromParent];
				}];
				
				SKAction* invisible = [SKAction runBlock:^{ [player setHidden:true]; }];
				SKAction* wait = [SKAction waitForDuration:(3.0)];
				SKAction* visible = [
					SKAction runBlock:^{
						[player setHidden:false];
						[player setPosition:CGPointMake(self.frame.size.width / 2, self.frame.size.height /2)];
					}
				];
				
			    [player runAction:[SKAction sequence:@[invisible, wait, visible]]];
            	//int rand_text_index = rand() % clever_labels.count;
            	//myLabel.text = clever_labels[rand_text_index];
				break;
			}
    	}
		asteroid_nodes = NULL;
	}

    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}
-(int)genNum:(int)length{
    int ret = rand() % (length * 4);
    if(ret > 0 && ret < length){
        ret = -ret;
        return ret;
    }
    else{
        return ret;
    }
    
}

-(void)initExplosionArray{
    explosion_array = [NSMutableArray arrayWithCapacity:15];
    for(int i = 0; i < 15;++i){ //15 explosion animations
        NSString *explosionName = [NSString stringWithFormat:@"explosions_%d", i + 1];
        SKTexture *explosion = [SKTexture textureWithImageNamed:explosionName];
        [explosion_array addObject:explosion];
    }
    //self.exAnimation = [SKAction animateWithTextures:explosion_array timePerFrame:0.2];
}

-(void)insertCleverLabels:(NSMutableArray*) array{
    [array addObject:@"You can win"];
    [array addObject:@"Don't get discouraged"];
    [array addObject:@"There's no score anyways"];
    [array addObject:@"If there was a score you would lose"];
    [array addObject:@"Roses are red"];
    [array addObject:@"Violets are blue"];
    [array addObject:@"I like turtles"];
    [array addObject:@"Three's a crowd"];
    
}

@end

