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

#import "GameScene.h"

#import "AccelerometerSimulation.h"
#import "Constants.h"
#import "GameManager.h"

@implementation GameScene

-(id) initWithSize:(CGSize)size
{
    if ( self = [super initWithSize:size] )
    {       
        [self initWorldAndBackground];
        [self createHUD];
        [self createHero];
        [self createProjectile:CGPointMake(0.0, self.frame.size.height/2)];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"_state._score"];
}

-(void)initWorldAndBackground
{
    // Enable the accelerometer.
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager startAccelerometerUpdates];
    
    // Create the background image sprite node.
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    
    // Position it in the center of the frame.
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    // Add it to the scene.
    [self addChild:background];
    
    // Add the floor.
    self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero
                                                    toPoint:(CGPointMake(CGRectGetMaxX(self.frame), 0.0f))];
}

-(void)createHUD
{
    // Get an instance of the game state singleton.
    _state = [GameState sharedInstance];
    
    // Create and initialise a label for the hashtag.
    SKLabelNode* hashtag = [SKLabelNode labelNodeWithFontNamed:kHWTextBodyFamily];
    hashtag.name = kHWHUDHashtagName;
    hashtag.fontColor = kHWTextColor;
    hashtag.fontSize = kHWTextBodySize;
    hashtag.text = _state._hashtag;
    hashtag.position = CGPointMake(hashtag.frame.size.width, self.size.height - 20);
    
    // Create and initialise a label for the score.
    SKLabelNode* score = [SKLabelNode labelNodeWithFontNamed:kHWTextBodyFamily];
    score.name = kHWHUDScoreName;
    score.fontColor = kHWTextColor;
    score.fontSize = kHWTextBodySize;
    score.text = [NSString stringWithFormat:@"Score: %d", _state._score];
    score.position = CGPointMake(self.size.width - score.frame.size.width, self.size.height - 20);
    
    // Add the labels to the scene.
    [self addChild:hashtag];
    [self addChild:score];
    
    // Listen to updates on the score.
    [self addObserver:self
           forKeyPath:@"_state._score"
              options:NSKeyValueObservingOptionNew
              context:nil];
}

-(void)createHero
{
    // Create our hero.
    _hero = [[Hero alloc] initAtPosition:CGPointZero];
    CGPoint heroLocation = CGPointMake(self.frame.size.width/2, _hero.frame.size.height/2);
    _hero.position = heroLocation;
    
    NSLog(@"Adding new hero at %0.2f x %0.2f", heroLocation.x, heroLocation.y);
    
    // Add him to the scene.
    [self addChild:_hero];
    
    // Tie him down.
    [SKPhysicsJointSliding jointWithBodyA:self.physicsBody
                                    bodyB:_hero.physicsBody
                                   anchor:_hero.anchorPoint
                                     axis:CGVectorMake(1.0f, 0.0f)];
}

-(void)createProjectile:(CGPoint)position
{
    NSLog(@"Adding new projectile at %0.2f x %0.2f", position.x, position.y);
    
    // Create the projectile.
    _projectile = [[Projectile alloc] initAtPosition:position];
    
    // Add it to the scene.
    [self addChild:_projectile];
    
    // Fire!
    [_projectile.physicsBody applyImpulse:CGVectorMake(2.0f, 0.0f)];
    
    // Add some spin.
    [_projectile.physicsBody applyTorque:-0.01f];
}

-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ( [keyPath isEqual:@"_state._score"] )
    {
        SKLabelNode* score = (SKLabelNode*)[self childNodeWithName:kHWHUDScoreName];
        score.text = [NSString stringWithFormat:@"Score: %d", _state._score];
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    // Handle the device motion.
    [self processUserMotionForUpdate:currentTime];
    
    // Update the score randomly for now until we'ge got multiple balls and can score correctly.
    _state._score += arc4random() % 5;
}

-(void)processUserMotionForUpdate:(NSTimeInterval)currentTime
{
    // Retrieve the accelerometer data.
    CMAccelerometerData* data = self.motionManager.accelerometerData;
    
    // Tell the hero about this.
    [_hero handleAccelerometerData:data];
}

@end
