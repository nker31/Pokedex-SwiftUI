//
//  ForgotPasswordView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 18/11/2566 BE.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var displayAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            VStack(spacing: 30){
                Text("Forgot Password").font(.title3)
                InputView(text: $email, title: "Enter your email", placeholder: "email")
                    .autocapitalization(.none)

            }
            .padding(.horizontal, 50)
            Button(action: {
                authViewModel.resetPassword(withEmail: email)
                displayAlert = true
            }, label: {
                Text("Send an email reset password")
                    
            })
            .frame(width: UIScreen.main.bounds.width - 100, height: 40)
            .background(Color(red: 0.957, green: 0.455, blue: 0.455))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 30)
            .disabled(!formValid)
            .opacity(formValid ? 1.0: 0.5)
        }
        .alert(isPresented:$displayAlert) {
                    Alert(
                        title: Text("Reset password completed"),
                        message: Text("An email to reset your password has been sent to your email address \(email)"),
                        dismissButton: .destructive(Text("Got it")) {
                            dismiss()
                        }
                    )
                }

    }
}

#Preview {
    NavigationStack{
        ForgotPasswordView().environmentObject(AuthViewModel())
    }
    
}

// MARK: - AuthenticationFormProtocal
extension ForgotPasswordView: AuthenticationFormProtocal{
    var formValid: Bool {
        return !email.isEmpty
        && email.contains("@")
    }
}
