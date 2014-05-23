//
//  MediaCache.m
//  SpotMyRide
//
//  Created by Sebastian Cancinos on 5/28/13.
//  Copyright (c) 2013 Sebastian Cancinos. All rights reserved.
//

#import "MediaCache.h"
#import "ServerCommunications.h"
#import "AFImageRequestOperation.h"

#define kBgQueue        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation MediaCache

+ (NSString *)cacheDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (BOOL)isJPEGValid:(NSData *)jpeg
{
    if ([jpeg length] < 4) return NO;
    const char * bytes = (const char *)[jpeg bytes];
    if (bytes[0] != '\xff' || bytes[1] != '\xd8') return NO;
    if (bytes[[jpeg length] - 2] != '\xff' || bytes[[jpeg length] - 1] != '\xd9') return NO;
    return YES;
}

+ (void) downloadImageFromPath:(NSString*) path completion:(void (^)(UIImage* ))completion
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    NSURL           *url = [NSURL URLWithString: path];
    NSString* cachesDirectory = [MediaCache cacheDirectory];

    //The last directory should mark if it's a thumbnail or the original image. I add it to the filename to have both for different views.
    
    NSString *filename = [NSString stringWithFormat:@"%@_%@", [url.pathComponents objectAtIndex:url.pathComponents.count-2],[url lastPathComponent] ];
    NSString *file = [cachesDirectory stringByAppendingPathComponent:filename];

    if([fileManager fileExistsAtPath:file])
    {
        UIImage* img = [UIImage imageWithContentsOfFile:file];
        completion(img);
    }
    else
    {
        NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                         requestWithURL:url
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

       AFImageRequestOperation* imageOperation = [AFImageRequestOperation imageRequestOperationWithRequest:theRequest
                                                          success:^(UIImage* img){
                                                              
                NSData *imageData = UIImageJPEGRepresentation(img, 1);
                if([self isJPEGValid:imageData])
                {
                  [imageData writeToFile:file atomically:YES];
                }
                
                completion(img);
            }];
        [[ServerCommunications getSharedInstance].operationQueue addOperation:imageOperation];
    }
}

@end
