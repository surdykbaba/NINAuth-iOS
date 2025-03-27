import SwiftUI
import RealmSwift

struct DigitalbackCard: View {
    @ObservedResults(User.self) var user

    var body: some View {
        ZStack {
            Image("NinBack")
                .resizable()
                .scaledToFill()
                .frame(height: 242)
                .clipped()

            VStack {
                Spacer() // Pushes the first text to the center
                
                Text("CVV234") // First text in the center
                    .customFont(.body, fontSize: 16)
                    .foregroundColor(.gray)
                    .offset(x: -120)
                    .padding(.top, 30)

                Spacer() // Creates space between both texts
                
                Text("2045 4664 7474 7474".localized) // Second text at the bottom
                    .customFont(.title, fontSize: 24)
                    .foregroundColor(.gray)
                    .offset(x: -25)
                    .padding(.bottom, 20) // Adjust as needed
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 242)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DigitalbackCard()
}
