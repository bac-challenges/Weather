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
//	ID: 2CB4980D-51DF-4E5B-9315-CCB1CFC1A97F
//
//	Pkg: Weather
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

protocol LayoutAnchor {
	func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
	func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
	func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor {}

struct LayoutProperty<Anchor: LayoutAnchor> {
	fileprivate let anchor: Anchor
}

class LayoutProxy {
	lazy var leading = property(with: view.leadingAnchor)
	lazy var trailing = property(with: view.trailingAnchor)
	lazy var top = property(with: view.topAnchor)
	lazy var bottom = property(with: view.bottomAnchor)
	lazy var centerX = property(with: view.centerXAnchor)
	lazy var centerY = property(with: view.centerYAnchor)
	lazy var width = property(with: view.widthAnchor)
	lazy var height = property(with: view.heightAnchor)
	
	private let view: UIView
	
	fileprivate init(view: UIView) {
		self.view = view
	}
	
	private func property<A: LayoutAnchor>(with anchor: A) -> LayoutProperty<A> {
		return LayoutProperty(anchor: anchor)
	}
}

extension LayoutProperty {
	func equal(to otherAnchor: Anchor, offsetBy
		constant: CGFloat = 0) {
		anchor.constraint(equalTo: otherAnchor,
						  constant: constant).isActive = true
	}
	
	func greaterThanOrEqual(to otherAnchor: Anchor,
							offsetBy constant: CGFloat = 0) {
		anchor.constraint(greaterThanOrEqualTo: otherAnchor,
						  constant: constant).isActive = true
	}
	
	func lessThanOrEqual(to otherAnchor: Anchor,
						 offsetBy constant: CGFloat = 0) {
		anchor.constraint(lessThanOrEqualTo: otherAnchor,
						  constant: constant).isActive = true
	}
}

extension UIView {
	func layout(using closure: (LayoutProxy) -> Void) {
		translatesAutoresizingMaskIntoConstraints = false
		closure(LayoutProxy(view: self))
	}
}

func +<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
	return (lhs, rhs)
}

func -<A: LayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
	return (lhs, -rhs)
}

func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>,
						 rhs: (A, CGFloat)) {
	lhs.equal(to: rhs.0, offsetBy: rhs.1)
}

func ==<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
	lhs.equal(to: rhs)
}

func >=<A: LayoutAnchor>(lhs: LayoutProperty<A>,
						 rhs: (A, CGFloat)) {
	lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

func >=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
	lhs.greaterThanOrEqual(to: rhs)
}

func <=<A: LayoutAnchor>(lhs: LayoutProperty<A>,
						 rhs: (A, CGFloat)) {
	lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

func <=<A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
	lhs.lessThanOrEqual(to: rhs)
}
