//
//  ViewController.swift
//  Graphical Set
//
//  Created by Mouhamed Sourang on 1/20/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    var set = Set()
    var currentDeck = [Card]()
    var drawFrame: CGRect!
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .orange
        createDrawArea()
        set.setUpGame()
        SetUpView()
        createbuttons()
    }
    
    private func createbuttons() {
        let newGameButton = UIButton(frame: CGRect(x: drawFrame.minX + 10.0 , y: drawFrame.maxY, width: 120, height: 60.0))
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.backgroundColor = .gray
        newGameButton.clipsToBounds = true
        newGameButton.layer.cornerRadius = 8.0
        let dealMoreCardButton = UIButton(frame: CGRect(x: drawFrame.maxX - 140 , y: drawFrame.maxY, width: 120, height: 60))
        dealMoreCardButton.setTitle("Deal 3 Cards", for: .normal)
        dealMoreCardButton.backgroundColor = .gray
        dealMoreCardButton.layer.cornerRadius = 8.0
        let scoreLabel = UILabel()
        scoreLabel.frame.origin = self.view.frame.origin.offsetBy(dx: 20.0, dy: 40.0)
        scoreLabel.text = "Score \(score)"
        scoreLabel.frame.size = CGSize.zero
        scoreLabel.sizeToFit()
        self.view.addSubview(newGameButton)
        self.view.addSubview(dealMoreCardButton)
        self.view.addSubview(scoreLabel)
    }
    
    
    // Fix so that the cards are proprelly layed out in landscape mode
    override func viewWillLayoutSubviews() {
        createDrawArea()
        SetUpView()
    }
    
    func createDrawArea() {
        let currentFrame = self.view.frame
        let drawViewOrigine = CGPoint(x: currentFrame.origin.x + 10.0, y: currentFrame.origin.y + 20.0)
        let drawViewSize = CGSize(width: currentFrame.size.width - 10.0, height: currentFrame.size.height - 110.0)
        drawFrame = CGRect(origin: drawViewOrigine, size: drawViewSize)
    }
    
    private func SetUpView() {
        var grid = Grid(layout: .aspectRatio(CGFloat(0.8)), frame: drawFrame)
        grid.cellCount = set.cardsInPlay.count
        for card in set.cardsInPlay.indices {
            guard let cardFrame = grid[card]?.insetBy(dx: 8, dy: 8) else {return}
            let cardView = CardView(frame: cardFrame)
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 8.0
            cardView.backgroundColor = .white
            cardView.numberOfShape = set.cardsInPlay[card].number
            cardView.typeOfShape = set.cardsInPlay[card].shape
            cardView.fillcolor = set.cardsInPlay[card].color
            cardView.strokeColor = set.cardsInPlay[card].shadding
            self.view.addSubview(cardView)
        }
    }
    
}


extension

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
