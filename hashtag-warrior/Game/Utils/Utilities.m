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

#import "Utilities.h"

@implementation Utilities

+ (SKTextureAtlas*)initTextureAtlasNamed:(NSString*)fileName
{
    if ( IS_IPHONE )
    {
        if ( IS_IPHONE_5 )
        {
            // iPhone Retina 4-inch
            fileName = [NSString stringWithFormat:@"%@-568h", fileName];
        }
        else
        {
            // iPhone Retina 3.5-inch
            fileName = fileName;
        }
        
    }
    else
    {
        // iPad
        fileName = [NSString stringWithFormat:@"%@-ipad", fileName];
    }
    
    NSLog(@"File named %@", fileName);
    
    SKTextureAtlas* textureAtlas = [SKTextureAtlas atlasNamed:fileName];
    
    return textureAtlas;
}

@end
