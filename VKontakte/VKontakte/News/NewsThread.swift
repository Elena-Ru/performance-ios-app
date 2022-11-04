//
//  NewsThread.swift
//  VKontakte
//
//  Created by Елена Русских on 17.10.2022.
//

import Foundation

// MARK: - News
class News: Codable {
    let response: Response?

    init(response: Response?) {
        self.response = response
    }
}

// MARK: - Response
class Response: Codable {
    let items: [Item]?
    let profiles: [Profile]?
    let groups: [GroupNews]?
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }

    init(items: [Item]?, profiles: [Profile]?, groups: [GroupNews]?, nextFrom: String?) {
        self.items = items
        self.profiles = profiles
        self.groups = groups
        self.nextFrom = nextFrom
    }
}

// MARK: - GroupNews
class GroupNews: Codable {
    let id: Int?
    let name, screenName: String?
    let isClosed: Int?
    let type: String?
    let isAdmin, isMember, isAdvertiser: Int?
    let photo50, photo100, photo200: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }

    init(id: Int?, name: String?, screenName: String?, isClosed: Int?, type: String?, isAdmin: Int?, isMember: Int?, isAdvertiser: Int?, photo50: String?, photo100: String?, photo200: String?) {
        self.id = id
        self.name = name
        self.screenName = screenName
        self.isClosed = isClosed
        self.type = type
        self.isAdmin = isAdmin
        self.isMember = isMember
        self.isAdvertiser = isAdvertiser
        self.photo50 = photo50
        self.photo100 = photo100
        self.photo200 = photo200
    }
}

// MARK: - Item
class Item: Codable {
    let sourceID, date: Int?
    let canDoubtCategory, canSetCategory, isFavorite: Bool?
    let postType: PostTypeEnum?
    let text: String?
    let markedAsAds: Int?
    let attachments: [ItemAttachment]?
    let postSource: ItemPostSource?
    let comments: Comments?
    let likes: Likes?
    let reposts: Reposts?
    let views: Views?
    let donut: Donut?
    let shortTextRate: Double?
    let carouselOffset, postID: Int?
    let type: PostTypeEnum?
    let copyHistory: [CopyHistory]?
    let copyright: Copyright?
    let topicID: Int?

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case isFavorite = "is_favorite"
        case postType = "post_type"
        case text
        case markedAsAds = "marked_as_ads"
        case attachments
        case postSource = "post_source"
        case comments, likes, reposts, views, donut
        case shortTextRate = "short_text_rate"
        case carouselOffset = "carousel_offset"
        case postID = "post_id"
        case type
        case copyHistory = "copy_history"
        case copyright
        case topicID = "topic_id"
    }

    init(sourceID: Int?, date: Int?, canDoubtCategory: Bool?, canSetCategory: Bool?, isFavorite: Bool?, postType: PostTypeEnum?, text: String?, markedAsAds: Int?, attachments: [ItemAttachment]?, postSource: ItemPostSource?, comments: Comments?, likes: Likes?, reposts: Reposts?, views: Views?, donut: Donut?, shortTextRate: Double?, carouselOffset: Int?, postID: Int?, type: PostTypeEnum?, copyHistory: [CopyHistory]?, copyright: Copyright?, topicID: Int?) {
        self.sourceID = sourceID
        self.date = date
        self.canDoubtCategory = canDoubtCategory
        self.canSetCategory = canSetCategory
        self.isFavorite = isFavorite
        self.postType = postType
        self.text = text
        self.markedAsAds = markedAsAds
        self.attachments = attachments
        self.postSource = postSource
        self.comments = comments
        self.likes = likes
        self.reposts = reposts
        self.views = views
        self.donut = donut
        self.shortTextRate = shortTextRate
        self.carouselOffset = carouselOffset
        self.postID = postID
        self.type = type
        self.copyHistory = copyHistory
        self.copyright = copyright
        self.topicID = topicID
    }
}

// MARK: - ItemAttachment
class ItemAttachment: Codable {
    let type: AttachmentType?
    let video: Video?
    let photo: PhotoNews?
    let link: Link?

    init(type: AttachmentType?, video: Video?, photo: PhotoNews?, link: Link?) {
        self.type = type
        self.video = video
        self.photo = photo
        self.link = link
    }
}

// MARK: - Link
class Link: Codable {
    let url: String?
    let title, caption, linkDescription: String?
    let photo: PhotoNews?
    let isFavorite: Bool?
    let target: String?

    enum CodingKeys: String, CodingKey {
        case url, title, caption
        case linkDescription = "description"
        case photo
        case isFavorite = "is_favorite"
        case target
    }

    init(url: String?, title: String?, caption: String?, linkDescription: String?, photo: PhotoNews?, isFavorite: Bool?, target: String?) {
        self.url = url
        self.title = title
        self.caption = caption
        self.linkDescription = linkDescription
        self.photo = photo
        self.isFavorite = isFavorite
        self.target = target
    }
}

// MARK: - Photo
class PhotoNews: Codable {
    let albumID, date, id, ownerID: Int?
    let sizes: [Size]?
    let text: String?
    let userID: Int?
    let hasTags: Bool?
    let accessKey: String?
    let postID: Int?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case sizes, text
        case userID = "user_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case postID = "post_id"
    }

    init(albumID: Int?, date: Int?, id: Int?, ownerID: Int?, sizes: [Size]?, text: String?, userID: Int?, hasTags: Bool?, accessKey: String?, postID: Int?) {
        self.albumID = albumID
        self.date = date
        self.id = id
        self.ownerID = ownerID
        self.sizes = sizes
        self.text = text
        self.userID = userID
        self.hasTags = hasTags
        self.accessKey = accessKey
        self.postID = postID
    }
}

// MARK: - Size
class Size: Codable {
    let height: Int?
    let url: String?
    let type: SizeType?
    let width, withPadding: Int?

    enum CodingKeys: String, CodingKey {
        case height, url, type, width
        case withPadding = "with_padding"
    }

    init(height: Int?, url: String?, type: SizeType?, width: Int?, withPadding: Int?) {
        self.height = height
        self.url = url
        self.type = type
        self.width = width
        self.withPadding = withPadding
    }
}

enum SizeType: String, Codable {
    case k = "k"
    case l = "l"
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case temp = "temp"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}

enum AttachmentType: String, Codable {
    case doc = "doc"
    case link = "link"
    case photo = "photo"
    case video = "video"
}

// MARK: - Video
class Video: Codable {
    let accessKey: String?
    let canComment, canLike, canRepost, canSubscribe: Int?
    let canAddToFaves, canAdd, comments, date: Int?
    let videoDescription: String?
    let duration: Int?
    let image: [Size]?
    let id, ownerID: Int?
    let title: String?
    let isFavorite: Bool?
    let trackCode: String?
    let type: AttachmentType?
    let views, localViews: Int?
    let platform: VideoPlatform?
    let firstFrame: [Size]?
    let width, height, videoRepeat: Int?

    enum CodingKeys: String, CodingKey {
        case accessKey = "access_key"
        case canComment = "can_comment"
        case canLike = "can_like"
        case canRepost = "can_repost"
        case canSubscribe = "can_subscribe"
        case canAddToFaves = "can_add_to_faves"
        case canAdd = "can_add"
        case comments, date
        case videoDescription = "description"
        case duration, image, id
        case ownerID = "owner_id"
        case title
        case isFavorite = "is_favorite"
        case trackCode = "track_code"
        case type, views
        case localViews = "local_views"
        case platform
        case firstFrame = "first_frame"
        case width, height
        case videoRepeat = "repeat"
    }

    init(accessKey: String?, canComment: Int?, canLike: Int?, canRepost: Int?, canSubscribe: Int?, canAddToFaves: Int?, canAdd: Int?, comments: Int?, date: Int?, videoDescription: String?, duration: Int?, image: [Size]?, id: Int?, ownerID: Int?, title: String?, isFavorite: Bool?, trackCode: String?, type: AttachmentType?, views: Int?, localViews: Int?, platform: VideoPlatform?, firstFrame: [Size]?, width: Int?, height: Int?, videoRepeat: Int?) {
        self.accessKey = accessKey
        self.canComment = canComment
        self.canLike = canLike
        self.canRepost = canRepost
        self.canSubscribe = canSubscribe
        self.canAddToFaves = canAddToFaves
        self.canAdd = canAdd
        self.comments = comments
        self.date = date
        self.videoDescription = videoDescription
        self.duration = duration
        self.image = image
        self.id = id
        self.ownerID = ownerID
        self.title = title
        self.isFavorite = isFavorite
        self.trackCode = trackCode
        self.type = type
        self.views = views
        self.localViews = localViews
        self.platform = platform
        self.firstFrame = firstFrame
        self.width = width
        self.height = height
        self.videoRepeat = videoRepeat
    }
}

enum VideoPlatform: String, Codable {
    case youTube = "YouTube"
}

// MARK: - Comments
class Comments: Codable {
    let canPost, count: Int?
    let groupsCanPost: Bool?

    enum CodingKeys: String, CodingKey {
        case canPost = "can_post"
        case count
        case groupsCanPost = "groups_can_post"
    }

    init(canPost: Int?, count: Int?, groupsCanPost: Bool?) {
        self.canPost = canPost
        self.count = count
        self.groupsCanPost = groupsCanPost
    }
}

// MARK: - CopyHistory
class CopyHistory: Codable {
    let id, ownerID, fromID, date: Int?
    let postType: PostTypeEnum?
    let text: String?
    let attachments: [CopyHistoryAttachment]?
    let postSource: CopyHistoryPostSource?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case fromID = "from_id"
        case date
        case postType = "post_type"
        case text, attachments
        case postSource = "post_source"
    }

    init(id: Int?, ownerID: Int?, fromID: Int?, date: Int?, postType: PostTypeEnum?, text: String?, attachments: [CopyHistoryAttachment]?, postSource: CopyHistoryPostSource?) {
        self.id = id
        self.ownerID = ownerID
        self.fromID = fromID
        self.date = date
        self.postType = postType
        self.text = text
        self.attachments = attachments
        self.postSource = postSource
    }
}

// MARK: - CopyHistoryAttachment
class CopyHistoryAttachment: Codable {
    let type: AttachmentType?
    let photo: PhotoNews?
    let link: Link?
    let doc: Doc?
    let video: Video?

    init(type: AttachmentType?, photo: PhotoNews?, link: Link?, doc: Doc?, video: Video?) {
        self.type = type
        self.photo = photo
        self.link = link
        self.doc = doc
        self.video = video
    }
}

// MARK: - Doc
class Doc: Codable {
    let id, ownerID: Int?
    let title: String?
    let size: Int?
    let ext: EXT?
    let date, type: Int?
    let url: String?
    let accessKey: String?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case title, size, ext, date, type, url
        case accessKey = "access_key"
    }

    init(id: Int?, ownerID: Int?, title: String?, size: Int?, ext: EXT?, date: Int?, type: Int?, url: String?, accessKey: String?) {
        self.id = id
        self.ownerID = ownerID
        self.title = title
        self.size = size
        self.ext = ext
        self.date = date
        self.type = type
        self.url = url
        self.accessKey = accessKey
    }
}

enum EXT: String, Codable {
    case djvu = "djvu"
    case pdf = "pdf"
}

// MARK: - CopyHistoryPostSource
class CopyHistoryPostSource: Codable {
    let type: PostSourceType?

    init(type: PostSourceType?) {
        self.type = type
    }
}

enum PostSourceType: String, Codable {
    case api = "api"
    case vk = "vk"
}

enum PostTypeEnum: String, Codable {
    case post = "post"
}

// MARK: - Copyright
class Copyright: Codable {
    let link: String?
    let type, name: String?

    init(link: String?, type: String?, name: String?) {
        self.link = link
        self.type = type
        self.name = name
    }
}

// MARK: - Donut
class Donut: Codable {
    let isDonut: Bool?

    enum CodingKeys: String, CodingKey {
        case isDonut = "is_donut"
    }

    init(isDonut: Bool?) {
        self.isDonut = isDonut
    }
}

// MARK: - Likes
class Likes: Codable {
    var canLike, count, userLikes, canPublish: Int?

    enum CodingKeys: String, CodingKey {
        case canLike = "can_like"
        case count
        case userLikes = "user_likes"
        case canPublish = "can_publish"
    }

    init(canLike: Int?, count: Int?, userLikes: Int?, canPublish: Int?) {
        self.canLike = canLike
        self.count = count
        self.userLikes = userLikes
        self.canPublish = canPublish
    }
}

// MARK: - ItemPostSource
class ItemPostSource: Codable {
    let type: PostSourceType?
    let platform: PostSourcePlatform?

    init(type: PostSourceType?, platform: PostSourcePlatform?) {
        self.type = type
        self.platform = platform
    }
}

enum PostSourcePlatform: String, Codable {
    case adminApp = "admin_app"
    case iphone = "iphone"
}

// MARK: - Reposts
class Reposts: Codable {
    let count, userReposted: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }

    init(count: Int?, userReposted: Int?) {
        self.count = count
        self.userReposted = userReposted
    }
}

// MARK: - Views
class Views: Codable {
    let count: Int?

    init(count: Int?) {
        self.count = count
    }
}

// MARK: - Profile
class Profile: Codable {
    let id, sex: Int?
    let screenName: String?
    let photo50, photo100: String?
    let onlineInfo: OnlineInfo?
    let online: Int?
    let firstName, lastName: String?
    let canAccessClosed, isClosed: Bool?
    let onlineMobile, onlineApp: Int?
    let deactivated: String?

    enum CodingKeys: String, CodingKey {
        case id, sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case onlineInfo = "online_info"
        case online
        case firstName = "first_name"
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case onlineMobile = "online_mobile"
        case onlineApp = "online_app"
        case deactivated
    }

    init(id: Int?, sex: Int?, screenName: String?, photo50: String?, photo100: String?, onlineInfo: OnlineInfo?, online: Int?, firstName: String?, lastName: String?, canAccessClosed: Bool?, isClosed: Bool?, onlineMobile: Int?, onlineApp: Int?, deactivated: String?) {
        self.id = id
        self.sex = sex
        self.screenName = screenName
        self.photo50 = photo50
        self.photo100 = photo100
        self.onlineInfo = onlineInfo
        self.online = online
        self.firstName = firstName
        self.lastName = lastName
        self.canAccessClosed = canAccessClosed
        self.isClosed = isClosed
        self.onlineMobile = onlineMobile
        self.onlineApp = onlineApp
        self.deactivated = deactivated
    }
}

// MARK: - OnlineInfo
class OnlineInfo: Codable {
    let visible: Bool?
    let lastSeen: Int?
    let isOnline: Bool?
    let appID: Int?
    let isMobile: Bool?

    enum CodingKeys: String, CodingKey {
        case visible
        case lastSeen = "last_seen"
        case isOnline = "is_online"
        case appID = "app_id"
        case isMobile = "is_mobile"
    }

    init(visible: Bool?, lastSeen: Int?, isOnline: Bool?, appID: Int?, isMobile: Bool?) {
        self.visible = visible
        self.lastSeen = lastSeen
        self.isOnline = isOnline
        self.appID = appID
        self.isMobile = isMobile
    }
}
