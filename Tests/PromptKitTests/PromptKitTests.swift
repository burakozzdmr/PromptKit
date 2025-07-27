import XCTest
@testable import PromptKit

final class PromptKitTests: XCTestCase {
    // MARK: - Properties
    
    private var networkManager: NetworkManager!
    private var mockURLSession: MockURLSession!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession(configuration: .default)
        networkManager = NetworkManager(session: mockURLSession)
    }
    
    override func tearDown() {
        networkManager = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    // MARK: - EndpointType Tests
    
    func testEndpointTypeTextGeneratorGPTRequestPreparation() {
        // Given
        let rules = "Test rules"
        let prompt = "Test prompt"
        let apiKey = "test-api-key"
        let endpoint = EndpointType.textGeneratorGPT(promptRules: rules, prompt: prompt, apiKey: apiKey)
        
        // When
        let result = EndpointType.prepareRequestURL(endpoint)
        
        // Then
        switch result {
        case .success(let request):
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, NetworkConstants.GPTConstants.baseURL + NetworkConstants.GPTConstants.completionsPath)
            XCTAssertEqual(request.value(forHTTPHeaderField: NetworkConstants.authorizationHeaderKey), "\(NetworkConstants.apiKeyPrefix) \(apiKey)")
            XCTAssertEqual(request.value(forHTTPHeaderField: NetworkConstants.contentTypeHeaderKey), NetworkConstants.jsonContentType)
            
            // Verify request body
            guard let httpBody = request.httpBody,
                  let requestModel = try? JSONDecoder().decode(GPTAnalyzeRequestModel.self, from: httpBody) else {
                XCTFail("Failed to decode request body")
                return
            }
            
            XCTAssertEqual(requestModel.model, "gpt-3.5-turbo")
            XCTAssertEqual(requestModel.messages.count, 2)
            XCTAssertEqual(requestModel.messages[0].role, NetworkConstants.GPTConstants.systemRoleName)
            XCTAssertEqual(requestModel.messages[0].content, rules)
            XCTAssertEqual(requestModel.messages[1].role, NetworkConstants.GPTConstants.userRoleName)
            XCTAssertEqual(requestModel.messages[1].content, prompt)
            
        case .failure:
            XCTFail("Request preparation should not fail with valid inputs")
        }
    }
    
    func testEndpointTypeImageAnalyzerGPTRequestPreparation() {
        // Given
        let rules = "Test rules"
        let imageData = "base64EncodedImageData"
        let apiKey = "test-api-key"
        let endpoint = EndpointType.imageAnalyzerGPT(promptRules: rules, imageData: imageData, apiKey: apiKey)
        
        // When
        let result = EndpointType.prepareRequestURL(endpoint)
        
        // Then
        switch result {
        case .success(let request):
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, NetworkConstants.GPTConstants.baseURL + NetworkConstants.GPTConstants.completionsPath)
            XCTAssertEqual(request.value(forHTTPHeaderField: NetworkConstants.authorizationHeaderKey), "\(NetworkConstants.apiKeyPrefix) \(apiKey)")
            XCTAssertEqual(request.value(forHTTPHeaderField: NetworkConstants.contentTypeHeaderKey), NetworkConstants.jsonContentType)
            
            // Verify request body
            guard let httpBody = request.httpBody,
                  let requestModel = try? JSONDecoder().decode(GPTAnalyzeRequestModel.self, from: httpBody) else {
                XCTFail("Failed to decode request body")
                return
            }
            
            XCTAssertEqual(requestModel.model, "gpt-3.5-turbo")
            XCTAssertEqual(requestModel.messages.count, 2)
            XCTAssertEqual(requestModel.messages[0].role, NetworkConstants.GPTConstants.systemRoleName)
            XCTAssertEqual(requestModel.messages[0].content, rules)
            XCTAssertEqual(requestModel.messages[1].role, NetworkConstants.GPTConstants.userRoleName)
            XCTAssertEqual(requestModel.messages[1].content, imageData)
            
        case .failure:
            XCTFail("Request preparation should not fail with valid inputs")
        }
    }
    
    // MARK: - NetworkManager Tests
    
    func testNetworkManagerSuccessfulResponse() {
        // Given
        let expectation = expectation(description: "Network request should succeed")
        let mockResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockData = """
        {
            "choices": [
                {
                    "message": {
                        "content": "This is a test response"
                    }
                }
            ]
        }
        """.data(using: .utf8)!
        
        mockURLSession.mockData = mockData
        mockURLSession.mockResponse = mockResponse
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When
        networkManager.sendRequest(request: request, T: GPTAnalyzeResponseModel.self) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.choices.first?.message.content, "This is a test response")
                expectation.fulfill()
            case .failure:
                XCTFail("Request should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkManagerFailureResponse() {
        // Given
        let expectation = expectation(description: "Network request should fail")
        let mockResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        mockURLSession.mockResponse = mockResponse
        
        let request = URLRequest(url: URL(string: "https://test.com")!)
        
        // When
        networkManager.sendRequest(request: request, T: GPTAnalyzeResponseModel.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Request should fail")
            case .failure(let error):
                if case .statusCodeError(let code) = error {
                    XCTAssertEqual(code, 400)
                } else {
                    XCTFail("Wrong error type received")
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - TextGenerator Tests
    
    func testTextGeneratorSuccess() {
        // Given
        let expectation = expectation(description: "Text generation should succeed")
        let mockGenerateService = MockGenerateService()
        let textGenerator = TextGenerator(
            promptRules: "Test rules",
            prompt: "Test prompt",
            apiKey: "test-api-key",
            generateType: .textGeneratorGPT,
            generateService: mockGenerateService
        )
        
        let mockResponse = GPTAnalyzeResponseModel(
            choices: [
                GPTAnalyzeResponseModel.Choice(
                    message: GPTAnalyzeResponseModel.Choice.Message(
                        content: "Generated text"
                    )
                )
            ]
        )
        
        mockGenerateService.mockResponse = .success(mockResponse)
        
        // When
        textGenerator.fetchGeneratedText { result in
            // Then
            switch result {
            case .success(let text):
                XCTAssertEqual(text, "Generated text")
                expectation.fulfill()
            case .failure:
                XCTFail("Text generation should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testTextGeneratorFailure() {
        // Given
        let expectation = expectation(description: "Text generation should fail")
        let mockGenerateService = MockGenerateService()
        let textGenerator = TextGenerator(
            promptRules: "Test rules",
            prompt: "Test prompt",
            apiKey: "test-api-key",
            generateType: .textGeneratorGPT,
            generateService: mockGenerateService
        )
        
        mockGenerateService.mockResponse = .failure(.requestFailedError)
        
        // When
        textGenerator.fetchGeneratedText { result in
            // Then
            switch result {
            case .success:
                XCTFail("Text generation should fail")
            case .failure(let error):
                if case .requestFailedError = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Wrong error type received")
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Classes

final class MockURLSession: URLSession, @unchecked Sendable {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    init(configuration: URLSessionConfiguration) {
        
    }
    
    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return MockURLSessionDataTask(closure: {
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        })
    }
}

final class MockURLSessionDataTask: URLSessionDataTask, @unchecked Sendable {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }
    
    override func resume() {
        closure()
    }
}

final class MockGenerateService: GenerateServiceProtocol {
    var mockResponse: Result<GPTAnalyzeResponseModel, NetworkError>?
    
    func fetchTextMessage(
        rules: String?,
        prompt: String,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @escaping (Result<GPTAnalyzeResponseModel, NetworkError>) -> Void
    ) {
        if let mockResponse = mockResponse {
            completion(mockResponse)
        }
    }
    
    func fetchImageAnalyze(
        rules: String,
        imageData: Data,
        generateType: TextGenerateType,
        apiKey: String,
        completion: @escaping (
            Result<GPTAnalyzeResponseModel, NetworkError>
        ) -> Void
    ) {
        if let mockResponse = mockResponse {
            completion(mockResponse)
        }
    }
}

