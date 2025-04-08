import SwiftUI
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
            HStack(alignment: .bottom, spacing: 0) {
                
                // ZStack to create the holographic effect
                ZStack {
                    // Blended background
                    Image("holographic")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .opacity(29)

                    // Rotating holographic effect
                    Image("holographic")
                        .resizable()
                        .frame(width: 53, height: 52)
                        .clipShape(Circle())
                        .rotationEffect(.degrees(rotateHolographic))
                        .opacity(0.2)
                        .onAppear {
                            withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                                rotateHolographic = 360
                            }
                        }
                    
                    // Static NIMC logo on top
                    Image("Nimc")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
                .offset(y: 20)
                .padding(.leading, 16)
                .padding(.trailing, 14)

                // Left column: user info
                VStack(alignment: .leading, spacing: 8) {
                    doubleTextView(title: "SURNAME", subtitle: user.first?.last_name ?? "")
                    doubleTextView(title: "FIRST NAME", subtitle: user.first?.first_name ?? "")
                    doubleTextView(title: "MIDDLE NAME", subtitle: user.first?.middle_name ?? "")
                    doubleTextView(title: "GENDER",  subtitle: user.first?.gender?.lowercased() == "m" ? "Male" :
                                    user.first?.gender?.lowercased() == "f" ? "Female" : ""
                      )
                }
                
                // Right column: additional info
                VStack(alignment: .leading, spacing: 8) {
                    doubleTextView(title: "NATIONAL IDENTITY NUMBER", subtitle: user.first?.nin.map {
                        String(repeating: "*", count: max($0.count - 4, 0)) + $0.suffix(4)
                    } ?? ""
                )
                    doubleTextView(title: "STATE OF ORIGIN", subtitle: "LAGOS")
                    doubleTextView(title: "LGA", subtitle: "SURULERE")
                    doubleTextView(title: "DATE OF BIRTH", subtitle: user.first?.getDOB() ?? "")
                }
                .padding(.leading, 16)
                
                
                
                Spacer()
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        //.padding(.leading, 40)
        .padding(.top, 10)
        .frame(height: 242)
        .frame(maxWidth: .infinity, maxHeight: 242, alignment: .leading)
        .background(
            Image("NinID_Front_new")
                .resizable()
                .scaledToFill()
                
        )
        // User image blended with the background
        .overlay(
            Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 89, height: 107)
                .offset(y: -30),
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
