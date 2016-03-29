//
//  TweetMediaImage.h
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetMediaImage : NSObject


@property (nonatomic, strong) NSString * ImageURL;
@property (nonatomic, strong) NSString * LargeImageURL;
@property (nonatomic, strong) NSString * ThumbImageURL;



- (instancetype)initWithDictionary:(NSDictionary *)mediaItem;
- (instancetype)initWithFirstItemOnArray:(NSArray *) arr;
+ (TweetMediaImage *) ItemWithDictionary:(NSDictionary *)dic;
+ (TweetMediaImage *) ItemWithFirstItemOnArray:(NSArray *)arr;

- (BOOL) hasImage;
@end
