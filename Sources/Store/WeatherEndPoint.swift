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
//	ID: DC30E41D-41D8-4B07-920B-5630AD73ADB8
//
//	Pkg: Weather
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation

enum WeatherEndPoint: EndPoint {
	
	case search(city: String)
	case group(id: String)
	
	var baseURL: URL {
		return URL(string: "https://api.openweathermap.org/data/2.5")!
	}
	
	var path: String {
		switch self {
		case .search: return "weather"
		case .group: return "group"
		}
	}
	
	var params: [String: String] {
		
		var params = ["appid":"6e63cfdb34ebbe020b74729b22c24791", "units":"metric"]
		
		switch self {
		case .search(let city): params["q"] = city
		case .group(let id): params["id"] = id
		}
		
		return params
	}
	
	var httpMethod: HTTPMethod {
		switch self {
		default: return .GET
		}
	}
}
