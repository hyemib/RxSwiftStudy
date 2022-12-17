//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

/*:
 # take(for:scheduler:)
 */


let disposeBag = DisposeBag()

let o = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
/*
o.subscribe { print($0) }
    .disposed(by: disposeBag)

// 1초마다 1씩 증가하는 정수를 방출
/*
 next(0)
 next(1)
 next(2)
 next(3)
 next(4)
 next(5)
 next(6)
 next(7)
 */
*/

o.take(for: .seconds(3), scheduler: MainScheduler.instance) // Observable이 이벤트 방출을 시작하면 지정 시간만큼 이벤트를 전달하고 시간이 견과하면 더이상 이벤트를 전달하지 않고 끝남
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 시간상의 오차로 1까지 전달하고 끝남
/*
 next(0)
 next(1)
 completed
 */
