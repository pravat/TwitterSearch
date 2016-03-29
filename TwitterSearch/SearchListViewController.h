//
//  SearchListViewController.h
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/28/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitter.h"
@interface SearchListViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, STTwitterAPIOSProtocol>

@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBarLoginLogout;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintStatusHeight;

- (IBAction)loginLogout:(UIBarButtonItem *)sender;


- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;
@end
