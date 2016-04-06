//
//  ShipObject.m
//  p04-redband
//
//  Created by Matthew Reigada on 2/21/16.
//  Copyright © 2016 Timothy Redband. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShipObject.h"


@implementation ShipObject

@synthesize sprite;
@synthesize action;
@synthesize placedInView;
@synthesize Spin_Speed;        // Angular Velocity
@synthesize objectVelocity;    // Velocity
@synthesize velocityVector;   //unit vector describing velocity, normalize to 1

- (id)init{
    if( self = [super init] ){
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.physicsBody = [SKPhysicsBody bodyWithTexture:sprite.texture size:sprite.texture.size];
        CGPoint tmp = { 100.0, 100.0 };
        sprite.position = tmp;
        objectVelocity = 1.0;
        velocityVector.x = 1.0;
        velocityVector.y = 0.0;
        Spin_Speed = 1.0;
        placedInView = false;
    }
    
    return self;
}

-(BOOL) Collided:(CollidableObject*) otherObj{
    return true;
}

-(void) CalcVelocityVector:(CGPoint) position{
    CGPoint tmp;
    tmp.x = position.x - [self getSprite].position.x;
    tmp.y = position.y - [self getSprite].position.y;
    CGFloat hypotenuse = sqrt(pow(tmp.x, 2.0) + pow(tmp.y, 2.0));
    velocityVector.x = tmp.x / hypotenuse;
    velocityVector.y = tmp.y / hypotenuse;
    SKAction* act = [SKAction rotateByAngle:M_PI duration:1];//[SKAction moveByX:velocityVector.x*objectVelocity y:velocityVector.y*objectVelocity duration:1];
    [sprite runAction:[SKAction repeatActionForever:act]];    
}

@end