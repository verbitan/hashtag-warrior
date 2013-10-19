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

#import "SplashScene.h"

#import "MainMenuScene.h"
#import "Utilities.h"

@implementation SplashScene

-(id) initWithSize:(CGSize)size {
    if ( self = [super initWithSize:size] ) {
        
        // Initialise contentCreated to NO.
        self.contentCreated = NO;
        
        // Set the background colour.
        self.backgroundColor = [SKColor blackColor];
        
        // Create the background image sprite node.
        SKTextureAtlas* backgroundAtlas = [Utilities initTextureAtlasNamed:@"Splash"];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[backgroundAtlas textureNamed:@"Splash"]];
        
        // Position it in the center of the frame.
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        // Add it to the scene.
        [self addChild:background];
    }
    
    return self;
}

- (void)didMoveToView: (SKView*) view {
    if ( !self.contentCreated ) {
        self.contentCreated = YES;
        
        SKTextureAtlas* background = [Utilities initTextureAtlasNamed:@"Background"];

        NSArray* textureAtlases = [NSArray arrayWithObjects:background, nil];
        
        [SKTextureAtlas preloadTextureAtlases:textureAtlases
                        withCompletionHandler:^(void)
        {
            NSLog(@"Preloaded textures successfully.");
            
            // TODO: Load main menu scene. Need to convert to SpriteKit first.
            //SKScene* mainMenuScene = [[MainMenuScene alloc] initWithSize:self.size];
            //SKTransition* transition = [SKTransition fadeWithDuration:0.5];
            
            //[self.view presentScene:mainMenuScene transition:transition];
        }];
    }
}

@end
