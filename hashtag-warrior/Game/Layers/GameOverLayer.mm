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
        [self addScore];
        [self addMenu];
    }
    return self;
}

- (void) addTitle
{
    CCLabelBMFont *title = [CCLabelBMFont labelWithString:NSLocalizedString(@"Game Over!", nil)
                                                  fntFile:kHWTextHeadingFamily];
    title.color = kHWTextColor;
    title.position = ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.5)+100);
    [self addChild: title];
}

- (void) addScore
{
    // Show score
    NSString *youScored;
    if ( [[GameState sharedInstance] _practice] ) {
        youScored = [NSString stringWithFormat:NSLocalizedString(@"You scored practice", nil), [GameState sharedInstance]._score];
        
    } else {
        youScored = [NSString stringWithFormat:NSLocalizedString(@"You scored", nil), [GameState sharedInstance]._score, [GameState sharedInstance]._hashtag];
    }
    
    CCLabelTTF *score = [CCLabelTTF labelWithString:youScored
                                           fontName:kHWTextHeadingFamily
                                           fontSize:24];

    score.color = kHWTextColor;
    score.position = ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.5));
    [self addChild: score];
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
    CCMenu *menu = [CCMenu menuWithItems:playAgain, mainMenu, nil];
    
    // Only add the share button if not in practice mode.
    if(![[GameState sharedInstance] _practice]) {
        [menu addChild: share];
    }
    
    // Align everything horizontally with a bit of padding.
    [menu alignItemsHorizontallyWithPadding:25.0f];
    
    // Place it in the middle of the screen.
    [menu setPosition:ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.5)-50)];
    
    // Add to the layer.
    [self addChild: menu];
}

@end
