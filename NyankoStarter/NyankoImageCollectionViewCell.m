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



@end
