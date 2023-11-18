//
//  InputView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 12/11/2566 BE.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(title)
                
            if isSecureField{
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))
            }else{
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
            }
            Rectangle().frame(height: 1)
                .foregroundStyle(Color(red: 0.957, green: 0.455, blue: 0.455))
//            Divider()
            
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email", placeholder: "Name ex.")
}
