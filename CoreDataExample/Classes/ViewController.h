//
//  ViewController.h
//  CoreDataExample
//
//  Created by Maitrayee Ghosh on 18/09/15.
//  Copyright (c) 2015 Maitrayee Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController<UIAlertViewDelegate>
{
    NSMutableArray *tableDataArray;
    NSManagedObject *selectedDataObject;
}

- (IBAction)didTapInsertBtn:(id)sender;
- (IBAction)didTapDeleteDataBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong) NSManagedObject *device;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

