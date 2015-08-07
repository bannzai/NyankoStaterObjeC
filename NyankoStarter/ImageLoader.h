//
//  ImageLoader.h
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/07.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ImageLoader : NSObject

+ (instancetype)sharedInstance;
- (void)loadImage:(NSString*)sUrl completionBlock:(void(^)(UIImage *image))completionBlock;
@end


@interface ImageCache : NSObject

@property (nonatomic) NSCache *cache;

+ (instancetype)sharedInstance;
- (UIImage*)imageForKey:(NSString*)key;
- (void)setImage:(UIImage*)image key:(NSString*)key;

@end