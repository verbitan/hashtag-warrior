//
//  GameOverLayer.m
//  hashtag-warrior
//
//  Created by Nick James on 18/01/2013.
//  Copyright 2013 Ossum Games. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameManager.h"
#import "GameState.h"
#import "Constants.h"

@implementation GameOverLayer

- (id)init
{
    if ((self=[super init]))
    {
        [self addTitle];
        [self addMenu];
    }
    return self;
}

- (void) addTitle
{
    CCLabelBMFont *title = [CCLabelBMFont labelWithString:NSLocalizedString(@"Game Over!", nil)
                                                  fntFile:kHWTextHeadingFamily];
    title.color = kHWTextColor;
    title.position = ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.15));
    [self addChild: title];
}

- (void) addMenu
{
    // Play again menu item.
    CCLabelBMFont *playAgainText = [CCLabelBMFont labelWithString:NSLocalizedString(@"Play again", nil)
                                                          fntFile:kHWTextSmallMenuFamily];
    playAgainText.color = kHWTextColor;
    CCMenuItemLabel *playAgain = [CCMenuItemFont itemWithLabel:playAgainText
                                                         block:^(id sender)
    {
        [[GameManager sharedGameManager] runSceneWithID:kHWGameScene];
    }];
    
    // Main menu menu item.
    CCLabelBMFont *mainMenuText = [CCLabelBMFont labelWithString:NSLocalizedString(@"Main menu", nil)
                                                        fntFile:kHWTextSmallMenuFamily];
    mainMenuText.color = kHWTextColor;
    CCMenuItemLabel *mainMenu = [CCMenuItemFont itemWithLabel:mainMenuText
                                                        block:^(id sender)
    {
        [[GameManager sharedGameManager] runSceneWithID:kHWMainMenuScene];
    }];
    
    // Share with Twitter menu item.
    CCLabelBMFont *shareText = [CCLabelBMFont labelWithString:NSLocalizedString(@"Share", nil)
                                                         fntFile:kHWTextSmallMenuFamily];
    shareText.color = kHWTextColor;
    CCMenuItemLabel *share = [CCMenuItemFont itemWithLabel:shareText
                                                     block:^(id sender)
    {
        // First check if we are able to send a Tweet.
        if ( [TWTweetComposeViewController canSendTweet] )
        {
            // We are! Now create the Tweet Sheet.
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            
            // Set the initial text.
            NSString *tweetText = [NSString stringWithFormat:NSLocalizedString(@"Glory Tweet", nil),
                                      [GameState sharedInstance]._score, [GameState sharedInstance]._hashtag];
            [tweetSheet setInitialText:tweetText];
            
            // Attach our URL.
            NSURL *url = [[NSURL alloc] initWithString:NSLocalizedString(@"URL", nil)];
            [tweetSheet addURL:url];
            
            // Popup the Tweet Sheet for Tweeting with.
            [[CCDirector sharedDirector] presentModalViewController:tweetSheet animated:YES];
        }
        else
        {
            // Alert the user to our inability to Tweet anything.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tweetastrophe", nil)
                                                                message:NSLocalizedString(@"No Twitter", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
    // Create the actual menu.
    CCMenu *menu = [CCMenu menuWithItems:playAgain, mainMenu, share, nil];
    
    // Align everything horizontally.
    [menu alignItemsHorizontally];
    
    // Place it in the middle of the screen.
    [menu setPosition:ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.5))];
    
    // Add to the layer.
    [self addChild: menu];
}

@end
