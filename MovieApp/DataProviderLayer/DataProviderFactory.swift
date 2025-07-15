//
//  DataProviderFactory.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

struct DataProviderFactory {
    static func getDataProvider() -> DataProviderService {
        return DataProviderLayer()
    }
}
