//
//  PastRemindersViewController.m
//  Reminder
//
//  Created by Roberto on 3/26/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import "PastRemindersViewController.h"

#import "ReminderAppDelegate.h"

#import "EditReminderViewController.h"
#import "PersistAndFetchReminderData.h"
#import "Reminder.h"

@interface PastRemindersViewController ()
{
    NSMutableArray *remindersArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PastRemindersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    ReminderAppDelegate *appDelegate = (ReminderAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.currentUser = [appDelegate currentUser];  //etc.
    
    PersistAndFetchReminderData *fetchReminders = [[PersistAndFetchReminderData alloc]init];
    remindersArray = (NSMutableArray*)[fetchReminders fetchReminders:_currentUser];
    
    remindersArray =[self pastReminders:remindersArray];
}

-(void)viewWillAppear:(BOOL)animated{
    PersistAndFetchReminderData *fetchReminders = [[PersistAndFetchReminderData alloc]init];
    remindersArray = (NSMutableArray*)[fetchReminders fetchReminders:_currentUser];
    
    remindersArray =[self pastReminders:remindersArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"editPastReminder"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        EditReminderViewController *editReminderVC = segue.destinationViewController;
        //        AddReminderTableViewController *addReminderTVC = (AddReminderTableViewController *)[navigationController.viewControllers objectAtIndex:0];
        editReminderVC.selectedReminder = [remindersArray objectAtIndex:indexPath.row];
        
        //        addReminderTVC.delegate =self ;
        
    }
}


#pragma mark - TableViewDataSource Protocole
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [remindersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ReminderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Reminder *reminder = [remindersArray objectAtIndex:indexPath.row];
    cell.textLabel.text = reminder.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, y, h:mm a"];
    //    NSLog(@"Todays date is %@",[formatter stringFromDate:[reminder startDate]]);
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Start:%@  End:%@",[formatter stringFromDate:[reminder startDate]], [formatter stringFromDate:[reminder endDate]]];
    //    NSLog(@"ObjectID:%@",[reminder.objectID description]);
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PersistAndFetchReminderData *fetchReminders = [[PersistAndFetchReminderData alloc]init];
    Reminder *reminderToDelete= [[Reminder alloc] init];
    reminderToDelete = [remindersArray objectAtIndex:indexPath.row];
    [fetchReminders deleteReminder:[reminderToDelete objectID]];
    [remindersArray removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reminder *selectedReminder = [[Reminder alloc]init];
    selectedReminder = [remindersArray objectAtIndex:indexPath.row];
    
}

-(NSMutableArray *) pastReminders:(NSMutableArray *) reminders
{
    NSMutableArray *pastReminderArray = [[NSMutableArray alloc]init];
    
    NSDate *today = [NSDate date];
    //    NSDate *compareDate = [NSDate dateWithString:@"your date"];
    //
    //    NSComparisonResult compareResult = [today compare : compareDate];
    //
    //    if (compareResult == NSOrderedAscending)
    //    {
    //        NSLog(@"CompareDate is in the future");
    //    }
    //    else if (compareResult == NSOrderedDescending)
    //    {
    //        NSLog(@"CompareDate is in the past");
    //    }
    
    for (int i = 0; i < [reminders count]; i++) {
        Reminder *tempReminder = [[Reminder alloc]init];
        tempReminder = [reminders objectAtIndex:i];
        NSComparisonResult compareResult = [today compare : tempReminder.startDate];
        if (compareResult == NSOrderedDescending) {
            //            NSLog(@"REminder:%@",tempReminder.title);
            [pastReminderArray addObject:tempReminder];
        }
        
        
    }
    
    return pastReminderArray;
}

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end
