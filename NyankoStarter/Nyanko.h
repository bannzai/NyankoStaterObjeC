//
//  Nyanko.h
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/07.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject.h"

typedef enum {
    
   NyankoImageTypeUnKnown = -1,
   NyankoImageTypeThumbnail,
   NyankoImageTypeLow,
   NyankoImageTypeStandard,
    
}NyankoImageType;

typedef enum {
    NyankoContentTypeUnknown = -1 ,
    NyankoContentTypeImage,
    NyankoContentTypeVideo,
}NyankoContentType;

RLM_ARRAY_TYPE(Nyanko)

@interface NyankoImage : RLMObject

@property NyankoImageType type;
@property NSString *url;
@property NSInteger width;
@property NSInteger height;

+ (NSArray*)nyankoImagesFromJson:(NSDictionary*)json;
+ (instancetype)nyankoImageFromPartJson:(NSDictionary*)json;

@end

@interface Nyanko : RLMObject

@property NSString *linkUrl;
@property NyankoImage *image;
@property NSString *filter;
@property NyankoContentType contentType;

+ (NSArray*)nyankosFromJson:(NSDictionary*)json;
+ (instancetype)nyankoFromPartJson:(NSDictionary*)json;

@end

