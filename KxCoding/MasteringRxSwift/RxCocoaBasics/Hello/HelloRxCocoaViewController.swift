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


class HelloRxCocoaViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var tapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // RxCocoa에서 tap 이벤트를 처리할 때는 tap 속성을 사용
        // tap 속성은 ControlEvent로 선언되어 있고 touchUpInside 이벤트가 발생하면 next 이벤트를 방출하는 특별한 Observable
        tapButton.rx.tap
            .map { "Hello, RxCocoa" } // 버튼을 tap할 때 마다 구독자에게 문자열을 전달
            //.subscribe(onNext: { [weak self] str in
            //    self?.valueLabel.text = str // text 속성에 접근해서 값을 변경
            //})
            .bind(to: valueLabel.rx.text) // 방출된 문자열을 label의 text 속성과 binding.  rx를 통해 text 속성에 접근. rx를 통해 접근하는 속성은 binder이고 일반속성과 타입이 다름. 
            .disposed(by: bag)
    }
}
