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

@property (nonatomic) Nyankos *nyankos;
@property (nonatomic) BOOL loading;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.nyankos = [Nyankos new];
        self.nyankos.nextUrl = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NyankoImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellKey];
    [self load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (Nyanko*)nyankoAtIndexPath:(NSIndexPath*)indexPath {
    return self.nyankos.array[indexPath.item];
}

- (BOOL)loadNext {
    if (self.loading) {
        return NO;
    }
    [self load];
    return YES;
}

- (void)load {
    APIRequest *request = [APIRequest new];
    request.url = self.nyankos.nextUrl;
    request.success = ^(NSDictionary *json) {
        [self.nyankos addListFromJson:json];
        [self.collectionView reloadData];
        self.loading = NO;
    };
    request.fail = ^(NSError *error) {
        NSLog(@"error : %@",error);
        self.loading = NO;
    };
    [[API sharedInstance] request:request];
    
    self.loading = YES;
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
    float offsetBottomY = scrollView.contentOffset.y + scrollView.bounds.size.height;
    float contentSizeHeight = MAX(scrollView.contentSize.height, scrollView.frame.size.height - scrollView.contentInset.top);
    
    float soonThrethould = contentSizeHeight / 3 < 2000 ? contentSizeHeight / 3 : 2000;
    
    static BOOL isLowerSoon;
    
    if (contentSizeHeight - soonThrethould < offsetBottomY) {
        if (!isLowerSoon) {
            [self scrollLowerSoon];
            isLowerSoon = YES;
        }
    }
    
    if (contentSizeHeight <= offsetBottomY) {
        isLowerSoon = NO;
    }
}

- (BOOL)scrollLowerSoon {
    return [self loadNext];
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nyankos.array.count;
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
