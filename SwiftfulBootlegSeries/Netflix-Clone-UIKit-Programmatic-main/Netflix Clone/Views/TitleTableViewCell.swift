//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Aarish Khanna on 20/01/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let playTitleButton: UIButton = {
                let button = UIButton()
                let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
                button.setImage(image, for: .normal)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.tintColor = .white
                return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let titlesPosterUIImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()
        
    }
    
    private func applyConstraints() {
        let titlesPosterUIImageViewConstraints = [
                    titlesPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    titlesPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                    titlesPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                    titlesPosterUIImageView.widthAnchor.constraint(equalToConstant: 0.3*(Constants.screenSize.width)),
                
                ]
                
                
                let titleLabelConstraints = [
                    titleLabel.leadingAnchor.constraint(equalTo: titlesPosterUIImageView.trailingAnchor, constant: 0.06*(Constants.screenSize.width)),
                    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    titleLabel.widthAnchor.constraint(equalToConstant: 0.47*(Constants.screenSize.width))
                ]
        
                let playTitleButtonConstraints = [
                    playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0.03*(Constants.screenSize.width)),
                    playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
                
                
        
        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    
    public func configure(With model: TitleViewModel) {
//        guard let url = URL(string: model.posterURL) else {
//            return
//        }
        
        guard let url = URL(string:"https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
  //      guard let url = URL(string: "https://m.media-amazon.com/images/I/71niXI3lxlL._SY679_.jpg") else {return}
     //   print(url)
        
        titlesPosterUIImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
