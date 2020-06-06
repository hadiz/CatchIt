//
//  Network.swift
//  CatchItCore
//
//  Created by Hadi Zamani on 5/17/20.
//  Copyright © 2020 SomeSimpleSolutions. All rights reserved.
//

internal protocol Network {
    func fetchData(with: String) -> Array<String>
}
