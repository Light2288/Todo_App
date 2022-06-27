//
//  EmptyListView.swift
//  Todo App
//
//  Created by Davide Aliti on 16/06/22.
//

import SwiftUI

struct EmptyListView: View {
    // MARK: - Properties
    @State private var isAnimating: Bool = false
    
    let images: [String] = ["illustration-no1","illustration-no2","illustration-no3"]
    
    let tips: [String] = ["Use your time wisely", "Slow and steady wins the race", "Keep it short and sweet", "Put hard tasks first", "Reward yourself after work", "Collect tasks ahead of time", "Each night schedule for tomorrow"]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image(images.randomElement() ?? self.images[0])
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                Text(tips.randomElement() ?? self.tips[0])
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
            }
            .padding(.horizontal)
            .opacity(isAnimating ? 1 : 0)
            .offset(x: 0, y: isAnimating ? 0 : -50)
            .animation(.easeOut(duration: 1.5), value: isAnimating)
            .onAppear {
                self.isAnimating.toggle()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Preview
struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
