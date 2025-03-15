//
//  ContentView.swift
//  GrokPlayingCard
//
//  Created by Tatiana Kornilova on 06.03.2025.
//

import SwiftUI

struct PlayingCardView: View {
    let card: PlayingCard
    
    var body: some View {
        GeometryReader { geometry in
            let cardWidth = min(geometry.size.width, geometry.size.height)
            ZStack {
             // 1) Background (assuming you have this already)
                RoundedRectangle(cornerRadius: cardWidth * 0.06)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: cardWidth * 0.06)
                            .stroke(Color.black, lineWidth: 2)
                    )
                
                // 2) Central content
                        if case .number(let num) = card.rank {
                            let positions = symbolPositions(for: num)
                            ForEach(0..<positions.count, id: \.self) { index in
                                let pos = positions[index]
                                Text(card.suit.rawValue)
                                    .font(Font.system(size: cardWidth * 0.2))
                                    .rotationEffect(pos.1 > 0.5 ? .degrees(180) : .degrees(0))
                                    .position(x: geometry.size.width * pos.0,
                                              y: geometry.size.height * pos.1)
                            }
                        } else if case .ace =  card.rank {
                            Text(card.suit.rawValue)
                                .font(Font.system(size: cardWidth * 0.3))
                                .position(x: geometry.size.width * 0.5,
                                          y: geometry.size.height * 0.5)
                        } else {
                            Image(card.rank.display + card.suit.rawValue)
                                .resizable()
                                .scaledToFit()
                                .padding(cardWidth * 0.03)
                        }
                    
                // 3) Rank and suit in corners
                       VStack {
                           HStack {
                               RankSuitView(rank: card.rank.display,
                                            suit: card.suit.rawValue, cardWidth: cardWidth)
                               Spacer()
                           }
                           Spacer()
                           HStack {
                               Spacer()
                               RankSuitView(rank: card.rank.display,
                                            suit: card.suit.rawValue, cardWidth: cardWidth)
                                   .rotationEffect(.degrees(180))
                           }
                       } //  VStack
                       .padding(cardWidth * 0.02)
                   } // geometry
        } // ZStack
        .aspectRatio(5/8.5, contentMode: .fit)
        .foregroundColor(card.suit.color)
    }
    
    // Function to determine symbol positions based on rank
    func symbolPositions(for rank: Int) -> [(CGFloat, CGFloat)] {
        // Define positions as fractions of width and height
        switch rank {
        case 2:
           return [
                (0.5, 0.25 ),  // Top
                (0.5, 0.75 )   // Bottom
            ]
        case 3:
            return [
                (0.5, 0.25 ),  // Top
                (0.5, 0.5  ),  // Center
                (0.5, 0.75 )   // Bottom
            ]
        case 4:
            return [
                (0.25, 0.25 ),  // Top left
                (0.75, 0.25 ),  // Top right
                (0.25, 0.75 ),  // Bottom left
                (0.75, 0.75 )   // Bottom right
            ]
        case 5:
            return [
                (0.25, 0.25 ),  // Top left
                (0.75, 0.25 ),  // Top right
                (0.5, 0.5),     // Center
                (0.25, 0.75 ),  // Bottom left
                (0.75, 0.75 )   // Bottom right
            ]
        case 6:
            return [
                (0.25, 0.25 ),  // Top left
                (0.75, 0.25 ),  // Top right
                (0.25, 0.5  ),  // Center left
                (0.75, 0.5  ),  // Center right
                (0.25, 0.75 ),  // Bottom left
                (0.75, 0.75 )   // Bottom right
            ]
        case 7:
            return [
                // Top row: three symbols
                (0.25, 0.15 ),  // Top left: slightly lower
                (0.5 , 0.3  ),  // Top center
                (0.75, 0.15 ),  // Top right: slightly higher
                // Middle: two symbols
                (0.25, 0.5),    // Center left
                (0.75, 0.5),     // Center right
                // Bottom row: two symbols (mirrored)
                (0.25, 0.85 ),  // Bottom left
                (0.75, 0.85 )   // Bottom right
            ]
        case 8:
            return [
                // Top row: three symbols
                (0.25, 0.15 ),  // Top left: slightly lower
                (0.5, 0.3),     // Top center
                (0.75, 0.15 ),  // Top right:
                // Middle: two symbols (one on each side)
                (0.25, 0.5),            // Middle left
                (0.75, 0.5),            // Middle right
                // Bottom row: three symbols (mirrored)
                (0.25, 0.85 ),  // Bottom left
                (0.5, 0.7),     // Bottom center
                (0.75, 0.85 )   // Bottom right
            ]
        case 9:
            return [
                // Top row: three symbols
                (0.25, 0.15 ),  // Top left
                (0.5, 0.5),     // Top center
                (0.75, 0.15 ),  // Top right
                // Middle row: four symbols (two on each side)
                (0.25, 0.38 ),   // Middle left upper
                (0.25, 0.62 ),   // Middle left lower
                (0.75, 0.38 ),   // Middle right upper
                (0.75, 0.62 ),   // Middle right lower
                // Bottom row: three symbols (mirrored)
                (0.25, 0.85 ),  // Bottom left
                (0.75, 0.85 )   // Bottom right
            ]
        case 10:
            return [
                // Top row: three symbols
                (0.25, 0.15 ),  // Top left
                (0.5, 0.30),    // Top center
                (0.75, 0.15 ),  // Top right
                // Middle row: four symbols (two on each side)
                (0.25, 0.4 ),   // Middle left upper
                (0.25, 0.6 ),   // Middle left lower
                (0.75, 0.4 ),   // Middle right upper
                (0.75, 0.6 ),   // Middle right lower
                // Bottom row: three symbols (mirrored)
                (0.25, 0.85 ),  // Bottom left
                (0.5, 0.70  ),  // Bottom center
                (0.75, 0.85 )   // Bottom right
            ]
        default:
            // For other ranks, stack symbols vertically as a fallback
            return (0..<rank).map { i in
                (0.5, CGFloat(i + 1) / CGFloat(rank + 1))
            }
        }
    }
}

struct RankSuitView: View {
    let rank: String
    let suit: String
    let cardWidth: CGFloat
    
    var body: some View {
        VStack {
            Text(rank)
                .font(.system(size: cardWidth * 0.1)) // Previously .headline
                .bold()
            Text(suit)
                .font(.system(size: cardWidth * 0.08)) // Smaller suit text
        }
    }
}

// Assuming these are your PlayingCard and related types
struct PlayingCard {
    let suit: Suit
    let rank: Rank
    
    enum Suit {
        case spades, hearts, diamonds, clubs
        
        var rawValue: String {
            switch self {
            case .spades: return "♠️"
            case .hearts: return "♥️"
            case .diamonds: return "♦️"
            case .clubs: return "♣️"
            }
        }
        
        var color: Color {
            switch self {
            case .spades, .clubs: return .black
            case .hearts, .diamonds: return .red
            }
        }
    }

    enum Rank {
        case number(Int)
        case ace, jack, queen, king
        
        var display: String {
            switch self {
            case .number(let num): return "\(num)"
            case .ace: return "A"
            case .jack: return "J"
            case .queen: return "Q"
            case .king: return "K"
            }
        }
    }
}

// Example usage
struct ContentView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        if verticalSizeClass == .compact {
            HStack {
                // CardView(card: PlayingCard(suit: .spades, rank: .ace))
                PlayingCardView(card: PlayingCard(suit: .clubs, rank: .king))
                PlayingCardView(card: PlayingCard(suit: .hearts, rank: .ace))
                PlayingCardView(card: PlayingCard(suit: .clubs, rank: .number(9)))
            }
           
        } else {
            VStack {
                // CardView(card: PlayingCard(suit: .spades, rank: .ace))
                PlayingCardView(card: PlayingCard(suit: .clubs, rank: .king))
                PlayingCardView(card: PlayingCard(suit: .hearts, rank: .ace))
                PlayingCardView(card: PlayingCard(suit: .clubs, rank: .number(9)))
            }
        }
    }
}

#Preview {
    ContentView()
        .padding()
}
#Preview {
    PlayingCardView(card: PlayingCard(suit: .hearts, rank: .number(10)))
        .padding()
}
