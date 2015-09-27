//
//  ViewController.m
//  CoreDataExample
//
//  Created by Maitrayee Ghosh on 18/09/15.
//  Copyright (c) 2015 Maitrayee Ghosh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableDataArray=[[NSMutableArray alloc]init];
    [self FetchDataFromDataBase];
}

-(void)FetchDataFromDataBase
{
    [tableDataArray removeAllObjects];
    AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedObjectContext=[appDel managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DataBasket"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray  *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"no object");
    }
    else
    {
        for(NSManagedObject* currentObj in fetchedObjects) {
            [tableDataArray addObject:currentObj];
        }}
    [_mTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /****************** Insert Data **********************/
    if (alertView.tag==111) {
        if (buttonIndex==1) {
            UITextField *nameTextField = [alertView textFieldAtIndex:0];
            UITextField *cityTextField = [alertView textFieldAtIndex:1];
            [self insertDataIntoDataBaseWithName:nameTextField.text WithCity:cityTextField.text];
        }
    }
    /****************** Update Data **********************/
    if (alertView.tag==222) {
        if (buttonIndex==1) {
            UITextField *nameTextField = [alertView textFieldAtIndex:0];
            UITextField *cityTextField = [alertView textFieldAtIndex:1];
            [self updateDataInDataBase:nameTextField.text WithCity:cityTextField.text];
        }
    }
    
}

#pragma mark - Insert Data

- (IBAction)didTapInsertBtn:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Core Data" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Save", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:0].placeholder = @"Enter Name";
    [alert textFieldAtIndex:1].placeholder = @"Enter City";
    [alert textFieldAtIndex:1].secureTextEntry=NO;
    alert.tag=111;
    [alert show];

}

-(void)insertDataIntoDataBaseWithName:(NSString *)name WithCity:(NSString *)city
{
    AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedObjectContext = [appDel managedObjectContext];
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"DataBasket" inManagedObjectContext:_managedObjectContext];
    [newDevice setValue:name forKey:@"name"];
    [newDevice setValue:city forKey:@"city"];
    NSError *error = nil;
    if ([_managedObjectContext save:&error]) {
        NSLog(@"data saved");
        [tableDataArray addObject:newDevice];
        [_mTableView reloadData];
    }
    else{
        NSLog(@"Error occured while saving");
    }
    
}

#pragma mark - Update Data

-(void)updateDataInDataBase:(NSString *)name WithCity:(NSString *)city
{
    AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedObjectContext = [appDel managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DataBasket" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    [selectedDataObject setValue:name forKey:@"name"];
    [selectedDataObject setValue:city forKey:@"city"];
    NSLog(@"object edited");
    
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Error editing  - error:%@",error);
    }
    [_mTableView reloadData];
}

#pragma mark - Delete Data

- (IBAction)didTapDeleteDataBtn:(id)sender {
    
    [_mTableView setEditing:YES animated:YES];
}

#pragma mark - UITableView Delegate and DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableDataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    NSManagedObject *obj=[tableDataArray objectAtIndex:indexPath.row ];
    cell.textLabel.text=[obj valueForKey:@"name"];
    cell.detailTextLabel.text=[obj valueForKey:@"city"];
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *obj=[tableDataArray objectAtIndex:indexPath.row ];
    selectedDataObject=obj;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Core Data" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Save", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:0].placeholder = @"Enter Name";
    [alert textFieldAtIndex:1].placeholder = @"Enter City";
    [alert textFieldAtIndex:1].secureTextEntry=NO;
    [alert textFieldAtIndex:0].text=[obj valueForKey:@"name"];
    [alert textFieldAtIndex:1].text=[obj valueForKey:@"city"];
    alert.tag=222;
    [alert show];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [appDel managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Basket" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        [_managedObjectContext deleteObject:[tableDataArray objectAtIndex:indexPath.row]];
        
        NSLog(@"object deleted");
        
        if (![_managedObjectContext save:&error])
        {
            NSLog(@"Error deleting  - error:%@",error);
        }

        [tableDataArray removeObjectAtIndex:indexPath.row];
        [_mTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_mTableView setEditing:NO animated:YES];
    }
    
}



@end
