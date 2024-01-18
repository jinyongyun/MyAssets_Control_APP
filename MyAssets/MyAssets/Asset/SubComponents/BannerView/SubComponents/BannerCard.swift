//
//  BannerCard.swift
//  MyAssets
//
//  Created by jinyong yun on 1/17/24.
//


import SwiftUI

struct BannerCard: View {
    var banner: AssetBanner
    
    var body: some View {
        Color(banner.backgroundColor)
            .overlay(
                VStack {
                    Text(banner.title)
                        .font(.title)
                    Text(banner.description)
                        .font(.subheadline)
                }
            )
    }
}

struct BannerCard_Previews: PreviewProvider {
    static var previews: some View {
        BannerCard(banner: AssetBanner(title: "공지사항", description: "추가된 공지사항을 확인하세요", backgroundColor: .red))
            .aspectRatio(5/2, contentMode: .fit)
    }
}
