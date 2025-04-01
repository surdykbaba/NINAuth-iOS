import SwiftUI
import RealmSwift

struct DigitalIDCardView: View {
    @ObservedResults(User.self) var user
    @State private var rotateHolographic = 0.0 // Rotation state

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("federal_republic_of_nigeria".localized)
                .customFont(.title, fontSize: 14)
                .foregroundColor(Color.button)
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(x: -25)
                .padding(.top, 20)

            Text("national_identity_card".localized)
                .customFont(.title, fontSize: 12)
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(x: -35)
                .padding(.top, 6)

            // HStack containing NIMC logo and details
            HStack(alignment: .top, spacing: 0) {
                
                // ZStack to create the holographic effect
                ZStack {
                    // Blended background
                    Image("holographic")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .opacity(29) // Soft blending

                    // Rotating holographic effect
                    Image("holographic")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .rotationEffect(.degrees(rotateHolographic))
                        .opacity(0.3) // Reduce intensity to blend better
                        .onAppear {
                            withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                                rotateHolographic = 360
                            }
                        }

                    
                    // Static NIMC logo on top
                    Image("Nimc")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(.top, 65)
                .offset(x: -20)

                // Left column: user info
                VStack(alignment: .leading, spacing: 4) {
                    doubleTextView(title: "SURNAME", subtitle: user.first?.last_name ?? "")
                    doubleTextView(title: "FIRST NAME", subtitle: user.first?.first_name ?? "")
                    doubleTextView(title: "MIDDLE NAME", subtitle: user.first?.middle_name ?? "")
                    doubleTextView(title: "GENDER", subtitle: user.first?.gender  ?? "")
                }
                
                // Right column: additional info
                VStack(alignment: .leading, spacing: 4) {
                    doubleTextView(title: "NATIONAL IDENTITY NUMBER", subtitle: user.first?.nin ?? "")
                    doubleTextView(title: "STATE OF ORIGIN", subtitle: user.first?.first_name ?? "")
                    doubleTextView(title: "LGA", subtitle: user.first?.first_name ?? "")
                    doubleTextView(title: "DATE OF BIRTH", subtitle: user.first?.getDOB() ?? "")
                }
                .padding(.leading, 13)
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding(.leading, 40)
        .padding(.top, 10)
        .frame(height: 242)
        .frame(maxWidth: .infinity, maxHeight: 242, alignment: .leading)
        .background(
            Image("NinID_Front")
                .resizable()
                .scaledToFill() // Ensure it fully covers the space
                
        )
        // User image blended with the background
        .overlay(
            Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 12)),
            alignment: .bottomTrailing
        )
    }

    func doubleTextView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(.body, fontSize: 9)
                .foregroundColor(Color(red: 65/255, green: 66/255, blue: 60/255))
                .padding(.top, 1)
            Text(subtitle)
                .customFont(.body, fontSize: 12)
        }
    }
}

#Preview {
    DigitalIDCardView()
}
