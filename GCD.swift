//
//  GCD.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/18.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void) {
    DispatchQueue.main.async(execute: updates)
}
