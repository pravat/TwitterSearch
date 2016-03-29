//
//  TwitterUser.m
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import "TwitterUser.h"
#import "TweetMediaImage.h"
@implementation TwitterUser



- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.Name = [dic objectForKey:@"name" ];
        self.ScreenName = [dic objectForKey:@"screen_name"];
        NSDictionary *tweetEntities = [dic objectForKey:@"entities"];
        
        NSString *profile_image_url_https = [dic objectForKey:@"profile_image_url_https"];
        self.ProfileImageURL = profile_image_url_https;
    }
    return self;
}

+ (TwitterUser *) ItemWithDictionary:(NSDictionary *)dic{
    return [[TwitterUser alloc] initWithDictionary:dic];
}
@end
