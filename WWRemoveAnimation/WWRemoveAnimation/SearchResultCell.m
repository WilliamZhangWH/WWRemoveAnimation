//
//  SearchResultCell.m
//  WWRemoveAnimation
//
//  Created by 天奕 on 16/1/15.
//  Copyright © 2016年 Ti-link. All rights reserved.
//

#import "SearchResultCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface SearchResultCell () {
    BOOL editable;
}

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation SearchResultCell

- (void)awakeFromNib {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panToRemove:)];
    self.panGesture = pan;
    pan.maximumNumberOfTouches = 1;
    pan.minimumNumberOfTouches = 1;
    [self.resultBackgroundView addGestureRecognizer:pan];
    
}

- (void)panToRemove:(UIPanGestureRecognizer*)recognizer {
    /* 开始移动隐藏分割线 */
    for (UILabel *edgeLine in self.edgeLines) {
        edgeLine.hidden = YES;
    }
    
    self.resultBackgroundView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y);
    [recognizer setTranslation:CGPointZero inView:self];
    
    CGAffineTransform transform = self.resultBackgroundView.transform;
    if (translation.x > 0) {/* 向右移动 */
        if ((recognizer.view.center.x < WIDTH*3/10 && transform.b < 0) || recognizer.view.center.x > WIDTH*7/10) {
            transform = CGAffineTransformRotate(transform, M_PI/(3*WIDTH));
        }else{
            self.resultBackgroundView.transform=CGAffineTransformIdentity;
            return;
        }
    }else if (translation.x < 0) {/* 向左移动 */
        if ((recognizer.view.center.x > WIDTH*7/10 && transform.b > 0) || recognizer.view.center.x < WIDTH*3/10) {
            transform = CGAffineTransformRotate(transform, -M_PI/(3*WIDTH));
        }else{
            self.resultBackgroundView.transform=CGAffineTransformIdentity;
            return;
        }
    }
    
    self.resultBackgroundView.transform = transform;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {

        if (recognizer.view.center.x < 0) {
            [UIView animateWithDuration:0.6 animations:^{
                recognizer.view.center = CGPointMake(recognizer.view.center.x - WIDTH/2, recognizer.view.center.y);
                
            } completion:nil];
            self.resultBackgroundView.transform = CGAffineTransformRotate(transform, -M_PI/(2*WIDTH));
            if (self.refreshDataBlock) {
                self.refreshDataBlock();
            }
        }else if (recognizer.view.center.x > WIDTH) {
            self.resultBackgroundView.transform=CGAffineTransformIdentity;
            [UIView animateWithDuration:0.6 animations:^{
                recognizer.view.center = CGPointMake(recognizer.view.center.x + WIDTH/2, recognizer.view.center.y);
            } completion:nil];
            self.resultBackgroundView.transform = CGAffineTransformRotate(transform, M_PI/(2*WIDTH));
            if (self.refreshDataBlock) {
                self.refreshDataBlock();
            }
        }else{
            [UIView animateWithDuration:0.6 animations:^{
                recognizer.view.center = CGPointMake(WIDTH/2, recognizer.view.center.y);
                self.resultBackgroundView.transform=CGAffineTransformIdentity;
                
                for (UILabel *edgeLine in self.edgeLines) {
                    edgeLine.hidden = NO;
                }
                self.resultBackgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
            } completion:nil];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBtnSelected:(BOOL)selected {
    self.favoBtn.selected = selected;
    if (selected) {
        self.panGesture.enabled = NO;
    }
}

- (IBAction)changeFavoState:(UIButton *)sender {
    sender.selected = !sender.selected;
    editable = !sender.selected;
    self.panGesture.enabled = editable;
    if (self.changeBtnStateBlock) {
        self.changeBtnStateBlock(!editable);
    }
}


@end
