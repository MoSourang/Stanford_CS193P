//
//  AnimatedSetViewController.swift
//  Animated Set
//
//  Created by Mouhamed Sourang on 2/7/21.
//  Copyright © 2021 Mouhamed Sourang. All rights reserved.
//


import UIKit

class AnimatedSetViewController: UIViewController, didTouchCard {
    
    private lazy var ViewBound  = self.view.bounds
    private lazy var setGame = Set()
    private var maincardViews = [CardView]()
    private lazy var grid = Grid(layout: .aspectRatio(CGFloat(0.8)), frame: drawView.bounds)
    enum addType: CaseIterable {case replaceCards, addCards}
    private var mode: addType!
    private var selectedCards = [Int]()
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = Cardbehavior(animator: animator)
    
    // views of selected cards
    private var selectedCardViews: [CardView] {
        var cardsViews = [CardView]()
        selectedCards.forEach {cardsViews.append(maincardViews[$0])}
        return cardsViews
    }
    // return the index of the 3 dealt cards
    private var IndexOfDealtCards: [Int] {
        return setGame.lastThreeDealtCards
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        newGamebutton.isUserInteractionEnabled = false
        dealbutton.isUserInteractionEnabled = false
        setGame.setUpGame()
        configureGameLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if maincardViews.count == 0 {
            configureCardViews()
        }
    }
    
    // adopts layout to new orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        view.layoutSubviews()
        coordinator.animate(alongsideTransition: { (context) in
            self.refreshView()
        }) { (context) in
        }
    }
    
    private var drawView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // layout of container views
    func layoutMainViews() {
        view.addSubview(drawView)
        drawView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        drawView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        drawView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        drawView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.88).isActive = true
        
        view.addSubview(bottomView)
        bottomView.topAnchor.constraint(equalTo: drawView.bottomAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.setNeedsLayout()
    }
    
    private lazy var scorelabel: UILabel = {
        let label = UILabel()
        label.text = "Score \(0)"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var newGamebutton: UIButton = {
        let button = UIButton()
        button.setTitle("New Game", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        button.layer.cornerRadius = 6.0
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(animateNewGameButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var dealbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Deal Card", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        button.layer.cornerRadius = 6.0
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(animateDealMoreButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var  deckLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6.0
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.text = "New"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var  discardLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6.0
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Old"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func layoutButtonsAndLabels() {
        let labelStackView = UIStackView(arrangedSubviews: [deckLabel, discardLabel])
        labelStackView.distribution = .fillEqually
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.spacing = 4.0
        
        let butttonStackView = UIStackView(arrangedSubviews: [newGamebutton, dealbutton])
        butttonStackView.translatesAutoresizingMaskIntoConstraints = false
        butttonStackView.distribution = .fillEqually
        butttonStackView.spacing = 4.0
        
        let mainStackView = UIStackView(arrangedSubviews: [labelStackView , scorelabel , butttonStackView])
        bottomView.addSubview(mainStackView)
        mainStackView.distribution = .fillEqually
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.distribution = .fillEqually
        mainStackView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
    }
    
    // Add gestures to the main view of our App
    private func configureGestureRecognizer() {
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
        view.addGestureRecognizer(rotate)
        let tap =  UISwipeGestureRecognizer(target: self, action: #selector(dealMoreCards))
        tap.direction = [.up, .down ,.left , .right]
        view.addGestureRecognizer(tap)
    }
    
    // Create the initial state of the UI at the start of a new game and when cards are shuffled
    @objc private func configureCardViews() {
        grid = Grid(layout: .aspectRatio(CGFloat(0.8)), frame: drawView.bounds)
        grid.cellCount = setGame.cardsInPlay.count
        for card in setGame.cardsInPlay.indices {
            guard let cardFrame = grid[card]?.insetBy(dx: cardInset, dy: cardInset) else {return}
            let cardView = CardView()
            cardView.frame = cardFrame
            cardView.originalFrame = cardFrame
            cardView.buttonIndex = card
            cardView.card = setGame.cardsInPlay[card]
            maincardViews.append(cardView)
            if setGame.selectedCards.contains(setGame.cardsInPlay[card]) {cardView.layer.borderWidth = 3.0 ; cardView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)}
        }
        configureFinalCardsViews(for: maincardViews)
    }
    
    // Configure the final states of the cardviews before it is displayed to the users
    func configureFinalCardsViews(for cardViews: [CardView]) {
        guard cardViews.count > 0 else {return}
        cardViews.forEach { cardView in
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 8.0
            cardView.backgroundColor = .white
            cardView.alpha = 0.0
            cardView.cardViewDelegate = self
        }
        animateDealingOfCard(for: cardViews.first! , And: cardViews)
    }
    
    // Configure view for newly dealt cards
    @objc func UpdateViewConfigurationForNewlyDealtCards () {
        grid.cellCount = setGame.cardsInPlay.count
        for cardView in maincardViews {
            guard let cardFrame = grid[cardView.buttonIndex]?.insetBy(dx: cardInset, dy: cardInset) else {return}
            cardView.frame = cardFrame
            cardView.layer.borderWidth = 0.0
        }
        configureNeawlyDealtCardsViews(for: IndexOfDealtCards, mode: .addCards)
    }
    
    // Configure cardView for newly dealt cards
    func configureNeawlyDealtCardsViews(for cardIndices: [Int], mode: addType) {
        var cardViews = [CardView]()
        cardIndices.forEach { index in
            guard let cardFrame = grid[index]?.insetBy(dx: cardInset, dy: cardInset) else {return}
            let cardView = CardView()
            cardView.frame = cardFrame
            cardView.originalFrame = cardFrame
            cardView.buttonIndex = index
            cardView.card = setGame.cardsInPlay[index]
            switch mode {
            case .replaceCards: maincardViews[index] = cardView
            case .addCards: maincardViews.append(cardView)
            }
            cardViews.append(cardView)
        }
        configureFinalCardsViews(for: cardViews)
    }
    
    // animate the dealing of cards
    func animateDealingOfCard(for cardView: CardView,  And cardViewsTobeAnimated: [CardView]) {
        self.drawView.addSubview(cardView)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            cardView.bounds  = self.deckLabel.bounds
            let center = self.deckLabel.center
            let cardViewCenter = self.bottomView.convert(center, to: self.view)
            cardView.center = cardViewCenter
        }, completion: { done in
            cardView.alpha = 1.0
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                cardView.frame =  cardView.originalFrame
                cardView.backgroundColor = .lightGray
            }, completion: { done in
                UIView.transition(with: cardView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
                    cardView.cardIsFaceUp = true
                    cardView.backgroundColor = .white
                    self.drawView.layoutIfNeeded()
                }) { (done) in
                }
            })
            guard let cardIndex = cardViewsTobeAnimated.firstIndex(of: cardView) else {return}
            let nextCardIndex =  cardViewsTobeAnimated.index(after: cardIndex)
            if nextCardIndex < cardViewsTobeAnimated.endIndex {
                self.newGamebutton.isUserInteractionEnabled = false
                self.dealbutton.isUserInteractionEnabled = false
                self.animateDealingOfCard(for : cardViewsTobeAnimated[nextCardIndex], And: cardViewsTobeAnimated)
            } else {
                self.dealbutton.isUserInteractionEnabled = true
                self.newGamebutton.isUserInteractionEnabled = true
            }
        })
    }
    
    // handled the logic for when a card is selected
    func cardWasSelected(at cardindex: Int) {
        let selectedCard = setGame.cardsInPlay[cardindex]
        // User selects a cards that has already been selected -> card is deselected
        if setGame.selectedCards.contains(selectedCard) {
            guard let index = selectedCards.firstIndex(of: cardindex) else {return}
            selectedCards.remove(at: index)
            setGame.unSelectCard(selectedCard)
            maincardViews[cardindex].layer.borderWidth = 0.0
        } else {
            // User selects a card -> Highlight newly selected card
            maincardViews[cardindex].layer.borderWidth = 4.0
            maincardViews[cardindex].layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            selectedCards.append(cardindex)
            setGame.chooseCard(at: cardindex)
            if selectedCards.count == 3 {
                // The 3 Selected cards are a mismatch
                if !setGame.ismatched  {
                    selectedCardViews.forEach { cardView in
                        cardView.layer.borderWidth = 4.0
                        cardView.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        scorelabel.text = "Score \(setGame.score)"
                    }
                    Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshView), userInfo: nil, repeats: false)
                } else if setGame.ismatched {
                    // The 3 matched cards are animated
                    selectedCardViews.forEach { cardView in
                        cardView.layer.borderWidth = 4.0
                        cardView.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                        scorelabel.text = "Score \(setGame.score)"
                    }
                    animateMatchedCards(for: selectedCardViews)
                    if setGame.cardsDeck.count >= 3 {
                        dealbutton.isUserInteractionEnabled = false
                        configureNeawlyDealtCardsViews(for: selectedCards, mode: .replaceCards)
                    }
                }
                selectedCards.removeAll()
            }
        }
    }
    
    func animateMatchedCards(for cardViews: [CardView]) {
        for cardView in cardViews {
            view.addSubview(cardView)
            cardBehavior.addItem(item: cardView)
        }
        
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(discardCards), userInfo: ["CardViews" : cardViews], repeats: false)
    }
    
    // animated the Discarding of cards when there is a match
    @objc func discardCards(timer: Timer) {
        guard let info = timer.userInfo as? NSDictionary else {return}
        guard let cardViews =  info["CardViews"] as? [CardView] else {return}
        let point = self.discardLabel.center
        let origine = self.bottomView.convert(point, to: self.view)
        cardViews.forEach { cardView in
            cardView.layoutIfNeeded()
            view.addSubview(cardView)
            self.cardBehavior.removeItem(item: cardView)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0 , delay: 0, options: [.curveEaseIn], animations: {
                self.discardLabel.isOpaque = false
                self.discardLabel.layer.opacity = 0.0
                cardView.bounds.size = self.discardLabel.bounds.size
                self.cardBehavior.snap(item: cardView, snapTo: origine)
                cardView.layer.borderWidth = 0.0
            }, completion: { done in
                UIView.transition(with: cardView, duration: 1.0, options: [.transitionFlipFromLeft], animations: {
                    cardView.cardIsFaceUp = false
                    cardView.backgroundColor = .gray
                }, completion: { done in
                    cardView.removeFromSuperview()
                    self.discardLabel.isOpaque = true
                    self.discardLabel.layer.opacity = 1.0
                })
            })
        }
        
        if setGame.cardsDeck.count < 3 {Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshView), userInfo: nil, repeats: false)}
    }
    
    // Refresh UI When there is no more cards in the deck
    @objc func refreshView() {
        drawView.subviews.forEach {$0.removeFromSuperview()}
        maincardViews.removeAll()
        grid = Grid(layout: .aspectRatio(CGFloat(0.8)), frame: drawView.bounds)
        grid.cellCount = setGame.cardsInPlay.count
        for card in setGame.cardsInPlay.indices {
            drawView.superview?.layoutIfNeeded()
            guard let cardFrame = grid[card]?.insetBy(dx: cardInset, dy: cardInset) else {return}
            let cardView = CardView()
            cardView.frame = cardFrame
            cardView.originalFrame = cardFrame
            cardView.buttonIndex = card
            cardView.clipsToBounds = true
            cardView.layer.cornerRadius = 8.0
            cardView.backgroundColor = .white
            cardView.card = setGame.cardsInPlay[card]
            cardView.cardIsFaceUp = true
            cardView.cardViewDelegate = self
            maincardViews.append(cardView)
            drawView.addSubview(cardView)
            if setGame.selectedCards.contains(setGame.cardsInPlay[card]) {cardView.layer.borderWidth = 3.0 ; cardView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)}
        }
    }
    
    @objc func dealMoreCards() {
        dealbutton.isUserInteractionEnabled = false
        guard setGame.cardsDeck.count > 0 else {return}
        setGame.dealMoreCard()
        UpdateViewConfigurationForNewlyDealtCards()
    }
    
    func configureGameLayout() {
        layoutMainViews()
        layoutButtonsAndLabels()
        configureGestureRecognizer()
        setGame.setUpGame()
    }
    
    @objc func startNewGame() {
        maincardViews.removeAll()
        selectedCards.removeAll()
        newGamebutton.isUserInteractionEnabled = false
        dealbutton.isUserInteractionEnabled = false
        drawView.subviews.forEach {$0.removeFromSuperview()}
        bottomView.subviews.forEach {$0.removeFromSuperview()}
        self.view.subviews.forEach {$0.removeFromSuperview()}
        setGame.setUpGame()
        configureGameLayout()
        scorelabel.text = "Score \(0)"
    }
    
    @objc func shuffleCards() {
        setGame.shuffleCards()
        configureCardViews()
    }
    
    @objc func animateButton(_ button: UIButton) {
        button.animate()
    }
    
    @objc func animateDealMoreButton() {
        animateButton(dealbutton)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(dealMoreCards), userInfo: nil, repeats: false)
    }
    
    @objc func animateNewGameButton() {
        animateButton(newGamebutton)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startNewGame), userInfo: nil, repeats: false)
    }
}

extension AnimatedSetViewController {
    
    struct SizeRatio {
        static let cardInsetRatio = CGFloat(0.01)
    }
    
    private var cardInset: CGFloat {
        return ViewBound.width * SizeRatio.cardInsetRatio
    }
}

extension UIButton {
    @objc func animate () {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = .blue
        }) { (done) in
            if done {
                self.backgroundColor = .lightGray
            }
        }
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}

