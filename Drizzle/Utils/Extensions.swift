//
//  Extensions.swift
//  Drizzle
//
//  Created by Osama Khaled on 19/06/2026.
//

import Foundation
import SwiftUI

extension View {
    func backgroundWithTimeBasedImage() -> some View {
        let imageName = TimeHelpers.backgroundImageName()
        return self
            .background(
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
    }
}
