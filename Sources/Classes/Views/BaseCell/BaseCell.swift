//
//  Copyright (c) 2017 Touch Instinct
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the Software), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import TableKit

open class BaseCell: UITableViewCell {

    //    public weak var viewModel: BaseCellViewModel?

    public func configureSeparator(with viewModel: BaseCellViewModel) {
        //        self.viewModel = viewModel
        configureInterface(with: viewModel)
    }

    // MARK: - Private

    private var topView: UIView!
    private var bottomView: UIView!

    // top separator
    private var topViewLeftConstraint: NSLayoutConstraint!
    private var topViewRightConstraint: NSLayoutConstraint!
    private var topViewTopConstraint: NSLayoutConstraint!

    private var topViewHeightConstraint: NSLayoutConstraint!

    // bottom separator
    private var bottomViewLeftConstraint: NSLayoutConstraint!
    private var bottomViewRightConstraint: NSLayoutConstraint!
    private var bottomViewBottomConstraint: NSLayoutConstraint!

    private var bottomViewHeightConstraint: NSLayoutConstraint!

    // insets
    private var topSeparatorInsets = UIEdgeInsets.zero
    private var bottomSeparatorInsets = UIEdgeInsets.zero

    override open func updateConstraints() {
        topViewTopConstraint.constant       = topSeparatorInsets.top
        topViewLeftConstraint.constant      = topSeparatorInsets.left
        topViewRightConstraint.constant     = topSeparatorInsets.right

        bottomViewLeftConstraint.constant   = bottomSeparatorInsets.left
        bottomViewRightConstraint.constant  = bottomSeparatorInsets.right
        bottomViewBottomConstraint.constant = bottomSeparatorInsets.bottom

        super.updateConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureLineViews()
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureLineViews()
    }

    private func configureInterface(with viewModel: BaseCellViewModel?) {
        guard let viewModel = viewModel else {
            return
        }

        topView.isHidden                    = viewModel.separatorType.topIsHidden
        bottomView.isHidden                 = viewModel.separatorType.bottomIsHidden

        topView.backgroundColor             = viewModel.topSeparatorConfiguration?.color
        topViewHeightConstraint.constant    = viewModel.topSeparatorConfiguration?.height ?? CGFloat(pixels: 1)
        topSeparatorInsets                  = viewModel.topSeparatorConfiguration?.insets ?? .zero

        bottomView.backgroundColor          = viewModel.bottomSeparatorConfiguration?.color
        bottomViewHeightConstraint.constant = viewModel.bottomSeparatorConfiguration?.height ?? CGFloat(pixels: 1)
        bottomSeparatorInsets               = viewModel.bottomSeparatorConfiguration?.insets ?? .zero
    }

    private func configureLineViews() {
        let requiredValues: [Any?] = [
            topView, bottomView,
            topViewLeftConstraint, topViewRightConstraint, topViewTopConstraint,
            bottomViewLeftConstraint, bottomViewRightConstraint, bottomViewBottomConstraint]

        if !requiredValues.contains(where: { $0 == nil }) {
            return
        }

        topView = createSeparatorView()
        bottomView = createSeparatorView()

        configureConstrains()
    }

    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        contentView.bringSubview(toFront: view)
        return view
    }

    private func configureConstrains() {
        // height
        topViewHeightConstraint = topView.heightAnchor.constraint(equalToConstant: CGFloat(pixels: 1))
        topViewHeightConstraint.isActive = true

        bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: CGFloat(pixels: 1))
        bottomViewHeightConstraint.isActive = true

        // top separator
        topViewTopConstraint = topView.topAnchor.constraint(equalTo: contentView.topAnchor)
        topViewTopConstraint.isActive = true

        topViewRightConstraint = contentView.rightAnchor.constraint(equalTo: topView.rightAnchor)
        topViewRightConstraint.isActive = true

        topViewLeftConstraint = topView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        topViewLeftConstraint.isActive = true

        // bottom separator
        bottomViewRightConstraint = contentView.rightAnchor.constraint(equalTo: bottomView.rightAnchor)
        bottomViewRightConstraint.isActive = true

        bottomViewLeftConstraint = bottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        bottomViewLeftConstraint.isActive = true

        bottomViewBottomConstraint = bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomViewBottomConstraint.isActive = true
    }

}

public extension TableRow where CellType.T: BaseCellViewModel {

    @discardableResult
    func with(separatorType: CellSeparatorType) -> Self {
        item.with(separatorType: separatorType)
        return self
    }

}
