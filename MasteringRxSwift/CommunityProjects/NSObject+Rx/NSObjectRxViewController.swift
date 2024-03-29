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
import RxCocoa
import NSObject_Rx

class NSObjectRxViewController: UIViewController {
    
    //let bag = DisposeBag()
    
    let button = UIButton(type: .system)
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just("Hello")
            .subscribe { print($0) }
            .disposed(by: rx.disposeBag)
        
        button.rx.tap
            .map { "Hello" }
            .bind(to: label.rx.text)
            .disposed(by: rx.disposeBag)
    }
}

// NSObsect를 상속받지 않음. HasDisposeBag 프로토콜 채용
// HasDisposeBag 프로토콜은 class 프로토콜로 선언되어 있기 때문에 구조체에서는 채용할 수 없음
class MyClass: HasDisposeBag {
    //let bag = DisposeBag()
    
    func doSomething() {
        Observable.just("Hello")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
    }
}

// NSObject+Rx : DisposeBag 속성을 자동으로 추가해주는 라이브러리


