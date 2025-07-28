import XCTest
@testable import PromptKit

final class PromptKitTests: XCTestCase {
    
    // MARK: - EndpointType Tests
    
    func testEndpointTypeTextGeneratorGPTRequestPreparation() {
        let rules = "Test rules"
        let prompt = "Test prompt"
        let apiKey = "test-api-key"
        let endpoint = EndpointType.textGeneratorGPT(promptRules: rules, prompt: prompt, apiKey: apiKey)

        let result = EndpointType.prepareRequestURL(endpoint)

        switch result {
        case .success(let request):
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.url)
            XCTAssertNotNil(request.value(forHTTPHeaderField: "Authorization"))
            XCTAssertNotNil(request.value(forHTTPHeaderField: "Content-Type"))
            XCTAssertNotNil(request.httpBody)
            
        case .failure:
            XCTFail("Request preparation should not fail with valid inputs")
        }
    }
    
    func testEndpointTypeImageAnalyzerGPTRequestPreparation() {
        let rules = "Test rules"
        let imageData = "base64EncodedImageData"
        let apiKey = "test-api-key"
        let endpoint = EndpointType.imageAnalyzerGPT(promptRules: rules, imageData: imageData, apiKey: apiKey)
        
        let result = EndpointType.prepareRequestURL(endpoint)
        
        switch result {
        case .success(let request):
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.url)
            XCTAssertNotNil(request.value(forHTTPHeaderField: "Authorization"))
            XCTAssertNotNil(request.value(forHTTPHeaderField: "Content-Type"))
            XCTAssertNotNil(request.httpBody)
            
        case .failure:
            XCTFail("Request preparation should not fail with valid inputs")
        }
    }
    
    // MARK: - NetworkError Tests
    
    func testNetworkErrorMessages() {
        XCTAssertEqual(NetworkError.invalidURL.errorMessage, "Invalid URL")
        XCTAssertEqual(NetworkError.requestFailedError.errorMessage, "Request failed")
        XCTAssertEqual(NetworkError.noDataError.errorMessage, "No data returned")
        XCTAssertEqual(NetworkError.decodingFailedError.errorMessage, "Decoding failed")
        XCTAssertEqual(NetworkError.statusCodeError(404).errorMessage, "Status code Error: 404")
    }
    
    // MARK: - Model Tests
    
    func testGPTAnalyzeRequestModelEncoding() {
        let requestModel = GPTAnalyzeRequestModel(
            model: "gpt-3.5-turbo",
            messages: [
                GPTAnalyzeRequestModel.AnalyzeModel(role: "system", content: "Test system message"),
                GPTAnalyzeRequestModel.AnalyzeModel(role: "user", content: "Test user message")
            ]
        )
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(requestModel)
        
        XCTAssertNotNil(data)
        XCTAssertTrue(data!.count > 0)
    }
    
    func testGPTAnalyzeResponseModelDecoding() {
        let jsonString = """
        {
            "choices": [
                {
                    "message": {
                        "content": "Test response content"
                    }
                }
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try? decoder.decode(GPTAnalyzeResponseModel.self, from: jsonData)
        
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.choices.first?.message.content, "Test response content")
    }
    
    // MARK: - TextGenerator Tests
    
    func testTextGeneratorInitialization() {
        let textGenerator = TextGenerator(
            promptRules: "Test rules",
            prompt: "Test prompt",
            apiKey: "test-api-key",
            generateType: .textGeneratorGPT
        )
        
        XCTAssertNotNil(textGenerator)
    }
    
    // MARK: - ImageAnalyzer Tests
    
    func testImageAnalyzerInitialization() {
        let testData = "test image data".data(using: .utf8)!
        
        let imageAnalyzer = ImageAnalyzer(
            promptRules: "Test rules",
            imageData: testData,
            apiKey: "test-api-key",
            generateType: .imageAnalyzerGPT
        )
        
        XCTAssertNotNil(imageAnalyzer)
    }
}

