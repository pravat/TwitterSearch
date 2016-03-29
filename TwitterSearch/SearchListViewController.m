//
//  SearchListViewController.m
//  TwitterSearch
//
//  Created by Pravat Maskey on 3/28/16.
//  Copyright © 2016 Pravat Maskey. All rights reserved.
//

#import "SearchListViewController.h"
#import <Accounts/Accounts.h>
#import "Settings.h"
#import "TweetCell.h"
#import "LoadMoreCell.h"
#import "TweetDetailsViewController.h"
#import "TweetItem.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage);
typedef enum : NSUInteger{
    TwitterStatusNotSignedIn = (1 << 0),
    TwitterStatusSignedIn = (1 << 1)
}TwitterStatus;

typedef enum : NSUInteger{
    TwitterWorkStatusRequesting = (1 << 0),
    TwitterWorkStatusDone = (1 << 1),
    TwitterWorkStatusDoneWithError = (1 << 2)
}TwitterWorkStatus;

@interface SearchListViewController (){
    TwitterStatus twitterStatus;
    TwitterWorkStatus twitterWorkStatus;
}


@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;
@property (nonatomic, strong) NSMutableArray *responseStatuses;
@property (nonatomic, strong) NSDictionary *responseSearchMetaData;
@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTwitterSettings];
    self.responseStatuses = [NSMutableArray array];
    //self.lblInfo.text = @"Please login";
    [self showStatusWithText:@"Please login" withAnimation:YES isShake:NO autoHide:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize
-(void) setupTwitterSettings{
    self.accountStore = [[ACAccountStore alloc] init];
    
}



- (void)chooseAccount {
    
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if(granted == NO) {
                _accountChooserBlock(nil, @"Acccess not granted.");
                return;
            }
            
            self.iOSAccounts = [_accountStore accountsWithAccountType:accountType];
            
            if([_iOSAccounts count] == 1) {
                ACAccount *account = [_iOSAccounts lastObject];
                _accountChooserBlock(account, nil);
            } else {
                if (_iOSAccounts.count > 0) {
                    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Select an account:"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Cancel"
                                                      destructiveButtonTitle:nil otherButtonTitles:nil];
                    for(ACAccount *account in _iOSAccounts) {
                        [as addButtonWithTitle:[NSString stringWithFormat:@"@%@", account.username]];
                    }
                    [as showInView:self.view.window];
                }
                else{;
                    _lblInfo.text = @"Open Setting and login on twitter.";
                    
                    UIAlertController *alert= [UIAlertController
                                               alertControllerWithTitle:@"Login Required"
                                               message:@"Need to login on twitter app, do you want to login?"
                                               preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                                                   
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
                                                               }];
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       
                                                                       NSLog(@"cancel btn");
                                                                       
                                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                                       
                                                                   }];
                    
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    
                    
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                }
                
            }
        }];
    };
    
#if TARGET_OS_IPHONE &&  (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                     withCompletionHandler:accountStoreRequestCompletionHandler];
    } else {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                                   options:NULL
                                                completion:accountStoreRequestCompletionHandler];
    }
#else
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:accountStoreRequestCompletionHandler];
#endif
    
}




- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    // in case the user has just authenticated through WebViewVC
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);

        
    } errorBlock:^(NSError *error) {
        
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == [actionSheet cancelButtonIndex]) {
        _accountChooserBlock(nil, @"Account selection was cancelled.");
        return;
    }
    
    NSUInteger accountIndex = buttonIndex - 1;
    ACAccount *account = [_iOSAccounts objectAtIndex:accountIndex];
    
    _accountChooserBlock(account, nil);
}

#pragma mark STTwitterAPIOSProtocol

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
    if(twitterAPI != _twitter) return;
    NSLog(@"-- account was invalidated: %@ | %@", invalidatedAccount, invalidatedAccount.username);
}
#pragma mark - Status
- (void) showInfoWithTitle:(NSString *)title info:(NSString *)info{
    
}

#pragma mark - LoginHandle
- (IBAction)loginLogout:(UIBarButtonItem *)sender {
    __weak typeof(self) weakSelf = self;
    
    self.accountChooserBlock = ^(ACAccount *account, NSString *errorMessage) {
        
        NSString *status = nil;
        if(account) {
            status = [NSString stringWithFormat:@"User : '%@' logged in. ", account.username];
            
            [weakSelf loginWithiOSAccount:account];
        } else {
            status = errorMessage;
        }
        [weakSelf showStatusWithText:status];
        //weakSelf.lblInfo.text = status;
    };
    [self chooseAccount];
}

- (void)loginWithiOSAccount:(ACAccount *)account {
    __weak typeof(self) weakSelf = self;
    self.twitter = nil;
    self.twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
    
    [_twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        weakSelf.btnBarLoginLogout.title = @"LoggedIn";
        weakSelf.btnBarLoginLogout.enabled = NO;
        
    } errorBlock:^(NSError *error) {
        weakSelf.btnBarLoginLogout.title = @"Login";
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = self.responseStatuses.count;
    if ([self hasMoreTweets]) {
        count++;
    }
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger index = indexPath.row;
    if (index < self.responseStatuses.count) {
        static NSString * CellIndentifierTweets = @"TweetCell";
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifierTweets forIndexPath:indexPath];
        NSDictionary *tweetItem = [self.responseStatuses objectAtIndex:index];
        TweetItem *item = [self.responseStatuses objectAtIndex:index];
        cell.lblTweet.text = item.Text;
    
        if (item.hasImage) {
            [cell.imgTweet sd_setImageWithURL:[NSURL URLWithString:item.TweetImage.ThumbImageURL] placeholderImage:[UIImage imageNamed:@"twitterPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            //we can create single instance for placeholder image by
            //dispatch_once(<#dispatch_once_t *predicate#>, <#^(void)block#>)
        }
        else{
            cell.constraintImageWidth.constant = 0.0f;
        }
        
        
        return cell;
    }
    else{
        static NSString * CellIndentifierLoadMoreCell = @"LoadMoreCell";
        LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifierLoadMoreCell];
        return cell;
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[LoadMoreCell class]]) {
        [self loadMore];
    }
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"SegueTweetDetails"]) {
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         TweetDetailsViewController *tweetDetailsViewController = segue.destinationViewController;
         tweetDetailsViewController.tweetItem = [self.responseStatuses objectAtIndex:path.row];
     }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


#pragma mark - ShowStatus

- (void) showStatusWithText:(NSString *)text withAnimation:(BOOL)withAnimation isShake:(BOOL) isShake autoHide:(BOOL)autohide{
    self.lblInfo.text = text;
    self.lblInfo.hidden = NO;
    void (^DoShake) (void) = ^{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.1];
        [animation setRepeatCount:3];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake(self.lblInfo.center.x - 5,self.lblInfo.center.y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake(self.lblInfo.center.x + 5, self.lblInfo.center.y)]];
        [self.lblInfo.layer addAnimation:animation forKey:@"position"];
    };
    if (withAnimation) {
        [UIView animateWithDuration:0.5 animations:^{
            self.constraintStatusHeight.constant = 40;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (isShake) {
                DoShake();
            }
            
        }];
    }
    else{
        self.constraintStatusHeight.constant = 40;
        if (isShake) {
            DoShake();
        }
    }
    
    if (autohide) {
        [self performSelector:@selector(hideStatus) withObject:nil afterDelay:2.0];
    }
}

- (void) showStatusWithText:(NSString *)text{
    [self showStatusWithText:text withAnimation:YES isShake:NO autoHide:YES];
}
- (void) hideStatus{
    [UIView animateWithDuration:0.5 animations:^{
        self.constraintStatusHeight.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.lblInfo.hidden = YES;
    }];
}
#pragma mark - TwitterUtilities
- (void) searchTweetWithText:(NSString *) query{
    //next_results
    if (!self.twitter || !self.twitter.userID) {
        [self showStatusWithText:@"Please login first." withAnimation:NO isShake:YES autoHide: NO];
        return;
    }
    assert(self.twitter);
    twitterWorkStatus = TwitterWorkStatusRequesting;
    [self showStatusWithText:@"Searching tweets" withAnimation:NO isShake:NO autoHide: NO];
    __weak typeof(self) weakSelf = self;
    NSString *searchQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.twitter getSearchTweetsWithQuery:searchQuery geocode:nil lang:nil locale:nil resultType:nil count:@"10" until:nil sinceID:nil maxID:nil includeEntities:nil callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
        weakSelf.responseStatuses = [NSMutableArray array];
        //[weakSelf.responseStatuses addObjectsFromArray:statuses];
        [statuses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TweetItem *tweetItem = [TweetItem ItemWithDictionary:obj];
            [weakSelf.responseStatuses addObject:tweetItem];
        }];
        weakSelf.responseSearchMetaData = searchMetadata;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView reloadData];
                if (weakSelf.responseStatuses.count == 0 && ((twitterWorkStatus & TwitterWorkStatusDone)|| (twitterWorkStatus &TwitterWorkStatusDoneWithError))) {
                    [self showStatusWithText:@"No Tweets found" withAnimation:YES isShake:YES autoHide:NO];
                }
                else{
                    [self showStatusWithText:@"Done" withAnimation:YES isShake:NO autoHide:YES];
                }
            });
        });
        twitterWorkStatus = TwitterWorkStatusDone;
    } errorBlock:^(NSError *error) {
        NSLog(@"Error : %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showStatusWithText:@"No Tweets found" withAnimation:YES isShake:YES autoHide:NO];
            [weakSelf.tableView reloadData];
        });
        twitterWorkStatus = TwitterWorkStatusDoneWithError;
    }];
}

- (BOOL) hasMoreTweets{
    BOOL retVal = false;
    NSDictionary * nextresults = [self.responseSearchMetaData objectForKey:@"next_results"];
    if (nextresults != nil) {
        retVal = YES;
    }
    return  retVal;
}

- (void) loadMore{
    __weak typeof(self) weakSelf = self;
    
    NSString * nextresults = [self.responseSearchMetaData objectForKey:@"next_results"];
    NSMutableDictionary *queryStrings = [[NSMutableDictionary alloc] init];
    for (NSString *qs in [nextresults componentsSeparatedByString:@"&"]) {
        // Get the parameter name
        NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
        // Get the parameter value
        NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        queryStrings[key] = value;
    }
    NSString *count = [queryStrings objectForKey:@"count"];
    NSString *max_id = [queryStrings objectForKey:@"max_id"];
    NSString *searchQuery = [queryStrings objectForKey:@"q"];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *include_entities = [f numberFromString:[queryStrings objectForKey:@"include_entities"]];
    [self showStatusWithText:@"Loading more" withAnimation:NO isShake:NO autoHide:NO];
    twitterWorkStatus = TwitterWorkStatusRequesting;
    [self.twitter getSearchTweetsWithQuery:searchQuery geocode:nil lang:nil locale:nil resultType:nil count:count until:nil sinceID:nil maxID:max_id includeEntities:include_entities  callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
        [weakSelf.responseStatuses addObjectsFromArray:statuses];
        [statuses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TweetItem *tweetItem = [TweetItem ItemWithDictionary:obj];
            [weakSelf.responseStatuses addObject:tweetItem];
        }];
        weakSelf.responseSearchMetaData = searchMetadata;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.responseStatuses.count == 0 && ((twitterWorkStatus & TwitterWorkStatusDone)|| (twitterWorkStatus &TwitterWorkStatusDoneWithError))) {
                [self showStatusWithText:@"No Tweets found" withAnimation:YES isShake:YES autoHide:NO];
            }
            else{
                [self showStatusWithText:@"Done" withAnimation:YES isShake:NO autoHide:YES];
            }
            [weakSelf.tableView reloadData];
            
        });
        twitterWorkStatus = TwitterWorkStatusDone;
    } errorBlock:^(NSError *error) {
        NSLog(@"Error : %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [self showStatusWithText:@"No Tweets found" withAnimation:YES isShake:YES autoHide:NO];
        });
        twitterWorkStatus = TwitterWorkStatusDoneWithError;
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    NSString *query = [NSString stringWithFormat:@"%@ filter:images" ,searchBar.text];
    [self searchTweetWithText:query];
    
}
@end
