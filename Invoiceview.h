

#import <UIKit/UIKit.h>


@interface Invoiceview : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
    NSIndexPath *__selectedPath;
}
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtBillNo;
- (IBAction)backaction:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (strong, nonatomic) IBOutlet UITableView *tblItem;
@property(strong,nonatomic) NSString *datastr;
- (IBAction)create:(id)sender;
-(NSString*)getPDFFilePath;
-(NSString*)getTemplatePDFFilePath;

@property (strong,nonatomic) NSMutableSet *selectStates;
@end
