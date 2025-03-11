import SwiftUI
import RealmSwift

struct DigitalIDCardView: View {
    @ObservedResults(User.self) var user

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

            // HStack containing nimclogo and the two columns for details
            HStack(alignment: .top, spacing: 0) {
                // Nimclogo image on the left
                Image("nimc_logo")
                    .resizable()
                    .frame(width: 41, height: 44) // Adjust size as needed
                    .padding(.top, 90)
                    .offset(x: -15)
                
                // Left column: original user info
                VStack(alignment: .leading, spacing: 4) {
                    doubleTextView(title: "SURNAME", subtitle: user.first?.last_name ?? "")
                    doubleTextView(title: "FIRST NAME", subtitle: user.first?.first_name ?? "")
                    doubleTextView(title: "MIDDLE NAME", subtitle: user.first?.middle_name ?? "")
                    doubleTextView(title: "GENDER", subtitle: user.first?.gender  ?? "")
                    doubleTextView(title: "DATE OF BIRTH", subtitle: user.first?.getDOB() ?? "")
                }
                // Right column: additional info shifted right by 5 points
                VStack(alignment: .leading, spacing: 4) {
                    doubleTextView(title: "NATIONAL IDENTITY NUMBER", subtitle: user.first?.nin ?? "")
                    doubleTextView(title: "STATE OF ORIGIN", subtitle: user.first?.gender ?? "")
                    doubleTextView(title: "LGA", subtitle: user.first?.gender ?? "")
                    doubleTextView(title: "DATE OF ISSUE", subtitle: user.first?.gender ?? "")
                    doubleTextView(title: "DATE OF EXPIRY", subtitle: user.first?.gender ?? "")
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
        )
        // Place the user image in the top trailing corner
        .overlay(
            Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                .resizable()
                .frame(width: 100, height: 130)
                .clipped()
                .padding(),
            alignment: .topTrailing
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
