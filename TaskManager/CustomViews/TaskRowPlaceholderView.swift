//
//  TaskRowPlaceholderView.swift
//  TaskManager
//
//  Created by Teknip INC on 13/03/2025.
//

import SwiftUI

struct TaskRowPlaceholderView: View {
    var body: some View {
        HStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 16)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 14)
            }
            .padding(.leading, 8)
        }
        .padding()
        .redacted(reason: .placeholder) // Makes it look like a placeholder
    }
}

#Preview {
    TaskRowPlaceholderView()
}
