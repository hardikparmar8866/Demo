

#import "ViewItemsViewController.h"
#import "Billitem.h"
#import "AddItemsViewController.h"

#import "ViewItemsTableViewCell.h"
@interface ViewItemsViewController ()
{
    sqlite3 *BillMakerDB;
    NSMutableArray *arrayofitem;
}

@end

@implementation ViewItemsViewController
@synthesize tblViewItems;


- (void)viewDidLoad {
    [super viewDidLoad];
  
   
}
- (IBAction)barbtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private method implementation
-(void)viewWillAppear:(BOOL)animated
{
    arrayofitem = [[NSMutableArray alloc]init];
    NSLog(@"%@",self.datastr);
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([_datastr UTF8String], &BillMakerDB)==SQLITE_OK) {
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
    [tblViewItems reloadData];
    

}


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayofitem.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static ViewItemsTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     Billitem *Billitemobj = [arrayofitem objectAtIndex:indexPath.row];
    cell.itemName.text=Billitemobj.name;
    cell.itemPrice.text=[NSString stringWithFormat:@"₹ %@",Billitemobj.price];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Billitem *p = [arrayofitem objectAtIndex:indexPath.row];
        [self deleteData:[NSString stringWithFormat:@"Delete from ITEM1 where ID is '%s'", [p.ID UTF8String]]];
        [arrayofitem removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Perform the segue.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddItemsViewController *controller = (AddItemsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"AddItemsViewController"];
    Billitem *Billitemobj = [arrayofitem objectAtIndex:indexPath.row];
    
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






@end
