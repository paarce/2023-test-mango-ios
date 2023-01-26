//
//  ComicsCollectionViewController.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: ComicCollectionViewCell.identifier)
        customLayout.itemSize = .init(
            width: (view.frame.size.width / 2) - 1,
            height: (view.frame.size.height / 4) - 4
        )

        useCase.initView(onRefresh: { [weak self] in
            self?.collectionView.reloadData()
        })
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
        case .loading:
            return 2
        case .success(let comics):
            return comics.count
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCollectionViewCell.identifier, for: indexPath) as! ComicCollectionViewCell
        let size = useCase.cellSize(from: view.frame.size, in: ComicCollectionViewCell.identifier)
        cell.updateConstraints(cellSize: size)
        cell.set(model: useCase.comics?[indexPath.item])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        useCase.loadNextPageIfNeeded(lastIndexShowed: indexPath.item)
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
