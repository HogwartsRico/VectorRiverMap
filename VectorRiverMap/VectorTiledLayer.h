//
//  VectorTiledLayer.h
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

@interface VectorTiledLayer : AGSTiledServiceLayer
{
@protected
    AGSTileInfo* _tileInfo;
    AGSEnvelope* _fullEnvelope;
    NSString * _baseUrl;
}
- (id)initWithBaseUrl: (NSString *)baseUrl  ;
@end
