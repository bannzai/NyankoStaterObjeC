//
//  NyankoImageCollectionViewCell.m
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/07.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import "NyankoImageCollectionViewCell.h"

#import "Nyanko.h"
#import "ImageLoader.h"

@interface NyankoImageCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NyankoImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setNyanko:(Nyanko *)nyanko {
    _nyanko = nyanko;
   
    [self configureImageView];
    
}

- (void)configureImageView {
    [[ImageLoader sharedInstance] loadImage:self.nyanko.image.url completionBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];
}


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
