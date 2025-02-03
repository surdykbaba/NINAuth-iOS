//
//  TermsOfServiceView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        Color.secondaryGrayBackground
            .ignoresSafeArea()
            .overlay(
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Terms of Service")
                            .padding(.bottom, 10)
                            .padding(.top, 40)
                            .customFont(.headline, fontSize: 24)
                        
                        VStack(alignment: .leading, spacing: 40) {
                            HStack {
                                Text("Last Updated: ")
                                Text("22nd July 2024")
                            }
                            .foregroundColor(Color.text)
                            .customFont(.body, fontSize: 16)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Acceptance of Terms")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("By accessing or using NINAuth, you agree to be bound by these Terms of Use. If you do not agree to these terms, please do not use our services.")
                                    .foregroundColor(Color.text)
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Description of Services")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("NINAuth provides a digital identity management platform that allows users to verify their identity, process transactions, and manage their personal information securely.")
                                    .foregroundColor(Color.text)
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("User Obligations")
                                        .customFont(.headline, fontSize: 17)
                                    Group {
                                        UnorderedListView(listItem: "You must provide accurate, current, and complete information when using our Services.")
                                        UnorderedListView(listItem: "You are responsible for maintaining the confidentiality of your account credentials.")
                                        UnorderedListView(listItem: "You agree not to use the Services for any unlawful purpose or in any way that could damage, disable, overburden, or impair our systems.")
                                    }
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.text)
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Privacy and Data Usage")
                                        .customFont(.headline, fontSize: 17)
                                    Group {
                                        UnorderedListView(listItem: "Your use of our Services is also governed by our Privacy Policy, which is incorporated into these Terms by reference.")
                                        UnorderedListView(listItem: "We collect and use personal information as described in our Privacy Policy, including but not limited to:")
                                        UnorderedListView(listItem: "National Identification Number (NIN)")
                                        UnorderedListView(listItem: "Full name")
                                        UnorderedListView(listItem: "Date of birth")
                                        UnorderedListView(listItem: "Contact information")
                                        UnorderedListView(listItem: "Biometric data")
                                        UnorderedListView(listItem: "By using our Services, you consent to the collection, use, and sharing of your information as outlined in our Privacy Policy.")
                                    }
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.text)
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Intellectual Property Rights")
                                        .customFont(.headline, fontSize: 17)
                                    Group {
                                        UnorderedListView(listItem: "All content, features, and functionality of the Services are owned by NINAuth and are protected by copyright, trademark, and other intellectual property laws.")
                                        UnorderedListView(listItem: "You may not reproduce, distribute, modify, create derivative works of, publicly display, publicly perform, republish, download, store, or transmit any of the material on our Services without our prior written consent.")
                                    }
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.text)
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Limitation of Liability")
                                        .customFont(.headline, fontSize: 17)
                                    Group {
                                        UnorderedListView(listItem: "NINAuth shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use or inability to use the Services.")
                                        UnorderedListView(listItem: "Our liability for any direct damages shall be limited to the amount paid by you, if any, for accessing our Services during the month in which the damage occurred.")
                                    }
                                    .padding(.leading, 10)
                                    .foregroundColor(Color.text)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Indemnification")
                                    .customFont(.headline, fontSize: 17)
                                Text("You agree to indemnify, defend, and hold harmless NINAuth and its officers, directors, employees, agents, and affiliates from and against any claims, liabilities, damages, judgments, awards, losses, costs, expenses, or fees arising out of your use of the Services or violation of these Terms.")
                                    .customFont(.body, fontSize: 17)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Termination")
                                    .customFont(.headline, fontSize: 17)
                                Group {
                                    UnorderedListView(listItem: "We may terminate or suspend your account and access to the Services at our sole discretion, without notice, for any reason, including breach of these Terms.")
                                    UnorderedListView(listItem: "Upon termination, your right to use the Services will immediately cease")
                                }
                                .padding(.leading, 10)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Changes to Terms")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("We may revise these Terms at any time. We will notify you of any significant changes through our platform or via email. Your continued use of the Services after such changes constitutes your acceptance of the new Terms.")
                                    .foregroundColor(Color.text)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Governing Law")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("These Terms are governed by the laws of Nigeria, without regard to its conflict of law provisions.")
                                    .foregroundColor(Color.text)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Contact Information")
                                    .customFont(.headline, fontSize: 22)
                                    .foregroundColor(Color.button)
                                Text("If you have any questions about these Terms, please contact us at")
                                    .foregroundColor(Color.text)
                                Text("nimccustomercare@nimc.gov.ng")
                                    .underline()
                                    .accentColor(Color.button)
                                Text("By using NINAuth, you acknowledge that you have read, understood, and agree to be bound by these Terms of Use.")
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
    TermsOfServiceView()
}
