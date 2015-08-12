//
//  ListModel.m
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/12.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import "ListModel.h"

@interface ListModel()

@property (nonatomic, readwrite) NSUInteger pageNumber;

@end

@implementation ListModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
        self.pageNumber = 1;
        self.nextUrl = @"";
    }
    return self;
}

- (void)addListFromJson:(NSDictionary*)json {
    self.pageNumber++;
}

@end


