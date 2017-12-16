

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewItemsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (strong, nonatomic) IBOutlet UITableView *tblViewItems;
@property(strong,nonatomic) NSString *datastr;
@property (nonatomic) int recordIDToEdit;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *Backbarbtn;

@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
