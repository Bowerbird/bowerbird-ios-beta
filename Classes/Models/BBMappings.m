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
    
    
    // Map the user's memberships
    RKObjectMapping *membership = [RKObjectMapping mappingForClass:[BBMembership class]];
    [membership mapKeyPath:@"GroupId" toAttribute:@"groupId"];
    [membership mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [membership mapKeyPath:@"PermissionIds" toAttribute:@"permissions"];
    [membership mapKeyPath:@"RoleIds" toAttribute:@"roleIds"];
    [manager.mappingProvider setMapping:membership forKeyPath:@"Memberships"];
    
    
    // Project has an avatar
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[BBProject class]];
    [projectMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [projectMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [projectMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"MemberCount" toAttribute:@"memberCount"];
    [projectMapping mapKeyPath:@"PostCount" toAttribute:@"postCount"];
    [projectMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:projectMapping forKeyPath:@"Project"];

    
    // Map a paged project list
    RKObjectMapping *projectsPagination = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
    projectsPagination.rootKeyPath = @"Model.Projects";
    [projectsPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [projectsPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [projectsPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [projectsPagination mapKeyPath:@"PagedListItems" toRelationship:@"projects" withMapping:projectMapping];
    [manager.mappingProvider setMapping:projectsPagination forKeyPath:@"Model.Projects"];
    
    
    // Map the Authenticated user
    RKObjectMapping *authenticatedUser = [RKObjectMapping mappingForClass:[BBAuthenticatedUser class]];
    authenticatedUser.rootKeyPath = @"Model";
    [authenticatedUser mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [authenticatedUser mapKeyPath:@"AppRoot.Categories" toAttribute:@"categories"];
    [authenticatedUser mapKeyPath:@"Projects" toRelationship:@"projects" withMapping:projectMapping];
    [authenticatedUser mapKeyPath:@"Memberships" toRelationship:@"memberships" withMapping:membership];
    [manager.mappingProvider setMapping:authenticatedUser forKeyPath:@"Model.AuthenticatedUser"];
    [manager.mappingProvider setSerializationMapping:authenticatedUser forClass:[BBAuthenticatedUser class]];
    
    
    // Map the Observation
    RKObjectMapping *observation = [RKObjectMapping mappingForClass:[BBObservation class]];
    [manager.mappingProvider setMapping:observation forKeyPath:@"ObservationAdded"];
    [manager.mappingProvider setSerializationMapping:observation forClass:[BBObservation class]];
    
    
    // Map the Authentication response
    RKObjectMapping *authentication = [RKObjectMapping mappingForClass:[BBAuthentication class]];
    authentication.rootKeyPath = @"Model";
    [authentication mapKeyPath:@"User" toRelationship:@"authenticatedUser" withMapping:userMapping];
    [manager.mappingProvider setMapping:authentication forKeyPath:@"Model.User"];
    [manager.mappingProvider setSerializationMapping:authentication forClass:[BBAuthentication class]];
    
    
    // Map the Login Request
    RKObjectMapping *loginRequest = [RKObjectMapping mappingForClass:[BBLoginRequest class]];
    [loginRequest mapKeyPath:@"email" toAttribute:@"email"];
    [loginRequest mapKeyPath:@"password" toAttribute:@"password"];
    [manager.mappingProvider setMapping:loginRequest forKeyPath:@"Login"];
    
    
    // Map the Activity
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[BBActivity class]];
    
    [manager.mappingProvider setMapping:activityMapping forKeyPath:@"Activities"];
    [manager.mappingProvider setSerializationMapping:activityMapping forClass:[BBActivity class]];
    
    
    // Map the Activity paginator
    RKObjectMapping *activityPagination = [RKObjectMapping mappingForClass:[BBActivityPaginator class]];
    activityPagination.rootKeyPath = @"Model.Activities";
    [activityPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [activityPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [activityPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [activityPagination mapKeyPath:@"PagedListItems" toRelationship:@"activities" withMapping:activityMapping];
    [manager.mappingProvider setSerializationMapping:activityPagination forClass:[BBActivityPaginator class]];
    
}

@end