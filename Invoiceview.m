

#import "Invoiceview.h"
#import "ViewItemsTableViewCell.h"
#import <sqlite3.h>
#import "Billitem.h"
#import "PDFRenderer.h"
#import "PDFViewController.h"
@interface Invoiceview()<UITextViewDelegate>
{
    sqlite3 *BillMakerDB;
    NSMutableArray *arrayofitem;
    int Count;
    NSMutableArray *selectedrow;
    NSMutableArray *selecteditemarray;
    NSMutableDictionary *dicSelectedItem;
    ViewItemsTableViewCell *cell;
    UIDatePicker *picker;
    NSInteger nextTag;

//    UIButton *plus;
//    UIButton *minus;
   
}
@end
@implementation Invoiceview
@synthesize tblItem,txtName,txtBillNo,txtDate,txtAddress;

#pragma viewdidLoad
-(void)viewDidLoad
{
    txtName.delegate = self;
    txtName.tag = 1;
    
    txtBillNo.delegate = self;
    txtBillNo.tag = 2;
    
    txtAddress.delegate = self;
    txtAddress.tag = 4;
    
//    txtDate.delegate = self;
//    txtDate.tag = 3;
    
    nextTag =0;
    
    cell.plus.hidden=YES;
    cell.minus.hidden=YES;
    cell.txtQtyvalue.hidden=YES;
    cell.lblqty.hidden=YES;
    [self.txtDate addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingDidBegin];
 
    tblItem.allowsMultipleSelection=YES;
    
     dicSelectedItem=[[NSMutableDictionary alloc]init];
    NSString * srcPath = [[NSBundle mainBundle] pathForResource:@"sample_0" ofType:@"pdf"];
    
    NSLog(@"src : %@", srcPath);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * destPath = [documentsDirectory stringByAppendingPathComponent:@"Old.pdf"];
    
    NSLog(@"dest : %@", destPath);
    
    NSError * error = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:destPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
        if(error)
        {
            NSLog(@"Error while removing file : %@", [error localizedDescription]);
        }
    }
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&error];
    
    if(error)
    {
        NSLog(@"Error while copying file : %@", [error localizedDescription]);
    }
    selecteditemarray=[[NSMutableArray alloc]init];
    selectedrow=[NSMutableArray array];
    tblItem.allowsMultipleSelection=YES;
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

    
}
#pragma mark - ----------------------------------TEXT FIELD-----------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     nextTag = textField.tag + 1;
    [self jumpToNextTextField:textField withTag:nextTag];
    
    return NO;
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


#pragma mark - ----------------------------------DATE PICKER------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSDate *dateSelected = [picker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        txtDate.text = [dateFormatter stringFromDate:dateSelected];
    }
}

-(void)textFieldDidChange
{
 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Date" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
    picker.datePickerMode = UIDatePickerModeDate;
    [alert addSubview:picker];
    alert.bounds = CGRectMake(0, 0, 320 + 20, alert.bounds.size.height + 216 + 20);
    [alert setValue:picker forKey:@"accessoryView"];
    
    [alert show];
  
}

#pragma mark - ----------------------------------TABLE VIEW SECTION------------------------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return arrayofitem.count;
    return arrayofitem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell=(ViewItemsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    Billitem *Billitemobj = [arrayofitem objectAtIndex:indexPath.row];
    cell.itemName.text=Billitemobj.name;

    cell.itemPrice.text=[NSString stringWithFormat:@"₹ %@",Billitemobj.price];
  
    if ([selectedrow containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.contentView.backgroundColor=[UIColor colorWithRed:(84/255.0) green:(153/255.0) blue:(199/255.0) alpha:1];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentView.backgroundColor=[UIColor whiteColor];
        cell.plus.hidden=YES;
        cell.minus.hidden=YES;
        cell.txtQtyvalue.hidden=YES;
        cell.lblqty.hidden=YES;
        
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tblItem reloadData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
 
    if ([selectedrow containsObject:indexPath])
    {
       
    
        cell.txtQtyvalue.text=@"1";
        [selectedrow removeObject:indexPath];
        [dicSelectedItem removeObjectForKey:indexPath];
          cell.plus.hidden=YES;
        cell.minus.hidden=YES;
        cell.txtQtyvalue.hidden=YES;
        cell.lblqty.hidden=YES;
           // minus.hidden=YES;
        
     //   [cell.contentView.superview removeFromSuperview];
    //    [minus.superview removeFromSuperview];
         [tableView reloadData];
        
    }
    else
    {
        Billitem *Billitemobj = [arrayofitem objectAtIndex:indexPath.row];
        [selectedrow addObject:indexPath];
        
        Billitem *selecteditem=[[Billitem alloc]init];
        selecteditem.ID=Billitemobj.ID;
        selecteditem.name=Billitemobj.name;
        selecteditem.price=Billitemobj.price;
        selecteditem.qty=cell.txtQtyvalue.text;
        
        
        cell.plus.hidden=NO;
        cell.minus.hidden=NO;
        cell.txtQtyvalue.hidden=NO;
        cell.lblqty.hidden=NO;
        //----------------
        
        
        
            [cell.plus addTarget:self action:@selector(stepperPlus:)  forControlEvents:UIControlEventTouchUpInside];
            cell.plus.backgroundColor=[UIColor clearColor];
            cell.plus.tag=indexPath.row;
        
     
        
        //------------------
        [cell.minus addTarget:self action:@selector(stepperMinus:)  forControlEvents:UIControlEventTouchUpInside];
        cell.minus.backgroundColor=[UIColor clearColor];
        cell.minus.tag=indexPath.row;
        
        
//            plus=[[UIButton alloc]initWithFrame:(CGRect){{300, 10}, 20, 20}];
//            [plus addTarget:self action:@selector(stepperPlus:)  forControlEvents:UIControlEventTouchUpInside];
//            plus.backgroundColor=[UIColor clearColor];
//            plus.tag=indexPath.row;
//            plus.titleLabel.text=@"-";
//            [plus setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:nil];
//        
//            [cell.contentView addSubview:plus];
        //----------------
       
        
        
        [dicSelectedItem setObject:selecteditem forKey:indexPath];
        
    
    }
    [tableView reloadData];
}

#pragma mark ----------------------------------PDF SECTION------------------------------------

- (IBAction)create:(id)sender {
    
    
    
    
    
    [[PDFRenderer getSharedInstance]saveData:txtName.text billno:txtBillNo.text address:txtAddress.text date:txtDate.text dic:dicSelectedItem];

    [self performSegueWithIdentifier:@"showPDF" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showPDF"])
    {
        UIButton * button = (UIButton *)sender;
        PDFViewController * vc = (PDFViewController *)segue.destinationViewController;
        
        vc.filePath = [self getPDFFilePath];
        NSLog(@"Create PDF");
        
        
    }
}

//-------------------
-(NSString*)getPDFFilePath
{
    NSString* fileName = @"New.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFilePath = [path stringByAppendingPathComponent:fileName];
    
    return pdfFilePath;
}

-(NSString*)getTemplatePDFFilePath
{
    NSString* fileName = @"Old.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFilePath = [path stringByAppendingPathComponent:fileName];
    
    return pdfFilePath;
}

#pragma mark----------------------------------STEPPER VALUE CHANGE------------------------------------
- (void)stepperPlus:(UIButton*)stepper
{
  
  
    ViewItemsTableViewCell *currentCell = [tblItem cellForRowAtIndexPath:[NSIndexPath indexPathForRow:stepper.tag inSection:0]];
    int value;

    value=[currentCell.txtQtyvalue.text integerValue];
    if(value<30)
    {
       value++;
    }
    currentCell.txtQtyvalue.text = [NSString stringWithFormat:@"%d",value];
   Billitem *selected=[[Billitem alloc]init];
     selected = [dicSelectedItem objectForKey:[NSIndexPath indexPathForRow:stepper.tag inSection:0]];
    Billitem *selecteditem=[[Billitem alloc]init];
    selecteditem.ID=selected.ID;
    selecteditem.name=selected.name;
    selecteditem.price=selected.price;
    selecteditem.qty=currentCell.txtQtyvalue.text;
    [dicSelectedItem setObject:selecteditem forKey:[NSIndexPath indexPathForRow:stepper.tag inSection:0]];

  
    
   
    
    [tblItem reloadData];
    
}
- (void)stepperMinus:(UIButton*)stepper
{
    ViewItemsTableViewCell *currentCell = [tblItem cellForRowAtIndexPath:[NSIndexPath indexPathForRow:stepper.tag inSection:0]];
    int value;
    value=[currentCell.txtQtyvalue.text integerValue];
    if(value>1)
    {
        value--;
    }
    currentCell.txtQtyvalue.text = [NSString stringWithFormat:@"%d",value];
    Billitem *selected=[[Billitem alloc]init];
    selected = [dicSelectedItem objectForKey:[NSIndexPath indexPathForRow:stepper.tag inSection:0]];
    Billitem *selecteditem=[[Billitem alloc]init];
    selecteditem.ID=selected.ID;
    selecteditem.name=selected.name;
    selecteditem.price=selected.price;
    selecteditem.qty=currentCell.txtQtyvalue.text;
    [dicSelectedItem setObject:selecteditem forKey:[NSIndexPath indexPathForRow:stepper.tag inSection:0]];
    
    [tblItem reloadData];
    

}

#pragma mark----------------------------------Button back------------------------------------
- (IBAction)backaction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
