//
//  AddressBookDetailViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/14.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "AddressBookDetailViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface AddressBookDetailViewController ()

@end

@implementation AddressBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    ABRecordID recordId = self.recordIdAsNumber.intValue ;
    
    CFErrorRef error ;
    ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABRecordRef record = ABAddressBookGetPersonWithRecordID(addressbook, recordId) ;
    
    
    // 多值属性值
    ABMultiValueRef multiValue = ABRecordCopyValue(record, kABPersonEmailProperty) ;
    NSArray * emails = (__bridge_transfer id)ABMultiValueCopyArrayOfAllValues(multiValue) ;
    for (int i = 0; i < emails.count; i ++) {
        NSString * email = emails[i] ;
        NSString * emailLabel = (__bridge_transfer id)ABMultiValueCopyLabelAtIndex(multiValue, i) ;
        DDLog(@"%@,%@",emailLabel, email) ;
    }
    
    DDLog(@"%@",kABPersonPhoneMainLabel) ;
    CFRelease(addressbook) ;
}

@end
