//
//  ImageCache.h
//  BeautyDate
//
//  Created by Moacir Lamego on 07/09/15.
//  Copyright (c) 2015 B2Beauty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DOC_PATH                    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define TMP_PATH                    NSTemporaryDirectory()
#define IS_RETINA                   [[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.0

#define IMAGE_PATH(img)             [TMP_PATH stringByAppendingFormat:@"%@",img]

#define PROFILE_PICTURE_PATH        [DOC_PATH stringByAppendingString:@"/profile.png"]
#define DEFAULT_PROFILE_IMG         [UIImage imageNamed:@"person-icon"]

#define MAX_SIMULTANEOUS_REQUESTS   2
#define FILE_MANAGER                [NSFileManager defaultManager]

#define DOWNLOAD_TIMEOUT			60
#define MAX_IMGCACHE_TIME           1 * 60 * 60 * 24 //1 dia

#define SAMPLE_COVER_IMG            [UIImage imageNamed:@"default_image"]

@interface ImageCache : NSObject

+ (NSString*)sha1:(NSString*)str border:(BOOL)border;

+ (void)asyncRequestImageFromURL:(NSURL*)imgUrl size:(CGSize)size border:(BOOL)border forceRemote:(BOOL)forceRemote returnToMainThread:(BOOL)mainThread success:(void (^)(UIImage*))image fail:(void (^)(NSError*))error;
+ (void)asyncRequestImageFromStringURL:(NSString*)imgStringUrl size:(CGSize)size border:(BOOL)border forceRemote:(BOOL)forceRemote returnToMainThread:(BOOL)mainThread success:(void (^)(UIImage*))image fail:(void (^)(NSError*))error;

+ (void)asyncRequestImageFromURL:(NSURL*)imgUrl size:(CGSize)size border:(BOOL)border forceRemote:(BOOL)forceRemote success:(void (^)(UIImage*))image fail:(void (^)(NSError*))error;
+ (void)asyncRequestImageFromStringURL:(NSString*)imgStringUrl size:(CGSize)size border:(BOOL)border forceRemote:(BOOL)forceRemote success:(void (^)(UIImage*))image fail:(void (^)(NSError*))error;

+ (void)mountImg1:(NSString*)url1 img2:(NSString*)url2 img3:(NSString*)url3 img4:(NSString*)url4 size:(CGSize)size success:(void (^)(UIImage*,NSString*))success fail:(void (^)(NSError*))didFail;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (UIImage*)getProfilePicture;
+ (BOOL)saveProfilePicture:(UIImage*)image;
+ (NSString*) getNameImageFromStringURL:(NSString*)stringUrl;


+ (void)cleanOldFiles;
+ (void)cleanAll;

@end
