//
//  VectorTiledLayerSchema.m
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "VectorTiledLayerSchema.h"
#import <ArcGIS/ArcGIS.h>
@implementation VectorTiledLayerSchema
@synthesize spatialReference = _spatialReference;
@synthesize fullEnvelope = _fullEnvelope;
@synthesize tileInfo = _tileInfo;
-(id) init
{
	if (self = [super init]) {
        _spatialReference = [[AGSSpatialReference alloc] initWithWKID:102100 WKT:nil];
        _fullEnvelope = [[AGSEnvelope alloc] initWithXmin:-22041257.773878
                                                     ymin:-32673939.6727517
                                                     xmax:22041257.773878
                                                     ymax:20851350.0432886
                                         spatialReference:self.spatialReference];
        
        NSMutableArray *lods = [NSMutableArray arrayWithObjects:
                                [[[AGSLOD alloc] initWithLevel:0 resolution:156543.033928 scale: 591657527.591555] autorelease] ,
                                [[[AGSLOD alloc] initWithLevel:1 resolution:78271.5169639999 scale: 295828763.795777]autorelease],
                                [[[AGSLOD alloc] initWithLevel:2 resolution:39135.7584820001 scale: 147914381.897889]autorelease],
                                [[[AGSLOD alloc] initWithLevel:3 resolution:19567.879240999919 scale: 73957190.948944002]autorelease],
                                [[[AGSLOD alloc] initWithLevel:4 resolution:9783.93962049996 scale: 36978595.474472]autorelease],
                                [[[AGSLOD alloc] initWithLevel:5 resolution:4891.96981024998 scale: 18489297.737236]autorelease],
                                [[[AGSLOD alloc] initWithLevel:6 resolution:2445.98490512499 scale: 9244648.868618]autorelease],
                                [[[AGSLOD alloc] initWithLevel:7 resolution:1222.9924525624949 scale: 4622324.4343090001]autorelease],
                                [[[AGSLOD alloc] initWithLevel:8 resolution:611.49622628138 scale: 2311162.217155]autorelease],
                                [[[AGSLOD alloc] initWithLevel:9 resolution:305.748113140558 scale: 1155581.108577]autorelease],
                                [[[AGSLOD alloc] initWithLevel:10 resolution:152.874056570411 scale: 577790.554289]autorelease],
                                [[[AGSLOD alloc] initWithLevel:11 resolution:76.4370282850732 scale: 288895.277144]autorelease],
                                [[[AGSLOD alloc] initWithLevel:12 resolution:38.2185141425366 scale: 144447.638572]autorelease],
                                [[[AGSLOD alloc] initWithLevel:13 resolution:19.1092570712683 scale: 72223.819286]autorelease],
                                [[[AGSLOD alloc] initWithLevel:14 resolution:9.55462853563415 scale:36111.909643]autorelease],
                                [[[AGSLOD alloc] initWithLevel:15 resolution:4.7773142679493699 scale: 18055.954822]autorelease],
                                [[[AGSLOD alloc] initWithLevel:16 resolution:2.3886571339746849 scale: 9027.9774109999998]autorelease],
                                [[[AGSLOD alloc] initWithLevel:17 resolution:1.1943285668550503 scale: 4513.9887049999998]autorelease],
                                [[[AGSLOD alloc] initWithLevel:18 resolution:0.59716428355981721 scale: 2256.994353]autorelease],
                                [[[AGSLOD alloc] initWithLevel:19 resolution:0.29858214164761665 scale: 1128.4971760000001]autorelease],
                                nil ];
        _tileInfo = [[AGSTileInfo alloc]
                     initWithDpi:96
                     format :@"PNG"
                     lods:lods
                     origin:[AGSPoint pointWithX:-20037508.342787 y:20037508.342787 spatialReference:_spatialReference]
                     spatialReference :_spatialReference
                     tileSize:CGSizeMake(256,256)
                     ];
        [_tileInfo computeTileBounds:self.fullEnvelope ];
    };

 	
	return self;
}
- (void)dealloc {
	self.spatialReference = nil;
	self.fullEnvelope = nil;
	self.tileInfo = nil;
    
	[super dealloc];	
}
@end
