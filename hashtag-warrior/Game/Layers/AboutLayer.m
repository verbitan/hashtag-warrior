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
