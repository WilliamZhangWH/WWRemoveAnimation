//
//  SearchResultCell.h
//  WWRemoveAnimation
//
//  Created by 天奕 on 16/1/15.
//  Copyright © 2016年 Ti-link. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIButton *favoBtn;

@property (weak, nonatomic) IBOutlet UIView *resultBackgroundView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *edgeLines;

@property (nonatomic, copy) void (^refreshDataBlock)();

@property (nonatomic, copy) void (^changeBtnStateBlock)(BOOL isFavo);

- (IBAction)changeFavoState:(UIButton *)sender;

- (void)setBtnSelected:(BOOL)selected;

@end
