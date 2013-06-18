//
//  ViewController.h
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
@interface ViewController : UIViewController
{
    AGSMapView *_mapView;
}
@property (nonatomic, strong) IBOutlet AGSMapView *mapView;
@end
