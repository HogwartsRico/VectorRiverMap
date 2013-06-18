//
//  VectorTileOperation.m
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "VectorTileOperation.h"
#import "GeoJSON.h"
#import "VectorTileCache.h"
@implementation VectorTileOperation
@synthesize tileKey;
@synthesize target;
@synthesize action;
@synthesize baseUrl;
@synthesize imageData;
@synthesize tileInfo;

- (id)initWithTileInfo:(AGSTileInfo*) ti tileKey:(AGSTileKey *)tk baseUrl:(NSString *)bu target:(id)t action:(SEL)a
{
    if (self = [super init]) {
        self.tileInfo = ti;
		self.target = t;
		self.action = a;
		self.baseUrl = bu  ;
		self.tileKey = tk;
		
	}
	return self;
}

-(void)main {
    //If this operation was cancelled, do nothing
    @autoreleasepool {
        if(self.isCancelled)
            return;
        
        //Fetch the tile for the requested Level, Row, Column
        @try {
             VectorTileCache *cache = [VectorTileCache sharedInstance];
  
                
                NSString * key = [NSString stringWithFormat:@"v_%d_%d_%d",self.tileKey.level,self.tileKey.row,self.tileKey.column];
            
                NSData * data = [cache readCacheForKey:key];
                if (data == nil) {
                    data = UIImagePNGRepresentation([self buildImage]);
                    [cache writeCache:data forKey:key];
                  //  NSLog(@"cache %@ write",key);
                }
                else
                {
                   // NSLog(@"cache %@ used",key);
                }
                self.imageData= data;
            }
        
		
        @catch (NSException *exception) {
            NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
        }
        @finally {
            //Invoke the layer's action method
            if(!self.isCancelled)
                [self.target performSelector:self.action withObject:self];
        }
    }
    
}
-(CGPoint) calZreoPos:(double)res
{
    
    double x = self.tileInfo.origin.x +res * self.tileInfo.tileSize.width*self.tileKey.column;
    double y = self.tileInfo.origin.y -res * self.tileInfo.tileSize.height*self.tileKey.row;
    // CGPoint tl =[self.mapView toScreenPoint:[AGSPoint pointWithX:x y:y spatialReference:nil]];
    CGPoint rp = CGPointMake(x, y);
    //   NSLog(@"%@",NSStringFromCGPoint(rp));
    return rp;
}
-(UIImage *)buildImage
{
    UIGraphicsBeginImageContext(CGSizeMake(256, 256));
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString * url = [NSString stringWithFormat:@"%@/%d/%d/%d.json",self.baseUrl,self.tileKey.level,self.tileKey.column,self.tileKey.row];
    //   NSLog(@"%@",url);
    //  NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSError * error = nil;
    NSString * strJSON =[[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:url] encoding:(NSUTF8StringEncoding) error:&error];
    GeoJSONFeatureCollection * fc = [strJSON toGeoJSONFeatureCollection];
    [strJSON release];
    
    //  CGPoint  tl=[self calTopLeft];
    AGSLOD * lod = [self.tileInfo.lods objectAtIndex:self.tileKey.level];
    double res = lod.resolution;
    CGPoint zero = [self calZreoPos:res];
    for (int i = 0; i < [fc numOfFeatures];i++)
    {
        @autoreleasepool {
            GeoJSONFeature * f = [fc featureAtIndex:i];
            NSInteger strahler = [[f.properties objectForKey:@"strahler"] intValue] ;
            //  NSLog(@"%d",strahler);
            switch (f.geometry.type) {
                case GeoJSONObjectType_Geom_Point:
                {
                    GeoJSONPoint * p = (GeoJSONPoint *)f.geometry;
                    AGSPoint * wgsPoint = [AGSPoint pointWithX:p.x y:p.y spatialReference:nil];
                    AGSPoint *webMPoint =(AGSPoint *) AGSGeometryGeographicToWebMercator(wgsPoint);
                    //  CGPoint cp =[self.mapView toScreenPoint:webMPoint];
                    double dx =(webMPoint.x -zero.x)/res;
                    double dy = (zero.y-webMPoint.y)/res;
                    CGContextAddEllipseInRect(context,(CGRectMake (dx, dy, 3.0, 3.0)));
                    CGContextDrawPath(context, kCGPathFill);
                    CGContextStrokePath(context);
                    
                }
                    break;
                case GeoJSONObjectType_Geom_LineString:
                {
                    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
                    CGContextSetLineWidth(context, strahler/4.0);
                    GeoJSONLineString * line = (GeoJSONLineString*)f.geometry;
                    for (int i = 0; i< [line numOfPoints]; i++) {
                        @autoreleasepool {
                            GeoJSONPoint * p = [line pointAtIndex:i];
                            AGSPoint * wgsPoint = [AGSPoint pointWithX:p.x y:p.y spatialReference:nil];
                            AGSPoint *webMPoint =(AGSPoint *) AGSGeometryGeographicToWebMercator(wgsPoint);
                            //  CGPoint cp =[self.mapView toScreenPoint:webMPoint];
                            double dx =(webMPoint.x -zero.x)/res;
                            double dy = (zero.y-webMPoint.y)/res;
                            if (i == 0) {
                                
                                CGContextMoveToPoint(context, dx, dy);
                            }
                            else
                            {
                                CGContextAddLineToPoint(context, dx, dy);
                            }
                        }
                        
                    }
                    
                    CGContextStrokePath(context);
                }
                    break;
                case GeoJSONObjectType_Geom_MultiLineString:
                {
                    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
                    CGContextSetLineWidth(context, strahler/4.0);
                    GeoJSONMultiLineString* mline = (GeoJSONMultiLineString*)f.geometry;
                    for (int j =0 ; j< [mline numOfLineStrings]; j++) {
                        @autoreleasepool {
                            GeoJSONLineString * line = [mline lineStringAtIndex:j];
                            for (int i = 0; i< [line numOfPoints]; i++) {
                                @autoreleasepool {
                                    GeoJSONPoint * p = [line pointAtIndex:i];
                                    AGSPoint * wgsPoint = [AGSPoint pointWithX:p.x y:p.y spatialReference:nil];
                                    AGSPoint *webMPoint =(AGSPoint *) AGSGeometryGeographicToWebMercator(wgsPoint);
                                    //  CGPoint cp =[self.mapView toScreenPoint:webMPoint];
                                    double dx =(webMPoint.x -zero.x)/res;
                                    double dy = (zero.y-webMPoint.y)/res;
                                    if (i == 0) {
                                        
                                        CGContextMoveToPoint(context, dx, dy);
                                    }
                                    else
                                    {
                                        CGContextAddLineToPoint(context, dx, dy);
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    CGContextStrokePath(context);
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return result;
}
@end
