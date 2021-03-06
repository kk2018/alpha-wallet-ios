// Copyright © 2018 Stormbird PTE. LTD.

import Foundation
import UIKit

class OpenSeaNonFungibleTokenViewCell: UICollectionViewCell {
    static let identifier = "OpenSeaNonFungibleTokenViewCell"

    private var currentDisplayedImageUrl: URL?
    private let background = UIView()
    private let imageView = UIImageView()
    //Holder so UIMotionEffect don't reveal the background behind the image
    private let imageHolder = UIView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        background.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(background)

        let stackView = [
            imageHolder,
            label,
        ].asStackView(axis: .vertical, spacing: 0, alignment: .fill)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(stackView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageHolder.addSubview(imageView)

        let xMargin = CGFloat(5)
        let yMargin = CGFloat(0)
        let imageViewBleed = CGFloat(12)
        NSLayoutConstraint.activate([
            background.anchorsConstraint(to: contentView, edgeInsets: .init(top: yMargin, left: xMargin, bottom: yMargin, right: xMargin)),

            stackView.anchorsConstraint(to: background),

            imageHolder.widthAnchor.constraint(equalTo: imageHolder.heightAnchor),

            imageView.anchorsConstraint(to: imageHolder, margin: imageViewBleed),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupParallaxEffect(forView: imageView, max: 20)
    }

    func configure(viewModel: OpenSeaNonFungibleTokenViewCellViewModel) {
        contentView.backgroundColor = viewModel.backgroundColor

        background.backgroundColor = viewModel.contentsBackgroundColor
        background.layer.cornerRadius = viewModel.contentsCornerRadius
        background.clipsToBounds = true

        imageHolder.clipsToBounds = true

        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        if let currentDisplayedImageUrl = currentDisplayedImageUrl, currentDisplayedImageUrl == viewModel.imageUrl {
            //Empty
        } else {
            imageView.image = nil
        }

        if let imagePromise = viewModel.image {
            currentDisplayedImageUrl = viewModel.imageUrl
            imagePromise.done { [weak self] image in
                guard let strongSelf = self else { return }
                guard strongSelf.currentDisplayedImageUrl == viewModel.imageUrl else { return }
                strongSelf.imageView.image = image
            }.cauterize()
        } else {
            //TODO better to have a dedicated icon instead of assuming the app's file name
            imageView.image = UIImage(named: "AppIcon60x60")
        }

        label.textAlignment = .center
        label.textColor = viewModel.titleColor
        label.font = viewModel.titleFont
        label.text = viewModel.title
    }
}
