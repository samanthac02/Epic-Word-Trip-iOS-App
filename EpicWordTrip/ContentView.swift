//
//  ViewController.swift
//  Leaderboard with Firebase
//
//  Created by Samantha Chang on 6/4/22.
//

import SwiftUI
import FirebaseDatabase

let defaults = UserDefaults.standard
// Leters and their respective point amount
let alphabet = ["A": 1, "B": 3, "C": 3, "D": 2, "E": 1, "F": 4, "G": 2, "H": 4, "I": 1, "J": 8, "K": 5, "L": 1, "M": 3, "N": 1, "O": 1, "P": 3, "Q": 10, "R": 1, "S": 1, "T": 1, "U": 1, "V": 4, "W": 4, "X": 8, "Y": 4, "Z": 10]
let nums = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
let states = ["ALABAMA", "ALASKA", "ARIZONA", "ARKANSAS", "CALIFORNIA", "COLORADO", "CONNECTICUT", "DELAWARE", "FLORIDA", "GEORGIA", "HAWAII", "IDAHO", "ILLINOIS", "INDIANA", "IOWA", "KANSAS", "KENTUCKY", "LOUISIANA", "MAINE", "MARYLAND", "MASSACHUSETTS", "MICHIGAN", "MINNESOTA", "MISSISSIPPI", "MISSOURI", "MONTANA", "NEBRASKA", "NEVADA", "NEW HAMPSHIRE", "NEW JERSEY", "NEW MEXICO", "NEW YORK", "NORTH CAROLINA", "NORTH DAKOTA", "OHIO", "OKLAHOMA", "OREGON", "PENNSYLVANIA", "RHODE ISLAND", "SOUTH CAROLINA", "SOUTH DAKOTA", "TENNESSEE", "TEXAS", "UTAH", "VERMONT", "VIRGINIA", "WASHINGTON", "WEST VIRGINIA", "WISCONSIN", "WYOMING", "DMV"]
var fiveLetterWords = [""]

struct ContentView: View {
    @State var foundWords: [String] = []
    @State var letters: String = "_ _ _"
    @State var subplate: String = ""
    @State var word: String = ""
    @State var score: Int = 0
    @State var currentWordColor: [Color] = [Color(red: 54/255, green: 70/255, blue: 80/255), Color.gray] // Text color, border color
    
    @State var showingAlert = false
    @State var alertMessage = ""
    @State var tempTitle = "Epic Word Trip"
    @State var showingHelpPage: Bool = false
    @State var showingSettingsPage = false
    @State var showingKeyboard = false
    @State var previouslyLaunched: Bool = defaults.bool(forKey: "previouslyLaunched")
    
    @State var isSmallPhone: Bool = false
    
    @StateObject var locationManager = LocationManager()
    var userLatitude: String { return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)" }
    var userLongitude: String { return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)" }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // MARK: Title and menu bar
            HStack(alignment: .center) {
                
                // Help button within a Menu
                Menu {
                    Button("Help", action: help)
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(red: 12/255, green: 60/255, blue: 73/255))
                        .padding([.leading, .trailing])
                }.sheet(isPresented: $showingHelpPage) {
                    HelpView(showingHelpPage: $showingHelpPage, isSmallPhone: $isSmallPhone)
                }
                
                Spacer()
                
                // Title of the app
                Text(tempTitle)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 12/255, green: 60/255, blue: 73/255))
                    .padding()
                    .onAppear() {
                        // Shows 'Help' page if it is a first time launch
                        if previouslyLaunched == false {
                            previouslyLaunched = true
                            defaults.set(previouslyLaunched, forKey: "previouslyLaunched")
                            showingHelpPage = true
                        }
                        
                        // Loads all the 5-letter words
                        if let filepath = Bundle.main.path(forResource: "Words", ofType: "txt") {
                            do {
                                let contents = try String(contentsOfFile: filepath)
                                fiveLetterWords = contents.components(separatedBy: "\n")
                            } catch {
                                print("Contents could not be loaded")
                            }
                        } else {
                            print("Words.txt not found!")
                        }
                    }
                
                Spacer()
                
                Image(systemName: "line.3.horizontal")
                    .padding([.leading, .trailing])
                    .hidden()
            }
            
            VStack {
                ZStack {
                    VStack {
                        // MARK: Current letter bank and Scan button
                        HStack {
                            // Current letter bank
                            Text(letters.uppercased())
                                .onChange(of: letters) { _ in
                                    tempTitle.append(letters)
                                    
                                    subplate = ""
                                    
                                    if letters.count > 4 {
                                        letters = letters.uppercased()
                                        //letters = letters.replacingOccurrences(of: "\n", with: "")
                                        
                                        for i in 0..<letters.count {
                                            if nums.contains(letters[i]) == false && Array(alphabet.keys).contains(letters[i]) == false {
                                                letters = letters.replacingOccurrences(of: letters[i], with: "")
                                            }
                                        }
                                        
                                        for state in states {
                                            letters = letters.replacingOccurrences(of: state, with: "")
                                        }
                                        
                                        // Checks to see if the letters are on a standard license plate
                                        if letters.count >= 3 {
                                            for i in 0..<(letters.count - 3) {
                                                if Array(alphabet.keys).contains(letters[i]) && Array(alphabet.keys).contains(letters[i + 1]) && Array(alphabet.keys).contains(letters[i + 2]) && nums.contains(letters[i + 3]) {
                                                        print("JELLO")
                                                        
                                                        // Letters appeend to the subplate if the format is letter, letter, letter, number
                                                        subplate.append(letters[i])
                                                        subplate.append(letters[i + 1])
                                                        subplate.append(letters[i + 2])
                                                        
                                                        letters = subplate
                                    
                                                        break
                                                    } /*else if nums.contains(letters[i]) && Array(alphabet.keys).contains(letters[i + 1]) && Array(alphabet.keys).contains(letters[i + 2]) && Array(alphabet.keys).contains(letters[i + 3]) {
                                                    subplate = ""
                                                    
                                                    // Letters appeend to the subplate if the format is letter, letter, letter, number
                                                    subplate.append(letters[i + 1])
                                                    subplate.append(letters[i + 2])
                                                    subplate.append(letters[i + 3])
                                                    
                                                    letters = subplate
                                                    
                                                    break
                                                }*/
                                            }
                                        }
                                        
                                        if subplate == "" {
                                            var temporaryPlate = ""
                                            subplate = ""

                                            print("HELLO")

                                            for i in 0..<letters.count {
                                                if Array(alphabet.keys).contains(letters[i]) {
                                                    temporaryPlate.append(letters[i])
                                                }
                                            }

                                            print(temporaryPlate)

                                            if temporaryPlate.count >= 3 {
                                                subplate.append(temporaryPlate[0])
                                                subplate.append(temporaryPlate[1])
                                                subplate.append(temporaryPlate[2])

                                                letters = subplate
                                            } else {
                                                letters = "_ _ _"
                                            }
                                        }
                                                
//                                        if subplate == "_ _ _" {
//                                            for i in 0..<(letters.count - 3) {
//                                                letters = letters.replacingOccurrences(of: "1", with: "I")
//                                                letters = letters.replacingOccurrences(of: "2", with: "S")
//                                                letters = letters.replacingOccurrences(of: "3", with: "E")
//                                                letters = letters.replacingOccurrences(of: "5", with: "S")
//                                                letters = letters.replacingOccurrences(of: "7", with: "T")
//                                                letters = letters.replacingOccurrences(of: "8", with: "B")
//                                                letters = letters.replacingOccurrences(of: "9", with: "P")
//                                                letters = letters.replacingOccurrences(of: "0", with: "O")
//
//
//                                                if Array(alphabet.keys).contains(letters[i]) && Array(alphabet.keys).contains(letters[i + 1]) && Array(alphabet.keys).contains(letters[i + 2]) {
//                                                    subplate = ""
//
//                                                    // Letters appeend to the subplate if the format is letter, letter, letter, number
//                                                    subplate.append(letters[i])
//                                                    subplate.append(letters[i + 1])
//                                                    subplate.append(letters[i + 2])
//
//                                                    break
//                                                } else {
//                                                    subplate = "_ _ _"
//                                                }
//                                            }
//                                        }
//
                                    //}
                                        /* else {
                                        letters = "_ _ _"*/
                                    }
                                    
                                    print(subplate)
                                    
                                }
                                .font(.system(size: 45))
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                            
                            // Live-text button
                            ScanButton(text: $letters)
                                .frame(width: 156, height: 56, alignment: .leading)
                                .padding([.leading, .trailing])
                            
                        }// i Pad .padding([.leading, .trailing, .bottom], 12)
                        .padding([.leading, .trailing], 12)

                        // MARK: Words list
                        ScrollViewReader { scrollView in
                            ScrollView {
                                VStack {
                                    // MARK: Found words list
                                    ForEach(0..<foundWords.count, id:\.self) { word in
                                        HStack {
                                            ForEach(0...4, id: \.self) { letter in
                                                ZStack {
                                                    Rectangle()
                                                        .fill(Color(red: 151/255, green: 202/255, blue: 51/255))
                                                        .border(Color(red: 151/255, green: 202/255, blue: 51/255))
                                                        .frame(width: 64, height: 64)
                                                    
                                                    Text(foundWords[word][letter])
                                                        .font(.title2)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color(red: 246/255, green: 255/255, blue: 247/255))
                                                }
                                            }
                                        }
                                        .padding([.leading, .trailing])
                                    }
                                    .onChange(of: letters) { _ in
                                        foundWords = []
                                        score = 0
                                    }
                                    
                                    // MARK: Current word
                                    ZStack {
                                        // Interface for the current word
                                        HStack {
                                            ForEach(0...4, id: \.self) { letter in
                                                ZStack {
                                                    Rectangle()
                                                        .fill(Color(red: 246/255, green: 255/255, blue: 247/255))
                                                        .border(currentWordColor[1])
                                                        .frame(width: 64, height: 64)
                                                    
                                                    Text(word[letter].uppercased())
                                                        .font(.title2)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(currentWordColor[0])
                                                }
                                            }
                                        }
                                        
                                        // Input field for the current word
                                        TextField("", text: $word)
                                            .onTapGesture {
                                                showingKeyboard = true
                                            }
                                            .onSubmit {
                                                showingKeyboard = false
                                                
                                                // Is not long enough
                                                if word.count < 5 {
                                                    showingAlert.toggle()
                                                    alertMessage = "Not long enough"
                                                }
                                            }
                                            .onChange(of: word) { _ in
                                                showingKeyboard = true
                                                
                                                // Sumbits the word
                                                if word.count == 5 {
                                                    hideKeyboard()
                                                    showingKeyboard = false
                                                    
                                                    // Easter egg for my dad
                                                    if word.uppercased() == "WOWWE" {
                                                        score += 200
                                                        showingAlert.toggle()
                                                        alertMessage = "What you doing daddy"
                                                    }
                                                    
                                                    // Checks for valid word (and appends to foundWords if valid)
                                                    if fiveLetterWords.contains(word.lowercased()) && checkForCorrectLetters(for: letters, in: word) == true && foundWords.contains(word.uppercased()) == false {
                                                        // If valid word
                                                        score += calculateScore(for: word)
                                                        currentWordColor = [Color(red: 151/255, green: 202/255, blue: 51/255), Color(red: 151/255, green: 202/255, blue: 51/255)]

                                                        // Turns green for 0.78 seconds and then goes back to default
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.78) {
                                                            foundWords.append(word.uppercased())
                                                            word = ""
                                                            currentWordColor = [Color(red: 54/255, green: 70/255, blue: 80/255), Color.gray]
                                                        }
                                                    } else {
                                                        // If not valid word
                                                        currentWordColor = [Color(red: 219/255, green: 84/255, blue: 97/255), Color(red: 219/255, green: 84/255, blue: 97/255)]
                                                        
                                                        // Turns red for 0.78 seconds and then goes back to default
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.78) {
                                                            word = ""
                                                            currentWordColor = [Color.black, Color.gray]
                                                        }
                                                    }
                                                }
                                            }
                                            .alert(alertMessage, isPresented: $showingAlert) {
                                                Button("OK", role: .cancel) { }
                                            }
                                            .disableAutocorrection(true)
                                            .aspectRatio(contentMode: .fill)
                                            .accentColor(Color.clear)
                                            .foregroundColor(Color.clear)
                                            .font(.title)
                                            .frame(height: 64)
                                    }.id(foundWords.count)
                                }
                            // Auto-scrolling
                            }.onChange(of: foundWords) { _ in
                                withAnimation {
                                    scrollView.scrollTo(foundWords.count, anchor: .bottom)
                                }
                            }
                            // For iPad
                            // .frame(height: 460)
                            .frame(height: (isSmallPhone ? 280 : 350))
                        }
                    }
                }
                
                // MARK: Bottom image and score
                ZStack {
                    Image("TreesBackground5")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(x: 0, y: (isSmallPhone ? 28 : 40))

                    // Score
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 0)
                            .background(Circle().foregroundColor(Color(red: 246/255, green: 217/255, blue: 115/255)))
                            .frame(width: 64, height: 64)
                        
                        Text("\(score)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 246/255, green: 255/255, blue: 247/255))
                            .offset(x: 0, y: -1)
                    }
                    .offset(x: 0, y: (isSmallPhone ? -36 : -30))
                }
            }
        // Interface depending on the device type
        }.onAppear() {
            let modelName = UIDevice.modelName
            
            if modelName == "iPhone 6" || modelName == "iPhone 6s" || modelName == "iPhone 7" || modelName == "iPhone 8" || modelName == "iPhone SE (2nd generation)" || modelName == "iPhone SE (3rd generation)"{
                isSmallPhone = true
            }
        
            if modelName == "iPhone 6 Plus" || modelName == "iPhone 7 Plus" || modelName == "iPhone 8 Plus" || modelName == "iPhone X" || modelName == "iPhone XS" || modelName == "iPhone XS Max" || modelName == "iPhone XR" || modelName == "iPhone 11" || modelName == "iPhone 11 Pro" || modelName == "iPhone 11 Pro Max" || modelName == "iPhone 12" || modelName == "iPhone 12 Pro" || modelName == "iPhone 12 Pro Max" || modelName == "iPhone 12 mini" || modelName == "iPhone 13" || modelName == "iPhone 13 Pro" || modelName == "iPhone 13 Pro Max" || modelName == "iPhone 13 mini" {
                isSmallPhone = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("-----------------------")
                print(userLatitude)
                print("-----------------------")
                let myRef = Database.database().reference()
                
                myRef.child("locations").childByAutoId().setValue(["latitude": "\(userLatitude)", "longitude": "\(userLongitude)"])
            }
        }
        .background(Color(red: 246/255, green: 255/255, blue: 247/255).ignoresSafeArea())
    }
    
    // Calculates the word's score based off of each letter's point value
    func calculateScore(for word: String) -> Int {
        var wordScore = 0
        
        for letter in word {
            wordScore += alphabet[letter.uppercased()]!
        }
        
        return wordScore
    }
    
    // Sees if all 3 letters are in the typed word
    func checkForCorrectLetters(for letters: String, in word: String) -> Bool {
        for i in letters {
            if word.uppercased().contains(i) == false {
                return false
            }
        }
        
        return true
    }
    
    // Brings up the 'Help' page
    func help() {
        hideKeyboard()
        showingKeyboard = false
        showingHelpPage = true
    }
    
    // Brings up the 'Settings' page
    func settings() {
        hideKeyboard()
        showingKeyboard = false
        showingSettingsPage = true
    }
}
