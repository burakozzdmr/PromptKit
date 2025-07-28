# PromptKit

PromptKit is a modular and developer-friendly Swift package designed to simplify interactions with AI-powered APIs. It provides reusable components for two core functionalities: generating text from prompts and analyzing images to produce descriptive text outputs.

Whether you're building an intelligent chatbot or an app that interprets image content, PromptKit offers a lightweight and clean abstraction layer to integrate AI capabilities with minimal setup.

## ✨ Features

- ✍️ **TextGenerator** — Used for generating intelligent, context-aware text based on user-provided prompts. Ideal for building chatbots, content assistants, or any kind of natural language interface.

- 🖼️ **ImageAnalyzer** — Takes an input image and prepares it for AI analysis by encoding it and forming a descriptive text prompt. Useful for extracting meaning or generating captions from visual data.

## 📦 Installation

### Swift Package Manager (SPM)

To install PromptKit via Swift Package Manager:

1. Open your Xcode project.
2. Go to **File > Add Packages**.
3. Enter the following URL in the search bar:
``` swift
https://github.com/burakozzdmr/PromptKit.git
```
Choose the latest version and add the package to your project.

Alternatively, you can add it manually to your `Package.swift` file:
``` swift
dependencies: [
    .package(url: "https://github.com/burakozzdmr/PromptKit.git", from: "1.0.0")
]
```
## Usage
### TextGenerator

``` swift
let textGenerator = TextGenerator(
    promptRules: "Prompt Rules",
    prompt: "Prompt",
    apiKey: "YOUR_API_KEY",
    generateType: .textGeneratorGPT
)

func sendPrompt() {
    textGenerator.fetchGeneratedText { generateResult in
        switch generateResult {
        case .success(let generatedText):
            generateResultLabel.text = generatedText
        case .failure(let errorType):
            print(errorType.errorMessage)
        }
    }
}
```
### ImageAnalyzer
```swift
let imageAnalyzer = ImageAnalyzer(
    promptRules: "Prompt Rules",
    imageData: imageData,
    apiKey: "YOUR_API_KEY",
    generateType: .imageAnalyzerGPT
)

func sendPrompt() {
    imageAnalyzer.fetchImageAnalyzeData { analyzeResult in
        switch analyzeResult {
        case .success(let analyzeText):
            analyzeResultLabel.text = analyzeText
        case .failure(let errorType):
            print(errorType.errorMessage)
        }
    }
}
```
# LICENSE
[MIT](https://github.com/burakozzdmr/PromptKit/blob/main/LICENSE)
