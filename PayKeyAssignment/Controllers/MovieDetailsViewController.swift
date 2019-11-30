//
//  MovieDetailsViewController.swift
//  PayKeyAssignment
//
//  Created by Josh Sorokin on 25/11/2019.
//  Copyright © 2019 Enjeera Interactive. All rights reserved.
//

import UIKit

//Still need to work the design for this view, placeholders, etc.

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var genre1: UILabel!
    @IBOutlet weak var genre2: UILabel!
    @IBOutlet weak var genre3: UILabel!
    @IBOutlet weak var dateLanguageRuntime: UILabel!
    @IBOutlet weak var homepage: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseInfo: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var boxOffice: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    var movieDetails: MovieDetails?
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        self.title = movieDetails?.title ?? ""
    }
    
    func updateUI() {
        
        let movie = self.movieDetails
        
        movieTitle.text = movie?.title ?? ""
        
        let backdropPath = movie?.backdropPath ?? ""
        let backdropURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdropPath)")!
        backdrop.downloadImage(from: backdropURL)
        
        tagline.text = "\"\(movie?.tagline ?? "")\""
        
        if movie?.genres.indices.contains(0) == true {
            
            genre1.text = movie?.genres[0].name
            
        } else {
            genre1.text = ""
            genre3.backgroundColor = .white
        }
        
        if movie?.genres.indices.contains(0) == true {
            
            genre2.text = movie?.genres[0].name
            
        } else {
            genre2.text = ""
            genre3.backgroundColor = .white
        }
        
        if movie?.genres.indices.contains(1) == true {
            
            genre3.text = movie?.genres[1].name
            
        } else {
            genre3.text = ""
            genre3.backgroundColor = .white
        }
        
        if movie?.genres.indices.contains(2) == true {
              
              genre3.text = movie?.genres[2].name
              
          } else {
              genre3.text = ""
              genre3.backgroundColor = .white
          }
        
        dateLanguageRuntime.text = "\(movie?.releaseDate.prefix(4) ?? "") / \(movie?.runtime  ?? 0) MIN"
        
        homepage.text = movie?.homepage
        
        rating.text = "\(movie?.voteAverage ?? 0)/10 out of \(movie?.voteCount ?? 0) votes"
        
        releaseInfo.text = "\(movie?.releaseDate  ?? "")"
        
        budget.text = "Budget: $\(movie?.budget ?? 0)"
        
        boxOffice.text = "Box Office: $\(movie?.revenue ?? 0)"
        
        movieDescription.text = movie?.overview ?? ""
        
    }
    
}


