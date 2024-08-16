//
//  GithubUserCell.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/14.
//

import UIKit
import SnapKit
import Kingfisher

class GithubUserCell: UITableViewCell {
    private let circularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let siteAdminLabel: UIPaddingLabel = {
        let label = UIPaddingLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.backgroundColor = UIColor(hex: "4A90E2")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setPadding(top: 1, left: 8, bottom: 1, right: 8)
        label.setCornerRadius(10)
        label.text = "STAFF"
        return label
    }()
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupViews() {
        contentView.addSubview(circularImageView)
        contentView.addSubview(vStackView)
        
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(siteAdminLabel)
        
        circularImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(circularImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    public func configure(cellModel: UserCellProtocol) {
        circularImageView.image = nil
        if let url = URL(string: cellModel.imageURL ?? "") {
            circularImageView.kf.setImage(with: url)
        }
        nameLabel.text = cellModel.name
        siteAdminLabel.isHidden = cellModel.subTitleHidden ?? true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
