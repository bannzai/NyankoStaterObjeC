//
//  Nyanko.h
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/07.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
   NyankoImageTypeUnKnown = -1,
   NyankoImageTypeThumbnail,
   NyankoImageTypeLow,
   NyankoImageTypeStandard,
    
}NyankoImageType;

@interface NyankoImage : NSObject

@property (nonatomic) NyankoImageType type;
@property (nonatomic) NSString *url;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;

+ (NSArray*)nyankoImagesFromJson:(NSDictionary*)json;
+ (instancetype)nyankoImageFromPartJson:(NSDictionary*)json;

@end

@interface Nyanko : NSObject

@property (nonatomic) NSString *linkUrl;
@property (nonatomic) NyankoImage *image;

+ (NSArray*)nyankosFromJson:(NSDictionary*)json;
+ (instancetype)nyankoFromPartJson:(NSDictionary*)json;

@end

