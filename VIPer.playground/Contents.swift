import UIKit

// Presenter
protocol ListPresenterActionHandler: AnyObject {
    // Action handler
    func refresh() async
    func load() async
    func openDetailView(string: String)
}

protocol ListPresenterResultHandler: AnyObject {
    // Result handler
    func present(list: [String])
    func present(error: Error)
}

class ListPresenter: ListPresenterActionHandler, ListPresenterResultHandler {
    
    let interactor: ListInteractorProtocol
    weak var view: ListViewProtocol?
    let router: ListViewRouter
    
    init(
        interactor: ListInteractorProtocol,
        router: ListViewRouter
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func refresh() async {
        interactor.fetchList()
    }
    
    func load() async {
        interactor.fetchList()
    }
    
    func present(list: [String]) {
        view?.fillStackViewWithTexts(text: list)
    }
    
    func present(error: Error) {
        
    }
    
    func openDetailView(string: String) {
        router.openDetailView()
    }
}

// Interactor
protocol ListInteractorProtocol {
    func fetchList()
}

class ListInteractor: ListInteractorProtocol {
    weak var presenter: ListPresenterResultHandler?

    func fetchList() {
        presenter?.present(list: ["abc"])
    }
}

// View

protocol ListViewProtocol: AnyObject {
    var presenter: ListPresenterActionHandler? { get }
    
    func fillStackViewWithTexts(text: [String])
}

class ListView: UIViewController, ListViewProtocol {
    
    var presenter: ListPresenterActionHandler?
    
    lazy var stackView: UIStackView = .init()
    
    init(presenter: ListPresenterActionHandler) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.frame = view.bounds
        view.addSubview(stackView)
        Task {
            await presenter?.load()
        }
    }
    
    func fillStackViewWithTexts(text: [String]) {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        text.map {
            let label = UILabel()
            label.text = $0
            stackView.addArrangedSubview(label)
        }
    }
    
    func openSomething() {
        presenter?.openDetailView(string: "")
    }
}

// Router

protocol ListViewRouter {
    func build() -> ListView
    func openDetailView(string: String)
}

class ListViewDefaultRouter: ListViewRouter {
    
    weak var view: UIViewController?
    
    let detailViewRouter: DetailViewRouter
    
    init(detailViewRouter: DetailViewRouter) {
        self.detailViewRouter = detailViewRouter
    }
    
    func build() -> ListView {
        let interactor = ListInteractor()
        let presenter = ListPresenter(interactor: interactor, router: self)
        interactor.presenter = presenter
        let view = ListView(presenter: presenter)
        presenter.view = view
        self.view = view
        return view
    }
    
    func openDetailView(string: String) {
        let detailView = detailViewRouter.build(name: string)
        view?.present(detailView, animated: true)
    }
}



protocol DetailViewRouter {
    func build(name: String) -> UIViewController
}

// Entity

