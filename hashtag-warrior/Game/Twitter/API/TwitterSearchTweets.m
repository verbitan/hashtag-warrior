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

#import "TwitterSearchTweets.h"

#import "Tweet.h"

@implementation TwitterSearchTweets

- (id)init
{
    if(![super init])
    {
        return nil;
    }
    
    // Default the search criteria to us!
    _searchCriteria = @"#Warrior";
    
    // Initialise the search results array.
    _searchResults = [[NSMutableArray alloc] init];
    
    // There are no results yet, mark as stale.
    _stale = true;
    
    return self;
}

-(NSURL*)getURL
{
    // The Twitter API URL for searching for Tweets with a specific criteria.
    // See https://dev.twitter.com/docs/api/1.1/get/search/tweets for more details.
    
    return [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
}

-(NSDictionary*)getParams
{
    // Params
    //
    // q           - A UTF-8, URL-encoded search query of 1,000 characters maximum, including operators.
    // required      Queries may additionally be limited by complexity.
    //
    // count       - The number of tweets to return per page, up to a maximum of 100. Defaults to 15.
    // optional      This was formerly the "rpp" parameter in the old Search API.
    //
    // result_type - Specifies what type of search results you would prefer to receive.
    // optional      The current default is "mixed." Valid values include:
    //                 * mixed: Include both popular and real time results in the response.
    //                 * recent: return only the most recent results in the response
    //                 * popular: return only the most popular results in the response.
    
    return @{@"q"           : _searchCriteria,
             @"count"       : @"100",
             @"result_type" : @"recent"};;
}

-(bool)parseResponse:(NSDictionary*)json;
{
    bool parseOk = FALSE;

    // Get the statuses.
    NSArray* statuses = json[@"statuses"];
    
    // Did we get any statuses?
    if ( statuses && [statuses count] > 0)
    {
        // Clear out any existing search results.
        [_searchResults removeAllObjects];
        
        // Now extract them all.
        for ( int i = 0; i < statuses.count; ++i )
        {
            // Create a Tweet object for each.
            Tweet *tweet = [[Tweet alloc] initWithTweet:statuses[i]];
            
            // Add it to the search results array.
            [_searchResults addObject:tweet];
        }
        
        // Mark as not stale.
        _stale = false;
        
        NSLog(@"Successfully downloaded %i tweets.", [_searchResults count]);
    }
    else
    {
        // We didnt. Log an error.
        NSLog(@"Statuses not found in response");
    }
    
    return parseOk;
}

-(void)setSearchCriteria:(NSString*)criteria
{
    _searchCriteria = criteria;
}

-(NSArray*)getSearchResults
{
    // The data bas been read, it's now stale.
    _stale = true;
    
    return _searchResults;
}

-(bool)isStale
{
    return _stale;
}

@end
