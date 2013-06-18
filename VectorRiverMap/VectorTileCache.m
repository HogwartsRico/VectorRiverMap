//
//  VectorTileCache.m
//  VectorRiverMap
//
//  Created by zhang baocai on 13-6-17.
//  Copyright (c) 2013年 Esri. All rights reserved.
//

#import "VectorTileCache.h"

@implementation VectorTileCache

+(id)sharedInstance
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}
- (id)init
{
    return [self initWithNamespace:@"default"];
}

- (id)initWithNamespace:(NSString *)ns
{
    if ((self = [super init]))
    {
        NSString *fullNamespace = [@"net.giser." stringByAppendingString:ns];
        
        // Create IO serial queue
        _ioQueue = dispatch_queue_create("net.giser.VectorTileCache", DISPATCH_QUEUE_SERIAL);
        
        
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [[paths[0] stringByAppendingPathComponent:fullNamespace] retain];
      //   NSFileManager *fileManager = [NSFileManager defaultManager];
      //  [fileManager  removeItemAtPath:_diskCachePath error:NULL];
     }
    
    return self;
}

- (void)dealloc
{
    dispatch_release(_ioQueue);
    [super dealloc];
}


-(void) writeCache:(NSData*)data forKey:(NSString*)key
{
    if (!data || !key)
    {
        return;
    }

    dispatch_async(_ioQueue, ^
    {
      if (data)
      {   
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:_diskCachePath])
        {
            [fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
          ;
        [fileManager createFileAtPath:[_diskCachePath stringByAppendingPathComponent:key] contents:data attributes:nil];
      }
   });
 
}
-(NSData*) readCacheForKey:(NSString*)key
{
    NSString *defaultPath = [_diskCachePath stringByAppendingPathComponent:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data)
    {
        return data;
    }
    return nil;
}
@end
