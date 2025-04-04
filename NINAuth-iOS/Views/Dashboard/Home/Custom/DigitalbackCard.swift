import SwiftUI
import RealmSwift

struct DigitalbackCard: View {
    @ObservedResults(User.self) var user

    var body: some View {
        ZStack {
            Image("NinID_Back_new")
                .resizable()
                
                .frame(height: 242)
                .clipped()

                    }
        .frame(maxWidth: 370, maxHeight: 242, alignment: .leading)
    }
}

#Preview {
    DigitalbackCard()
}
