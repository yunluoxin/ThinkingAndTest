//
//  AddressBookDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/14.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "AddressBookDemoViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "AddressBookDetailViewController.h"
@interface AddressBookDemoViewController () < UISearchBarDelegate, UISearchDisplayDelegate>
/**
 *  <#note#>
 */
@property (nonatomic, strong)NSArray * contacts ;

- (void)fillterContentForSearchText:(NSString *)searchText ;

@end

@implementation AddressBookDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"通讯录" ;
    
    
    // add pull to refresh component
    [self addRefreshComponent] ;
    
    [self setupSearchBar] ;
    
    // request to authorized to access address book
    [self p_requestAddressBookAccess] ;
    
    

}

- (void)addRefreshComponent
{
    UIRefreshControl * refreshControl = [[UIRefreshControl alloc]init] ;
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"] ;
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
    self.refreshControl = refreshControl ;
}

- (void)setupSearchBar
{
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.dd_width, 44)] ;
    searchBar.delegate = self ;
    self.tableView.tableHeaderView = searchBar ;
}

- (void)p_requestAddressBookAccess
{
    CFErrorRef error = NULL ;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error) ;
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (!error && granted) {
            DDLog(@"agree to see contacts") ;
            [self fillterContentForSearchText:@""] ;
        }
    });
    CFRelease(addressBook) ;
}

- (void)p_changeActivityindicatorView
{
    if (self.navigationItem.titleView) {
//        [(UIActivityIndicatorView *) [self.navigationItem titleView] stopAnimating] ;
//        self.navigationItem.prompt = nil ;
        
        self.navigationItem.titleView = nil ;
    }else{
        UIActivityIndicatorView * view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
        self.navigationItem.titleView = view ;
        
        ////
        ////   UIActivityIndicatorView 必须调用 startAnimating!! 否则无法显示。。。坑！！！！！
        ////
        [view startAnimating] ;
        
//        self.navigationItem.prompt = @"数据加载中..." ;
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier" ;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    
    ABRecordRef record = (__bridge CFTypeRef)self.contacts[indexPath.row] ;
    
    NSString * firstName = (__bridge_transfer id)ABRecordCopyValue(record, kABPersonFirstNameProperty) ;
    
    NSString * lastName = (__bridge_transfer id)ABRecordCopyValue(record, kABPersonLastNameProperty) ;
    
    lastName = lastName?:@"" ;
    
    NSString * suffix = (__bridge_transfer id)ABRecordCopyValue(record, kABPersonSuffixProperty) ;
    suffix = suffix?:@"" ;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",firstName, lastName, suffix] ;
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABRecordRef record =(__bridge CFTypeRef)self.contacts[indexPath.row] ;
    
    ABRecordID recordId = ABRecordGetRecordID(record) ;
    
    AddressBookDetailViewController *vc = [AddressBookDetailViewController new] ;
    vc.recordIdAsNumber = @(recordId) ;
    [self.navigationController pushViewController:vc animated:YES] ;
}

#pragma mark - UISearchBarDelegate 协议方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder] ;
    
    [self fillterContentForSearchText:@""] ;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self fillterContentForSearchText:searchString] ;
    
    // 返回YES的情况下，表视图可以重新加载
    return YES ;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES ;
    
    return YES ;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO ;
}

- (void)fillterContentForSearchText:(NSString *)searchText
{
    // if no permission, exit.
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return ;
    }
    
    CFErrorRef error = NULL ;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error) ;
                                             
    if (!searchText || searchText.length == 0) {
        // search all
        self.contacts = (__bridge_transfer id)ABAddressBookCopyArrayOfAllPeople(addressBook) ;
    }else{
        // condition search
        self.contacts = (__bridge_transfer id)ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)searchText) ;
    }
    
    [self.tableView reloadData] ;
    CFRelease(addressBook) ;
}


#pragma mark - private

- (void)refresh:(UIControl *)control
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中..."] ;
        
        [self p_changeActivityindicatorView] ;
        
        
        // simulate to request from network
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.refreshControl endRefreshing] ;

            self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"] ;
            
            [self p_changeActivityindicatorView] ;
            
            [self.tableView reloadData] ;
        });
    }

    
}
@end
