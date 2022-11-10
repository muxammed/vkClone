// ReactionView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// кастомная вьюв для переиспользования реакций лайки комменты шейр
@IBDesignable final class ReactionView: UIView {
    // MARK: - IBOutlets

    @IBOutlet private var reactionView: UIView!
    @IBOutlet private var reactionImageView: UIImageView!
    @IBOutlet private var reactionLabel: UILabel!
    @IBOutlet private var labelLeadigConstraint: NSLayoutConstraint!
    @IBOutlet private var labelViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Public properties

    @IBInspectable var caption: String? {
        get { reactionLabel?.text }
        set { reactionLabel?.text = newValue
            labelViewWidthConstraint?.constant = CGFloat(newValue?.count ?? 0 * 10)
        }
    }

    @IBInspectable var image: UIImage? {
        get { emptyImage }
        set { reactionImageView?.image = newValue
            emptyImage = newValue ?? UIImage()
        }
    }

    @IBInspectable var filledImage: UIImage? {
        get { filedImage }
        set { reactionImageView?.image = newValue
            filedImage = newValue ?? UIImage()
        }
    }

    @IBInspectable var hasLabelText: Bool = true {
        didSet {
            labelLeadigConstraint?.constant = hasLabelText ? 4 : 0
            reactionLabel.isHidden = !hasLabelText
        }
    }

    // MARK: - Private properties

    private var emptyImage = UIImage()
    private var filedImage = UIImage()

    // MARK: - Initialisators

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
        setupGestures()
    }

    // MARK: - Public methods

    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }

    func updateView() {
        labelViewWidthConstraint?.constant = CGFloat(reactionLabel.text?.count ?? 0 * 10)
    }

    // MARK: - Private methods

    private func configureView() {
        reactionView.layer.cornerRadius = frame.height / 2
        layer.cornerRadius = frame.height / 2
    }

    private func setupGestures() {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(touchedAction(sender:)))
        recognizer.delegate = self
        recognizer.minimumPressDuration = 0.0
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
    }

    private func initSubviews() {
        let bundle = Bundle(for: ReactionView.self)
        bundle.loadNibNamed(Constants.reactionViewNibName, owner: self, options: nil)
        addSubview(reactionView)
        reactionView.translatesAutoresizingMaskIntoConstraints = false
        reactionViewConstraints()
        frame = bounds
        clipsToBounds = true
        reactionView.clipsToBounds = true
    }

    private func reactionViewConstraints() {
        NSLayoutConstraint.activate([
            reactionView.topAnchor.constraint(equalTo: topAnchor),
            reactionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reactionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            reactionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func makeAnimation(with scaledAndTranslatedTransform: CGAffineTransform, isFilledImage: Bool) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0,
            options: .curveLinear
        ) {
            self.transform = scaledAndTranslatedTransform
            self.reactionImageView.image = isFilledImage ? self.filedImage : self.emptyImage
        }
    }

    @objc func touchedAction(sender: UILongPressGestureRecognizer) {
        var originalTransform = transform
        if sender.state == .began {
            let originalTransform2 = transform
            let scaledTransform = originalTransform2.scaledBy(x: 1.2, y: 1.2)
            originalTransform = scaledTransform
            let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: 0.0)
            makeAnimation(with: scaledAndTranslatedTransform, isFilledImage: true)
        } else if sender.state == .ended {
            let scaledTransform = originalTransform.scaledBy(x: 1 / 1.2, y: 1 / 1.2)
            let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: 0.0)
            makeAnimation(with: scaledAndTranslatedTransform, isFilledImage: false)
        }
    }
}

/// UIGestureRecognizerDelegate
extension ReactionView: UIGestureRecognizerDelegate {}

/// константы
extension ReactionView {
    enum Constants {
        static let reactionViewNibName = "ReactionView"
    }
}
