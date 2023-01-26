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
    private var useCase: ComicsCollectionUseCaseRepresenable

    init(
        useCase: ComicsCollectionUseCaseRepresenable
    ) {
        self.useCase = useCase
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
        useCase.close()
    }

    // MARK: - Setup

    private func initialSetup() {
        self.collectionView!.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: ComicCollectionViewCell.identifier)
        self.collectionView!.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)

        useCase.initView(onRefresh: { [weak self] in
            self?.refresh()
        })
    }

    private func refresh() {
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool { false }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool { false }
}

// MARK: - UICollectionViewDataSource

extension ComicsCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch useCase.state {
        case .success(let comics):
            return comics.count
        default:
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch useCase.state {
        case .success:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCollectionViewCell.identifier, for: indexPath) as! ComicCollectionViewCell
            cell.set(model: useCase.storeComics?[indexPath.item])
            return cell
        case .loading:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
            cell.set(model: .init(loadingMessage: "We are receiving the comics..."))
            return cell
        case .fail(let error):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
            cell.set(model: .init(error: error))
            return cell
        case .empty:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
            cell.set(model: .init(emptyMessage: "Here you should shoulde see the MARVEL comics."))
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        useCase.loadNextPageIfNeeded(lastIndexShowed: indexPath.item)
    }
}

extension ComicsCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellIdentifier: String
        switch useCase.state {
        case .success:
            cellIdentifier = ComicCollectionViewCell.identifier
        default:
            cellIdentifier = InfoCollectionViewCell.identifier
        }
        return useCase.cellSize(from: view.frame.size, in: cellIdentifier)
    }
}

extension ComicsCollectionViewController {

    enum ViewFactory {
        static var layout: UICollectionViewFlowLayout {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 1
            return layout
        }
    }
}
