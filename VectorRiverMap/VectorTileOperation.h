//
//  VectorTileOperation.h
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
@interface VectorTileOperation : NSOperation
{
    
}
- (id)initWithTileInfo:(AGSTileInfo*) tileInfo tileKey:(AGSTileKey *)tile baseUrl:(NSString *)baseUrl target:(id)target action:(SEL)action;


@property (nonatomic,strong) AGSTileKey* tileKey;

@property (nonatomic,strong) id target;
@property (nonatomic,strong) AGSTileInfo *tileInfo;
@property (nonatomic,assign) SEL action;
@property (nonatomic,strong) NSString* baseUrl;
@property (nonatomic,strong) NSData* imageData;
@end
