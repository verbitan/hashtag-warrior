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

#import "GameObject.h"

#import "Utilities.h"

@implementation GameObject

@synthesize reactsToScreenBoundaries;
@synthesize state;

-(id)initAtPosition:(CGPoint)position forClassName:(NSString*)className
{
    // We don't have the initial image at this point so just construct a small white square.
    if ( self = [super initWithColor:[UIColor colorWithWhite:1.0f alpha:1.0f] size:CGSizeMake(1.0f, 1.0f)] )
    {
        // Go parse the configuration for the game object.
        [self readPlist:@"GameObject" forClassName:className];
        
        // Load the init animation.
        // Note: This doesn't resize straight away, only after the animation has run. So if there's a delay in the
        //       animation the initial size of the sprite will be reported as 1x1.
        [self loadInitAnimation];
        
        // To get around the above, set the size of the game object to the first frame in the init animation.
        self.size = _initFrame.size;
        
        // Update the position of the game object based on what we were told.
        self.position = position;
    }
    
    return self;
}

-(void)readPlist:(NSString*)plistName forClassName:(NSString*)className
{
    NSDictionary* cfg = nil;
    
    // Locate the plist within the app bundle.
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GameObject" ofType:@"plist"];
    
    // If we managed to find the plist...
    if ( plistPath != nil )
    {
        // ...extract the root dictionary.
        NSDictionary* rootCfg = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        // If we have the root config...
        if ( rootCfg != nil )
        {
            NSLog(@"Loading class named %@.", className);
        
            // ...try and extract the animations for this class.
            cfg = rootCfg[className];
        }
    }
    else
    {
        NSLog(@"Failed to find plist %@", plistName);
    }
    
    // If we found the plist go ahead and extract what we want.
    if ( cfg != nil )
    {
        _initCfg = cfg[@"init"];
        _animCfg = cfg[@"animations"];
    }
}
    
-(void)loadInitAnimation
{
    // If we loaded the init config...
    if ( _initCfg != nil )
    {
        // ...then load the init animation.
        NSString* initAnimationName = _initCfg[@"initAnimation"];
        
        // Run the animation.
        [self runAction:[SKAction repeatActionForever:[self animationWithName:initAnimationName]]];
    }
}

-(void)changeState:(GameObjectState)newState
{
    // Child classes should override this
}

//-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
//{
//    // Child classes should override this
//}

-(SKAction*)animationWithName:(NSString*)animationName
{
    // Animation to return.
    SKAction* retVal = nil;
    
    // Initialise the animation details.
    NSString* atlasName = nil;
    NSString* prefix = nil;
    NSMutableArray* frames = nil;
    float delay = 0.0;
        
    // If we have the class config...
    if ( _animCfg != nil )
    {
        // ...load all the details for the given animation.
        NSDictionary* animationDetails = _animCfg[animationName];
        
        if ( animationDetails != nil )
        {
            atlasName = animationDetails[@"atlasName"];
            prefix = animationDetails[@"filenamePrefix"];
            frames = animationDetails[@"animationFrames"];
            delay = [animationDetails[@"delay"] floatValue];
        }
    }

    // If we managed to extract the animation information from the plist, continue to create the animation, else log an
    // error.
    if ( atlasName != nil && prefix != nil && frames != nil && frames.count > 0 && delay > 0.0 )
    {
        // Initialise an array of textures.
        NSMutableArray* textures = [NSMutableArray array];
        
        // Go over every frame we extracted and add it to the animation.
        for ( NSString* frame in frames )
        {
            // Get the texture atlas.
            SKTextureAtlas* atlas = [Utilities initTextureAtlasNamed:atlasName];
            
            // Format up the image name.
            NSString* frameName = [NSString stringWithFormat:@"%@%@", prefix, frame];
            
            // Add the texture to the texture array.
            [textures addObject:[atlas textureNamed:frameName]];
            
            // For the first texture, store it so we can get the size. We only care about this once and it's stupid.
            // Once I realise what it is that I've done wrong, this can be removed.
            if ( _initFrame == nil )
            {
                _initFrame = textures[0];
            }
        }
        
        // Create the animation and assign it to the return value.
        retVal = [SKAction animateWithTextures:textures timePerFrame:delay resize:YES restore:NO];
    }
    else
    {
        // Log an error.
        NSLog(@"Failed to load the animation %@.", animationName);
    }
    
    return retVal;
}

@end