import SwiftUI
import SwiftUIGIF
import RealmSwift

struct DigitalIDCardView: View {
    @ObservedResults(User.self) var user
    @State private var rotateHolographic = 0.0 // Rotation state

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("federal_republic_of_nigeria")
                .customFont(.title, fontSize: 14)
                .foregroundColor(Color.button)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)

            Text("national_identity_card")
                .customFont(.title, fontSize: 12)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)

            // HStack containing NIMC logo and details
            HStack(alignment: .top, spacing: 0) {
                
                // ZStack to create the holographic effect
                VStack {
                    Spacer()
                    GIFImage(name: "ninc")
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(maxWidth: 53, maxHeight: .infinity, alignment: .bottom)
                //.padding(.leading, 4)

                // Left column: user info
                VStack(alignment: .leading, spacing: 4) {
                    doubleTextView(title: "SURNAME", subtitle: user.first?.last_name ?? "")
                    doubleTextView(title: "FIRST NAME", subtitle: user.first?.first_name ?? "")
                    doubleTextView(title: "MIDDLE NAME", subtitle: user.first?.middle_name ?? "")
                    doubleTextView(title: "GENDER", subtitle: user.first?.gender  ?? "")
                }
                .frame(maxWidth: 100)
                
                // Right column: additional info
                VStack(alignment: .leading, spacing: 4) {
                    doubleTextView(title: "NATIONAL IDENTITY NUMBER", subtitle: user.first?.nin ?? "")
                    doubleTextView(title: "STATE OF ORIGIN", subtitle: "")
                    doubleTextView(title: "LGA", subtitle: "")
                    doubleTextView(title: "DATE OF BIRTH", subtitle: user.first?.getDOB() ?? "")
                }
                .padding(.leading, 16)
                .frame(maxWidth: 150)
                
                Spacer()
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding(.top, 10)
        .frame(height: 242)
        //.padding(.horizontal, 8)
        .frame(maxWidth: .infinity, maxHeight: 242, alignment: .leading)
        .background(
            Image("NinID_Front_new")
                .resizable()
                //.scaledToFill()
                .frame(width: 375, height: 242)
                .clipped()
                //.padding(.horizontal, 8)
        )
        // User image blended with the background
        .overlay(
            VStack {
                Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 89, height: 107)
            }.frame(width: 89, height: 107)
                .background(Color.white)
                .padding(.bottom, 20),
            alignment: .bottomTrailing
        )

    }

    func doubleTextView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(.body, fontSize: 9)
                .foregroundColor(Color(.cardLabel))
                .padding(.top, 1)
            Text(subtitle)
                .customFont(.title, fontSize: 12)
                .foregroundColor(Color(.text))
        }
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    DigitalIDCardView()
}
