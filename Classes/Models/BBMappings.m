/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBMappings.h"

@implementation BBMappings

-(void)mappingsForRKManager:(RKObjectManager*)manager
{
    
    // Image mapping
    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[BBImage class]];
    [imageMapping mapKeyOfNestedDictionaryToAttribute:@"imageDimensionName"];
    [imageMapping mapKeyPath:@"(imageDimensionName).FileName" toAttribute:@"fileName"];
    [imageMapping mapKeyPath:@"(imageDimensionName).RelativeUri" toAttribute:@"relativeUri"];
    [imageMapping mapKeyPath:@"(imageDimensionName).Format" toAttribute:@"format"];
    [imageMapping mapKeyPath:@"(imageDimensionName).Width" toAttribute:@"width"];
    [imageMapping mapKeyPath:@"(imageDimensionName).Height" toAttribute:@"height"];
    [imageMapping mapKeyPath:@"(imageDimensionName).Extension" toAttribute:@"extension"];
    [imageMapping mapKeyPath:@"(imageDimensionName).Size" toAttribute:@"size"];
    [imageMapping mapKeyPath:@"(imageDimensionName).OriginalFilename" toAttribute:@"originalFileName"];
    [imageMapping mapKeyPath:@"(imageDimensionName).ExifData" toAttribute:@"ExifData"];
    [manager.mappingProvider setMapping:imageMapping forKeyPath:@"Image"];
 

    // Avatar has a bunch of images
    RKObjectMapping *mediaResourceMapping = [RKObjectMapping mappingForClass:[BBMediaResource class]];
    [mediaResourceMapping mapKeyPath:@"MediaType" toAttribute:@"mediaType"];
    [mediaResourceMapping mapKeyPath:@"UploadedOn" toAttribute:@"uploadedOn"];
    [mediaResourceMapping mapKeyPath:@"Metadata" toAttribute:@"metaData"];
    [mediaResourceMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [mediaResourceMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [mediaResourceMapping mapKeyPath:@"Image" toRelationship:@"media" withMapping:imageMapping];
    [manager.mappingProvider setMapping:mediaResourceMapping forKeyPath:@"Avatar"];
    
    
    // userMapping has an image
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[BBUser class]];
    [userMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [userMapping mapKeyPath:@"FirstName" toAttribute:@"firstName"];
    [userMapping mapKeyPath:@"LastName" toAttribute:@"lastName"];
    [userMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:userMapping forKeyPath:@"User"];
    
    
    // Project has an avatar
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[BBProject class]];
    [projectMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [projectMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [projectMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"MemberCount" toAttribute:@"memberCount"];
    [projectMapping mapKeyPath:@"PostCount" toAttribute:@"postCount"];
    [projectMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:projectMapping forKeyPath:@"Project"];

    
    // This does not seem likely to work. Does it require these drill downs? How to retreive the PagedListItems... via Delegate?
    RKObjectMapping *projectsPagination = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
    projectsPagination.rootKeyPath = @"Model.Projects";
    [projectsPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [projectsPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [projectsPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [projectsPagination mapKeyPath:@"PagedListItems" toRelationship:@"projects" withMapping:projectMapping];
    [manager.mappingProvider setMapping:projectsPagination forKeyPath:@"Model.Projects"];
    
    
    // This is for the base model responder for all the ajax crapsky..
//    RKObjectMapping *modelMapping = [RKObjectMapping mappingForClass:[BBBaseModel class]];
//    [manager.mappingProvider setMapping:modelMapping forKeyPath:@""];
}

@end