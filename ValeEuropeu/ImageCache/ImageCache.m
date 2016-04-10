//
//  ImageCache.m
//  BeautyDate
//
//  Created by Moacir Lamego on 07/09/15.
//  Copyright (c) 2015 B2Beauty. All rights reserved.
//

#import "ImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "GlobalVariables.h"


@implementation ImageCache

# pragma mark - Fila de operação

+ (NSOperationQueue*)queue
{
    static NSOperationQueue *queue;
    
    if (!queue)
    {
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:MAX_SIMULTANEOUS_REQUESTS];
    }
    
    return queue;
}

# pragma mark - Obtenção do nome da img

+ (NSString*)sha1:(NSString*)str border:(BOOL)border
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x%i", digest[i], border];
    
    return output;
}

+ (NSString*)imageNameFromStringURL:(NSString*)stringUrl border:(BOOL)border
{
    return [self sha1:stringUrl border:border];
}

+ (NSString*) getNameImageFromStringURL:(NSString*)stringUrl {
    return [self imageNameFromStringURL:stringUrl border:NO];
}


# pragma mark Request com tamanho

+ (NSURL*)urlByRemovingFragment:(NSURL*)url
{
    NSString *urlString = [url absoluteString];
    NSRange fragmentRange = [urlString rangeOfString:@"&type" options:NSBackwardsSearch];
    if (fragmentRange.location != NSNotFound)
    {
        NSString* newURLString = [urlString substringToIndex:fragmentRange.location];
        return [NSURL URLWithString:newURLString];
    }
    else
        return url;
}

+ (UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    // Cria contexto sem antialiasing
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, false);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    // Remove borda de 1px
    CGContextClearRect(context, CGRectMake(0, 0, size.width, 1));
    CGContextClearRect(context, CGRectMake(size.width - 1, 0, 1, size.height));
    CGContextClearRect(context, CGRectMake(0, size.height - 1, size.width, 1));
    CGContextClearRect(context, CGRectMake(0, 0, 1, size.height));
    
    // Aplica stroke de 1px
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.2);
    CGContextStrokeRect(context, CGRectMake(0, 1, size.width - 1, size.height - 1));
    
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return testImg;
}

+ (void)asyncRequestImageFromURL:(NSURL*)imgUrl size:(CGSize)size border:(BOOL)border forceRemote:(BOOL)forceRemote returnToMainThread:(BOOL)mainThread success:(void (^)(UIImage*))image fail:(void (^)(NSError*))error {
    // Remove parâmetros que ainda estão vindo no mock
    __block NSURL *url = [self urlByRemovingFragment:imgUrl];
    
    // Dobra o tamanho (que vem em pontos e não pixels) quando a tela é retina
//    __block CGSize requestSize = (IS_RETINA) ? CGSizeMake(size.width * 2.0, size.height * 2.0) : size;
    
    dispatch_queue_t background =  dispatch_queue_create("ImageCache.Requestimage", NULL);
    dispatch_async(background, ^
                   {
//                       if ([[url absoluteString] rangeOfString:@"w="].location == NSNotFound)
//                           url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:@"&type=mobile&w=%.0f&h=%.0f", requestSize.width, requestSize.height]];
                       
//                       DLog(@"URL IMAGE: %@", url);
                       NSString *imageName = [self imageNameFromStringURL:url.absoluteString border:border];
                       
                       // Entra caso determine nome da imagem
                       if (imageName)
                       {
                           UIImage *img;
                           
                           // Verifica existencia e carrega imagem sincronizadamente para evitar concorrencia com o cleaner, ou ignora essa verificação caso tenha que forçar download
                           BOOL fileExists = NO;
                           if (!forceRemote)
                           {
                               @synchronized(self)
                               {
                                   fileExists = [FILE_MANAGER fileExistsAtPath:IMAGE_PATH(imageName)];
                                   if (fileExists)
                                       img = [UIImage imageWithContentsOfFile:IMAGE_PATH(imageName)];
                               }
                           }
                           
                           // Retorna imagem local carregada acima
                           if (fileExists) {
                               if ([[[GlobalVariables shared] dictImage] objectForKey:imageName] == nil) {
                                   [[[GlobalVariables shared] dictImage] setObject:image forKey:imageName];
                               }

                               if (mainThread)
                                   dispatch_async(dispatch_get_main_queue(), ^ {
                                       image(img);
                                   });
                               else
                                   image(img);
                           }
                           
                           // Caso contrário, inicia requisicao remota
                           else
                           {
                               NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                               [request setTimeoutInterval:DOWNLOAD_TIMEOUT];
                               
                               [NSURLConnection sendAsynchronousRequest:request
                                                                  queue:[self queue]
                                                      completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                                {
                                    // Erro de conexao
                                    if (connectionError)
                                    {
                                        if (mainThread)
                                            dispatch_async(dispatch_get_main_queue(), ^ {
                                                error(connectionError);
                                            });
                                        else
                                            error(connectionError);
                                    }
                                    
                                    // Recebeu NSData
                                    else
                                    {
                                        // Verifica se data for invalida
                                        if (!data)
                                        {
                                            if (mainThread)
                                                dispatch_async(dispatch_get_main_queue(), ^ {
                                                    error([NSError errorWithDomain:NSStringFromClass(self) code:0 userInfo:@{@"description": @"Invalid data."}]);
                                                });
                                            else
                                                error([NSError errorWithDomain:NSStringFromClass(self) code:0 userInfo:@{@"description": @"Invalid data."}]);
                                        }
                                        
                                        UIImage *img = [[UIImage alloc] initWithData:data];
                                        if (!img)
                                        {
                                            if (mainThread)
                                                dispatch_async(dispatch_get_main_queue(), ^ {
                                                    error([NSError errorWithDomain:NSStringFromClass(self) code:0 userInfo:@{@"description": @"Invalid data."}]);
                                                });
                                            else
                                                error([NSError errorWithDomain:NSStringFromClass(self) code:0 userInfo:@{@"description": @"Invalid data."}]);
                                        }
                                        else
                                        {
                                            // Aplica borda caso seja requisitada
                                            if (border)
                                            {
                                                img = [self imageWithBorderFromImage:img];
                                                data = UIImagePNGRepresentation(img);
                                            }
                                            
                                            // Verifica se imagem for invalida
                                            if (!img)
                                            {
                                                if (mainThread)
                                                    dispatch_async(dispatch_get_main_queue(), ^ {
                                                        error([NSError errorWithDomain:NSStringFromClass(self) code:0 userInfo:@{@"description": @"Invalid data."}]);
                                                    });
                                                else
                                                    error([NSError errorWithDomain:NSStringFromClass(self) code:0 userInfo:@{@"description": @"Invalid data."}]);
                                            }
                                            
                                            // Persiste e retorna imagem
                                            else {
                                                [data writeToFile:IMAGE_PATH(imageName) atomically:YES];
                                                
                                                [[[GlobalVariables shared] dictImage] setObject:image forKey:imageName];
                                                
                                                if (mainThread)
                                                    dispatch_async(dispatch_get_main_queue(), ^ {
                                                        image(img);
                                                    });
                                                else
                                                    image(img);
                                            }
                                        }
                                    }
                                }];
                           }
                       }
                       
                       // Nome da imagem não pode ser obtido
                       else
                       {
                           if (mainThread)
                               dispatch_async(dispatch_get_main_queue(), ^ {
                                   error([NSError errorWithDomain:NSStringFromClass(self) code:0 userInfo:@{@"description": @"Could not determine image name."}]);
                               });
                           else
                               error([NSError errorWithDomain:NSStringFromClass(self) code:0 userInfo:@{@"description": @"Could not determine image name."}]);
                       }
                   });
}

+ (void)asyncRequestImageFromStringURL:(NSString*)imgStringUrl size:(CGSize)size border:(BOOL)border forceRemote:(BOOL)forceRemote returnToMainThread:(BOOL)mainThread success:(void (^)(UIImage*))image fail:(void (^)(NSError*))error;
{
    NSURL *url = [NSURL URLWithString:imgStringUrl];
    [self asyncRequestImageFromURL:url size:size border:border forceRemote:forceRemote returnToMainThread:mainThread success:image fail:error];
}

+ (void)asyncRequestImageFromURL:(NSURL*)imgUrl size:(CGSize)size border:(BOOL)border forceRemote:(BOOL)forceRemote success:(void (^)(UIImage*))image fail:(void (^)(NSError*))error
{
    [self asyncRequestImageFromURL:imgUrl size:size border:border forceRemote:forceRemote returnToMainThread:YES success:image fail:error];
}

+ (void)asyncRequestImageFromStringURL:(NSString*)imgStringUrl size:(CGSize)size border:(BOOL)border forceRemote:(BOOL)forceRemote success:(void (^)(UIImage*))image fail:(void (^)(NSError*))error
{
    [self asyncRequestImageFromStringURL:imgStringUrl size:size border:border forceRemote:forceRemote returnToMainThread:YES success:image fail:error];
}

# pragma mark Monta mosaico

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)defaultCoverImageWithSize:(CGSize)size
{
    UIImage *defaultCoverImage = [self imageWithImage:SAMPLE_COVER_IMG scaledToSize:size];
    return [self imageWithBorderFromImage:defaultCoverImage];
}

+ (void)mountImg1:(NSString*)url1 img2:(NSString*)url2 img3:(NSString*)url3 img4:(NSString*)url4 size:(CGSize)size success:(void (^)(UIImage*,NSString*))success fail:(void (^)(NSError*))didFail
{
    dispatch_queue_t background =  dispatch_queue_create("ImageCache.Mosaicgen", NULL);
    dispatch_async(background, ^
                   {
                       // Gera nome da imagem a partir das urls
                       NSString *imageName = [self sha1:[NSString stringWithFormat:@"%@%@%@%@%@", url1, url2, url3, url4, NSStringFromCGSize(size)] border:YES];
                       
                       // Verifica existencia e carrega imagem sincronizadamente para evitar concorrencia com o cleaner
                       BOOL fileExists = NO;
                       UIImage *img;
                       @synchronized(self)
                       {
                           fileExists = [FILE_MANAGER fileExistsAtPath:IMAGE_PATH(imageName)];
                           if (fileExists)
                               img = [UIImage imageWithContentsOfFile:IMAGE_PATH(imageName)];
                       }
                       
                       // Retorna imagem local carregada acima
                       if (fileExists)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^ {
                               success(img,IMAGE_PATH(imageName));
                           });
                       }
                       
                       // Caso contrário, inicia montagem do mosaico
                       else
                       {
                           // Inicia processo em background
                           dispatch_queue_t background = dispatch_queue_create("com.beautydate.mountimg", NULL);
                           dispatch_async(background, ^
                                          {
                                              // Inicializa array de imagens
                                              NSMutableArray *imgsDownloaded = [NSMutableArray new];
                                              NSMutableArray *imgsToDownload = [NSMutableArray new];
                                              
                                              // Determina se a imagem deve ser salva (não salva caso alguma url seja nula)
                                              __block BOOL save = YES;
                                              if (!url1 || !url2 || !url3 || !url4)
                                                  save = NO;
                                              
                                              // Determina quais imagens tentará puxar (tratamento de url nula)
                                              (!url1 || url1.length == 0) ? [imgsDownloaded addObject:@{@"image": [self defaultCoverImageWithSize:size], @"index": [NSNumber numberWithInt:0]}] : [imgsToDownload addObject:@{@"url": url1, @"index":[NSNumber numberWithInt:0]}];
                                              (!url2 || url2.length == 0) ? [imgsDownloaded addObject:@{@"image": [self defaultCoverImageWithSize:size], @"index": [NSNumber numberWithInt:1]}] : [imgsToDownload addObject:@{@"url": url2, @"index":[NSNumber numberWithInt:1]}];
                                              (!url3 || url3.length == 0) ? [imgsDownloaded addObject:@{@"image": [self defaultCoverImageWithSize:size], @"index": [NSNumber numberWithInt:2]}] : [imgsToDownload addObject:@{@"url": url3, @"index":[NSNumber numberWithInt:2]}];
                                              (!url4 || url4.length == 0) ? [imgsDownloaded addObject:@{@"image": [self defaultCoverImageWithSize:size], @"index": [NSNumber numberWithInt:3]}] : [imgsToDownload addObject:@{@"url": url4, @"index":[NSNumber numberWithInt:3]}];
                                              
                                              // Entra se houver imagens para puxar
                                              if (imgsToDownload.count > 0)
                                              {
                                                  // Inicializa semáforo
                                                  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                                                  
                                                  // Puxa async cada uma das imagens - caso falhe, insere imagem padrão
                                                  for (NSDictionary *imgToDownloadDict in imgsToDownload)
                                                      [self asyncRequestImageFromStringURL:[imgToDownloadDict objectForKey:@"url"] size:CGSizeMake(size.width/2.0, size.height/2.0) border:YES forceRemote:NO success:^(UIImage *image)
                                                       {
                                                           image = [self imageWithImage:image scaledToSize:size];
                                                           [imgsDownloaded addObject:@{@"image": image, @"index": [imgToDownloadDict objectForKey:@"index"]}];
                                                           
                                                           if (imgsDownloaded.count >= 4)
                                                               dispatch_semaphore_signal(semaphore);
                                                           
                                                       } fail:^(NSError *error) {
                                                           save = NO;
                                                           [imgsDownloaded addObject:@{@"image": [self defaultCoverImageWithSize:size], @"index": [imgToDownloadDict objectForKey:@"index"]}];
                                                           
                                                           if (imgsDownloaded.count >= 4)
                                                               dispatch_semaphore_signal(semaphore);
                                                           
                                                       }];
                                                  
                                                  // Trava a thread esperando por todas as UIImages
                                                  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                                              }
                                              
                                              while (imgsDownloaded.count < 4)
                                                  [imgsDownloaded addObject:@{@"image": [self defaultCoverImageWithSize:size], @"index": [NSNumber numberWithInt:3]}];
                                              
                                              // Ordena lista de images puxadas de acordo com indice
                                              NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
                                              imgsDownloaded = (NSMutableArray*)[imgsDownloaded sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                                              
                                              // Auxiliares
                                              UIImage *img1 = [[imgsDownloaded objectAtIndex:0] objectForKey:@"image"];
                                              UIImage *img2 = [[imgsDownloaded objectAtIndex:1] objectForKey:@"image"];
                                              UIImage *img3 = [[imgsDownloaded objectAtIndex:2] objectForKey:@"image"];
                                              UIImage *img4 = [[imgsDownloaded objectAtIndex:3] objectForKey:@"image"];
                                              
                                              // Determina tamanho do mosaico final
                                              CGFloat resultWidth  = MIN(img1.size.width + img2.size.width, img3.size.width + img4.size.width);
                                              CGFloat resultHeight = MIN(img1.size.height + img3.size.height, img2.size.height + img4.size.height);
                                              CGSize size = CGSizeMake(resultWidth, resultHeight);
                                              
                                              // Abre contexto e desenha cada imagem nele
                                              CGPoint point;
                                              UIGraphicsBeginImageContext(size);
                                              
                                              point = CGPointMake(0, 0);
                                              [img1 drawAtPoint:point];
                                              
                                              point = CGPointMake(resultWidth/2.0, 0);
                                              [img2 drawAtPoint:point];
                                              
                                              point = CGPointMake(0, resultHeight/2.0);
                                              [img3 drawAtPoint:point];
                                              
                                              point = CGPointMake(resultWidth/2.0, resultHeight/2.0);
                                              [img4 drawAtPoint:point];
                                              
                                              // Obtem imagem resultado final e fecha contexto
                                              UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
                                              UIGraphicsEndImageContext();
                                              
                                              // Calcula o caminho da imagem
                                              NSString *imagePath = IMAGE_PATH(imageName);
                                              
                                              // Persiste resultado final - verifica
                                              if (!save)
                                              {
                                                  // Imagem foi gerada com alguma DEFAULT_IMG, logo não salva mas retorna o resultado para a ImageView
                                                  dispatch_async(dispatch_get_main_queue(), ^ {
                                                      success(result,nil);
                                                  });
                                              }
                                              else if (![UIImagePNGRepresentation(result) writeToFile:imagePath atomically:YES])
                                              {
                                                  // Chama bloco de falha
                                                  dispatch_async(dispatch_get_main_queue(), ^ {
                                                      didFail([NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:@{@"description": @"Could not save result image."}]);
                                                  });
                                              }
                                              else
                                              {
                                                  // Chama bloco de sucesso
                                                  dispatch_async(dispatch_get_main_queue(), ^ {
                                                      success(result,imagePath);
                                                  });
                                              }
                                          });
                       }
                   });
}

+ (UIImage*)getProfilePicture
{
    if ([FILE_MANAGER fileExistsAtPath:PROFILE_PICTURE_PATH])
        return [UIImage imageWithContentsOfFile:PROFILE_PICTURE_PATH];
    
    return DEFAULT_PROFILE_IMG;
}

+ (BOOL)saveProfilePicture:(UIImage*)image
{
    return (image) ? [UIImagePNGRepresentation(image) writeToFile:PROFILE_PICTURE_PATH atomically:YES] : NO;
}

+ (void)cleanOldFiles
{
    @synchronized(self)
    {
        dispatch_queue_t background = dispatch_queue_create("com.beautydate.cleanoldcache", NULL);
        dispatch_async(background, ^
                       {
                           NSDate *currentDate = [NSDate date];
                           
                           NSError *error;
                           NSArray *cachedFiles = [FILE_MANAGER contentsOfDirectoryAtPath:TMP_PATH error:&error];
                           
                           for (NSString *fileName in cachedFiles)
                           {
                               NSDictionary *attrs = [FILE_MANAGER attributesOfItemAtPath:IMAGE_PATH(fileName) error:&error];
                               
                               if (attrs != nil)
                               {
                                   NSDate *dateModified = (NSDate*)[attrs objectForKey:NSFileModificationDate];
                                   if ([currentDate timeIntervalSinceDate:dateModified] > MAX_IMGCACHE_TIME)
                                       [FILE_MANAGER removeItemAtPath:IMAGE_PATH(fileName) error:&error];
                               }
                           }
                       });
    }
}

+ (void)cleanAll
{
    @synchronized(self)
    {
        dispatch_queue_t background = dispatch_queue_create("com.beautydate.cleanallcache", NULL);
        dispatch_async(background, ^
                       {
                           NSError *error;
                           NSArray *cachedFiles = [FILE_MANAGER contentsOfDirectoryAtPath:TMP_PATH error:&error];
                           
                           for (NSString *fileName in cachedFiles)
                               [FILE_MANAGER removeItemAtPath:IMAGE_PATH(fileName) error:&error];
                           
                           [FILE_MANAGER removeItemAtPath:PROFILE_PICTURE_PATH error:nil];
                       });
    }
}

@end