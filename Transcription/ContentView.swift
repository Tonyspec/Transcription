import SwiftUI
import AppKit

struct ContentView: View {
    @State private var inputText = ""
    @State private var outputText = ""
    
    let transcriptionMap: [String: String] = [
        "A": "А", "a": "а",
        "B": "Б", "b": "б",
        "V": "В", "v": "в",
        "G": "Г", "g": "г",
        "D": "Д", "d": "д",
        "E": "Е", "e": "е",
        "Yo": "Ё", "yo": "ё",
        "Zh": "Ж", "zh": "ж",
        "Z": "З", "z": "з",
        "I": "И", "i": "и",
        "Iy": "Й", "iy": "й",
        "K": "К", "k": "к",
        "L": "Л", "l": "л",
        "M": "М", "m": "м",
        "N": "Н", "n": "н",
        "O": "О", "o": "о",
        "P": "П", "p": "п",
        "R": "Р", "r": "р",
        "S": "С", "s": "с",
        "T": "Т", "t": "т",
        "U": "У", "u": "у",
        "F": "Ф", "f": "ф",
        "Kh": "Х", "kh": "х",
        "Ts": "Ц", "ts": "ц",
        "Ch": "Ч", "ch": "ч",
        "Sh": "Ш", "sh": "ш",
        "Shch": "Щ", "shch": "щ",
        "\"": "Ъ", "`": "ъ",
        "Y": "Ы", "y": "ы",
        "\\\"": "Ь", "'": "ь",
        "Eh": "Э", "eh": "э",
        "Yu": "Ю", "yu": "ю",
        "Ya": "Я", "ya": "я"
    ]

    var body: some View {
            VStack(spacing: 20) {
                Text("English to Russian Transcription")
                    .padding()
                    .font(.system(.title, design: .serif))
                    .foregroundColor(.primary)
                    .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 2)
                
                TextEditor(text: $inputText)
                    .frame(minHeight: 150)
                    .padding()
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Button(action: {
                    self.outputText = self.transcribeText(self.inputText)
                }) {
                    Text("Transcribe")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(NSColor.controlAccentColor))
                        .cornerRadius(15)
                }
                .buttonStyle(PlainButtonStyle())
                
                TextEditor(text: $outputText)
                    .frame(minHeight: 150)
                    .padding()
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.windowBackgroundColor))
        }
    
    private func transcribeText(_ text: String) -> String {
        var result = ""
        var index = text.startIndex

        while index < text.endIndex {
            var matchFound = false
            
            // Check for "iya" -> "ия" before any other transcription
            if text.distance(from: index, to: text.endIndex) >= 3 {
                let range = index..<text.index(index, offsetBy: 3)
                let substring = text[range]
                if substring.lowercased() == "iya" {
                    let originalKey = text[range]
                    let transcription = originalKey.first?.isUppercase ?? false ? "Ия" : "ия"
                    result += transcription
                    index = range.upperBound
                    matchFound = true
                    continue
                }
                // Priority check for "iyu" -> "ию"
                if substring.lowercased() == "iyu" {
                    let originalKey = text[range]
                    let transcription = originalKey.first?.isUppercase ?? false ? "Ию" : "ию"
                    result += transcription
                    index = range.upperBound
                    matchFound = true
                    continue
                }
            }
            
            // Now proceed with the general transcription logic
            let sortedKeys = transcriptionMap.keys.sorted { $0.count > $1.count }

            for key in sortedKeys {
                // Check if there's enough characters left to match the key
                guard text.distance(from: index, to: text.endIndex) >= key.count else { continue }
                
                let endIndex = text.index(index, offsetBy: key.count, limitedBy: text.endIndex) ?? text.endIndex
                let range = index..<endIndex
                let substring = text[range]
                
                if substring.lowercased() == key.lowercased() {
                    let originalKey = text[range]
                    let transcription = transcriptionMap[key]!
                    
                    let transcribedText = originalKey.first?.isUppercase ?? false ?
                        transcription.prefix(1).uppercased() + transcription.dropFirst().lowercased() :
                        transcription.lowercased()
                    
                    result += transcribedText
                    index = range.upperBound
                    matchFound = true
                    break
                }
            }
            if !matchFound {
                result.append(text[index])
                index = text.index(after: index)
            }
        }
        
        return result
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
