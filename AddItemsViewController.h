

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface AddItemsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) int recordIDToEdit;
@property (strong, nonatomic) IBOutlet UITextField *txtItemName;
@property (strong, nonatomic) IBOutlet UITextField *txtItemPrice;
- (IBAction)btnBack:(id)sender;
@property(nonatomic, strong)NSString *name;

@property(assign)int age;
@property(strong,nonatomic) NSString *datastr;
@property(strong,nonatomic) NSString *RecodeIdEdit;
@property (strong, nonatomic) IBOutlet UIButton *outSaveBtn;
@property (strong, nonatomic) IBOutlet UITableView *tblViewItems;
@property (strong, nonatomic) NSArray* letters;

@end
