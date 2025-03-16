import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ContentView: View {
    let grade2Braille: [String: String] = [
        "a": "⠁", "b": "⠃", "c": "⠉", "d": "⠙", "e": "⠑", "f": "⠋", "g": "⠛", "h": "⠓", "i": "⠊", "j": "⠚",
        "k": "⠅", "l": "⠇", "m": "⠍", "n": "⠝", "o": "⠕", "p": "⠏", "q": "⠟", "r": "⠗", "s": "⠎", "t": "⠞",
        "u": "⠥", "v": "⠧", "w": "⠺", "x": "⠭", "y": "⠽", "z": "⠵",
        "and": "⠯", "for": "⠿", "of": "⠷", "the": "⠮", "with": "⠾",
        "in": "⠬", "ed": "⠫", "en": "⠩", "er": "⠻", "ou": "⠳",
        "st": "⠌", "ing": "⠬", "th": "⠹", "wh": "⠺", "ch": "⠟",
        "sh": "⠩", "ar": "⠜", "capital": "⠠"
    ]

    @State private var inputText: String = ""
    @State private var brailleOutput: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Braille Grade 2 Converter")
                .font(.largeTitle)
                .bold()

            TextField("Enter text", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                brailleOutput = convertToBrailleGrade2(input: inputText)
            }) {
                Text("Convert to Braille")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if !brailleOutput.isEmpty {
                Text("Braille Output:")
                    .font(.title2)
                    .padding(.top, 20)

                Text(brailleOutput)
                    .font(.title)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    func convertToBrailleGrade2(input: String) -> String {
        var brailleText = ""
        
        // Sort contractions by length (longest first) to prioritize longer contractions
        let contractions = grade2Braille.keys.sorted { $0.count > $1.count }
        
        // Split the input into words
        let words = input.components(separatedBy: " ")

        for word in words {
            var remainingWord = word
            var formattedBrailleWord = ""
            
            // Process contractions and capital signs
            while !remainingWord.isEmpty {
                var matched = false
                
                // Check for contractions
                for contraction in contractions {
                    if remainingWord.lowercased().hasPrefix(contraction) {
                        if let brailleContraction = grade2Braille[contraction] {
                            // Add a capital sign if the contraction starts with an uppercase letter
                            if remainingWord.prefix(contraction.count).first!.isUppercase {
                                formattedBrailleWord += grade2Braille["capital"] ?? ""
                            }
                            formattedBrailleWord += brailleContraction
                            remainingWord.removeFirst(contraction.count)
                            matched = true
                            break
                        }
                    }
                }
                
                if !matched {
                    // Handle individual characters
                    let char = remainingWord.first!
                    remainingWord.removeFirst()
                    
                    if char.isUppercase {
                        formattedBrailleWord += grade2Braille["capital"] ?? ""
                    }
                    formattedBrailleWord += grade2Braille[String(char.lowercased())] ?? "⠿"
                }
            }
            
            brailleText += formattedBrailleWord + " "
        }

        return brailleText.trimmingCharacters(in: .whitespaces)
    }
}

#Preview {
    ContentView()
}