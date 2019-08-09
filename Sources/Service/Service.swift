//	MIT License
//
//	Copyright © 2019 Emile, Blue Ant Corp
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
//	ID: F3AC459B-1A18-45DA-A5D9-DE0DC678162E
//
//	Pkg: Weather
//
//	Swift: 5.0
//
//	MacOS: 10.15
//

import Foundation

protocol EndPoint {
	var baseURL: URL { get }
	var path: String { get }
	var params: [String: String] { get }
	var httpMethod: HTTPMethod { get }
}

enum HTTPMethod: String {
	case GET
	case POST
	case PUT
	case DELETE
	case PATCH
}

enum ServiceError: Error {
	case noResponse
	case notFound
	case jsonDecodingError(error: Error)
	case networkError(error: Error)
}

struct Service {
	let decoder: JSONDecoder
	
	init(decoder: JSONDecoder = JSONDecoder()) {
		self.decoder = decoder
	}

	func fetch<T: Codable>(endpoint: EndPoint, completionHandler: @escaping (Result<T, ServiceError>) -> Void) {
		
		let queryURL = endpoint.baseURL.appendingPathComponent(endpoint.path)
		var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
		components.queryItems = [URLQueryItem]()
		
		for (_, value) in endpoint.params.enumerated() {
			components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
		}
		
		var request = URLRequest(url: components.url!)
		request.httpMethod = endpoint.httpMethod.rawValue

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data, let response = response as? HTTPURLResponse else {
				completionHandler(.failure(.noResponse))
				return
			}
			guard error == nil else {
				completionHandler(.failure(.networkError(error: error!)))
				return
			}
			do {
				if response.statusCode == 200 {
					self.decoder.dateDecodingStrategy = .iso8601
					self.decoder.keyDecodingStrategy = .convertFromSnakeCase
					let object = try self.decoder.decode(T.self, from: data)
					completionHandler(.success(object))
				}
				else if response.statusCode == 404 {
					completionHandler(.failure(.notFound))
				}
			} catch let error {
				print(error)
				completionHandler(.failure(.jsonDecodingError(error: error)))
			}
		}
		task.resume()
	}
}
