//
//  TweetItem.h
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/29/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetMediaImage.h"
#import "TwitterUser.h"

@interface TweetItem : NSObject


@property (nonatomic, strong) NSString * Text;
@property (nonatomic, strong) TwitterUser * User;
@property (nonatomic, strong) TweetMediaImage *TweetImage;
@property (nonatomic, readonly) BOOL hasImage;
@property (nonatomic, strong) NSString * CreatedDate;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
+ (TweetItem *) ItemWithDictionary:(NSDictionary *)dic;


@end
