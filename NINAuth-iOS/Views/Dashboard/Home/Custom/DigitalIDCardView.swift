import SwiftUI
import RealmSwift

struct DigitalIDCardView: View {
    @ObservedResults(User.self) var user
    @State private var rotateHolographic = 0.0

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("federal_republic_of_nigeria")
                .customFont(.title, fontSize: 14)
                .foregroundColor(Color.button)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
                .padding(.trailing,5)

            Text("national_identity_card")
                .customFont(.title, fontSize: 12)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
                .padding(.trailing,5)

            HStack(alignment: .top, spacing: 0) {
                VStack {
                    Spacer()
                    ZStack {
                        Image("holographic")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .opacity(29)
                        
                        Image("holographic")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .rotationEffect(.degrees(rotateHolographic))
                            .opacity(0.29)
                            .onAppear {
                                withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                                    rotateHolographic = 360
                                }
                            }
                        
                        Image("Nimc")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .frame(maxWidth: 53, maxHeight: .infinity, alignment: .bottom,)
                .offset(x: 5)
                .offset(y: -10)
                

                VStack(alignment: .leading, spacing: 4) {
                    doubleTextView(title: "SURNAME", subtitle: user.first?.last_name ?? "")
                    doubleTextView(title: "FIRST NAME", subtitle: user.first?.first_name ?? "")
                    doubleTextView(title: "MIDDLE NAME", subtitle: user.first?.middle_name ?? "")
                    doubleTextView(title: "GENDER", subtitle: user.first?.gender ?? "")
                }
                .frame(maxWidth: 100)
                .padding(.trailing,5)

                VStack(alignment: .leading, spacing: 4) {
                    doubleTextView(
                            title: "NATIONAL IDENTITY NUMBER",
                            subtitle: {
                                let nin = user.first?.nin ?? ""
                                if nin.count >= 11 {
                                    let masked = String(repeating: "*", count: 7) + nin.suffix(4)
                                    return masked
                                } else {
                                    return nin
                                }
                            }()
                        )
                    doubleTextView(
                        title: "STATE OF ORIGIN",
                        subtitle: (user.first?.origin_state?.isEmpty == false ? user.first?.origin_state : "N/A") ?? "N/A"
                    )
                    doubleTextView(
                        title: "LGA",
                        subtitle: (user.first?.origin_local_government?.isEmpty == false ? user.first?.origin_local_government : "N/A") ?? "N/A"
                    )
                    doubleTextView(title: "DATE OF BIRTH", subtitle: user.first?.getDOB() ?? "")
                }
                .padding(.leading, 16)
                .padding(.trailing,5)
                .frame(maxWidth: 150)

                Spacer()
            }
            .padding(.top, 19)
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding(.top, 10)
        .frame(height: 242)
        .frame(maxWidth: .infinity, maxHeight: 242, alignment: .leading)
        .background(
            Image("NinID_Front_new")
                .resizable()
                .frame(width: 360, height: 230)
                .clipped()
        )
        .overlay(
            VStack {
                Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
                    .frame(width: 89, height: 70)
            }
            .frame(width: 79, height: 97)
            .background(Color.white)
            .padding(.bottom, 34)
            .padding(.trailing,),
            alignment: .bottomTrailing
        )
        .environment(\.dynamicTypeSize, .medium)
    }

    func doubleTextView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .customFont(.body, fontSize:9)
                .foregroundColor(Color(.cardLabel))
                .padding(.top, 1)
            Text(subtitle)
                .customFont(.title, fontSize: 12)
                .foregroundColor(Color(.text))
        }
        .multilineTextAlignment(.leading)
        .environment(\.dynamicTypeSize, .medium)
    }
}

#Preview {
    DigitalIDCardView()
        .environment(\.dynamicTypeSize, .medium)
}
