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

    init(
        presenter: ComicsPresenter
    ) {
        self.presenter = presenter
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
        presenter.close()
    }

    // MARK: - Setup

    private func initialSetup() {
        self.collectionView!.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: ComicCollectionViewCell.identifier)
        self.collectionView!.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)

        self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .rewind, target: self, action: #selector(moveToFavsView))

        presenter.initView(onRefresh: { [weak self] in
            self?.collectionView.reloadData()
        })
    }

    @objc
    private func moveToFavsView() {
        let favsView = AppState.shared.coodinator.createFavComics()
        self.navigationController?.pushViewController(favsView, animated: true)
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool { false }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool { false }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch presenter.state {
        case .success(let comics):
            return comics.count
        default:
            return 1
        }
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

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.loadNextPageIfNeeded(lastIndexShowed: indexPath.item)
    }
}

extension ComicsCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellIdentifier: String
        switch presenter.state {
        case .success:
            cellIdentifier = ComicCollectionViewCell.identifier
        default:
            cellIdentifier = InfoCollectionViewCell.identifier
        }
        return presenter.cellSize(from: view.frame.size, in: cellIdentifier)
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
