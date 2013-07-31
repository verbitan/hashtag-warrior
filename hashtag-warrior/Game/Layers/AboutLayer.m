//
//  AboutLayer.m
//  hashtag-warrior
//
//  Created by Daniel Wood on 20/01/2013.
//  Copyright (c) 2013 Ossum Games. All rights reserved.
//

#import "AboutLayer.h"
#import "Constants.h"
#import "GameManager.h"

@implementation AboutLayer

- (id)init
{
    if ((self=[super init]))
    {
        // Window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Add labels
        CCLabelBMFont *title = [CCLabelBMFont labelWithString:@"#Warrior"
                                                      fntFile:kHWTextHeadingFamily];
        title.color = kHWTextColor;
        title.position = ccp(PCT_FROM_LEFT(0.5), PCT_FROM_TOP(0.15));
        
        int posY = size.height-140;
        CCLabelBMFont *blurb = [CCLabelBMFont labelWithString:NSLocalizedString(@"About Blurb", nil)
                                                     fntFile:kHWTextBodyFamily];
        blurb.position = ccp(size.width/2, posY);
        blurb.color = kHWTextColor;
        posY -= 80;
        
        CCLabelBMFont *credits = [CCLabelBMFont labelWithString:NSLocalizedString(@"About Credits", nil)
                                                       fntFile:kHWTextBodyFamily];
        credits.position = ccp(size.width/2, posY);
        credits.color = kHWTextColor;
        
        [self addChild: title];
        [self addChild: blurb];
        [self addChild: credits];
        
        // Add return to menu... menu
        CCLabelBMFont *homeText = [CCLabelBMFont labelWithString:NSLocalizedString(@"Main Menu", nil)
                                                         fntFile:kHWTextSmallMenuFamily];
        homeText.color = kHWTextColor;
        CCMenuItemLabel *home = [CCMenuItemFont itemWithLabel:homeText
                                                        block:^(id sender)
        {
            [[GameManager sharedGameManager] runSceneWithID:kHWMainMenuScene];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:home, nil];
        [menu alignItemsVertically];
        [menu setPosition:ccp(size.width/2, 20)];
        
        [self addChild: menu];
    }
    return self;
}

@end
