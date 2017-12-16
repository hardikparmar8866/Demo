

#import "ViewController.h"
#import "AddItemsViewController.h"
#import "ViewItemsViewController.h"
#import "Invoiceview.h"
@interface ViewController ()
{
    sqlite3 *BillMakerDB;
}

@end

@implementation ViewController
@synthesize dbPathString;
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createOrOpenDB];
    
    self.navigationController.navigationBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addItem:(id)sender {

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddItemsViewController *controller = (AddItemsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"AddItemsViewController"];
    controller.datastr=dbPathString;
    controller.recordIDToEdit=-1;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)invoice:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    Invoiceview *controller = (Invoiceview *)[mainStoryboard instantiateViewControllerWithIdentifier: @"Invoiceview"];
    controller.datastr=dbPathString;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)viewItem:(id)sender {

     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewItemsViewController *controller = (ViewItemsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"ViewItemsViewController"];
    controller.datastr=dbPathString;
    [self.navigationController pushViewController:controller animated:YES];

}
#pragma database create
- (void)createOrOpenDB
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"BillMaker1.db"];
    ViewItemsViewController *nextview=[ViewItemsViewController alloc];
    nextview.datastr=dbPathString;
    
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        //creat db here
        if (sqlite3_open(dbPath, &BillMakerDB)==SQLITE_OK) {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS ITEM1 (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PRICE TEXT)";
            sqlite3_exec(BillMakerDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(BillMakerDB);
        }
        
    }
}
@end
