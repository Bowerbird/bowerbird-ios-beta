/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBMappings.h"

@implementation BBMappings

+(void)mappingsForRKManager:(RKObjectManager*)manager
{
    
    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[BBImage class]];
    imageMapping.forceCollectionMapping = YES;
    [imageMapping mapKeyOfNestedDictionaryToAttribute:@"dimensionName"];
    [imageMapping mapKeyPath:@"(dimensionName).Uri" toAttribute:@"uri"];
    [imageMapping mapKeyPath:@"(dimensionName).Width" toAttribute:@"width"];
    [imageMapping mapKeyPath:@"(dimensionName).Height" toAttribute:@"height"];
    [imageMapping mapKeyPath:@"(dimensionName).MimeType" toAttribute:@"mimeType"];
    [manager.mappingProvider setMapping:imageMapping forKeyPath:@"Image"];
    [manager.mappingProvider addObjectMapping:imageMapping];


    RKObjectMapping *mediaResourceMapping = [RKObjectMapping mappingForClass:[BBMediaResource class]];
    [mediaResourceMapping mapKeyPath:@"MediaResourceType" toAttribute:@"mediaType"];
    [mediaResourceMapping mapKeyPath:@"UploadedOn" toAttribute:@"uploadedOn"];
    [mediaResourceMapping mapKeyPath:@"Metadata" toAttribute:@"metaData"];
    [mediaResourceMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [mediaResourceMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [mediaResourceMapping mapKeyPath:@"Image" toRelationship:@"imageMedia" withMapping:imageMapping];
    [manager.mappingProvider addObjectMapping:mediaResourceMapping];
    

    RKObjectMapping *mediaMapping = [RKObjectMapping mappingForClass:[BBMedia class]];
    [mediaMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [mediaMapping mapKeyPath:@"IsPrimaryMedia" toAttribute:@"isPrimaryMedia"];
    [mediaMapping mapKeyPath:@"Licence" toAttribute:@"licence"];
    [mediaMapping mapKeyPath:@"MediaResource" toRelationship:@"mediaResource" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:mediaMapping forKeyPath:@"Media"];
    [manager.mappingProvider addObjectMapping:mediaMapping];
    
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[BBUser class]];
    [userMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [userMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"LatestActivity" toAttribute:@"latestActivity"];
    [userMapping mapKeyPath:@"LatestHeartbeat" toAttribute:@"latestHeartbeat"];
    [userMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:userMapping forKeyPath:@"User"];
    [manager.mappingProvider addObjectMapping:userMapping];
    
    
    RKObjectMapping *membershipMapping = [RKObjectMapping mappingForClass:[BBMembership class]];
    [membershipMapping mapKeyPath:@"GroupId" toAttribute:@"groupId"];
    [membershipMapping mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [membershipMapping mapKeyPath:@"PermissionIds" toAttribute:@"permissions"];
    [membershipMapping mapKeyPath:@"RoleIds" toAttribute:@"roleIds"];
    [manager.mappingProvider setMapping:membershipMapping forKeyPath:@"Memberships"];
    [manager.mappingProvider addObjectMapping:membershipMapping];
    
    
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[BBCategory class]];
    [categoryMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [categoryMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [categoryMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [manager.mappingProvider setMapping:categoryMapping forKeyPath:@"Categories"];
    [manager.mappingProvider addObjectMapping:categoryMapping];
    
    
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[BBProject class]];
    [projectMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [projectMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [projectMapping mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [projectMapping mapKeyPath:@"MemberCount" toAttribute:@"memberCount"];
    [projectMapping mapKeyPath:@"ObservationCount" toAttribute:@"observationCount"];
    [projectMapping mapKeyPath:@"PostCount" toAttribute:@"postCount"];
    [projectMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:projectMapping forKeyPath:@"Project"];
    [manager.mappingProvider addObjectMapping:projectMapping];

    
    RKObjectMapping *authenticatedUser = [RKObjectMapping mappingForClass:[BBAuthenticatedUser class]];
    authenticatedUser.rootKeyPath = @"Model.AuthenticatedUser";
    [authenticatedUser mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [authenticatedUser mapKeyPath:@"AppRoot.Categories" toRelationship:@"categories" withMapping:categoryMapping];
    [authenticatedUser mapKeyPath:@"Projects" toRelationship:@"projects" withMapping:projectMapping];
    [authenticatedUser mapKeyPath:@"Memberships" toRelationship:@"memberships" withMapping:membershipMapping];
    [authenticatedUser mapKeyPath:@"DefaultLicence" toAttribute:@"defaultLicence"];
    [manager.mappingProvider setMapping:authenticatedUser forKeyPath:@"Model.AuthenticatedUser"];
    [manager.mappingProvider addObjectMapping:authenticatedUser];
    
    
    RKObjectMapping *authenticationMapping = [RKObjectMapping mappingForClass:[BBAuthentication class]];
    //authenticationMapping.rootKeyPath = @"Model";
    [authenticationMapping mapKeyPath:@"User" toRelationship:@"authenticatedUser" withMapping:userMapping];
    [manager.mappingProvider setMapping:authenticationMapping forKeyPath:@"Model.User"];
    [manager.mappingProvider addObjectMapping:authenticationMapping];
    
    
    RKObjectMapping *taxonomicRankMapping = [RKObjectMapping mappingForClass:[BBTaxonomicRanks class]];
    [taxonomicRankMapping mapKeyPath:@"RankName" toAttribute:@"rankName"];
    [taxonomicRankMapping mapKeyPath:@"RankType" toAttribute:@"rankType"];
    [manager.mappingProvider setMapping:taxonomicRankMapping forKeyPath:@"TaxonomicRanks"];
    
    
    RKObjectMapping *identificationMapping = [RKObjectMapping mappingForClass:[BBIdentification class]];
    [identificationMapping mapKeyPath:@"Category" toAttribute:@"category"];
    [identificationMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [identificationMapping mapKeyPath:@"RankName" toAttribute:@"rankName"];
    [identificationMapping mapKeyPath:@"RankType" toAttribute:@"rankType"];
    [identificationMapping mapKeyPath:@"CommonGroupNames" toAttribute:@"commonGroupNames"];
    [identificationMapping mapKeyPath:@"CommonNames" toAttribute:@"commonNames"];
    [identificationMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [identificationMapping mapKeyPath:@"TaxonomicRanks" toRelationship:@"taxonomicRanks" withMapping:taxonomicRankMapping];
    [identificationMapping mapKeyPath:@"Synonyms" toAttribute:@"synonyms"];
    [identificationMapping mapKeyPath:@"AllCommonNames" toAttribute:@"allCommonNames"];
    [manager.mappingProvider setMapping:identificationMapping forKeyPath:@"Identification"];
    [manager.mappingProvider addObjectMapping:identificationMapping];
    
    
    RKObjectMapping *sightingNoteDescriptionMapping = [RKObjectMapping mappingForClass:[BBSightingNoteDescription class]];
    [manager.mappingProvider setMapping:sightingNoteDescriptionMapping forKeyPath:@"Descriptions"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Group" toAttribute:@"group"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Label" toAttribute:@"label"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [sightingNoteDescriptionMapping mapKeyPath:@"Text" toAttribute:@"text"];
    [manager.mappingProvider addObjectMapping:sightingNoteDescriptionMapping];
    
    
    RKObjectMapping *observationMapping = [RKObjectMapping mappingForClass:[BBObservation class]];
    [manager.mappingProvider setMapping:observationMapping forKeyPath:@"Observation"];
    [observationMapping mapKeyPath:@"ObservedOn" toAttribute:@"observedOnDate"];
    [observationMapping mapKeyPath:@"Title" toAttribute:@"title"];
    [observationMapping mapKeyPath:@"Address" toAttribute:@"address"];
    [observationMapping mapKeyPath:@"AnonymiseLocation" toAttribute:@"anonymiseLocation"];
    [observationMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [observationMapping mapKeyPath:@"IsIdentificationRequired" toAttribute:@"isIdentificationRequired"];
    [observationMapping mapKeyPath:@"Latitude" toAttribute:@"latitude"];
    [observationMapping mapKeyPath:@"Longitude" toAttribute:@"longitude"];
    [observationMapping mapKeyPath:@"Category" toAttribute:@"category"];
    [observationMapping mapKeyPath:@"Media" toRelationship:@"media" withMapping:mediaMapping];
    [observationMapping mapKeyPath:@"PrimaryMedia" toRelationship:@"primaryMedia" withMapping:mediaMapping];
    [manager.mappingProvider addObjectMapping:observationMapping];
    
    
//    RKObjectMapping *observationInsideNoteMapping = [RKObjectMapping mappingForClass:[BBObservation class]];
//    //[manager.mappingProvider setMapping:observationInsideNoteMapping forKeyPath:@"Sighting"];
//    [observationInsideNoteMapping mapKeyPath:@"ObservedOn" toAttribute:@"observedOnDate"];
//    [observationInsideNoteMapping mapKeyPath:@"Title" toAttribute:@"title"];
//    [observationInsideNoteMapping mapKeyPath:@"Address" toAttribute:@"address"];
//    [observationInsideNoteMapping mapKeyPath:@"AnonymiseLocation" toAttribute:@"anonymiseLocation"];
//    [observationInsideNoteMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
//    [observationInsideNoteMapping mapKeyPath:@"IsIdentificationRequired" toAttribute:@"isIdentificationRequired"];
//    [observationInsideNoteMapping mapKeyPath:@"Latitude" toAttribute:@"latitude"];
//    [observationInsideNoteMapping mapKeyPath:@"Longitude" toAttribute:@"longitude"];
//    [observationInsideNoteMapping mapKeyPath:@"Category" toAttribute:@"category"];
//    [observationInsideNoteMapping mapKeyPath:@"Media" toRelationship:@"media" withMapping:mediaMapping];
//    [observationInsideNoteMapping mapKeyPath:@"PrimaryMedia" toRelationship:@"primaryMedia" withMapping:mediaMapping];
//    //[manager.mappingProvider setSerializationMapping:[observationMapping inverseMapping] forClass:[BBObservation class]];
    
    
    
    RKObjectMapping *observationNoteMapping = [RKObjectMapping mappingForClass:[BBObservationNote class]];
    [manager.mappingProvider setMapping:observationNoteMapping forKeyPath:@"SightingNote"];
    [observationNoteMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [observationNoteMapping mapKeyPath:@"CreatedOn" toAttribute:@"createdOn"];
    [observationNoteMapping mapKeyPath:@"Identification" toRelationship:@"identification" withMapping:identificationMapping]; //toAttribute:@"identification"];
    [observationNoteMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [observationNoteMapping mapKeyPath:@"Descriptions" toRelationship:@"descriptions" withMapping:sightingNoteDescriptionMapping];
    [observationNoteMapping mapKeyPath:@"Tags" toAttribute:@"tags"];
    [observationNoteMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [observationNoteMapping mapKeyPath:@"TagCount" toAttribute:@"tagCount"];
    [observationNoteMapping mapKeyPath:@"DescriptionCount" toAttribute:@"descriptionCount"];
    [observationNoteMapping mapKeyPath:@"AllTags" toAttribute:@"allTags"];
    [manager.mappingProvider addObjectMapping:observationNoteMapping];
    
    
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[BBActivity class]];
    [activityMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [activityMapping mapKeyPath:@"CreatedDateTime" toAttribute:@"createdOn"];
    [activityMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [activityMapping mapKeyPath:@"CreatedDateTimeOrder" toAttribute:@"order"];
    [activityMapping mapKeyPath:@"Type" toAttribute:@"type"];
    [activityMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [activityMapping mapKeyPath:@"ObservationAdded.Observation" toRelationship:@"observation" withMapping:observationMapping];
    [activityMapping mapKeyPath:@"SightingNoteAdded.SightingNote" toRelationship:@"observationNote" withMapping:observationNoteMapping];
    [activityMapping mapKeyPath:@"SightingNoteAdded.Sighting" toRelationship:@"observationNoteObservation" withMapping:observationMapping];
    [manager.mappingProvider setSerializationMapping:activityMapping forClass:[BBActivity class]];
    
    
    
    RKObjectMapping *projectPaginationMapping = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
    projectPaginationMapping.rootKeyPath = @"Model.Projects";
    [projectPaginationMapping mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [projectPaginationMapping mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [projectPaginationMapping mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [projectPaginationMapping mapKeyPath:@"PagedListItems" toRelationship:@"projects" withMapping:projectMapping];
    [manager.mappingProvider setMapping:projectPaginationMapping forKeyPath:@"Model.Projects"];
    
        
    
    RKObjectMapping *activityPaginationMapping = [RKObjectMapping mappingForClass:[BBActivityPaginator class]];
    activityPaginationMapping.rootKeyPath = @"Model.Activities";
    [activityPaginationMapping mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [activityPaginationMapping mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [activityPaginationMapping mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [activityPaginationMapping mapKeyPath:@"PagedListItems" toRelationship:@"activities" withMapping:activityMapping];
    [manager.mappingProvider setMapping:activityPaginationMapping forKeyPath:@"Model.Activities"];

    
    
    RKObjectMapping *sightingPaginationMapping = [RKObjectMapping mappingForClass:[BBSightingPaginator class]];
    sightingPaginationMapping.rootKeyPath = @"Model.Sightings";
    [sightingPaginationMapping mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [sightingPaginationMapping mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [sightingPaginationMapping mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [sightingPaginationMapping mapKeyPath:@"Model.PagedListItems" toRelationship:@"activities" withMapping:activityMapping];
    [manager.mappingProvider setMapping:sightingPaginationMapping forKeyPath:@"Model.Sightings"];

    
    
    RKObjectMapping *jsonResponseMapping = [RKObjectMapping mappingForClass:[BBJsonResponse class]];
    jsonResponseMapping.rootKeyPath = @"Model.JsonResult";
    [jsonResponseMapping mapKeyPath:@"Success" toAttribute:@"success"];
    [jsonResponseMapping mapKeyPath:@"Action" toAttribute:@"action"];
    [manager.mappingProvider setMapping:jsonResponseMapping forKeyPath:@"Model.JsonResult"];
    [manager.mappingProvider setSerializationMapping:[jsonResponseMapping inverseMapping] forClass:[BBJsonResponse class]];
    
    
    RKObjectMapping *mediaResourceCreateMapping = [RKObjectMapping mappingForClass:[BBMediaResourceCreate class]];
    [mediaResourceCreateMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [mediaResourceCreateMapping mapKeyPath:@"Type" toAttribute:@"type"];
    [mediaResourceCreateMapping mapKeyPath:@"Usage" toAttribute:@"usage"];
    [mediaResourceCreateMapping mapKeyPath:@"File" toAttribute:@"file"];
    [mediaResourceCreateMapping mapKeyPath:@"FileName" toAttribute:@"fileName"];
    [manager.mappingProvider addObjectMapping:mediaResourceCreateMapping];
    [manager.mappingProvider setSerializationMapping:[mediaResourceCreateMapping inverseMapping] forClass:[BBMediaResourceCreate class]];
    
    
    RKObjectMapping *observationMediaCreateMapping = [RKObjectMapping mappingForClass:[BBObservationMediaCreate class]];
    observationMediaCreateMapping.rootKeyPath = @"Media";
    [observationMediaCreateMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [observationMediaCreateMapping mapKeyPath:@"MediaResourceId" toAttribute:@"mediaResourceId"];
    [observationMediaCreateMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [observationMediaCreateMapping mapKeyPath:@"Licence" toAttribute:@"licence"];
    [observationMediaCreateMapping mapKeyPath:@"IsPrimaryMedia" toAttribute:@"isPrimaryMedia"];
    [manager.mappingProvider addObjectMapping:observationMediaCreateMapping];
    [manager.mappingProvider setSerializationMapping:[observationMediaCreateMapping inverseMapping] forClass:[BBObservationMediaCreate class]];
    
    
    RKObjectMapping *observationCreateMapping = [RKObjectMapping mappingForClass:[BBObservationCreate class]];
    [observationCreateMapping mapKeyPath:@"Title" toAttribute:@"title"];
    [observationCreateMapping mapKeyPath:@"ObservedOn" toAttribute:@"observedOn"];
    [observationCreateMapping mapKeyPath:@"Latitude" toAttribute:@"latitude"];
    [observationCreateMapping mapKeyPath:@"Longitude" toAttribute:@"longitude"];
    [observationCreateMapping mapKeyPath:@"Address" toAttribute:@"address"];
    [observationCreateMapping mapKeyPath:@"IsIdentificationRequired" toAttribute:@"isIdentificationRequired"];
    [observationCreateMapping mapKeyPath:@"AnonymiseLocation" toAttribute:@"anonymiseLocation"];
    [observationCreateMapping mapKeyPath:@"Category" toAttribute:@"category"];
    [observationCreateMapping mapKeyPath:@"Media" toRelationship:@"media" withMapping:observationMediaCreateMapping];
    [observationCreateMapping mapKeyPath:@"ProjectIds" toAttribute:@"projectIds"];
    [manager.mappingProvider addObjectMapping:observationCreateMapping];
    [manager.mappingProvider setSerializationMapping:[observationCreateMapping inverseMapping] forClass:[BBObservationCreate class]];
    
    
    
    RKObjectMapping *modelIdMapping = [RKObjectMapping mappingForClass:[BBModelId class]];
    [modelIdMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [manager.mappingProvider addObjectMapping:modelIdMapping];
    [manager.mappingProvider setSerializationMapping:modelIdMapping forClass:[BBModelId class]];
    
    
    
    [manager.router routeClass:[BBMediaResourceCreate class] toResourcePath:@"/mediaresources/create" forMethod:RKRequestMethodPOST];
    [manager.router routeClass:[BBObservationCreate class] toResourcePath:@"/observations/create" forMethod:RKRequestMethodPOST];
}

@end