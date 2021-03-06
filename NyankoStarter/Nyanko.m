//
//  Nyanko.m
//  NyankoStarter
//
//  Created by hirose yudai on 2015/08/07.
//  Copyright (c) 2015年 hirose yudai. All rights reserved.
//

#import "Nyanko.h"

@implementation NyankoImage


+ (NSArray*)nyankoImagesFromJson:(NSDictionary*)json {
    NSArray *dics = json[@"images"];
    NSMutableArray *nyankoImages = [NSMutableArray array];
    for (NSDictionary *dic in dics) {
        [nyankoImages addObject:[NyankoImage nyankoImageFromPartJson:dic]];
    }
    return nyankoImages;
}

+ (instancetype)nyankoImageFromPartJson:(NSDictionary*)json {
    NyankoImage *nyankoImage = [self new];
    
    NSString *key = [json.allKeys firstObject];
    NSDictionary *dic = json[key];
    
    nyankoImage.type = [NyankoImage getTypeFromKey:key];
    nyankoImage.width = [dic[@"width"] integerValue];
    nyankoImage.height = [dic[@"heigth"] integerValue];
    nyankoImage.url = dic[@"url"];
    
    return nyankoImage;
}

+ (NyankoImageType)getTypeFromKey:(NSString*)key {
    if ([key isEqualToString:@"thumbnail"]) { return NyankoImageTypeThumbnail; }
    if ([key isEqualToString:@"low_resolution"]) { return NyankoImageTypeLow; }
    if ([key isEqualToString:@"standard_resolution"]) { return NyankoImageTypeStandard; }
    return NyankoImageTypeUnKnown;
}

@end


@implementation Nyanko

+ (NSArray*)nyankosFromJson:(NSDictionary*)json {
    NSArray *dics = json[@"data"];
    NSMutableArray *nyankos = [NSMutableArray array];
    for (NSDictionary *dic in dics) {
        [nyankos addObject:[Nyanko nyankoFromPartJson:dic]];
    }
    return nyankos;
}

+ (instancetype)nyankoFromPartJson:(NSDictionary*)json {
    Nyanko *nyanko = [self new];
    
    nyanko.image = [NyankoImage nyankoImageFromPartJson:json[@"images"]];
    nyanko.linkUrl = json[@"link"];
    
    return nyanko;
}

@end

@implementation Nyankos

- (void)addListFromJson:(NSDictionary *)json {
    [super addListFromJson:json];
    
    [self.array addObjectsFromArray:[Nyanko nyankosFromJson:json]];
    
    NSDictionary *partPagenation = json[@"pagination"];
    self.nextUrl = partPagenation[@"next_url"];
}

@end
