//
//  GifInfo.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import Foundation

struct GifInfo {
    let id: String
    let username: String
    let source: String
    let images : GifImages
    
    static let stub: [GifInfo] = [
        GifInfo(id: "1", username: "1", source: "1", images: GifImages(original: GifImage(height: "5616",
                                                                                          width: "3744",
                                                                                          url: "https://images.unsplash.com/photo-1610950809171-a80f9be3bb83?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwxfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"),
                                                                       fixedWidth: GifImage(height: "5616",
                                                                                            width: "3744",
                                                                                            url: ""))),
        GifInfo(id: "3", username: "3", source: "3", images: GifImages(original: GifImage(height: "2994",
                                                                                          width: "5323",
                                                                                          url: "https://images.unsplash.com/photo-1610950486427-2b1ca03d8857?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"),
                                                                       fixedWidth: GifImage(height: "2994",
                                                                                            width: "5323",
                                                                                            url: "https://images.unsplash.com/photo-1610950486427-2b1ca03d8857?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85"))),
        GifInfo(id: "4", username: "4", source: "4", images: GifImages(original: GifImage(height: "2994",
                                                                                          width: "5323",
                                                                                          url: "https://images.unsplash.com/photo-1610950486427-2b1ca03d8857?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"),
                                                                       fixedWidth: GifImage(height: "4240",
                                                                                            width: "2832",
                                                                                            url: "https://images.unsplash.com/photo-1610900214637-f76e7cb299ed?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwyfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85"))),
        GifInfo(id: "2", username: "2", source: "2", images: GifImages(original: GifImage(height: "4240",
                                                                                          width: "2832",
                                                                                          url: "https://images.unsplash.com/photo-1610900214637-f76e7cb299ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwyfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"),
                                                                       fixedWidth: GifImage(height: "4240",
                                                                                            width: "2832",
                                                                                            url: "https://images.unsplash.com/photo-1610900214637-f76e7cb299ed?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwyfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85"))),
        GifInfo(id: "5", username: "5", source: "5", images: GifImages(original: GifImage(height: "5616",
                                                                                          width: "3744",
                                                                                          url: "https://images.unsplash.com/photo-1610950809171-a80f9be3bb83?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwxfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"),
                                                                       fixedWidth: GifImage(height: "5616",
                                                                                            width: "3744",
                                                                                            url: "https://images.unsplash.com/photo-1610950809171-a80f9be3bb83?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwxfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85"))),
        GifInfo(id: "7", username: "7", source: "7", images: GifImages(original: GifImage(height: "2994",
                                                                                          width: "5323",
                                                                                          url: "https://images.unsplash.com/photo-1610950486427-2b1ca03d8857?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"),
                                                                       fixedWidth: GifImage(height: "2994",
                                                                                            width: "5323",
                                                                                            url: "https://images.unsplash.com/photo-1610950486427-2b1ca03d8857?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85"))),
        GifInfo(id: "8", username: "8", source: "8", images: GifImages(original: GifImage(height: "2994",
                                                                                          width: "5323",
                                                                                          url: "https://images.unsplash.com/photo-1610950486427-2b1ca03d8857?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"),
                                                                       fixedWidth: GifImage(height: "4240",
                                                                                            width: "2832",
                                                                                            url: "https://images.unsplash.com/photo-1610900214637-f76e7cb299ed?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwyfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85"))),
        GifInfo(id: "6", username: "6", source: "6", images: GifImages(original: GifImage(height: "4240",
                                                                                          width: "2832",
                                                                                          url: "https://images.unsplash.com/photo-1610900214637-f76e7cb299ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwyfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"),
                                                                       fixedWidth: GifImage(height: "4240",
                                                                                            width: "2832",
                                                                                            url: "https://images.unsplash.com/photo-1610900214637-f76e7cb299ed?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwyfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85")))
    ]
}

struct GifImages {
    let original: GifImage
    let fixedWidth: GifImage
}

struct GifImage {
    let height: String
    let width: String
    let url: String
}


