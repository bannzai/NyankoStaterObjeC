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
@property (nonatomic) BOOL loading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NyankoImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellKey];
    [self load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (Nyanko*)nyankoAtIndexPath:(NSIndexPath*)indexPath {
    return self.nyankos[indexPath.item];
}

- (BOOL)loadIfPossible {
    if (self.loading) {
        return NO;
    }
    [self load];
}

- (void)load {
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
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.dragging) {
        return;
    }
    
    [self callScrollLowerSoonIfNeeded:scrollView];
}

#pragma mark - ScrollView Helper

- (void)callScrollLowerSoonIfNeeded:(UIScrollView*)scrollView {
    
}

- (BOOL)scrollLowerSoon {
    
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nyankos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NyankoImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellKey forIndexPath:indexPath];
    cell.nyanko = [self nyankoAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionView Delegate
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
    NSURL *url = [NSURL URLWithString:nyanko.linkUrl];
    [[UIApplication sharedApplication] openURL:url];
}

@end
