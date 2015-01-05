//
//  AddItemViewController.m
//  CheckLists
//
//  Created by CY on 14/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "CheckListItem.h"

@interface ItemDetailViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;

@end

@implementation ItemDetailViewController{
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.txtNewItem setDelegate:self];
    
    if (self.itemToEdit != nil) {
        self.title = @"Edit Item";
        self.txtNewItem.text = self.itemToEdit.text;
        self.btnDone.enabled = YES;
        
        self.switchControl.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
    }
    else{
        self.switchControl.on = NO;
        _dueDate = [NSDate date];
    }
    
    [self updateDueDateLabel];
}

-(void)updateDueDateLabel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [dateFormatter stringFromDate:_dueDate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//当⽤户触碰某⼀行的时候,表视图会向代理发送⼀条willSelectRowAtIndexPath消息:“代理你好,我现在要选中某⼀行了。”通过返回⼀个nil,代理对此的答复是:“不好意思,恐怕你没有这个权限这么做!”
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这样就可以当用户触碰日期行的时候有响应
    if (indexPath.section == 1 && indexPath.row == 1) {
        return indexPath;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //检查当前是否存在日期选择器所在⾏对应的index-path
    if (indexPath.section == 1 && indexPath.row == 2) {
        UITableViewCell *cell = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DatePickeCell"];
        
        //询问表视图它是否已经有了⽇日期选择器的cell。如果没有就创建⼀一个新的。
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            //selection style(选择样式)是none,因为我们不希望在⽤户触碰它的时候显⽰一个已选中的状态
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //创建一个新的UIDatePicker控件。将其tag值设置为100,以便后续使⽤
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 216.0)];
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];
            
            //告诉⽇期选择器,每当用户更改了⽇期的时候调用dateChanged:方法。此前我们已经知道如果从 Interface Builder关联动作方法了。⽽这里则演示了如何从代码中关联动作⽅法。UIDatePicker的 Value Changed⽅法将会触发dateChanged⽅法
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            
        }
        return cell;
    }
    else{
        //对于任何⾮⽇期选择器cell对应的index-paths,直接调用super(也就是表视图控制器)。这样之前的static cell不会受到任何影响
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(void)dateChanged:(UIDatePicker*)datePicker
{
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果⽇期选择器可⻅见,就说明当前的section1有3⾏
    if (section == 1 && _datePickerVisible) {
        return 3;
    }
    else{
        //反之我们只需要调用super,利⽤初始数据源获取相关信息
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

//通过 heightForRowAtIndexPath⽅方法,我们可以为每个cell指定不同的⾼高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        //到目前为⽌,表视图中的cell⾼度是相同的44points;UIDatePicker控件的高是216points,再加上1point的分割线,所以总共占了217points
        return 217.0;
    }
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

//当选择某行后执行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中行的背景灰色
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //移除textField控件焦点，以便隐藏键盘
    [self.txtNewItem resignFirstResponder];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (!_datePickerVisible) {
            [self showDatePicker];
        }
        else{
            [self hideDatePicker];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

//viewWillAppear⽅法是iOS所提供的视图控制器⽅法,其作用是当界面跳转到当前界面但还没用显示出其中的内容时执⾏一些任务。通过给textField对象发送⼀个becomeFirstResponsder消息,我们通知它“成为当前的控制焦点”。在iOS术语中,当前的控件成为first responder(第一响应者)。
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.txtNewItem becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.txtNewItem == textField) {
        self.btnDone.enabled = newStr.length > 0;
    }
    
    return YES;
}

- (IBAction)cancelClick:(id)sender {
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate itemDetailViewControllerDidCancel:self];
}
- (IBAction)doneClick:(id)sender {
    
//    NSLog(@"You type new item is: %@",self.txtNewItem.text);
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.itemToEdit == nil) {
        CheckListItem *item = [[CheckListItem alloc] init];
        item.text = self.txtNewItem.text;
        item.checked = NO;
        
        item.shouldRemind = self.switchControl.on;
        item.dueDate = _dueDate;
        
        [item scheduleNotification];
        
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    }
    else{
        self.itemToEdit.text = self.txtNewItem.text;
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.dueDate = _dueDate;
        
        [self.itemToEdit scheduleNotification];
        
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
}

-(void)showDatePicker
{
    _datePickerVisible = YES;
    
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    
    //加了 begin｜end 后两种动画会同时执行
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];//Fade效果是淡出
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];//这里不能设置任何效果，不然这行会执行动画效果后就不见了
    
    [self.tableView endUpdates];
    
    //获取UIDatePicker所在的cell
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*)[datePickerCell viewWithTag:100];
    [datePicker setDate:_dueDate animated:NO];
}
-(void)hideDatePicker
{
    if (_datePickerVisible) {
        _datePickerVisible = NO;
        
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
    }
}
//开始编辑文本的时候隐藏日历控件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hideDatePicker];
}
@end
