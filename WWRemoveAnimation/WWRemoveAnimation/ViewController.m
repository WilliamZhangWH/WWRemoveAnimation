//
//  ViewController.m
//  WWRemoveAnimation
//
//  Created by 天奕 on 16/1/15.
//  Copyright © 2016年 Ti-link. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultCell.h"

@interface ViewController () <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *textViewBackgroundView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong) NSMutableArray *favoArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.resultTableView setBackgroundView:nil];
    [self.resultTableView setBackgroundColor:[UIColor clearColor]];
    self.resultArray = [NSMutableArray array];
    self.favoArray = [NSMutableArray array];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (![self.resultArray containsObject:textView.text] && ![textView.text isEqualToString:@""]) {
        [self.resultArray addObject:textView.text];
        [self.favoArray addObject:@(NO)];
        [self.resultTableView reloadData];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@" "]) {
        return NO;
    }
    
    if (![text isEqualToString:@""]) {
        self.placeholderLabel.hidden = YES;
    }

    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.placeholderLabel.hidden = NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cell";
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchResultCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.resultLabel.text = self.resultArray[indexPath.row];
    [cell setBtnSelected:[self.favoArray[indexPath.row] boolValue]];
    __weak ViewController *wself = self;
    cell.changeBtnStateBlock = ^(BOOL isFavo){
        [self.favoArray replaceObjectAtIndex:indexPath.row withObject:@(isFavo)];
    };
    
    cell.refreshDataBlock = ^(){
        
        /* 设置延迟时间为0.3秒 */
        double delayInSeconds = 0.3;
        /* 创建一个调度时间,相对于默认时钟或修改现有的调度时间 */
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            /* 更改数据源 刷新视图 */
            [wself.resultArray removeObjectAtIndex:indexPath.row];
            [wself.favoArray removeObjectAtIndex:indexPath.row];
            [UIView animateWithDuration:0.3 animations:^{
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } completion:^(BOOL finished) {
                [tableView reloadData];
            }];
            
        });
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
@end
