/*
 * #Warrior - http://tuftentertainment.github.io/hashtag-warrior/
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2013 Tuft Entertainment
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "Hero.h"

@implementation Hero

@synthesize idleAnim;
@synthesize runningAnim;

-(id)initAtPosition:(CGPoint)position
{
    if ( self = [super initAtPosition:position forClassName:NSStringFromClass([self class])] )
    {
        [self initPhysics];
        [self initAnimations];
        [self setState:kStateIdle];
    }
    
    return self;
}

-(void)initPhysics
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    self.physicsBody.categoryBitMask = kHeroCategory;
    self.physicsBody.contactTestBitMask = kProjectileCategory;
    self.physicsBody.collisionBitMask = kProjectileCategory;
    
    self.physicsBody.dynamic = YES;
    self.physicsBody.density = 1.0f;
    self.physicsBody.friction = 8.0f;
    self.physicsBody.restitution = 0.0f;
}

- (void) initAnimations
{
    // Load the idle animation.
    [self setIdleAnim: [self animationWithName:@"idleAnim"]];
    
    
    // Load the running animation.
    [self setRunningAnim: [self animationWithName:@"walkingAnim"]];
}

- (void) changeState:(GameObjectState)newState
{
    if ( newState == self.state )
    {
        return;
    }
    
    [self removeAllActions];
    [self setState:newState];
    
    SKAction* action = nil;
    switch ( newState )
    {
        case kStateIdle:
            action = [SKAction repeatActionForever:idleAnim];
            break;
            
        case kStateRunningLeft:
            self.xScale = -1.0;
            action = [SKAction repeatActionForever:runningAnim];
            break;
            
        case kStateRunningRight:
            self.xScale = 1.0;
            action = [SKAction repeatActionForever:runningAnim];
            break;
            
        case kStateDead:
            // TODO show the splat frame or animation.
            break;
            
        default:
            NSLog(@"Unrecognised state %u for class %@", newState, [self class]);
            break;
    }
    
    if ( action != nil )
    {
        [self runAction:action];
    }
}

/**
- (void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    if(self.state == kStateDead) {
        return;
    }
    
    // Check for collisions
    // TODO reintegrate the HeroContactListener
    CGRect myBoundingBox = self.frame;
    for (GameObject *obj in listOfGameObjects) {
        // No need to check collision with one's self
        if ([obj tag] == kHeroTagValue) {
            continue;
        }
        
        CGRect characterBox = [obj adjustedBoundingBox];
        if (CGRectIntersectsRect(myBoundingBox, characterBox)) {
            if ([obj gameObjectCategory] == kTweetCategory) {
                [self changeState:kStateDead];
                return;
            }
        }
    }
    
    if(!self.physicsBody->IsAwake()) {
        // Not moving? Idle
        [self changeState:kStateIdle];
        
    } else {
        // If we're moving, ensure the state reflects which direction
        // (threshold the velocity to a sensible value)
        b2Vec2 velocity = self.physicsBody->GetLinearVelocity();
        if(velocity.x > 1.0f) {
            [self changeState:kStateRunningRight];
        } else if(velocity.x < -1.0f) {
            [self changeState:kStateRunningLeft];
        } else {
            [self changeState:kStateIdle];
        }
    }
}
 **/

-(void)handleAccelerometerData:(CMAccelerometerData*)data
{
    if ( ABS(self.physicsBody.velocity.dx) <= kHWMaxVelocity )
    {
        // Setup the force x & y.
        UIAccelerationValue forceX = data.acceleration.y * kHWForceMagnifier;
        UIAccelerationValue forceY = data.acceleration.x * kHWForceMagnifier;
        
        // Alter the force based on the devices orientation.
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ( orientation == UIInterfaceOrientationLandscapeLeft )
        {
            forceY = forceY * -1;
        }
        else if ( orientation == UIInterfaceOrientationLandscapeRight )
        {
            forceX = forceX * -1;
        }
        
        // Apply the force to our hero.
        [self.physicsBody applyImpulse:CGVectorMake(forceX, forceY)];
    }
}

@end
