//
//  ListModel.h
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/12.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic) NSMutableArray *array;
@property (nonatomic) NSString *nextUrl;

@property (nonatomic, readonly) NSUInteger pageNumber;

- (void)addListFromJson:(NSDictionary*)json;

@end
