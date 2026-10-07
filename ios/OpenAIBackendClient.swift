import Foundation

struct OpenAIBackendClient {
    struct AskRequest: Encodable {
        let text: String
    }

    struct AskResponse: Decodable {
        let text: String
        let response_id: String?
    }

    func ask(_ text: String) async throws -> String {
        let url = AppConfig.backendBaseURL.appending(path: "ask")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        request.httpBody = try JSONEncoder().encode(AskRequest(text: text))

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(AskResponse.self, from: data)
        return decoded.text
    }
}
