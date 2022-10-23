# Autocrypt

## 구현 내용
1. Directory Tree
```
├── Autocrypt
│   ├── Application
│   ├── Utility
│   ├── Presentation
│   │   ├── Coordinator
│   │   ├── Protocol
│   │   ├── ListView
│   │   │   ├── View
│   │   │   │   └── Cell
│   │   │   └── ViewModel
│   │   ├── DetailView
│   │   │   ├── View
│   │   │   └── ViewModel
│   │   ├── MapView
│   │   │   ├── View
│   │   │   └── ViewModel
│   │   └── Extension
│   ├── Data
│   │   ├── Repository
│   │   ├── Network
│   │   │   ├── Extension
│   │   │   ├── Error
│   │   │   ├── Support
│   │   │   └── Endpoint
│   │   │   │   └── RequestModel
└── └── └── └── └── ResponseModel
└── AutocryptTest
    ├── TestDouble
    ├── ListView
    ├── DetailView
    ├── MapView
    └── Network
```
2. 동작 영상

|페이지네이션|-|
|---|---|
|<img src="https://user-images.githubusercontent.com/60725934/197403206-c528f0bb-9cc1-44d1-bd9b-2d79148d32ec.gif" width="400" height="400"/>|<img src="https://user-images.githubusercontent.com/60725934/197403300-2a6a8710-f505-4e21-9516-8b962c8a22e9.gif" width="400" height="400"/>|
|사용자의 스크롤에 따라 페이지 단위로 결과를 노출합니다.|다음 페이지가 없으면 Alert을 띄워줍니다.|

|Scroll To Top & Refresh Control|Map View|-|
|---|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/60725934/197403423-3652c3b5-9214-499b-b035-5b2a17c1c1d3.gif" width="400" height="400"/>|<img src="https://user-images.githubusercontent.com/60725934/197405129-9189d4de-2948-44e2-80eb-a9a264168b9d.gif" width="200" height="400"/>|<img src="https://user-images.githubusercontent.com/60725934/197405424-46de0aa5-5803-4ec9-88e8-508001d5551b.gif" width="200" height="400"/>|
|새로고침하면 결과를 초기화합니다.|현재위치, 접종센터 위치로 이동합니다.|위치 허용을 하지 않고 현재위치로 이동하기 버튼 터치시 Alert을 띄워줍니다.|

## 고민했던 부분

### 1. 데이터 바인딩

ViewController와 ViewModel간의 데이터 바인딩을 Input - Output 구조로 구현했습니다.
```swift
struct Input {
    let viewWillAppear: Observable<Void>
    let loadNextPage: Observable<Void>
}

struct Output {
    let result: Observable<[VaccinationCenter]>
    let canFetchNextPage: Observable<Int?>
}
```

이때 Output을 어떻게 구성할지에 대한 고민을 했었는데, 아래 두 방법중 후자를 선택했습니다.
- Input - Output을 일대일 대응시켜서 해당 이벤트의 처리에 대한 결과를 Output으로 설정
- Output을 ViewModel이 가진 상태값에 대한 변경으로 보기

ViewController에서 발생한 이벤트(Input)에 대한 처리를 ViewModel에서 하고, ViewModel이 가진 상태값을 변경하여 변경된 상태값(Output)에 따른 UI변경을 ViewController가 처리하도록 구현했습니다.

이렇게 구현한 이유는 페이지 단위로 API 요청을 할때, ViewModel에서 다음 요청을 위해 이전 요청에 대한 결과가 필요해서 상태값을 저장해놓아야 했고, ViewController의 UI이벤트에 의해 변경된 ViewModel의 상태값 UI에 반영하는 것이 코드 가독성 측면에서도 나을 것 같다고 생각했기 때문입니다.

```swift
private var nextPage = BehaviorRelay<Int?>(value: 1)
private var results = BehaviorRelay<[VaccinationCenter]>(value: [])
```

따라서 ViewModel에 BehaviorRelay를 사용해서 뷰의 상태값을 정의했고, 그대로 Output으로 전달했습니다.

Input에 따른 API 호출같은 사이드 이펙트에 대한 결과를 BehaviorRelay에 전달하면, 단순히 ViewController는 상태 변경에 따른 UI변경만 할 수 있도록 구현하였습니다.

```swift
output.result
    .bind(to: tableView.rx.items(
        cellIdentifier: "VaccinationListTableViewCell",
        cellType: VaccinationListTableViewCell.self)
    ) { index, element, cell in
        cell.configure(with: element)
    }.disposed(by: disposeBag)

output.canFetchNextPage
    .filter { $0 == nil }
    .asDriver(onErrorJustReturn: nil)
    .drive(with: self, onNext: { (self, nextPage) in
        self.presentAlert(with: "더 이상 결과가 없습니다.")
    })
    .disposed(by: disposeBag)
```

### 2. Coordinator를 관리하는 객체

Coordinator을 ViewController가 가지고 있을지 ViewModel이 가지고 있을지 고민했습니다.

아래 두 방법중 전자를 선택했습니다.
- ViewController가 화면전환 이벤트가 발생하면 Coordinator에게 위임
- 화면전환에 대한 이벤트도 ViewController가 ViewModel에게 Input으로 넘겨서 ViewModel이 가진 Coordinator에게 위임

그 이유는 일단 화면 전환 이벤트에 대한 뷰의 상태 변경이 없기도 했고, 화면 전환은 비즈니스로직이 아니라는 생각 때문에 ViewController가 Coordinator를 가지도록 구현하였습니다.

### 3. 화면 최상단으로 스크롤할때, 받아온 데이터를 첫페이지로 초기화할지

scrollToTop 버튼 이벤트가 발생하면, ViewModel이 가진 데이터를 초기화하고 첫페이지의 결과만 보이도록 구현할지 아니면 여러 페이지를 불러온 결과를 그대로 놔둘지 고민했습니다.

사용자 입장에서 생각해보니 이미 아래까지 스크롤해서 결과를 본 후 맨 위로 스크롤했다면, 언제든지 이전에 봤던 검색 결과를 빨리 다시 보고싶을것 같다는 생각에 검색 결과를 초기화하지 않는게 나을 것 같다고 생각했습니다.




## 트러블 슈팅

### 1. Coordinator 참조 관리중 ViewController가 메모리에서 해제되지 않았는데 Coordinator가 먼저 해제되는 문제

**<문제 상황>**

detailView -> mapView -> detailView 에서 mapView로 다시 화면전환이 되지 않는 문제점이 발생하였습니다.

**<발생한 이유>**

기존에는 Coordinator의 참조 관리를 위해서 ViewController가 화면에서 내려가면, viewDidDisappear 시점에 해당 Coordinator을 AppCoordinator가 가진 childCoordinator 배열에서 제거해주었습니다.
```swift
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    coordinator?.didFinishPresenting()
}
```
그러나, 이 방법은 화면전환이 한번만 될때는 문제가 없었지만,
이번에 구현한 구조처럼 ListView -> DetailView -> MapView로 화면전환이 두번 되는 경우에는
DetailView가 MapView로 전환되는 시점에 ViewDidDisappear가 불려서 Detail Coordinator가 nil이 되어
DetailView -> MapView -> DetailView로 돌아온 후 다시 MapView로 화면전환을 할 수 없는 상황이 발생하였습니다.

**<해결 방법>**  

네비게이션 스택에서 내려간 ViewController의 Coordinator만 제거하기 위해서 ViewController의 ViewDidDisappear 시점에 Coordinator을 제거하는 방법 대신  

아래와 같이 NavigationController를 가지고 있는 AppCoordinator을 UINavigationControllerDelegate로 설정하여 화면전환이 된 후 didShow 시점에 navigationController가 가진 viewControllers를 체크합니다.   

만약 viewControllers에 화면 전환이 시작된 viewController가 존재한다면 return을 하고, 존재하지 않는다면 그제서야 해당 ViewController의 Coordinator 제거하도록 수정하였습니다.

```swift
extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let detailViewController = fromViewController as? VaccinationDetailViewController,
           let detailViewCoordinator = detailViewController.coordinator as? Coordinator {
            childDidFinish(detailViewCoordinator)
        } else if let mapViewController = fromViewController as? VaccinationMapViewController,
                  let mapViewCoordinator = mapViewController.coordinator as? Coordinator {
            childDidFinish(mapViewCoordinator)
        }
    }
}
```
