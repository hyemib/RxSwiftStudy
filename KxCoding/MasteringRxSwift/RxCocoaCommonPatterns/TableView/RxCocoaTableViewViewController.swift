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


class RxCocoaTableViewViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.currency
        f.locale = Locale(identifier: "Ko_kr")
        
        return f
    }()
    
    let bag = DisposeBag()
    
    let nameObservable = Observable.of(appleProducts.map{ $0.name })
    
    let productObservable = Observable.of(appleProducts)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // # 1
        /*
        nameObservable.bind(to: listTableView.rx.items) { tableView, row, element in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell")!
            cell.textLabel?.text = element
            return cell
        }
        .disposed(by: bag)
         */
        
        // # 2
        /*
        nameObservable.bind(to: listTableView.rx.items(cellIdentifier: "standardCell")) {
            row, element, cell in
            
            cell.textLabel?.text = element
        }
        .disposed(by: bag)*/
        
        // # 3
        productObservable.bind(to: listTableView.rx.items(cellIdentifier: "productCell", cellType: ProductTableViewCell.self)) { [weak self] row,
            element, cell in // 마지막 파라미터로 전달한 cell은 cellType에서 전달한 형식으로 타입캐스팅 되어 전달. 그래서 연결된 outlet에 접근할 때 별도의 타입캐스팅 필요x
            
            cell.categoryLabel.text = element.category
            cell.productNameLabel.text = element.name
            cell.summaryLabel.text = element.summary
            cell.priceLabel.text = self?.priceFormatter.string(for: element.price)
            
        }
        .disposed(by: bag)
        /*
        listTableView.rx.modelSelected(Product.self)
            .subscribe(onNext: { product in
                print(product.name) // 선택한 셀 콘솔에 출력
            })
            .disposed(by: bag)
        
        listTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.listTableView.deselectRow(at: indexPath, animated: true) // 선택 상태 제거
            })
            .disposed(by: bag)
         */
        
        Observable.zip(listTableView.rx.modelSelected(Product.self),
            listTableView.rx.itemSelected)
            .bind { [weak self] (product, indexPath) in
                self?.listTableView.deselectRow(at: indexPath, animated: true)
                print(product.name)
            }
            .disposed(by: bag)
        // 선택 이벤트를 처리하면서 데이터가 필요하면 modelSelected 메소드를 활용.
        // indexPath로 충분하면 itemSelected 속성을 활용.
        // indexPath와 데이터가 모두 필요하면 modelSelected와 itemSelected를 따로 활용해도 되고 zip 연산자로 병합해서 구현해도 됨
    }
}


// RxSwift에서는 테이블뷰의 데이터소스와 델리게이트는 연결x. 대신 Observable을 테이빌뷰에 바인딩


