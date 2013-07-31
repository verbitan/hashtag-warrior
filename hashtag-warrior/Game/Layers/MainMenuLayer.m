//
//  MainMenuLayer.m
//  hashtag-warrior
//
//  Created by Nick James on 20/01/2013.
//  Copyright 2013 Ossum Games. All rights reserved.
//

#import "MainMenuLayer.h"
#import "Constants.h"
#import "GameManager.h"


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
        [[GameManager sharedGameManager] runSceneWithID:kHWChooseHashtagScene];
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
