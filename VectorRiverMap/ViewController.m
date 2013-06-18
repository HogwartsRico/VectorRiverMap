//
//  ViewController.m
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "ViewController.h"
#import "VectorTiledLayer.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize mapView = _mapView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   NSString * url =  @"http://server.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer";
    AGSTiledMapServiceLayer * bLayer = [AGSTiledMapServiceLayer  tiledMapServiceLayerWithURL:[NSURL URLWithString:url ]];
    [self.mapView addMapLayer:bLayer withName:@"bLa"] ;
    VectorTiledLayer * vLayer = [[VectorTiledLayer alloc] initWithBaseUrl:@"http://www.somebits.com:8001/rivers"];
    [self.mapView addMapLayer:vLayer withName:@"v"];
    AGSPoint * wgsPoint = [[AGSPoint alloc] initWithX:-120.976 y:37.958 spatialReference:nil];
    AGSPoint * webMPoint =(AGSPoint *)AGSGeometryGeographicToWebMercator(wgsPoint);
    [self.mapView zoomToScale:4622326 withCenterPoint:webMPoint animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
