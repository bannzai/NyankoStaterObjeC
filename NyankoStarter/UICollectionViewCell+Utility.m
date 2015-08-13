//
//  UICollectionViewCell+Utility.m
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/13.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import "UICollectionViewCell+Utility.h"

@implementation UICollectionViewCell (Utility)

+ (instancetype)view
{
    UINib* nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    id view = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    return view;
}


- (void)setWidthConstraint:(CGFloat)width {
    NSLayoutConstraint *widthConstraint = nil;
    for (NSLayoutConstraint *constraint in self.contentView.constraints) {
        if (constraint.firstItem == self.contentView && constraint.firstAttribute == NSLayoutAttributeWidth && constraint.relation == NSLayoutRelationEqual) {
            widthConstraint = constraint;
            break;
        }
    }
    if (!widthConstraint) {
        widthConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
        [self.contentView addConstraint:widthConstraint];
    }
    widthConstraint.constant = width;
}


- (CGSize)fittingSizeWithWidth:(CGFloat)width {
    [self setWidthConstraint:width];
    return [self fittingSize];
}

- (CGSize)fittingSize;
{
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end
