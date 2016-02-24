//
//  CollidableObject.h
//  p04-redband
//
//  Created by Matthew Reigada on 2/21/16.
//  Copyright © 2016 Timothy Redband. All rights reserved.
//

#ifndef CollidableObject_h
#define CollidableObject_h

#import <SpriteKit/SpriteKit.h>
//#import "GameScene.h"

@interface CollidableObject : NSObject
    -(BOOL) Collided:(CollidableObject*) otherObj;
    -(SKSpriteNode*) getSprite;
    -(BOOL) CheckCollisionL:(CollidableObject*) otherObj;
    -(void) SetVelocity:(double) V WithAngle:(double) V_Angle;
    -(void) SetAction:(SKAction*) act;
-(void) addToView:(SKScene*) scene :(CGPoint) pos;

    @property SKSpriteNode *sprite;
    @property SKAction *action;

    @property BOOL placedInView;
    @property double Spin_Speed;        // Angular Velocity
    @property double objectVelocity;    // Velocity
    @property CGPoint velocityVector;   //unit vector describing velocity, normalize to 1
@end


#endif /* CollidableObject_h */
