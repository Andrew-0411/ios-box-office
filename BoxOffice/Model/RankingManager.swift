//
//  RankingManager.swift
//  BoxOffice
//
//  Created by 레옹아범 ,Andrew on 2023/03/31.
//

import Foundation

struct RankingManager {
    private let date: Date
    let apiType: APIType
    var movieItems: [InfoObject] = []
    let boxofficeInfo: BoxofficeInfo<DailyBoxofficeObject>
    
    init(date: Date) {
        let dataText = Date.apiDateFormatter.string(from: date)
        self.date = date
        self.apiType = APIType.boxoffice(dataText)
        self.boxofficeInfo = BoxofficeInfo<DailyBoxofficeObject>(apiType: self.apiType, model: NetworkModel(session: .shared))
    }
    
    var navigationTitleText: String {
        return Date.dateFormatter.string(from: date)
    }
}
