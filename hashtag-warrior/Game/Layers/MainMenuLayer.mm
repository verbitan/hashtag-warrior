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

#import "MainMenuLayer.h"
#import "Constants.h"
#import "GameManager.h"
#import "GameState.h"


@implementation MainMenuLayer

- (id)init
{
    if ((self=[super init]))
    {
        [self addTitle];
        [self addMainMenu];
        [self addTestTweetStream];
    }
    return self;
}

- (void) addTitle
{
    CCLabelBMFont *title = [CCLabelBMFont labelWithString:@"#Warrior"
                                                  fntFile:kHWTextHeadingFamily];
    title.color = kHWTextColor;
    title.position = ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.15));
    [self addChild: title];
}

- (void) addMainMenu
{   
    // New game menu item.
    CCLabelBMFont *newGameText = [CCLabelBMFont labelWithString:NSLocalizedString(@"New Game", nil)
                                                        fntFile:kHWTextBigMenuFamily];
    newGameText.color = kHWTextColor;
    CCMenuItemLabel *newGameMenuItem = [CCMenuItemFont itemWithLabel:newGameText
                                                               block:^(id sender)
    {
        if([[GameState sharedInstance] _practice]) {
            [[GameManager sharedGameManager] runSceneWithID:kHWGameScene];
        } else {
            [[GameManager sharedGameManager] runSceneWithID:kHWChooseHashtagScene];
        }
    }];

    // About menu item.
    CCLabelBMFont *aboutText = [CCLabelBMFont labelWithString:NSLocalizedString(@"About", nil)
                                                      fntFile:kHWTextBigMenuFamily];
    aboutText.color = kHWTextColor;
    CCMenuItemLabel *aboutMenuItem = [CCMenuItemFont itemWithLabel:aboutText
                                                             block:^(id aboutSender)
    {
        [[GameManager sharedGameManager] runSceneWithID:kHWAboutScene];
    }];
    
    // Create the main menu.
    CCMenu *menu = [CCMenu menuWithItems:newGameMenuItem, aboutMenuItem, nil];
    
    // Align everything vertically.
    [menu alignItemsVertically];
    
    // Place it in the middle of the screen.
    [menu setPosition:ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.5))];
    
    // Add to the layer.
    [self addChild: menu];
}

- (void)addTestTweetStream
{
    // Initialise the tweet emitter.
    _tweetEmitter = [[TweetEmitter alloc] initWithDelegate:self];
    
    // Start the tweet stream.
    [_tweetEmitter startTweetStream:@"#Warrior"];
    
    // Make a label.
    _tweet = [CCLabelBMFont labelWithString:@"#Warrior"
                                    fntFile:kHWTextBodyFamily
                                      width:[[CCDirector sharedDirector] winSize].width
                                  alignment:kCCTextAlignmentCenter];
    _tweet.color = kHWTextColor;
    
    // Add the label to the layer.
    _tweet.position = ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.95));
    [self addChild: _tweet];
}

- (void)newTweet:(Tweet*)tweet
{
    [_tweet setString:[tweet getTweetText]];
}

@end
