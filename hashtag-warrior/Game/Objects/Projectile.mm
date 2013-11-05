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

#import "Projectile.h"

@implementation Projectile

-(id)initAtPosition:(CGPoint)position
{
    if ( self = [super initAtPosition:position forClassName:NSStringFromClass([self class])] )
    {
        [self initPhysics];
    }
    
    return self;
}

-(void)initPhysics
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.frame.size.width/2];
    
    self.physicsBody.categoryBitMask = kProjectileCategory;
    self.physicsBody.contactTestBitMask = kHeroCategory;
    self.physicsBody.collisionBitMask = kHeroCategory;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    
    self.physicsBody.dynamic = YES;
    self.physicsBody.density = 0.5f;
    self.physicsBody.friction = 0.001f;
    self.physicsBody.restitution = 1.0f;
    
    self.physicsBody.linearDamping = 0.0f;
    self.physicsBody.angularDamping = 1.0f;
}

@end
