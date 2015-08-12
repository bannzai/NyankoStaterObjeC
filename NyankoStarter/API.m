//
//  API.m
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/06.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import "API.h"

@interface APIRequest ()



@end

@implementation APIRequest


@end


@interface API ()

@end

@implementation API

+ (instancetype)sharedInstance {
	static typeof([self new]) s_sharedInstance = nil;
	static dispatch_once_t s_onceToken;
	dispatch_once(&s_onceToken, ^{
		s_sharedInstance = [[self alloc] init];
	});
	return s_sharedInstance;
}

- (void)request:(APIRequest*)request {
    NSURL* url = [NSURL URLWithString:request.url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                request.fail(error);
                return;
            }
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            
            NSError* errorParse = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorParse];
            
            if (errorParse) {
                request.fail(errorParse);
                return;
            }
            
            request.success(json);
        });
    }];
    [task resume];
}

//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
//    NSData *data = [NSData dataWithContentsOfURL:location];
//    if (!data.length) {
//        NSAssert(@"oh my god!!", @"");
//    }
//    NSError* errorParse = nil;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorParse];
//
//}

@end
