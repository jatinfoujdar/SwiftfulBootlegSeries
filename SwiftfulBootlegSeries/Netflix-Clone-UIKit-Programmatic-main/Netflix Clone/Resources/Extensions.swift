//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Aarish Khanna on 19/01/23.
//

import Foundation

extension String{
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
