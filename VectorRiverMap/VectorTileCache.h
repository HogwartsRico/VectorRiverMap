//
//  VectorTileCache.h
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
@interface VectorTileCache : NSObject
{
    NSString *_diskCachePath;
    dispatch_queue_t _ioQueue;
}

+(id)sharedInstance;
-(void) writeCache:(NSData*)data forKey:(NSString*)key;
-(NSData*) readCacheForKey:(NSString*)key;
@end
