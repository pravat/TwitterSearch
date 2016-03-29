//
//  TweetMediaImage.m
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import "TweetMediaImage.h"
@interface TweetMediaImage(){
    BOOL _hasImage;
}
@end
@implementation TweetMediaImage


- (instancetype)initWithDictionary:(NSDictionary *)mediaItem{
    self = [super init];
    if (self) {
        if (mediaItem != nil) {
            NSString *media_url_https = [mediaItem objectForKey:@"media_url_https"];
            if (media_url_https != nil) {
                self.ImageURL = media_url_https;
                _hasImage = YES;
                NSString *media_url_https_large = [NSString stringWithFormat:@"%@:large", media_url_https];
                NSString *media_url_https_thumb = [NSString stringWithFormat:@"%@:large", media_url_https];
                self.LargeImageURL = media_url_https_large;
                self.ThumbImageURL = media_url_https_thumb;
            }
            
        }
    }
    return self;
}

- (instancetype)initWithFirstItemOnArray:(NSArray *) arr
{
    self = [super init];
    if (self) {
        if (arr.count > 0) {
            NSDictionary *dic = [arr objectAtIndex:0];
            self = [[TweetMediaImage alloc] initWithDictionary:dic];
        }
    }
    return self;
}

+ (TweetMediaImage *) ItemWithDictionary:(NSDictionary *)dic{
    return [[TweetMediaImage alloc] initWithDictionary:dic];
}

+ (TweetMediaImage *) ItemWithFirstItemOnArray:(NSArray *)arr{
    return [[TweetMediaImage alloc] initWithFirstItemOnArray:arr];
}

- (BOOL) hasImage{
    return _hasImage;
}

@end
