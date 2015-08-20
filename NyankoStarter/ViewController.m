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
@property (nonatomic) NSMutableArray *nyankos;
@property (nonatomic) NSString *nextUrl;

@property (nonatomic) NSMutableArray *filters;

@end

@interface ViewController (RLM)

@property (nonatomic) RLMNotificationToken *notification;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
//        self.notification = [RLMRealm.defaultRealm addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
//            NSLog(@"notification : %@", notification);
//            NSLog(@"realm : %@", realm);
//        }];
        _filters = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    APIRequest *request = [APIRequest new];
    request.url = @"";
    request.success = ^(NSDictionary *json) {
        self.nextUrl = [self nextUrlFromJson:json];
        self.nyankos = [NSMutableArray arrayWithArray:[Nyanko nyankosFromJson:json]];
        [self.collectionView reloadData];
    };
    request.fail = ^(NSError *error) {
        NSLog(@"error : %@",error);
    };
    [[API sharedInstance] request:request];
    
    [self setupNavigationBar];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NyankoImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellKey];
}

- (void)setupNavigationBar {
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    UIBarButtonItem *refine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(refine)];
    self.navigationItem.rightBarButtonItems = @[add,refine];
}

- (void)add {
    [self loadNext];
}

- (void)refine {
    RLMResults *results = [Nyanko allObjects];
    
    void(^addMessage)(NSString *) = ^void(NSString *message) {
        if (!_filters.count) {
            [_filters addObject:message];
            return;
        }
        
        for (NSString *filter in _filters) {
            if ([message isEqualToString:filter]) {
                return;
            }
        }
        [_filters addObject:message];
    };
    
    for (Nyanko *nyanko in results) {
        addMessage(nyanko.filter);
    }
    
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert.title = @"filter";
    
    for (NSString *message in _filters) {
        
        [alert addAction:[UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            RLMResults *results = [Nyanko objectsWhere:[NSString stringWithFormat:@"filter = '%@'", message]]; // How to convert RLMResutls -> RLMArray ??
            
            NSMutableArray *nyankos = [NSMutableArray array];
            
            for (Nyanko *nyanko in results) {
                [nyankos addObject:nyanko];
            }
            
            self.nyankos = [NSMutableArray arrayWithArray:nyankos];
            
            [self.collectionView reloadData];
        }]];
        
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"UIAlertActionStyleCancel");
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString*)nextUrlFromJson:(NSDictionary*)json {
    NSDictionary *dicPagination = json[@"pagination"];
    return dicPagination[@"next_url"];
}

- (void)loadNext {
    APIRequest *request = [APIRequest new];
    request.url = self.nextUrl;
    request.success = ^(NSDictionary *json) {
        self.nextUrl = [self nextUrlFromJson:json];
        [self.nyankos addObjectsFromArray:[Nyanko nyankosFromJson:json]];
        [self.collectionView reloadData];
    };
    request.fail = ^(NSError *error) {
        NSLog(@"error : %@",error);
    };
    [[API sharedInstance] request:request];
    
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
    NSURL *url = [NSURL URLWithString:nyanko.linkUrl];
    [[UIApplication sharedApplication] openURL:url];
}

@end
