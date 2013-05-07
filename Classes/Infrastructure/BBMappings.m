/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBMappings.h"
#import "BBModels.h"


@implementation BBMappings

+(void)mappingsForRKManager:(RKObjectManager*)manager
{
    
    /* BBValidationError */
    
    RKObjectMapping *validationErrorMapping = [RKObjectMapping mappingForClass:[BBValidationError class]];
    [validationErrorMapping addAttributeMappingsFromDictionary:@{
        @"Field" : @"field",
        @"Messages" : @"messages"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:validationErrorMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Errors"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBAudio */
    
    RKObjectMapping *audioMapping = [RKObjectMapping mappingForClass:[BBAudio class]];
    audioMapping.forceCollectionMapping = YES;
    [audioMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"dimensionName"];
    [audioMapping addAttributeMappingsFromDictionary:@{
        @"(dimensionName).Uri" : @"uri",
        @"(dimensionName).Width" : @"width",
        @"(dimensionName).Height" : @"height"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:audioMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Audio"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    /* BBVideo */
    
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[BBVideo class]];
    videoMapping.forceCollectionMapping = YES;
    [videoMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"dimensionName"];
    [videoMapping addAttributeMappingsFromDictionary:@{
        @"(dimensionName).Uri" : @"uri",
        @"(dimensionName).Width" : @"width",
        @"(dimensionName).Height" : @"height"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:videoMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Video"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    /* BBImage */
    
    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[BBImage class]];
    imageMapping.forceCollectionMapping = YES;
    [imageMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"dimensionName"];
    [imageMapping addAttributeMappingsFromDictionary:@{
        @"(dimensionName).Uri" : @"uri",
        @"(dimensionName).Width" : @"width",
        @"(dimensionName).Height" : @"height",
        @"(dimensionName).MimeType" : @"mimeType"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:imageMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Image"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    /* BBMediaResource */
     
    RKObjectMapping *mediaResourceMapping = [RKObjectMapping mappingForClass:[BBMediaResource class]];
    [mediaResourceMapping addAttributeMappingsFromDictionary:@{
        @"MediaResourceType" : @"mediaType",
        @"UploadedOn" : @"uploadedOn",
        @"Metadata" : @"metaData",
        @"Key" : @"key",
        @"Id" : @"identifier"
     }];
    [mediaResourceMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Image" toKeyPath:@"imageMedia" withMapping:imageMapping]];
    [mediaResourceMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Video" toKeyPath:@"videoMedia" withMapping:videoMapping]];
    [mediaResourceMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Audio" toKeyPath:@"audioMedia" withMapping:audioMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:mediaResourceMapping
                                                                           pathPattern:nil
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBMedia */

    RKObjectMapping *mediaMapping = [RKObjectMapping mappingForClass:[BBMedia class]];
    [mediaMapping addAttributeMappingsFromDictionary:@{
        @"Description" : @"description",
        @"IsPrimaryMedia" : @"isPrimaryMedia",
        @"Licence" : @"licence"
     }];
    [mediaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Media" toKeyPath:@"media" withMapping:mediaResourceMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:mediaMapping
                                                                           pathPattern:nil
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBUser */
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[BBUser class]];
    [userMapping addAttributeMappingsFromDictionary:@{
        @"Id" : @"identifier",
        @"Name" : @"name"
     }];
    [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Avatar" toKeyPath:@"avatar" withMapping:mediaResourceMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Model.User"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    /* BBMembership */
    
    RKObjectMapping *membershipMapping = [RKObjectMapping mappingForClass:[BBMembership class]];
    [membershipMapping addAttributeMappingsFromDictionary:@{
        @"GroupId" : @"groupId",
        @"GroupType" : @"groupType",
        @"PermissionIds" : @"permissions",
        @"RoleIds" : @"roleIds"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:membershipMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Memberships"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    

    /* BBCategory */

    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[BBCategory class]];
    [categoryMapping addAttributeMappingsFromDictionary:@{
        @"Id" : @"identifier",
        @"Name" : @"name",
        @"Taxonomy" : @"taxonomy"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:categoryMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Categories"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    /* BBGroup */

    RKObjectMapping *groupMapping = [RKObjectMapping mappingForClass:[BBGroup class]];
    [groupMapping addAttributeMappingsFromDictionary:@{
        @"Id" : @"identifier",
        @"Name" : @"name",
        @"GroupType" : @"groupType"
     }];
    [groupMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Avatar" toKeyPath:@"avatar" withMapping:mediaResourceMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:groupMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Group"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBProject */
    
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[BBProject class]];
    [projectMapping addAttributeMappingsFromDictionary:@{
        @"Id" : @"identifier",
        @"Name" : @"name",
        @"GroupType" : @"groupType",
        @"UserCount" : @"userCount",
        @"SightingCount" : @"observationCount",
        @"PostCount" : @"postCount",
        @"Description" : @"description"
     }];
    [projectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Avatar" toKeyPath:@"avatar" withMapping:mediaResourceMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:projectMapping
                                                                           pathPattern:@"projects/:\\identifier" // the double back slash should escape the /projects/project/332 convention of using forward slashes in Raven Ids
                                                                               keyPath:@"Project"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBAuthenticatedUser */
    
    RKObjectMapping *authenticatedUserMapping = [RKObjectMapping mappingForClass:[BBAuthenticatedUser class]];
    [authenticatedUserMapping addAttributeMappingsFromDictionary:@{
        @"DefaultLicence" : @"defaultLicence"
     }];
    [authenticatedUserMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"User" toKeyPath:@"user" withMapping:userMapping]];
    [authenticatedUserMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"AppRoot.Categories" toKeyPath:@"catagories" withMapping:categoryMapping]];
    [authenticatedUserMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Projects" toKeyPath:@"projects" withMapping:projectMapping]];
    [authenticatedUserMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Memberships" toKeyPath:@"memberships" withMapping:membershipMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:authenticatedUserMapping
                                                                           pathPattern:@"/account/profile"
                                                                               keyPath:@"Model.AuthenticatedUser"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBAuthentication */
    
    RKObjectMapping *authenticationMapping = [RKObjectMapping mappingForClass:[BBAuthentication class]];
    [authenticationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"User" toKeyPath:@"authenticatedUser" withMapping:userMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:authenticationMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Model.User"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBTaxonomicRanks */
    
    RKObjectMapping *taxonomicRankMapping = [RKObjectMapping mappingForClass:[BBTaxonomicRanks class]];
    [taxonomicRankMapping addAttributeMappingsFromDictionary:@{
        @"RankName" :@"name",
        @"RankType" :@"type"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:taxonomicRankMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"TaxonomicRanks"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    RKObjectMapping *identificationMapping = [RKObjectMapping mappingForClass:[BBIdentification class]];
    [identificationMapping addAttributeMappingsFromDictionary:@{
         @"IsCustomIdentification" :@"isCustomIdentification",
         @"Category" :@"category",
         @"Name" :@"name",
         @"RankName" :@"rankName",
         @"RankType" :@"rankType",
         @"CommonGroupNames" :@"commonGroupNames",
         @"CommonNames" :@"commonNames",
         @"Taxonomy" :@"taxonomy",
         @"Synonyms" :@"synonyms",
         @"AllCommonNames" :@"allCommonNames",
         @"Comments" :@"comments",
         @"CreatedOnDescription" :@"createdOnDescription",
         @"TotalVoteScore" :@"totalVoteScore",
         @"UserVoteScore" :@"userVoteScore",
         @"SightingId" :@"sightingId",
         @"Id" :@"identifier"
     }];
    [identificationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Ranks" toKeyPath:@"ranks" withMapping:taxonomicRankMapping]];
    [identificationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"User" toKeyPath:@"user" withMapping:userMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:identificationMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Identification"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    /* BBSightingNoteDescription */
    
    RKObjectMapping *sightingNoteDescriptionMapping = [RKObjectMapping mappingForClass:[BBSightingNoteDescription class]];
    [sightingNoteDescriptionMapping addAttributeMappingsFromDictionary:@{
        @"Id" :@"identifier",
        @"Group" :@"group",
        @"Label" :@"label",
        @"Description" :@"description",
        @"Name" :@"name",
        @"Text" :@"text"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:sightingNoteDescriptionMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Descriptions"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBObservationNote */
    
    RKObjectMapping *observationNoteMapping = [RKObjectMapping mappingForClass:[BBObservationNote class]];
    [observationNoteMapping addAttributeMappingsFromDictionary:@{
     @"Id" : @"identifier",
     @"CreatedOn" : @"createdOn",
     @"NoteComments" : @"noteComments",
     @"Tags" : @"tags",
     @"TagCount" : @"tagCount",
     @"DescriptionCount" : @"descriptionCount",
     @"AllTags" : @"allTags",
     @"TotalVoteScore" : @"totalVoteScore",
     @"UserVoteScore" : @"userVoteScore",
     @"SightingId" : @"sightingId"
     }];
    [observationNoteMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Descriptions" toKeyPath:@"descriptions" withMapping:sightingNoteDescriptionMapping]];
    [observationNoteMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"User" toKeyPath:@"user" withMapping:userMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:observationNoteMapping
                                                                           pathPattern:nil
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBObservation */
    
    RKObjectMapping *observationMapping = [RKObjectMapping mappingForClass:[BBObservation class]];
    [observationMapping addAttributeMappingsFromDictionary:@{
        @"ObservedOn" :@"observedOnDate",
        @"Title" :@"title",
        @"Address" :@"address",
        @"AnonymiseLocation" :@"anonymiseLocation",
        @"Id" :@"identifier",
        @"IsIdentificationRequired" :@"isIdentificationRequired",
        @"Latitude" :@"latitude",
        @"Longitude" :@"longitude",
        @"Category" :@"category",
        @"CommentCount" :@"commentCount",
        @"ProjectCount" :@"projectCount",
        @"NoteCount" :@"noteCount",
        @"IdentificationCount" :@"identificationCount",
        @"TotalVoteScore" :@"totalVoteScore",
        @"UserVoteScore" :@"userVoteScore",
        @"UserFavourited" :@"userFavourited",
        @"FavouritesCount" :@"favouritesCount"
     }];
    [observationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Media" toKeyPath:@"media" withMapping:mediaMapping]];
    [observationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PrimaryMedia" toKeyPath:@"primaryMedia" withMapping:mediaMapping]];
    [observationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"User" toKeyPath:@"user" withMapping:userMapping]];
    [observationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Projects" toKeyPath:@"projects" withMapping:projectMapping]];
    [observationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Notes" toKeyPath:@"notes" withMapping:observationNoteMapping]];
    [observationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Identifications" toKeyPath:@"identifications" withMapping:identificationMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:observationMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Model.Observation"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBPost */

    RKObjectMapping *postMapping = [RKObjectMapping mappingForClass:[BBPost class]];
    [postMapping addAttributeMappingsFromDictionary:@{
        @"Id" :@"identifier",
        @"CreatedOnDescription" :@"createdOnDescription",
        @"GroupId" :@"groupId",
        @"Message" :@"message",
        @"PostType" :@"postType",
        @"Subject" :@"subject"
     }];
    [postMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Group" toKeyPath:@"group" withMapping:groupMapping]];
    [postMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"User" toKeyPath:@"user" withMapping:userMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                           pathPattern:nil
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBActivity */
    
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[BBActivity class]];
    [activityMapping addAttributeMappingsFromDictionary:@{
        @"Id" :@"identifier",
        @"CreatedDateTime" :@"createdOn",
        @"Description" :@"description",
        @"CreatedDateTimeOrder" :@"order",
        @"Type" :@"type",
        @"DeletedActivityItem.Message" :@"deleted"
     }];
    [activityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"User" toKeyPath:@"user" withMapping:userMapping]];
    [activityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ObservationAdded.Observation" toKeyPath:@"observation" withMapping:observationMapping]];
    [activityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"SightingNoteAdded.SightingNote" toKeyPath:@"observationNote" withMapping:observationNoteMapping]];
    [activityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"SightingNoteAdded.Sighting" toKeyPath:@"observationNoteObservation" withMapping:observationMapping]];
    [activityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"IdentificationAdded.Sighting" toKeyPath:@"identificationObservation" withMapping:observationMapping]];
    [activityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"IdentificationAdded.Identification" toKeyPath:@"identification" withMapping:identificationMapping]];
    [activityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PostAdded.Post" toKeyPath:@"post" withMapping:postMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:activityMapping
                                                                           pathPattern:nil
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBClassification */
    
    RKObjectMapping *classificationMapping = [RKObjectMapping mappingForClass:[BBClassification class]];
    [classificationMapping addAttributeMappingsFromDictionary:@{
        @"Taxonomy" :@"taxonomy",
        @"Name" :@"name",
        @"RankPosition" :@"rankPosition",
        @"RankName" :@"rankName",
        @"ParentRankName" :@"parentRankName",
        @"Ranks" :@"ranks",
        @"Category" :@"category",
        @"SpeciesCount" :@"speciesCount",
        @"CommonGroupNames" :@"commonGroupNames",
        @"CommonNames" :@"commonNames",
        @"Synonyms" :@"synonyms",
        @"AllCommonNames" :@"allCommonNames"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:classificationMapping
                                                                           pathPattern:nil
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBPaginator */
    
    /*
    RKObjectMapping *paginatorMapping = [RKObjectMapping mappingForClass:[BBPaginator class]];
    [paginatorMapping addAttributeMappingsFromDictionary:@{
     @"Page" :@"currentPage",
     @"PageSize" :@"perPage",
     @"TotalResultCount" :@"objectCount"
     }];
    //[classificationPaginationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PagedListItems" toKeyPath:@"ranks" withMapping:classificationMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:paginatorMapping
                                                                           pathPattern:nil
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    */
    
    /* BBClassificationPaginator */
    
    RKObjectMapping *classificationPaginationMapping = [RKObjectMapping mappingForClass:[BBClassificationPaginator class]];
    [classificationPaginationMapping addAttributeMappingsFromDictionary:@{
        @"Page" :@"currentPage",
        @"PageSize" :@"perPage",
        @"TotalResultCount" :@"objectCount"
     }];
    [classificationPaginationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PagedListItems" toKeyPath:@"ranks" withMapping:classificationMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:classificationPaginationMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Model.Species"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    /* BBProjectPaginator */
    
    RKObjectMapping *projectPaginationMapping = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
    [projectPaginationMapping addAttributeMappingsFromDictionary:@{
     @"Page" :@"currentPage",
     @"PageSize" :@"perPage",
     @"TotalResultCount" :@"objectCount"
     }];
    [projectPaginationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PagedListItems" toKeyPath:@"projects" withMapping:projectMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:projectPaginationMapping
                                                                           pathPattern:@"/projects?PageSize=:perPage&Page=:page"
                                                                               keyPath:@"Model.Projects"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBActivityPaginator */
    
    RKObjectMapping *activityPaginationMapping = [RKObjectMapping mappingForClass:[BBActivityPaginator class]];
    [activityPaginationMapping addAttributeMappingsFromDictionary:@{
     @"Page" :@"currentPage",
     @"PageSize" :@"perPage",
     @"TotalResultCount" :@"objectCount"
     }];
    [activityPaginationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PagedListItems" toKeyPath:@"activities" withMapping:activityMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:activityPaginationMapping
                                                                           pathPattern:@"/?PageSize=:perPage&Page=:page"
                                                                               keyPath:@"Model.Activities"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBSightingPaginator */
    
    RKObjectMapping *sightingPaginationMapping = [RKObjectMapping mappingForClass:[BBSightingPaginator class]];
    [sightingPaginationMapping addAttributeMappingsFromDictionary:@{
     @"Page" :@"currentPage",
     @"PageSize" :@"perPage",
     @"TotalResultCount" :@"objectCount"
     }];
    [sightingPaginationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PagedListItems" toKeyPath:@"sightings" withMapping:observationMapping]];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:sightingPaginationMapping
                                                                           pathPattern:@"/favourites?PageSize=:perPage&Page=:page"
                                                                               keyPath:@"Model.Sightings"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    /* BBJsonResponse */
    
    RKObjectMapping *jsonResponseMapping = [RKObjectMapping mappingForClass:[BBJsonResponse class]];
    [jsonResponseMapping addAttributeMappingsFromDictionary:@{
        @"Success" :@"success"
     }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:jsonResponseMapping
                                                                           pathPattern:nil
                                                                               keyPath:@"Model.Success"
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    
    /* BBLoginRequest */
    
    RKObjectMapping *loginRequestMapping = [RKObjectMapping requestMapping];
    [loginRequestMapping addAttributeMappingsFromDictionary:@{
        @"email" :@"Email",
        @"password" :@"Password"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:loginRequestMapping
                                                                        objectClass:[BBLoginRequest class]
                                                                        rootKeyPath:nil]];
    
    /* BBRegisterRequest */
    
    RKObjectMapping *registerRequestMapping = [RKObjectMapping requestMapping];
    [registerRequestMapping addAttributeMappingsFromDictionary:@{
        @"Email" :@"email",
        @"Password" :@"password",
        @"Name" :@"name",
        @"Rememberme" :@"rememberme"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:registerRequestMapping
                                                                        objectClass:[BBRegisterRequest class]
                                                                        rootKeyPath:nil]];
    
    /* BBMediaResourceCreate */
    
    RKObjectMapping *mediaResourceCreateMapping = [RKObjectMapping requestMapping];
    [mediaResourceCreateMapping addAttributeMappingsFromDictionary:@{
        @"Key" :@"key",
        @"Type" :@"type",
        @"Usage" :@"usage",
        @"File" :@"file",
        @"FileName" :@"fileName"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:mediaResourceCreateMapping
                                                                        objectClass:[BBMediaResourceCreate class]
                                                                        rootKeyPath:@"Media"]];
    
    /* BBObservationMediaCreate */
    
    RKObjectMapping *observationMediaCreateMapping = [RKObjectMapping requestMapping];
    [observationMediaCreateMapping addAttributeMappingsFromDictionary:@{
     @"Key" :@"key",
     @"MediaResourceId" :@"mediaResourceId",
     @"Description" :@"description",
     @"Licence" :@"licence",
     @"IsPrimaryMedia" :@"isPrimaryMedia"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:observationMediaCreateMapping
                                                                        objectClass:[BBObservationMediaCreate class]
                                                                        rootKeyPath:@"Media"]];
    
    

    /* BBObservationCreate */

    RKObjectMapping *observationCreateMapping = [RKObjectMapping requestMapping];
    [observationCreateMapping addAttributeMappingsFromDictionary:@{
        @"Title" :@"title",
        @"ObservedOn" :@"observedOn",
        @"Latitude" :@"latitude",
        @"Longitude" :@"longitude",
        @"Address" :@"address",
        @"AnonymiseLocation" :@"anonymiseLocation",
        @"Category" :@"category",
        @"ProjectIds" :@"projectIds"
     }];
    [observationCreateMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Media" toKeyPath:@"media" withMapping:observationMediaCreateMapping]];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:observationCreateMapping
                                                                        objectClass:[BBObservationCreate class]
                                                                        rootKeyPath:nil]];
    
    /* BBSightingNoteDescriptionCreate */
    
    RKObjectMapping *sightingNoteDescriptionCreateMapping = [RKObjectMapping requestMapping];
    [sightingNoteDescriptionCreateMapping addAttributeMappingsFromDictionary:@{
        @"Key" :@"key",
        @"Value" :@"value"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:sightingNoteDescriptionCreateMapping
                                                                        objectClass:[BBSightingNoteDescriptionCreate class]
                                                                        rootKeyPath:nil]];
    
    /* BBSightingNoteCreate */
    
    RKObjectMapping *sightingNoteCreateMapping = [RKObjectMapping requestMapping];
    [sightingNoteCreateMapping addAttributeMappingsFromDictionary:@{
        @"SightingId" :@"sightingId",
        @"Tags" :@"tags",
        @"NoteComments" :@"comments"
     }];
    [sightingNoteCreateMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Descriptions" toKeyPath:@"descriptions" withMapping:sightingNoteDescriptionCreateMapping]];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:sightingNoteCreateMapping
                                                                        objectClass:[BBSightingNoteCreate class]
                                                                        rootKeyPath:nil]];
    
    /* BBIdentifySightingEdit */
    
    RKObjectMapping *identifySightingMapping = [RKObjectMapping requestMapping];
    [identifySightingMapping addAttributeMappingsFromDictionary:@{
        @"SightingId" :@"sightingId",
        @"Taxonomy" :@"taxonomy",
        @"IsCustomIdentification" :@"isCustomIdentification"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:identifySightingMapping
                                                                        objectClass:[BBIdentifySightingEdit class]
                                                                        rootKeyPath:nil]];

    /* BBVoteCreate */
    
    RKObjectMapping *voteCreateMapping = [RKObjectMapping requestMapping];
    [voteCreateMapping addAttributeMappingsFromDictionary:@{
        @"Score" :@"score"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:voteCreateMapping
                                                                        objectClass:[BBVoteCreate class]
                                                                        rootKeyPath:nil]];
    
    /* BBSubVoteCreate */
    
    RKObjectMapping *subCoteCreateMapping = [RKObjectMapping requestMapping];
    [subCoteCreateMapping addAttributeMappingsFromDictionary:@{
        @"Score" :@"score"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:subCoteCreateMapping
                                                                        objectClass:[BBSubVoteCreate class]
                                                                       rootKeyPath:nil]];
    
    /* BBModelId */
    
    RKObjectMapping *modelIdMapping = [RKObjectMapping requestMapping];
    [modelIdMapping addAttributeMappingsFromDictionary:@{
        @"Id" :@"identifier"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:modelIdMapping
                                                                        objectClass:[BBModelId class]
                                                                        rootKeyPath:nil]];
    
    /* BBProjectId */
    
    RKObjectMapping *projectIdMapping = [RKObjectMapping requestMapping];
    [projectIdMapping addAttributeMappingsFromDictionary:@{
        @"Id" :@"identifier"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:projectIdMapping
                                                                        objectClass:[BBProjectId class]
                                                                        rootKeyPath:nil]];
    
    /* BBFavouriteId */
    
    RKObjectMapping *favouriteMapping = [RKObjectMapping requestMapping];
    [favouriteMapping addAttributeMappingsFromDictionary:@{
     @"Id" :@"identifier"
     }];
    [manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:favouriteMapping
                                                                        objectClass:[BBFavouriteId class]
                                                                        rootKeyPath:nil]];

    /*
    // using escapeRoutedPath:NO prevents url encoding: http://stackoverflow.com/questions/9688113/avoid-uri-encoding-on-restkit-routers
    //escapeRoutedPath:NO]; has been depracated: https://github.com/restkit/restkit/issues/1091
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBMediaResourceCreate Class] pathPattern:@"/mediaresources" method:RKRequestMethodPOST]];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBObservationCreate Class] pathPattern:@"/observations" method:RKRequestMethodPOST]];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBIdentifySightingEdit Class] pathPattern:@"/:\\sightingId/identifications" method:RKRequestMethodPOST]]; 
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBSightingNoteCreate Class] pathPattern:@"/:\\sightingId/notes" method:RKRequestMethodPOST]]; //escapeRoutedPath:NO];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBFavouriteId Class] pathPattern:@"/favourites" method:RKRequestMethodPOST]]; //escapeRoutedPath:NO];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBProjectId Class] pathPattern:@"/:\\dentifier/members" method:RKRequestMethodPOST]]; //escapeRoutedPath:NO];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBProjectId Class] pathPattern:@"/:\\identifier/members" method:RKRequestMethodDELETE]]; //escapeRoutedPath:NO];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBVoteCreate Class] pathPattern:@"/:\\identifier/vote" method:RKRequestMethodPOST]]; //escapeRoutedPath:NO];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBSubVoteCreate Class] pathPattern:@"/:\\identifier/:\\subIdentifier/vote" method:RKRequestMethodPOST]]; //escapeRoutedPath:NO];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBAuthenticatedUser Class] pathPattern:@"/account/profile" method:RKRequestMethodGET]]; //escapeRoutedPath:NO];
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[BBLoginRequest Class] pathPattern:@"/account/login" method:RKRequestMethodPOST]];
     */
}

@end