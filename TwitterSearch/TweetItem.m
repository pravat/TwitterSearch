//
//  TweetItem.m
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import "TweetItem.h"
#import "TwitterUser.h"
#import "TweetMediaImage.h"
@interface TweetItem(){
    BOOL _hasImage;
}
@end

@implementation TweetItem


- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.Text = [dic objectForKey:@"text"];
        
        NSString *createdDateStr =  [dic objectForKey:@"created_at"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE MMM d HH:mm:ss Z y"];
        NSDate *date = [dateFormatter dateFromString:createdDateStr];
        
        [dateFormatter setDateFormat:@"d/m/y, HH:MM"];
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        
        self.CreatedDate = [dateFormatter stringFromDate:date];
        
        NSDictionary *tweetEntities = [dic objectForKey:@"entities"];
        NSArray *media = [tweetEntities objectForKey:@"media"];
        
        if (media != nil) {
            NSDictionary *mediaItem = [media objectAtIndex:0];
            if (mediaItem != nil) {
                NSString *media_url_https = [mediaItem objectForKey:@"media_url_https"];
                if (media_url_https != nil) {
                    _hasImage = YES;
                    self.TweetImage = [TweetMediaImage ItemWithDictionary:mediaItem];
                }
            }
        }
        
        NSDictionary *user = [dic objectForKey:@"user"];
        self.User = [TwitterUser ItemWithDictionary:user];
        
    }
    return self;
}

+ (TweetItem *) ItemWithDictionary:(NSDictionary *)dic{
    return [[TweetItem alloc] initWithDictionary:dic];
}

- (BOOL) hasImage{
    return _hasImage;
}

@end
