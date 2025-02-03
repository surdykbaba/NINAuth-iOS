//
//  PrivacyPolicyView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        Color.secondaryGrayBackground
            .ignoresSafeArea()
            .overlay(
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Privacy Policy")
                            .padding(.bottom, 10)
                            .padding(.top, 40)
                            .customFont(.headline, fontSize: 24)
                        
                        VStack(alignment: .leading, spacing: 40) {
                            HStack {
                                Text("Effective Date: ")
                                Text("August 2, 2024")
                            }
                            .foregroundColor(Color.text)
                            .customFont(.body, fontSize: 16)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Introduction")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("NINAuth is committed to protecting your privacy and securing your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our digital identity management platform and related services.")
                                    .foregroundColor(Color.text)
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Information We Collect")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Personal Information")
                                        .customFont(.headline, fontSize: 17)
                                    Group {
                                        UnorderedListView(listItem: "National Identification Number (NIN)")
                                        UnorderedListView(listItem: "Full name")
                                        UnorderedListView(listItem: "Date of birth")
                                        UnorderedListView(listItem: "Contact information (e.g., address, phone number, email)")
                                        UnorderedListView(listItem: "Biometric data (e.g., fingerprints, facial recognition data)")
                                    }
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.text)
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Usage Information")
                                        .customFont(.headline, fontSize: 17)
                                    Group {
                                        UnorderedListView(listItem: "Log data")
                                        UnorderedListView(listItem: "Device information")
                                        UnorderedListView(listItem: "IP address")
                                        UnorderedListView(listItem: "Browser type")
                                        UnorderedListView(listItem: "Pages visited and features used within our platform")
                                    }
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.text)
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("How We Use Your Information")
                                        .customFont(.headline, fontSize: 17)
                                    Text("We use your information to:")
                                        .customFont(.body, fontSize: 17)
                                    Group {
                                        UnorderedListView(listItem: "Verify your identity")
                                        UnorderedListView(listItem: "Provide and improve our services")
                                        UnorderedListView(listItem: "Process transactions and applications")
                                        UnorderedListView(listItem: "Communicate with you about our services")
                                        UnorderedListView(listItem: "Comply with legal obligations")
                                        UnorderedListView(listItem: "Detect and prevent fraud or unauthorized access")
                                    }
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.text)
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Data Sharing and Disclosure")
                                        .customFont(.headline, fontSize: 17)
                                    Text("We may share your information with:")
                                        .customFont(.body, fontSize: 17)
                                    Group {
                                        UnorderedListView(listItem: "Government agencies (as required for service delivery)")
                                        UnorderedListView(listItem: "Third-party service providers (under strict confidentiality agreements)")
                                        UnorderedListView(listItem: "Law enforcement agencies (when required by law)")
                                    }
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.text)
                                    Text("We do not sell your personal information to third parties.")
                                        .customFont(.body, fontSize: 16)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Data Security")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("We implement robust security measures to protect your information, including:")
                                    .customFont(.body, fontSize: 17)
                                Group {
                                    UnorderedListView(listItem: "Encryption of data in transit and at rest")
                                    UnorderedListView(listItem: "Regular security audits")
                                    UnorderedListView(listItem: "Access controls and authentication protocols")
                                    UnorderedListView(listItem: "Employee training on data protection")
                                }
                                .padding(.leading, 10)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Your Rights and Choices")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("You have the right to:")
                                    .customFont(.body, fontSize: 17)
                                Group {
                                    UnorderedListView(listItem: "Access your personal information")
                                    UnorderedListView(listItem: "Request corrections to your data")
                                    UnorderedListView(listItem: "Delete your account (subject to legal retention requirements)")
                                    UnorderedListView(listItem: "Opt-out of certain data processing activities")
                                    UnorderedListView(listItem: "Receive a copy of your data in a portable format")
                                }
                                .padding(.leading, 10)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Data Retention")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("We retain your personal information for as long as necessary to provide our services and comply with legal obligations. After this period, your data will be securely deleted or anonymized.")
                                    .foregroundColor(Color.text)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Changes to This Policy")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("We may update this Privacy Policy periodically. We will notify you of any significant changes through our platform or via email.")
                                    .foregroundColor(Color.text)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Children's Privacy")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("Our services are not intended for children under 13. We do not knowingly collect information from children under 13.")
                                    .foregroundColor(Color.text)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("International Data Transfers")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("Your information may be transferred and processed in countries other than your own. We ensure appropriate safeguards are in place for such transfers.")
                                    .foregroundColor(Color.text)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text(" Contact Us")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("If you have any questions or concerns about this Privacy Policy, please contact our Data Protection Officer at")
                                    .foregroundColor(Color.text)
                                Text("nimccustomercare@nimc.gov.ng")
                                    .underline()
                                    .accentColor(Color.button)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Governing Law")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("This Privacy Policy is governed by the laws of Nigeria  without regard to its conflict of law provisions.")
                                    .foregroundColor(Color.text)
                                Text("By using NINAuth you agree to the terms outlined in this Privacy Policy.")
                            }
                        }
                        .padding(.vertical, 30)
                        .padding(.horizontal, 15)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .environment(\._lineHeightMultiple, 1.2)
                        .mask(
                            RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .padding()
                })
    }
}

#Preview {
    PrivacyPolicyView()
}
