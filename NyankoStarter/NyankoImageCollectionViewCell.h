//
//  NyankoImageCollectionViewCell.h
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/07.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Nyanko;
@interface NyankoImageCollectionViewCell : UICollectionViewCell


@property (nonatomic) Nyanko *nyanko;

- (CGSize)fittingSizeWithWidth:(CGFloat)width;
+ (instancetype)view;

@end
