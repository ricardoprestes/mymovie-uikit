import UIKit

class MovieCell: UICollectionViewCell {
    static let identifier = "MovieCell"
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .secondarySystemBackground
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 4

        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "star.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .systemYellow
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ratingIcon, ratingLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingStack)
        
        NSLayoutConstraint.activate([
            // Imagem
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: -10),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 10),
            
            // Título
            titleLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            // Rating
            ratingStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingStack.trailingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor),
            ratingStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            ratingIcon.widthAnchor.constraint(equalToConstant: 14),
            ratingIcon.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: Movie) {
        imageView.image = UIImage(systemName: "photo")
        titleLabel.text = movie.title
        ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
        
        if let url = movie.posterURL {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
    
    func applyParallax(in collectionView: UICollectionView) {
        let cellCenter = collectionView.convert(center, to: collectionView.superview)
        let offsetFromCenter = collectionView.bounds.width / 2 - cellCenter.x
        let maxOffset: CGFloat = 25
        let normalizedOffset = offsetFromCenter / (collectionView.bounds.width / 2)
        let parallaxOffset = normalizedOffset * maxOffset
        imageView.transform = CGAffineTransform(translationX: parallaxOffset, y: 0)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.transform = .identity
    }
}
