//
//  TwitterUser.h
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TweetMediaImage;
@interface TwitterUser : NSObject


@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSString * ScreenName;
@property (nonatomic, strong) NSString * ProfileImageURL;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

+ (TwitterUser *) ItemWithDictionary:(NSDictionary *)dic;
@end
