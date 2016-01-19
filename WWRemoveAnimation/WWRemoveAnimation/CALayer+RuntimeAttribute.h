//
//  CALayer+RuntimeAttribute.h
//  WWRemoveAnimation
//
//  Created by 天奕 on 16/1/15.
//  Copyright © 2016年 Ti-link. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (RuntimeAttribute)

@property(nonatomic, assign) UIColor* borderIBColor;
@property(nonatomic, assign) UIColor* shadowIBColor;

@end
