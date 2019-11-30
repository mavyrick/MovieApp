//
//  MovieCollectionViewCell.swift
//  PayKeyAssignment
//
//  Created by Josh Sorokin on 24/11/2019.
//  Copyright © 2019 Enjeera Interactive. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var popularity: UILabel!
    
    var searchedMovie: SearchResult? {
        didSet{
            updateUISearch()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateUIPopular(with: .none)
        //        updateUISearch()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUIPopular(with movie: Movie?) {
        
        if let movie = movie {
            
            title.alpha = 1
            popularity.alpha = 1
            
            title.text = movie.title
            
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)")!
            posterImage.downloadImage(from: posterURL)
            
            popularity.text = String(movie.popularity)
            
        } else {
            title.alpha = 0
            posterImage.image = .none
            popularity.alpha = 0
        }
        
    }
    
    func updateUISearch() {
        
        title.alpha = 1
        popularity.alpha = 1
        
        if let movie = searchedMovie {
            
            title.text = movie.title
            
            if let posterPath = movie.posterPath {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")!
                posterImage.downloadImage(from: posterURL)
            }
            
            popularity.text = String(movie.popularity)
            
        }
    }
}
