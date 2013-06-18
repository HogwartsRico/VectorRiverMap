//
//  VectorTiledLayer.m
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "VectorTiledLayer.h"
#import "VectorTiledLayerSchema.h"
#import "VectorTileOperation.h"
@implementation VectorTiledLayer
-(void) dealloc
{
    if (_baseUrl != nil) {
        [_baseUrl release];
    }
    if (_fullEnvelope != nil) {
        [_fullEnvelope release];
    }
    if (_tileInfo != nil) {
        [_tileInfo release];
    }
    [super dealloc];
}

-(AGSUnits)units{
	return AGSUnitsMeters ;
}

-(AGSSpatialReference *)spatialReference{
	return _fullEnvelope.spatialReference;
}

-(AGSEnvelope *)fullEnvelope{
	return _fullEnvelope;
}

-(AGSEnvelope *)initialEnvelope{
	//Assuming our initial extent is the same as the full extent
	return _fullEnvelope;
}

-(AGSTileInfo*) tileInfo{
	return _tileInfo;
}
- (id)initWithBaseUrl: (NSString *)baseUrl
{
    if (self = [super init]) {
        _baseUrl = [baseUrl retain];
        VectorTiledLayerSchema *schema = [[VectorTiledLayerSchema alloc]init];
        _fullEnvelope = [schema.fullEnvelope retain];
        _tileInfo = [schema.tileInfo retain];
        [schema release];
        [super layerDidLoad];
    }
    return self;
}
- (void)requestTileForKey:(AGSTileKey *)key{
    //Create an operation to fetch tile from local cache
	VectorTileOperation *operation =
    [[VectorTileOperation alloc] initWithTileInfo:self.tileInfo tileKey:key baseUrl:_baseUrl target:self action:@selector(didFinishOperation:)];
    
    
	//Add the operation to the queue for execution
    [ [AGSRequestOperation sharedOperationQueue] addOperation:operation];
    [operation release];
}

- (void)cancelRequestForKey:(AGSTileKey *)key{
    //Find the OfflineTileOperation object for this key and cancel it
    for(NSOperation* op in [AGSRequestOperation sharedOperationQueue].operations){
        if( [op isKindOfClass:[VectorTileOperation class]]){
            VectorTileOperation* vOp = (VectorTileOperation*)op;
            if([vOp.tileKey isEqualToTileKey:key]){
                [vOp cancel];
            }
        }
    }
}



- (void) didFinishOperation:(VectorTileOperation*)op {
    //... pass the tile's data to the super class
    [super setTileData: op.imageData  forKey:op.tileKey];
}
@end
