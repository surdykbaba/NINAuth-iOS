//
//  URLs.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 28/01/2025.
//

enum URLs {
    
    static var baseurl: String {
        #if DEBUG
        return "https://api-alpha.yuvee.com/biieomghry/v2/"
        #else
        return "https://api.yuvee.com/biieomghry/v2/"
        #endif
    }
    
    
    //MARK: User
    static let REGISTER_USER = "registeruser"
    static let LOGIN = "login"
    static let SOCIAL_LOGIN = "social-login"
    static let ACTIVATE_USER = "activeuseraccount"
    static let EMAIL_VERIFICATION_CODE = "emailverification"
    static let FORGOT_PASSWORD = "emailverification"
    static let CHANGE_PASSWORD = "changepassord"
    static let ADD_REMOVE_SEEN = "user/seen/addremove"
    static let EMAIL_CHECK = "useremailchecked"
    
    
    
    //MARK: Streaming
    static let STREAMING_SERVICE_LIST = "streaming-services"
    static let STREAMING_USER_SERVICE = "streaming-services/user-update"
    
    
    
    //MARK: Genres
    static let GENRE = "genres"
    static let GENRE_UPDATE = "genres/user-update"
    
    
    
    //MARK: Profile
    static let PROFILE_DETAILS = "user/profile/detail"
    static let HOME_COLLECTION = "home/bands"
    static let RECENT_WINNERS = "prize/recent-winners"
    static let VIEW_MORE_COLLECTION = "collection-view-more"
    static let REWARD_HISTORY = "user/rewards/history"
    static let REWARD_HISTORY_LIST = "user/rewards/list"
    static let REWARD_USER_DATA = "user/rewards/data"
    static let REFERRAL_COUNT = "referral/count_referrals"
    static let GENERATE_QR_CODE = "referral/generate-qrcode"
    static let GET_REFERRAL_LIST = "referral/list_referrals"
    static let USER_GENRE = "user-genres"
    static let GENRE_MOVIE_LIST = "genres/movies"
    static let GENRE_TV_LIST = "genres/tvshows"
    static let THROTTLE = "user/profile/throttle"
    static let PRIMARY_WATCHLIST = "watch-list/primary"
    static let GIFT_CARD_BRAND = "giftcard/brand/list"
    static let GIFT_CARD_DETAIL = "giftcard/brand/item"
    static let REDEEM_GIFT = "giftcard/coupon/redeem"
    static let ACCOUNT_UPDATE = "user/account/update"
    static let UPDATE_PASSWORD = "user/account/changepassword"
    static let DELETE_ACCOUNT = "account/remove"
    static let PROFILE_UPDATE = "user/profile/edit"
    static let ACCOUNT_INFO = "user/account"
    static let PROFILE_LIST = "user/profile"
    static let PROFLE_DELETE = "user/profile/remove"
    static let PROFILE_CREATE = "user/profile/create"
    
    
    
    //MARK: WatchList
    static let ADD_ON_WATCHLIST = "watch-list/addonlist"
    static let WATCH_LIST = "watch-list"
    static let WATCH_LIST_CREATE = "watch-list/create"
    static let WATCH_LIST_ADD_REMOVE = "watch-list/favourites/addremove"
    static let CHANGE_ON_WATCHLIST = "watch-list/changeonlist"
    static let WATCH_LIST_DIALOG = "watch-list/dialoglist"
    static let WATCH_LIST_DETAILS = "watch-list/details"
    static let REMOVE_FROM_WATCHLIST = "watch-list/remove"
    static let WATCH_LIST_UPDATE = "watch-list/update"
    static let DELETE_WATCHLIST = "watch-list/delete"
    static let RE_ORDER_WATCHLIST = "watch-list/reorder"
    
    
    
    //MARK: Film/Content Rating
    static let FILM_RATING_LIST = "filmratinglist"
    static let UPDATE_FILM_RATING = "user/filmrating/update"
    
    
    
    //MARK: Viewing Option
    static let VIEW_OPTION_LIST = "viewing-option"
    static let UPDATE_VIEW_OPTION = "user/viewing-option/update"
    
    
    
    //MARK: Search Endpoints
    static let TOP_SEARCHES = "search/top-searches"
    static let SEARCH_MOVIES = "search-data"
    static let SEARCH_CAST_CREW = "search/cast-crew"
    static let CREW_DETAILS = "talent/details"
    static let CREW_FILMOGRAPHY = "talent/filmography"
    static let CREW_PHOTOS = "talent/photos"
    static let MOVIE_DETAILS = "movie-details"
    static let MOVIE_MORE_LIKE = "movie-morelike"
    static let MOVIE_CAST_CREW = "movie-castcrews"
    static let ADD_REMOVE_REACTION = "user/reaction/addremove"
    static let TV_SHOW_DETAILS = "tvshow-details"
    static let TV_SHOW_EPISODES = "tvshow-episodes"
    static let TV_SHOW_CAST_CREW = "tvshow-castcrews"
    static let TV_SHOW_MORE_LIKE = "tvshow-morelike"
    static let EPISODE_DETAILS = "episodes-details"
    static let BAD_LINK = "reporting/bad-links"
    static let SEARCH_ADD = "user/search/add"
    
    
    
    //MARK: Languages
    static let LANGUAGE_USER_LIST = "languagelist"
    static let LANGUAGE_USER_UPDATE = "user/languages/update"
    
    
    
    //MARK: Advertisement
    static let ADVERTISE_LIST_DECISION = "advertisement/list/decision"
    static let ADVERTISE_WATCHED_ADD = "advertisement/watched/add"
    static let ADS_ADDED = "advertisement/watch"
    static let DAILY_CHEK_IN = "prize/daily_checkin"
    
    
    
    //MARK: Notification
    static let SET_DEVICE_TOKEN = "user/profile/devicetoken/set"
    static let NOTIFICATION = "notification/list"
    static let BADGE_COUNT = "notification/badge-count"
    static let READ_NOTICATION = "notification/"
    
    
    
    //MARK: Leaderboards
    static let TOP_WATCHERS = "leaderboard/watch"
    static let LEADER_REFERRAL = "leaderboard/referral"
    static let TOP_PRICES = "leaderboard/prizes"
    
}

