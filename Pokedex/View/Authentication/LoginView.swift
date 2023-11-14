//
//  LoginView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 12/11/2566 BE.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack{
            
            VStack{
            
                // image
                Image("Pokedex")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding(.vertical, 30)
//                    .border(.red)
                // form
                VStack(spacing: 30){
                    InputView(text: $email, title: "Email", placeholder: "email")
                        .autocapitalization(.none)
                    InputView(text: $password, title: "Password", placeholder: "password", isSecureField: true)
                }
                .padding(.horizontal, 50)
                
                
                // sign in
                Button(action: {
                    Task{
                        try await authViewModel.signIn(withEmail: email, password: password)
                    }
                }, label: {
                    Text("Login")
                        
                })
                .frame(width: UIScreen.main.bounds.width - 100, height: 40)
                .background(Color(red: 0.957, green: 0.455, blue: 0.455))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 30)
                .disabled(!formValid)
                .opacity(formValid ? 1.0: 0.5)
//                Spacer()
                
                // sign up
                NavigationLink(destination: {
                    RegisterView()
                }, label: {
                    HStack{
                        Text("No Account? Register")
                        
                    }
                })
            }
        }
    }
}
// MARK: - AuthenticationFormProtocal
extension LoginView: AuthenticationFormProtocal{
    var formValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 8
    }
}

#Preview {
    LoginView()
}

