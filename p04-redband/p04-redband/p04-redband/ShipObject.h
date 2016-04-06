//
//  ShipObject.h
//  p04-redband
//
//  Created by Matthew Reigada on 2/21/16.
//  Copyright © 2016 Timothy Redband. All rights reserved.
//

#ifndef ShipObject_h
#define ShipObject_h

#import "CollidableObject.h"

@interface ShipObject : CollidableObject

    -(void) CalcVelocityVector:(CGPoint) position;

@end

#endif /* ShipObject_h */
