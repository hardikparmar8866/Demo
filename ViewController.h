

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnAddItem;
@property (strong, nonatomic) IBOutlet UIButton *btnViewItem;
@property (strong, nonatomic) IBOutlet UIButton *btnInvoice;
@property(nonatomic, strong)NSString *dbPathString;
@property(strong,nonatomic) NSString *datastr;
- (IBAction)addItem:(id)sender;
- (IBAction)invoice:(id)sender;

- (IBAction)viewItem:(id)sender;
@end

