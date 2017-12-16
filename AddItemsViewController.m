

#import "AddItemsViewController.h"
#import "ViewItemsViewController.h"
#import "Billitem.h"
#import "ViewItemsTableViewCell.h"

#import "ViewController.h"
@interface AddItemsViewController ()
{

     NSMutableArray *arrayofitem;
    sqlite3 *BillMakerDB;
    int recod;
    BOOL test;
    BOOL checkempty;
    NSMutableDictionary *filteredTableData;
   
    }

@end

@implementation AddItemsViewController
@synthesize txtItemName,txtItemPrice,name,age,datastr,outSaveBtn,letters;
- (void)Tabledata
{
    arrayofitem = [[NSMutableArray alloc]init];
    NSLog(@"%@",self.datastr);
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([datastr UTF8String], &BillMakerDB)==SQLITE_OK) {
        [arrayofitem removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM ITEM1"];
        const char* query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(BillMakerDB, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *ID = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *price = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                Billitem *Billitem1 = [[Billitem alloc]init];
                [Billitem1 setID:ID];
                [Billitem1 setName:name];
                [Billitem1 setPrice:price];
                
                [arrayofitem addObject:Billitem1];
            }
        }
    }
    [self.tblViewItems reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.recordIDToEdit == -1)
    {
        
    }
    else
    {
        _tblViewItems.hidden=YES;
    }
    [self Tabledata];
    [self viewDidLoad];
  
}
- (void)jumpToNextTextField:(UITextField *)textField withTag:(NSInteger)tag
{
    
    UIResponder *nextResponder = [self.view viewWithTag:tag];
    
    if ([nextResponder isKindOfClass:[UITextField class]]) {
        
        [nextResponder becomeFirstResponder];
    }
    else {
        
        [textField resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    [self jumpToNextTextField:textField withTag:nextTag];
    
    return NO;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self Tabledata];

    
    txtItemName.delegate = self;
    txtItemName.tag = 1;
    
    txtItemPrice.delegate = self;
    txtItemPrice.tag = 2;
    NSLog(@"%@",datastr);
    NSLog(@"%d",self.recordIDToEdit);
    recod=self.recordIDToEdit;
    if(_recordIDToEdit== -1)
    {
    }
    else
    {
        _tblViewItems.userInteractionEnabled=NO;
        [outSaveBtn setTitle:@"Update Item" forState:nil];
        sqlite3_stmt *statement;
        if (sqlite3_open([datastr UTF8String], &BillMakerDB)==SQLITE_OK) {
            NSString *querySql = [NSString stringWithFormat:@"SELECT NAME,PRICE FROM ITEM1 WHERE ID=%d",recod];
            const char* query_sql = [querySql UTF8String];
            if (sqlite3_prepare(BillMakerDB, query_sql, -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    NSString *price = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                    txtItemName.text=name;
                    txtItemPrice.text=price;
                }
            }
        }
    }
      [self updateTableData:@""];
    [_tblViewItems reloadData];
}

#pragma mark - IBAction method implementation

- (IBAction)saveInfo:(id)sender
{
    test=NO;
    checkempty=NO;
    char *error;
    if (sqlite3_open([datastr UTF8String], &BillMakerDB)==SQLITE_OK)
    {
            Billitem *billitem=[[Billitem alloc]init];
            NSMutableArray *namee =[[NSMutableArray alloc]init];
            int i;
            for (i=0; i<[arrayofitem count]; i++)
        {
                Billitem *Billitemobj = [arrayofitem objectAtIndex:i];
                NSLog(@" name ==%@",Billitemobj.name);
               [namee addObject:Billitemobj.name];
        }
        if ([txtItemPrice.text isEqualToString:@""] && [txtItemName.text isEqualToString:@""]) {
            checkempty=YES;
            test=YES;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty Field "                                                                                 message:@"Plase Enter Item Name And Price"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            //You can use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            if ([txtItemPrice.text isEqualToString:@""] ) {
                checkempty=YES;
                test=YES;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty Field "
                  message:@"Price Is Empty" preferredStyle:UIAlertControllerStyleAlert];
                //We add buttons to the alert controller by creating UIAlertActions:
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil]; //You can use a block here to handle a press on this button
                [alertController addAction:actionOk];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            }
            else if ([txtItemName.text isEqualToString:@""])
            {
                checkempty=YES;
                test=YES;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty Field "
                                                                                         message:@"Iteam Name Is Empty"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                //We add buttons to the alert controller by creating UIAlertActions:
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil]; //You can use a block here to handle a press on this button
                [alertController addAction:actionOk];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }
       
        
                for (NSString* stringFromArray in namee)
        {
            
            if ([txtItemName.text isEqualToString:stringFromArray])
            {
                if (self.recordIDToEdit == -1)
                {
                    
                        NSLog(@"sam name = %@",stringFromArray);
                        test=YES;
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Already Exists "
                                                                                         message:@"Item Already Exists In Table "
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                        //We add buttons to the alert controller by creating UIAlertActions:
                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil]; //You can use a block here to handle a press on this button
                        [alertController addAction:actionOk];
                        [self presentViewController:alertController animated:YES completion:nil];
                    
                        break;
                }
            }
            else
            {
                
               
             
            }
        }
        NSString *inserStmt;
        if(self.recordIDToEdit == -1)
        {
            if(test==NO)
            {
                if (checkempty==NO) {
                    
                    inserStmt = [NSString stringWithFormat:@"INSERT INTO ITEM1(NAME,PRICE) values ('%s', '%s')",[txtItemName.text UTF8String], [txtItemPrice.text UTF8String]];
                }
            
        
            }
            if(0<[arrayofitem count])
            {
                if(test==NO)
                {
                    if (checkempty==NO) {
                        {
                inserStmt = [NSString stringWithFormat:@"INSERT INTO ITEM1(NAME,PRICE) values ('%s', '%s')",[txtItemName.text UTF8String], [txtItemPrice.text UTF8String]];
                        }
                    
                        
                    }
                }
        }
        }
        else
        {
            inserStmt = [NSString stringWithFormat:@"UPDATE ITEM1 SET NAME='%s',PRICE='%s' WHERE ID=%d",[txtItemName.text UTF8String], [txtItemPrice.text UTF8String],recod];
        }
            
            
        //    -------------------------
        
        const char *insert_stmt = [inserStmt UTF8String];
        
        if (sqlite3_exec(BillMakerDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            if(_recordIDToEdit == -1)
            {
                NSLog(@"Item Added");
              
                
            }
            else
            {
                NSLog(@"Item Update");
                 [self.navigationController popViewControllerAnimated:YES];

            }
         }
    }
    
     [self viewDidLoad];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return letters.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key=[letters objectAtIndex:section];
    return key;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *letter = [letters objectAtIndex:section];
    NSArray *arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    return arrayForLetter.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    static ViewItemsTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    Billitem *food = (Billitem*)[arrayForLetter objectAtIndex:indexPath.row];
    cell.itemName.text=food.name;
    cell.itemPrice.text=food.price;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //----
        NSString* letter = [letters objectAtIndex:indexPath.section];
        NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
        Billitem *food = (Billitem*)[arrayForLetter objectAtIndex:indexPath.row];
        //------
        
        
        [self deleteData:[NSString stringWithFormat:@"Delete from ITEM1 where ID is '%s'", [food.ID UTF8String]]];
        
        
        [self viewDidLoad];
       
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    
    // Perform the segue.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddItemsViewController *controller = (AddItemsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"AddItemsViewController"];
    //Billitem *Billitemobj = [arrayofitem objectAtIndex:indexPath.row];
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    Billitem *Billitemobj = (Billitem*)[arrayForLetter objectAtIndex:indexPath.row];
    
    
    controller.datastr=self.datastr;
    controller.recordIDToEdit=[Billitemobj.ID intValue];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    
}



-(void)deleteData:(NSString *)deleteQuery
{
    char *error;
    
    if (sqlite3_exec(BillMakerDB, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK) {
        NSLog(@"ITEM deleted");
    }
}


- (IBAction)btnBack:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ----------------------------------Update Table data------------------------------------

-(void)updateTableData:(NSString*)searchString
{
    filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (Billitem *food in arrayofitem)
    {
        bool isMatch = false;
        if(searchString.length == 0)
        {
            // If our search string is empty, everything is a match
            isMatch = true;
        }
        else
        {
            // If we have a search string, check to see if it matches the food's name or description
            NSRange nameRange = [food.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
                isMatch = true;
        }
       // If we have a match...
        if(isMatch)
        {
            NSString* firstLetter = [food.name substringToIndex:1];
            BOOL isUpperCase = [firstLetter isEqualToString:[firstLetter uppercaseString]];
            if (isUpperCase==NO) {
                NSLog(@"%@",firstLetter);
                firstLetter=[firstLetter uppercaseString];
            }// Check to see if we already have an array for this group
            NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
            if(arrayForLetter == nil)
            {
                // If we don't, create one, and add it to our dictionary
                arrayForLetter = [[NSMutableArray alloc] init];
                [filteredTableData setValue:arrayForLetter forKey:firstLetter];
            }
            // Finally, add the food to this group's array
            [arrayForLetter addObject:food];
        }
    }
    // Make a copy of our dictionary's keys, and sort them
    letters = [[filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@end
