//
//  JBMessage+NSURLConnection.m
//  JBMessage
//
//  Created by Josip Bernat on 01/10/14.
//  Copyright (c) 2014 Jospi Bernat. All rights reserved.
//

#import "JBMessage+NSURLConnection.h"
#import "AFHTTPSessionManager.h"

@implementation JBMessage (NSURLConnection)

#pragma mark - AFNetworking

- (AFURLSessionManager *)requestOperationManager {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [self httpResponseSerializer];
    
    return manager;
}

- (AFHTTPResponseSerializer <AFURLResponseSerialization> *)httpResponseSerializer {
    
    switch (self.responseSerializer) {
        case JBResponseSerializerTypeCompound:
            return [AFCompoundResponseSerializer serializer];
            
        case JBResponseSerializerTypeHTTP:
            return [AFHTTPResponseSerializer serializer];
            
        case JBResponseSerializerTypeImage:
            return [AFImageResponseSerializer serializer];
            
        case JBResponseSerializerTypeJSON:
            return [AFJSONResponseSerializer serializer];
            
        case JBResponseSerializerTypePropertyList:
            return [AFPropertyListResponseSerializer serializer];
            
        case JBResponseSerializerTypeXMLParser:
            return [AFXMLParserResponseSerializer serializer];
            
        default:
            break;
    }
}

- (AFHTTPRequestSerializer <AFURLRequestSerialization> *)httpRequestSerializer {
    
    switch (self.requestSerializer) {
        case JBRequestSerializerTypeHTTP:
            return [AFHTTPRequestSerializer serializer];
            break;
            
        case JBRequestSerializerTypeJSON:
            return [AFJSONRequestSerializer serializer];
            break;
            
        case JBRequestSerializerTypePropertyList:
            return [AFPropertyListRequestSerializer serializer];
            break;
            
        default:
            break;
    }
}

#pragma mark - Request

- (NSString *)actionUrlString {
    
    if (self.requestURL) {
        
        if (self.action) {
            return [[self.requestURL absoluteString] stringByAppendingString:self.action];
        }
        else {
            return [self.requestURL absoluteString];
        }
    }
    else {
        return [NSString stringWithFormat:@"%@%@", [[self class] registratedBaseUrl], self.action];
    }
}

- (NSMutableURLRequest *)urlRequest {
    
    NSMutableURLRequest *request = nil;
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    if (self.authorizationToken) {
        [requestSerializer setValue:self.authorizationToken forHTTPHeaderField:@"Token"];
    }

    [self.headerValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [requestSerializer setValue:obj forHTTPHeaderField:key];
    }];

    if (self.username && self.username.length &&
        self.password && self.password.length) {
        [requestSerializer setAuthorizationHeaderFieldWithUsername:self.username
                                                          password:self.password];
    }
    
    
    
    
    if (!self.inputFileURL || self.httpMethod == JBHTTPMethodGET) {
        
        NSError *error = nil;
        request = [requestSerializer requestWithMethod:self.httpMethod
                                                                URLString:[self actionUrlString]
                                                               parameters:self.parameters
                                                                    error:&error];
        
#ifdef DEBUG
        if (error) { NSLog(@"Error while creating request: %@", error); }
#endif
        
    }
    else {
        
        __weak id this = self;
        NSError *multpartError = nil;
        
        request = [requestSerializer multipartFormRequestWithMethod:self.httpMethod
                                                                             URLString:[self actionUrlString]
                                                                            parameters:self.parameters
                                                             constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            __strong JBMessage *strongThis = this;
            [formData appendPartWithFileURL:strongThis.inputFileURL
                                       name:strongThis.filename
                                      error:nil];
        } error:&multpartError];
        
        
#ifdef DEBUG
        if (multpartError) { NSLog(@"Error while creating multpart form request: %@", multpartError); }
#endif
        
    }
    
    request.timeoutInterval = self.timeoutInterval;
    
    return request;
}

@end
