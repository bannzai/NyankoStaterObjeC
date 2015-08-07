//
//  ImageLoader.m
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/07.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader

+ (instancetype)sharedInstance {
	static typeof([self new]) s_sharedInstance = nil;
	static dispatch_once_t s_onceToken;
	dispatch_once(&s_onceToken, ^{
		s_sharedInstance = [[self alloc] init];
	});
	return s_sharedInstance;
}


- (void)loadImage:(NSString*)sUrl completionBlock:(void(^)(UIImage *image))completionBlock {

    UIImage *cache = [[ImageCache sharedInstance] imageForKey:sUrl];
    if (cache) {
        completionBlock(cache);
        return ;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url = [NSURL URLWithString:sUrl];
        if (!url) {
            return ;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if (!data.length) {
            return ;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        [[ImageCache sharedInstance] setImage:image key:sUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    });
    
}

@end

@implementation ImageCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}


+ (instancetype)sharedInstance {
	static typeof([self new]) s_sharedInstance = nil;
	static dispatch_once_t s_onceToken;
	dispatch_once(&s_onceToken, ^{
		s_sharedInstance = [[self alloc] init];
	});
	return s_sharedInstance;
}

- (UIImage*)imageForKey:(NSString*)key {
    return [self.cache objectForKey:key];
}

- (void)setImage:(UIImage*)image key:(NSString*)key {
    [self.cache setObject:image forKey:key];
}

@end
