//
//  CALayer+RuntimeAttribute.m
//  WWRemoveAnimation
//
//  Created by 天奕 on 16/1/15.
//  Copyright © 2016年 Ti-link. All rights reserved.
//

#import "CALayer+RuntimeAttribute.h"

@implementation CALayer (RuntimeAttribute)

-(void)setBorderIBColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderIBColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowIBColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(UIColor*)shadowIBColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}

@end
