//
//  PastRemindersViewController.h
//  Reminder
//
//  Created by Roberto on 3/26/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastRemindersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *currentUser;

@end
