//
//  NewItem.swift
//  VKontakte
//
//  Created by Елена Русских on 15.08.2022.
//

import Foundation
import RealmSwift

// MARK: - NewsResponse
class NewsResponse: Decodable {
    var response: Response
}

// MARK: - Response
class Response: Decodable {
    var items: [NewsItem]
    var groups: [GroupNews]
}

// MARK: - GroupNews
class GroupNews: Decodable {
    var id: Int = 0
    var name: String = ""
    var screenName: String = ""
    var type: String = ""
    var photo200: String = ""

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case type
        case photo200 = "photo_200"
    }
}

// MARK: - NewsItem
class NewsItem: Object, Decodable {
    @Persisted var id: Int = 0

    @Persisted var text: String = ""
    @Persisted var historyText: String = ""
    @Persisted var historyType: String = ""
    @Persisted var historyPhotoDate: Int = 0
    @Persisted var historyUrl: String = ""
    
    @Persisted var commentsCount: Int = 0
    
    @Persisted var likesCount: Int = 0
    @Persisted var userLikes: Int = 0
    
    @Persisted var repostCount: Int = 0
    @Persisted var userReposted: Int = 0
    
    @Persisted var viewsCount: Int = 0
    
    @Persisted var type: String = ""
    @Persisted var photoDate: Int = 0
    @Persisted var url: String = ""
    
    @Persisted var owner: MainUser?
    @Persisted var owners = LinkingObjects(fromType: MainUser.self, property: "news")
 

    enum CodingKeys: String, CodingKey {
        case id = "source_id"
        case text
        case comments, likes, reposts, views
        case attachments
        case history = "copy_history" //for post
    }
    
    enum HistoryKeys: String, CodingKey{
        case historyText = "text"
        case attachments
    }
    
    enum HistoryAttachmentsKey: String, CodingKey{
        case historyType = "type"
        case historyPhoto = "photo"
    }
    
    enum HistoryPhotosKeys: String, CodingKey{
        case historyPhotoDate = "date"
        case sizes
    }
    
    enum HistorySizesKeys: String, CodingKey{
        case historyUrl = "url"
    }
    
    
    
    
    
    enum CommentsKeys: String, CodingKey{
        case commentsCount = "count"
    }
    
    enum LikesKeys: String, CodingKey {
        case likesCount = "count"
        case userLikes = "user_likes"
    }
    
    enum RepostsKeys: String, CodingKey {
        case repostCount = "count"
        case userReposted = "user_reposted"
    }
    
    enum ViewsKeys: String, CodingKey{
        case viewsCount = "count"
    }
    
    enum AttachmentsKeys: String, CodingKey{
        case type
        case photo
    }
    
    enum PhotosKeys: String, CodingKey{
        case photoDate = "date"
        case sizes
    }
    
    enum SizesKeys: String, CodingKey{
        case url
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        
        //for posts
        if container.contains(.history){
            
            var copyHistoryValues = try container.nestedUnkeyedContainer(forKey: .history)
            let firstCopyHistoryValues = try copyHistoryValues.nestedContainer(keyedBy: HistoryKeys.self)
            self.historyText = try firstCopyHistoryValues.decode(String.self, forKey: .historyText)
            
            var copyHistoryPhotoValues = try firstCopyHistoryValues.nestedUnkeyedContainer(forKey: .attachments)
            let firstCopyHistoryPhotoValues = try copyHistoryPhotoValues.nestedContainer(keyedBy: HistoryAttachmentsKey.self)
            self.historyType = try firstCopyHistoryPhotoValues.decode(String.self, forKey: .historyType)
            
            
            let photoValues = try firstCopyHistoryPhotoValues.nestedContainer(keyedBy: HistoryPhotosKeys.self, forKey: .historyPhoto)
            self.historyPhotoDate = try photoValues.decode(Int.self, forKey: .historyPhotoDate)
            
            
            var sizesValues = try photoValues.nestedUnkeyedContainer(forKey: .sizes)
            let firstSizesValues = try sizesValues.nestedContainer(keyedBy: HistorySizesKeys.self)
            self.historyUrl = try firstSizesValues.decode(String.self, forKey: .historyUrl)
        }
        
        
        
        let commentsValues = try container.nestedContainer(keyedBy: CommentsKeys.self, forKey: .comments)
        self.commentsCount = try commentsValues.decode(Int.self, forKey: .commentsCount)
        
        let likesValues = try container.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.userLikes = try likesValues.decode(Int.self, forKey: .userLikes)
        self.likesCount = try likesValues.decode(Int.self, forKey: .likesCount)
        
        let repostsValues = try container.nestedContainer(keyedBy: RepostsKeys.self, forKey: .reposts)
        self.repostCount = try repostsValues.decode(Int.self, forKey: .repostCount)
        self.userReposted  = try repostsValues.decode(Int.self, forKey: .userReposted)
        
        let viewValues = try container.nestedContainer(keyedBy: ViewsKeys.self, forKey: .views)
        self.viewsCount = try viewValues.decode(Int.self, forKey: .viewsCount)
        
        
        
        if container.contains(.attachments) {
            var attachmentsValues = try container.nestedUnkeyedContainer(forKey: .attachments)
            let firstAttachmentsValues = try attachmentsValues.nestedContainer(keyedBy: AttachmentsKeys.self)
            self.type = try firstAttachmentsValues.decode(String.self, forKey: .type)
            print(self.type as Any)
            
            let photoValues = try firstAttachmentsValues.nestedContainer(keyedBy: PhotosKeys.self, forKey: .photo)
            self.photoDate = try photoValues.decode(Int.self, forKey: .photoDate)
            print(self.photoDate as Any)
            
            var sizesValues = try photoValues.nestedUnkeyedContainer(forKey: .sizes)
            let firstSizesValues = try sizesValues.nestedContainer(keyedBy: SizesKeys.self)
            self.url = try firstSizesValues.decode(String.self, forKey: .url)
            print(self.url as Any)
            
        }
    }
}








