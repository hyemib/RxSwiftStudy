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
 # skip(duration:scheduler:)
 */


let disposeBag = DisposeBag()

/*
let o = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) // 1초 간격으로 1씩 증가하는 정수 10개 방출

o.take(10)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(0)
 next(1)
 next(2)
 next(3)
 next(4)
 next(5)
 next(6)
 next(7)
 next(8)
 next(9)
 completed
 */
*/

let o = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

o.take(10)
    .skip(.seconds(3), scheduler: MainScheduler.instance) // 첫번째 파라미터는 Observable이 방출하는 이벤트를 무시하는 시간. 두번째 파라미터는 타이머를 실행할 스케줄러
    // Observable이 이벤트 방출을 시작한 시점부터 첫번째 파라미터로 전달한 시간동안 Observable이 방출하는 모든 이벤트를 무시
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// Observable이 방출하는 이벤트를 3초 동안 무시. Observable이 0부터 1씩 증가하는 정수를 1초마다 방출하고 있으므로 3부터 구독자로 전달되어야 하지만 2부터 전달되고 있음. => 시간을 처리할 때 오차가 발생하기 때문. 
/*
 next(2)
 next(3)
 next(4)
 next(5)
 next(6)
 next(7)
 next(8)
 next(9)
 completed
 */


