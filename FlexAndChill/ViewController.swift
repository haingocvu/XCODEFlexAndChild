/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import YogaKit

class ViewController: UIViewController {
    private let paddingHorizontal: YGValue = 8.0
    private let padding: YGValue = 8.0
    private let backgroundColor: UIColor = .black
    
    fileprivate var shows = [Show]()
    
    fileprivate let contentView: UIScrollView = UIScrollView(frame: .zero)
    fileprivate let showCellIdentifier = "ShowCell"
    
    // Overall show info
    private let showPopularity = 5
    private let showYear = "2010"
    private let showRating = "TV-14"
    private let showLength = "3 Series"
    private let showCast = "Benedict Cumberbatch, Martin Freeman, Una Stubbs"
    private let showCreators = "Mark Gatiss, Steven Moffat"
    
    // Show selected
    private let showSelectedIndex = 2
    private let selectedShowSeriesLabel = "S3:E3"
    
    // MARK: - Life cycle methods
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Calculate and set the content size for the scroll view
        var contentViewRect: CGRect = .zero
        for view in contentView.subviews {
            contentViewRect = contentViewRect.union(view.frame)
        }
        contentView.contentSize = contentViewRect.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load shows from plist
        shows = Show.loadShows()
        let show = shows[showSelectedIndex]
        
        
        // -----------------------
        // Content View
        // -----------------------
        contentView.backgroundColor = backgroundColor
        contentView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.height = YGValue(self.view.bounds.size.height)
            layout.width = YGValue(self.view.bounds.size.width)
            layout.justifyContent = .flexStart
        }
        self.view.addSubview(contentView)
        
        //show's image
        let episodImageView = UIImageView(frame: .zero)
        episodImageView.backgroundColor = UIColor.brown
        let image = UIImage(named: show.image)
        episodImageView.image = image
        let imageWidth = image?.size.width ?? 1.0
        let imageHeigh = image?.size.height ?? 1.0
        episodImageView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.flexGrow = 1
            YGLayout.aspectRatio = imageWidth/imageHeigh
        }
        contentView.addSubview(episodImageView)
        
        //show summary
        let showSummaryView = UIView(frame: .zero)
        showSummaryView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.flexDirection = .row
            YGLayout.padding = self.padding
        }
        
        //create rating label
        let summaryRatingLabel = UILabel(frame: .zero)
        summaryRatingLabel.text = String(repeating: "*", count: showPopularity)
        summaryRatingLabel.textColor = .red
        summaryRatingLabel.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.flexGrow = 1
        }
        showSummaryView.addSubview(summaryRatingLabel)
        
        //create summary info view for child items
        let summaryInfoView = UIView(frame: .zero)
        summaryInfoView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.flexDirection = .row
            YGLayout.flexGrow = 2
            YGLayout.justifyContent = .spaceBetween
        }
        
        //add items to summary info view
        for item in [self.showYear, self.showRating, self.showLength] {
            let summaryLabel = UILabel(frame: .zero)
            summaryLabel.text = item
            summaryLabel.font = UIFont.systemFont(ofSize: 14)
            summaryLabel.textColor = UIColor.lightGray
            summaryLabel.configureLayout { (YGLayout) in
                YGLayout.isEnabled = true
            }
            summaryInfoView.addSubview(summaryLabel)
        }
        
        //add space to the right of show summary info
        //by create a blank UIVIEW
        let summarySpacerView =  UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 1))
        summarySpacerView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.flexGrow = 1
        }
        
        showSummaryView.addSubview(summaryInfoView)
        showSummaryView.addSubview(summarySpacerView)
        contentView.addSubview(showSummaryView)
        
        //create title view
        let titleView = UIView(frame: .zero)
        titleView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.flexDirection = .row
            YGLayout.padding = self.padding
        }
        let titleEpisodeLabel =
            showLabelFor(text: selectedShowSeriesLabel,
                         font: UIFont.boldSystemFont(ofSize: 16.0))
        
        titleView.addSubview(titleEpisodeLabel)
        
        
        let titleFullLabel = UILabel(frame: .zero)
        titleFullLabel.text = show.title
        titleFullLabel.textColor = UIColor.lightGray
        titleFullLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleFullLabel.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.marginLeft = 20.0
            YGLayout.marginBottom = 5.0
        }
        titleView.addSubview(titleFullLabel)
        contentView.addSubview(titleView)
        
        //create description view
        let descriptionView = UIView(frame: .zero)
        descriptionView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.paddingHorizontal = self.paddingHorizontal
        }
        
        //description label
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = UIColor.lightGray
        descriptionLabel.text = show.detail
        descriptionLabel.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.marginBottom = 5
        }
        
        descriptionView.addSubview(descriptionLabel)
        
        //create cast label
        let castText = "Cast: \(self.showCast)"
        let castLabel = showLabelFor(text: castText, font: UIFont.boldSystemFont(ofSize: 14))
        
        //create creator label
        let creatorText = "Creator: \(self.showCreators)"
        let creatorLabel = showLabelFor(text: creatorText, font: UIFont.boldSystemFont(ofSize: 14))
        
        descriptionView.addSubview(castLabel)
        descriptionView.addSubview(creatorLabel)
        
        contentView.addSubview(descriptionView)
        
        //create acton view
        
        let actionView = UIView(frame: .zero)
        actionView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.flexDirection = .row
            YGLayout.padding = self.padding
        }
        
        //create add action view
        let addActionView = showActionViewFor(imageName: "add", text: "My List")
        actionView.addSubview(addActionView)
        
        //create share action view
        let shareActionView = showActionViewFor(imageName: "share", text: "Share")
        actionView.addSubview(shareActionView)
        
        contentView.addSubview(actionView)
        
        //create tab view
        let tabsView = UIView(frame: .zero)
        tabsView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.padding = self.padding
            YGLayout.flexDirection = .row
        }
        
        //create tab item to add to tabsview
        let tabItemEpisodes = showTabBarFor(text: "EPISODES", isSelected: true)
        let tabItemMore = showTabBarFor(text: "MORE", isSelected: false)
        
        tabsView.addSubview(tabItemEpisodes)
        tabsView.addSubview(tabItemMore)
        
        //add tab view to content view
        contentView.addSubview(tabsView)
        
        //create table view
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = self.backgroundColor
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: self.showCellIdentifier)
        tableView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.flexGrow = 1
        }
        
        //add table view to content view
        contentView.addSubview(tableView)
        
        // Apply the layout to view and subviews
        contentView.yoga.applyLayout(preservingOrigin: false)
        
    }
    
}

// MARK: - Private methods

private extension ViewController {
    func showLabelFor(
        text: String,
        font: UIFont = UIFont.systemFont(ofSize: 14.0)) -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = font
        label.textColor = .lightGray
        label.text = text
        label.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 5.0
        }
        return label
    }
    
    func showActionViewFor(imageName: String, text: String) -> UIView {
        let actionView = UIView(frame: .zero)
        actionView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.alignItems = .center
            YGLayout.marginRight = 20
        }
        let actionButton = UIButton(frame: .zero)
        actionButton.setImage(UIImage(named: imageName), for: .normal)
        actionButton.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.padding = 10
        }
        actionView.addSubview(actionButton)
        
        let actionLabel = showLabelFor(text: text)
        actionView.addSubview(actionLabel)
        
        return actionView
    }
    
    func  showTabBarFor(text: String, isSelected: Bool) -> UIView {
        let tabView = UIView(frame: .zero)
        tabView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.alignItems = .center
            YGLayout.marginRight = 20
        }
        let tabLabelFont = isSelected ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14)
        let fontSize = text.size(attributes: [NSFontAttributeName : tabLabelFont])
        
        //them thanh mau do khi chon vao tab
        let tabSelectionView = UIView(frame: CGRect(x: 0, y: 0, width: fontSize.width, height: 3))
        if isSelected {
            tabSelectionView.backgroundColor = .red
        }
        tabSelectionView.configureLayout { (YGLayout) in
            YGLayout.isEnabled = true
            YGLayout.marginBottom = 5
        }
        tabView.addSubview(tabSelectionView)
        
        //them chu cua tab
        let tabLabel = showLabelFor(text: text, font: tabLabelFont)
        tabView.addSubview(tabLabel)
        
        return tabView
    }
    
    // TODO: Add private methods below
    
}

// MARK: - UITableViewDataSource methods

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShowTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: showCellIdentifier, for: indexPath) as! ShowTableViewCell
        cell.show = shows[indexPath.row]
        return cell
    }
    
}

// MARK: - UITableViewDelegate methods

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row \(indexPath.row)")
    }
}

