//
//  HelpView.swift
//  Epic Word Trip
//
//  Created by Samantha Chang on 6/4/22.
//

import SwiftUI

struct HelpView: View {
    @Binding var showingHelpPage: Bool
    @Binding var isSmallPhone: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Image("TreesBackground5")
                .resizable()
                .aspectRatio(contentMode: (isSmallPhone ? .fill : .fit))
            
            Text("Game Play")
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading)
                .padding(.bottom, 6)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image("1024x")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .cornerRadius(12)
                        .padding([.leading, .trailing])

                    
                    VStack(alignment: .leading) {
                        Text("Scan license plates to get letters")
                            .fontWeight(.semibold)
                        
                        Text("This only works with license plates that contain at least 3 letters and isn't always accurate")
                        
                        Image("LicensePlate")
                            .resizable()
                            .cornerRadius((isSmallPhone ? 12 : 24))
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 16)
                            .padding(.bottom, 2)
                    }
                }
            }.padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("📱")
                        .font(.system(size: 54))
                        .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Make word with the letters")
                            .fontWeight(.semibold)
                        
                        Text("Think of as many words as you can that have all 3 of the shown letters")
                        
                        Image("Word")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing)
                            .padding(.bottom, 6)
                    }
                }
            }.padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("🏆")
                        .font(.system(size: 54))
                        .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text("Get points")
                            .fontWeight(.semibold)
                        
                        Text("Each words is awarded a point value and those points are added to your score")
                    }
                }
            }.padding(.trailing, 8)
            
            Spacer()
            
            HStack {
                Spacer()
            
                Button(action: {
                    showingHelpPage = false
                }) {
                    Text("Got it!")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 48)
                }
                .background(Color(red: 242/255, green: 242/255, blue: 242/255))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding(.bottom)
        }
    }
}

