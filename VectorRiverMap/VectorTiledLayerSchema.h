//
//  VectorTiledLayerSchema.h
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGSPoint;
@class AGSLOD;
@class AGSSpatialReference;
@class AGSTileInfo;
@class AGSEnvelope;
@interface VectorTiledLayerSchema : NSObject {
	AGSSpatialReference* _spatialReference;
	AGSEnvelope* _fullEnvelope;
	AGSTileInfo* _tileInfo;
    
}

@property (nonatomic,retain,readwrite) AGSSpatialReference* spatialReference;
@property (nonatomic,retain,readwrite) AGSEnvelope* fullEnvelope;
@property (nonatomic,retain,readwrite) AGSTileInfo* tileInfo;
@end