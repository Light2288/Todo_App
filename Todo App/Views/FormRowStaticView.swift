//
//  FormRowStaticView.swift
//  Todo App
//
//  Created by Davide Aliti on 28/06/22.
//

import SwiftUI

struct FormRowStaticView: View {
    // MARK: - Properties
    var icon: String
    var firstText: String
    var secondText: String
    
    // MARK: - Body
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.gray)
                    .frame(width: 36, height: 36, alignment: .center)
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            Text(firstText).foregroundColor(.gray)
            Spacer()
            Text(secondText)
        }
    }
}

// MARK: - Preview
struct FormRowStaticView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "ToDo")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
