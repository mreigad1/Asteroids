//
//  CollidableObject.m
//  p04-redband
//
//  Created by Matthew Reigada on 2/21/16.
//  Copyright © 2016 Timothy Redband. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CollidableObject.h"

@implementation CollidableObject

@synthesize sprite;
@synthesize action;
@synthesize placedInView;
@synthesize Spin_Speed;        // Angular Velocity
@synthesize objectVelocity;    // Velocity
@synthesize velocityVector;   //unit vector describing velocity, normalize to 1


/*- (id)init{
    if( self = [super init] ){
        objectVelocity = 0.0;
        velocityVector.x = 1.0;
        velocityVector.y = 0.0;
        Spin_Speed = 1.0;
        placedInView = false;
    }
    
    return self;
}*/

//NOTE: Children classes must override this method
//Object types must be considered and collision box must be considered
-(BOOL) Collided:(CollidableObject*) otherObj{
    
    SKSpriteNode* otherSprite = [otherObj getSprite];
    
    return [sprite intersectsNode:otherSprite];
}

-(SKSpriteNode*) getSprite{
    return sprite;
}

//both items must detect collision with one another
-(BOOL) CheckCollisionL:(CollidableObject*) otherObj{
    BOOL collided = true;
    collided = collided && [self Collided:otherObj];
    collided = collided && [otherObj Collided:self];
    return collided;
}

-(void) SetVelocity:(double) V WithAngle:(double) V_Angle{
    self.objectVelocity = V;
    velocityVector.x = cos(V_Angle);
    velocityVector.y = sin(V_Angle);
}

-(void) SetAction:(SKAction*) act{
    action = act;
    [sprite runAction:[SKAction repeatActionForever:action]];
}

-(void) addToView:(SKScene*) scene :(CGPoint) pos{
    if(placedInView == false && sprite != NULL){
        placedInView = true;
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        //sprite.position = pos;
        [scene addChild:sprite];
    }
}

@end