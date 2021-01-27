# GifApp

## 목차

1. [기능](#기능)
2. [구현 내용 정리](#구현-내용-정리)

<br>

## 기능

### 목차

1. [초기 화면](#초기-화면)
2. [검색 자동 완성](#검색-자동-완성)
3. [검색 결과](#검색-결과)
4. [Favorite On Off 기능](#favorite-on-off-기능)
5. [Favorite 목록 유지](#favorite-목록-유지)
6. [Gif 상세 정보](#gif-상세-정보)

<br>

### 초기 화면

앱 최초 실행 시 화면입니다. 검색을 할 수 있고, Trending gif 정보를 받아와서 보여줍니다.

![초기화면](https://github.com/1Consumption/GifApp/blob/main/Images/초기화면.gif?raw=true)

### 검색 자동 완성

검색을 할 수 있는 화면입니다. Giphy에서 제공해주는 API 중 AutoComplete 기능을 사용했으며, 0.5초 이내에 새로운 입력이 들어오면 기존에 예약되었던 요청을 취소하고 새로운 요청을 예약합니다.

![자동 완성](https://github.com/1Consumption/GifApp/blob/main/Images/자동완성.gif?raw=true)

### 검색 결과

keyword 검색 결과를 보여주는 화면입니다. 이 화면에서 또 검색해 다른 결과를 볼 수 있습니다.

![검색 결과](https://github.com/1Consumption/GifApp/blob/main/Images/검색.gif?raw=true)

### Favorite On Off 기능

gif에 대한 favorite을 더블 탭을 통해 on / off 할 수 있습니다. favorite 한 gif는 `Favorite` 탭에서 확인할 수 있습니다. 이미 favorite이 된 gif를 더블 탭을 한다면 favorite을 취소할 수 있습니다.

![Favorite on off](https://github.com/1Consumption/GifApp/blob/main/Images/FavoriteOnOff.gif?raw=true)

### Favorite 목록 유지

앱을 사용하면서 favorite 한 gif 정보들을 로컬에 저장해 껐다 켜도 favorite 목록이 유지됩니다.

![Favorite 목록 유지](https://github.com/1Consumption/GifApp/blob/main/Images/Favorite유지.gif?raw=true)

### Gif 상세 정보

gif cell을 탭 하면 상세 정보를 볼 수 있습니다. 여기서 제공자에 대한 정보를 얻을 수 있고, 이미지를 더블 탭 하거나 좋아요 버튼을 탭 해 favorite 여부를 결정할 수 있습니다. 

![Gif 상세 정보](https://github.com/1Consumption/GifApp/blob/main/Images/상세화면.gif?raw=true)

<br>

## 구현 내용 정리

### 목차

1. [사용한 라이브러리](#사용한-라이브러리)
2. [구조](#구조)
3. [Network Layer](#network-layer)
4. [Image Caching](#image-caching)
5. [Favorite 디스크 저장](#favorite-디스크-저장)

<br>

### 사용한 라이브러리

#### [Gifu](https://github.com/kaishin/Gifu)

사용한 이유: Gif는 여러 장의 이미지를 연달아서 보여주는 포맷입니다. 따라서 메모리를 많이 소모할 수 있습니다. Gifu 라이브러리는 `ImageView`의 크기에 맞춰 Gif 이미지들을 리사이징해주고, 필요한 프레임만 그때그때 메모리에 불러오기 때문에 비교적 메모리 관리를 쉽게 할 수 있어서 사용하게 되었습니다.

<br>

### 구조

#### 전체적인 구조

<img width="1000" alt="image" src="https://github.com/1Consumption/GifApp/blob/main/Images/구조.png?raw=true">

#### MVVM 채택

<img width="1000" alt="image" src="https://github.com/1Consumption/GifApp/blob/main/Images/MVVM.png?raw=true">

* View
  * ViewModel에게 이벤트를 전달. 
  * ViewModel을 관찰하고 있다가 ViewModel이 바뀌면 업데이트
* ViewModel
  * View에 대한 로직을 가지고 있음
  * Model을 소유하고 있음.
  * Model을 업데이트하고 Model이 바뀌면 변경사항을 방출
* Model
  * 데이터를 소유함
  * 데이터에 대한 비즈니스 로직을 가지고 있음.

<br>

#### MVVM 채택 이유

1. 테스트의 용이성 및 ViewController 역할 분리

   * MVC 패턴은 View와 Controller가 서로 강하게 의존하고 있어서 Controller(view에 대한 로직) 부분을 테스트하기가 어려웠습니다.
* 하지만 MVVM 패턴의 경우 View는 ViewModel에게 이벤트만 전달하는 역할을 할 뿐 로직을 가지지 않습니다. 대신 ViewModel이 View에 대한 비즈니스 로직만 가지기 때문에 ViewModel을 테스트해 View에 대한 로직을 검증할 수 있습니다.
   
2. View 업데이트 용이

   * MVC 패턴은 이벤트에 의해 ViewController가 Model을 업데이트하고, Model이 업데이트되면 ViewController에게 알려 ViewController가 View를 업데이트 합니다.
   * 반면 MVVM 패턴은 View가 ViewModel을 관찰하고 있다가 ViewModel의 상태가 변하면 View가 업데이트하기 때문에 View 업데이트가 용이합니다.

<br>

MVVM을 채택하면서 `View`의 로직을 `ViewModel`에서 담당하게 되면서 로직을 테스트할 수 있었고, 결과적으로 아래와 같이 75%의 코드를 커버할 수 있었습니다.

<img width="1000" alt="image" src="https://github.com/1Consumption/GifApp/blob/main/Images/TestCoverage.png?raw=true">

<br>

#### Observable 구현

View와 ViewModel을 바인딩하는 과정이 필요한데, 이를 위해 `Observable` 클래스를 구현했습니다. `bind(_:)` 메소드가 호출될 때 고유한 id와 매개변수로 넘겨받은 동작을 `observers`에 매핑합니다. 여기서 `Cancellable` 타입을 반환하는데, 이 `Cancellable` 타입은 deinit될 때 id에 해당하는 동작을 `observers`에서 지우는 역할을 합니다.  그리고 `value`가 바뀌면 `observers`에 등록된 동작을 실행하는 구조입니다.

``` swift
final class Observable<T> {
    
    typealias Handler = (T) -> Void
    
    var value: T {
        didSet {
            notify()
        }
    }
    private var observers: [UUID: Handler] = [UUID: Handler]()
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ handler: @escaping (T) -> Void) -> Cancellable {
        let id = UUID()
        observers[id] = handler
        
        let cancellable = Cancellable { [weak self] in
            self?.observers[id] = nil
        }
        
        return cancellable
    }
    
    func fire() where T == Void {
        notify()
    }
    
    private func notify() {
        observers.values.forEach {
            $0(value)
        }
    }
}
```

<br>

#### ViewModelType 프로토콜 정의 - ViewModelInput / Output 

ViewModel을 사용할 때 ViewModel에 들어오는 이벤트가 많아지며 관리하기 어려워지기 시작했습니다. 이를 극복하기 위해 `ViewModelType` 프로토콜을 정의하여 ViewModel에 들어오는 이벤트를 `Input` 타입으로 묶고, `Input`을 `transform(_:)` 메소드에서 가공하여 `Output`을 방출합니다. 그리고 이 방출된 `Output`을 View가 관찰하는 구조입니다. 이렇게 되면 여러 군데 흩어져있던 `Input`과 `Output`을 한군데로 집약할 수 있고, ViewModel에 대한 `Input`과 `Output`이 확실히 구분되기 때문에 관리에 더 용이하다는 장점이 있었습니다.

``` swift
protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
```

<br>

### Network Layer

네트워킹 기능을 구현했습니다. 핵심은 프로토콜을 통해 테스트가 가능하고 유연한 네트워킹 객체를 만들었다는 것에 있습니다.

두 가지 프로토콜을 정의했는데, `RequesterType`과 `NetworkManagerType` 프로토콜입니다. 그리고, 이 프로토콜을 조합해 만든 `NetworkManager` 클래스를 통해 네트워킹을 할 수 있습니다.

#### `RequesterType`

``` swift
protocol RequesterType {
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
```

실질적으로 서버와 통신하는 역할을 하는 프로토콜입니다. `URLSession`의 `dataTask(with:completionHandler) -> URLSessionDataTask` 메소드의 인터페이스를 따왔습니다. 따라서 `URLSession`은 자동적으로 `RequesterType` 프로토콜을 만족하게 됩니다. 

#### `NetworkManagerType`

``` swift
protocol NetworkManagerType {
    
    var requester: RequesterType { get }
    
    func loadData(with url: URL?, method: HTTPMethod, headers: [String: String]?, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}
```

`RequesterType`을 만족하는 프로퍼티와 `loadData(with:method:headers:completionHandler:) -> URLSessionDataTask?` 메소드를 요구합니다. 여기서 `RequesterType`를 채택한 객체는 `requester` 프로퍼티에 할당될 수 있기 때문에, 오류를 넘겨주는 `RequesterType`을 채택한 객체를 넘겨줄 수도 있고, 항상 성공하는 `RequesterType`을 넘겨줄 수 있어 테스트에 용이합니다. 네트워크 테스트의 경우는 실패하는 케이스가 여러 개이고, 상황을 만들기 어렵기 때문입니다.

#### `NetworkManager`

`NetworkManagerType` 프로토콜을 채택한 구현체입니다. `RequesterType`의 `requester`는 별도로 지정해주지 않으면 `URLSession.shared`를 사용하게 됩니다. 그리고 `loadData(with:method:headers:completionHandler:) -> URLSessionDataTask?` 메소드를 통해 url의 유효성, 네트워크 오류 등을 체크하고 `completionHandler`를 통해 결과를 넘겨줍니다.

<br>

위와 같이 프로토콜을 기반으로 `NetworkManager` 구현한 결과 다음과 같이 네트워킹 테스트를 성공적으로 수행할 수 있었습니다.

<img alt="image" src="https://github.com/1Consumption/GifApp/blob/main/Images/NetworkManagerTest.png?raw=true">

<br>

### Image Caching

필요한 이미지를 매번 네트워크에서 받아온다면 리소스 낭비가 심할 것입니다. 따라서 네트워크에서 받아온 이미지를 로컬에 저장하고 있다가, 필요할 때 네트워크에 요청하지 않고 로컬에서 받아오는 이미지 캐싱을 구현했습니다. 이미지 캐싱을 담당하는 `ImageManager` 클래스는 다음과 같은 구조로 설계되었습니다.

<img width="1000" alt="image" src="https://github.com/1Consumption/GifApp/blob/main/Images/ImageManager.png?raw=true">



#### `MemoryCacheStorage`

`MemoryCacheStorage` 클래스는 만료기한을 가지는 `ExpirableObject`를 캐싱합니다. 삽입, 참조, 삭제 등의 기능을 수행할 수 있으며  이미지 데이터가 참조되면 만료기한을 초기화하는 동작을 합니다.

#### `DiskStorage`

`DiskStorage` 클래스는 `Data` 타입을 로컬에 저장합니다. 기본적으로 `FileManager.default` 프로퍼티를 통해 `Document` 디렉토리에 접근합니다. 삽입, 참조, 삭제 등의 기능을 수행할 수 있습니다.

<br>

`ImageManager`는 다음과 같은 순서로 이미지 데이터를 찾습니다.

1. `MemoryCacheStorage`에 key를 넘겨주고 key에 해당하는 이미지 데이터가 있는지 확인합니다.
2. `MemoryCacheStorage`는`cache`프로퍼티에서 key에 해당하는 이미지 데이터를 확인합니다.
    1. 해당 이미지 데이터가 만료되었으면 해당 이미지 데이터를 `cache`에서 삭제하고 nil을 반환합니다.
    2. 해당 이미지 데이터가 없다면 nil을 반환합니다.
    3. 만료되지 않았다면 만료 시간을 초기화하고 handler를 통해 이미지 데이터를 외부에 넘겨줍니다.
3. 2번의 결과가 nil인 경우 메모리에 없다는 뜻이므로 `DiskStorage`에 key를 넘겨 이미지 데이터가 있는지 확인합니다.
   1. 해당 이미지가 있다면 handler를 통해 외부로 넘겨주고, `memoryCacheStorage`에도 이미지 데이터를 삽입합니다.
   2. 해당 이미지 데이터가 없다면 nil을 반환합니다.
4. 3번의 결과가 nil인 경우 로컬에 없다는 뜻이므로 `NetworkManageable`을 사용해 서버에서 이미지 데이터를 받아옵니다.
5. 서버에서 이미지 데이터를 받아오면 `DiskStorage`와 `MemoryCacheStorage`에 이미지 데이터를 저장하고 handler를 통해 이미지 데이터를 외부에 넘겨줍니다.

<br>

<br>

### Favorite 디스크 저장

gif를 favorite한 경우 이 결과는 앱을 껐다 켜도 유지되어야 합니다. 또한 이미 favorite된 gif를 취소하는 기능도 필요합니다. 따라서 Favorite된 Gif정보를 담고 있는 모델인 `GifInfo` 타입 객체를 디스크에 저장하고 이벤트가 발생할 때마다 검사할 필요가 있다고 생각했습니다. 이를 위해 `FavoriteManager` 객체를 생성했습니다.

#### `FavoriteManager`

`FavoriteManager`는 디스크에 파일을 읽고 쓸 수 있는 `DiskStorageType` 타입의 프로퍼티를 소유하며, 이 프로퍼티를 통해 전달된 gif 정보를 디스크에 저장, 삭제할 수 있습니다. 또한, 이 모든 작업은 `Document` 디렉토리에 생성된 `Favorite` 디렉토리에서 수행됩니다.

`changeFavoriteState(with:completionHandler:)` 메소드를 호출하게 되면 `DiskStorageType` 타입의 프로퍼티를 통해 `Favorite` 디렉토리를 검사합니다. 이 디렉토리에 전달된 `GifInfo`가 있으면 favorite이 취소된 것으로 간주하고, 없으면 favorite이 된 것으로 간주합니다. 따라서 이 결과를 `Result<Bool, Error>` 타입으로 래핑하여 `completionHandler`로 전달하게 됩니다.

또한 favorite 된 리스트를 한곳에서 모아 볼 수 있도록, `Favorite` 디렉토리에 있는 모든 데이터를 받아올 수 있는 `retrieveGifInfo(completionHandler:)` 메소드를 구현했습니다.

<br>

<img width="1000" alt="image" src="https://github.com/1Consumption/GifApp/blob/main/Images/FavoriteManager.png?raw=true">

gif가 favorite 되는 과정을 간략하게 설명하자면 다음과 같습니다.

1. `Cell`에서 `ViewModel`에게 이벤트를 전달합니다.
2. `ViewModel`은 `UseCase` 프로퍼티의 메소드를 실행합니다.
3. `UseCase`는 `FavoriteManagerType`의 메소드를 실행합니다.
4. `FavoriteManagerType`은 `DiskStorageType`을 통해 `Favorite` 디렉토리에 접근해 favorite 여부를 completionHandler로 넘겨줍니다.
5. `UseCase`에서 `ViewModel`로 결과가 전달되고, `ViewModel`은 내부 로직에 따라 output을 방출합니다.
6. 이 방출된 output을 `Cell`이 보고 favorite을 업데이트합니다.

결과적으로  `Cell`은 이벤트를 보내고, 그에 따른 output만을 반영하게 됩니다. 따라서 Favorite되는 과정을 숨길 수 있었고, 분리할 수 있었으며, 테스트할 수 있었습니다.

<br>

## Appendix

> 깃모지 정리
>
> | 깃모지     | 설명                           |
> | ---------- | ------------------------------ |
> | :tada:     | 프로젝트 생성                  |
> | 🔧          | 설정 파일 변경, 개발 환경 변경 |
> | :sparkles: | 기능 추가                      |
> | 💄          | UI 업데이트                    |
> | :fire:     | 코드 / 파일 제거               |
> | ✅          | Unit test 추가 / 수정          |
> | 🐛          | 버그 수정                      |
> | ♻️          | 리팩토링                       |
> | 📝          | 문서 작성 / 수정               |

