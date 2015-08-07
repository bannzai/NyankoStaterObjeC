//
//  ViewController.m
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/06.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import "ViewController.h"
#import "API.h"

#import "Nyanko.h"
#import "NyankoImageCollectionViewCell.h"

NSString *const cellKey = @"NyankoCell";

@interface ViewController ()

@property (nonatomic) NSArray *nyankos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    APIRequest *request = [APIRequest new];
    request.url = @"";
    request.success = ^(NSDictionary *json) {
        self.nyankos = [Nyanko nyankosFromJson:json];
        [self.collectionView reloadData];
    };
    request.fail = ^(NSError *error) {
        NSLog(@"error : %@",error);
    };
    [[API sharedInstance] request:request];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NyankoImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (Nyanko*)nyankoAtIndexPath:(NSIndexPath*)indexPath {
    return self.nyankos[indexPath.item];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nyankos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NyankoImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellKey forIndexPath:indexPath];
    cell.nyanko = [self nyankoAtIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)layout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    static CGSize size;
    
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        return size;
    }
    
    NyankoImageCollectionViewCell *cell = [NyankoImageCollectionViewCell view];
    NSUInteger column = 3;
    CGFloat width = CGRectGetWidth(collectionView.bounds) / column - (column - 1);
    size = [cell fittingSizeWithWidth:width];
    size = CGSizeMake(floor(size.width), floor(size.height));
    return size;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Nyanko *nyanko = [self nyankoAtIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:nyanko.image.url];
    [[UIApplication sharedApplication] openURL:url];
}

@end
