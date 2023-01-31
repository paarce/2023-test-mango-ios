//
//  ComicsCollectionViewController.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

//TODO: Multilanguage
class ComicsCollectionViewController: UICollectionViewController {

    private var customLayout = ViewFactory.layout
    private var presenter: ComicsPresenter
    private var resizer: ComicsResizer

    init(
        presenter: ComicsPresenter,
        resizer: ComicsResizer = ComicsResizerImpl()
    ) {
        self.presenter = presenter
        self.resizer = resizer
        super.init(collectionViewLayout: customLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            presenter.close()
        }
    }

    // MARK: - Setup

    private func initialSetup() {
        self.navigationItem.title = "Marvel Comics"
        collectionView.allowsMultipleSelection = false
        collectionView.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: ComicCollectionViewCell.identifier)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)

        self.navigationItem.rightBarButtonItem = .init(image: .init(systemName: "heart.fill"), style: .plain, target: self, action: #selector(moveToFavsView))

        presenter.initView(onRefresh: { [weak self] in
            self?.collectionView.reloadData()
        })
    }

    // MARK: - Navigation

    @objc
    private func moveToFavsView() {
        let favsView = AppState.shared.coodinator.createFavComics()
        self.navigationController?.pushViewController(favsView, animated: true)
    }

    private func moveToDetail(comic: ComicDTO) {
        let detail = AppState.shared.coodinator.createComicDetail(comic: comic)
        self.navigationController?.pushViewController(detail, animated: true)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard case .success(let comics) = presenter.state else { return 1 }
        return comics.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if case .success(let comics) = presenter.state {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCollectionViewCell.identifier, for: indexPath) as! ComicCollectionViewCell
            cell.set(model: comics[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
            cell.set(model: .init(comicsState: presenter.state))
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case .success(let comics) = presenter.state, comics.count > indexPath.item else { return }
        moveToDetail(comic: comics[indexPath.item].dto)
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.loadNextPageIfNeeded(lastIndexShowed: indexPath.item)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.reloadData()
    }
}

extension ComicsCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch presenter.state {
        case .success:
            return resizer.cellSize(from: view.frame.size, in: ComicCollectionViewCell.identifier)
        default:
            return resizer.cellSize(from: view.frame.size, in: InfoCollectionViewCell.identifier)
        }
    }
}

private extension InfoCellModel {
    init?(comicsState: ComicsViewState) {
        switch comicsState {
        case .loading:
            self = .init(loadingMessage: "We are receiving the comics...")
        case .fail(let error):
            self = .init(error: error)
        case .empty:
            self = .init(loadingMessage: "Here you should shoulde see the MARVEL comics.")
        default:
            return nil
        }
    }
}

extension ComicsCollectionViewController {

    enum ViewFactory {
        static var layout: UICollectionViewFlowLayout {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = 1
            return layout
        }
    }
}
