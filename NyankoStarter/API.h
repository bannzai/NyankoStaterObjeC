//
//  API.h
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/06.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successHandler)(NSDictionary *json);
typedef void (^failHandler)(NSError *error);

@interface APIRequest : NSObject

@property (nonatomic) NSString *url;
@property (nonatomic, copy) successHandler success;
@property (nonatomic, copy) failHandler fail;

@end

@interface API : NSObject
//<NSURLSessionDownloadDelegate>

+ (instancetype)sharedInstance;
- (void)request:(APIRequest*)request;
@end
