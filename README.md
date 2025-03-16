## iOS PlayingCard app powered by AI-generated code from Grok 3 xAI

 Built with cutting-edge AI from Grok 3 xAI, this app presents in SwiftUI Playing Card with minimum code.

 <img src="https://github.com/BestKora/Grok3PlayingCard/blob/b2b4dfa44eb44075782641ee97d3f80914c6847c/Grok3PlayingCardP.png " width="350">

 <img src="https://github.com/BestKora/Grok3PlayingCard/blob/383841da6322aa4935a6ccaae8d5a258421bde0b/Grok3PlayingCardL.png" width="550">

## "Thinking" AI Grok 3 xAI :
 <img src="https://github.com/BestKora/Grok3PlayingCard/blob/29d1477b593b7e84be2be3d4d222136af565efe4/Grok%203%20request.png" width="650">
 
 The protocol for interaction with Grok 3 is presented   [here](https://x.com/i/grok/share/QoOqZXCr4DSyIS9zcjWQEhOOc).

To create a playing card in SwiftUI, we need to design a view that represents a standard playing card with a suit (hearts, diamonds, clubs, or spades) and a rank (2 through 10, Jack, Queen, King, or Ace). Below is a complete SwiftUI implementation that includes the necessary enums for suits and ranks, a model struct for the card, and a view to display it.

### Step 1: Define the Suit Enum
The suit of a playing card can be one of four options, each with a corresponding symbol and color (red for hearts and diamonds, black for clubs and spades). We'll use an enum with raw values for the symbols and a computed property for the color.

```swift
import SwiftUI

enum Suit: String {
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
    case spades = "♠️"
    
    var color: Color {
        switch self {
        case .hearts, .diamonds:
            return .red
        case .clubs, .spades:
            return .black
        }
    }
}
```
### Step 2: Define the Rank Enum
The rank represents the card's value, which can be a number from 2 to 10 or a face card (Jack, Queen, King, Ace). We'll use an enum with an associated value for numbers and separate cases for face cards, along with a computed property to display the rank as text.

```swift
enum Rank {
    case number(Int)
    case jack
    case queen
    case king
    case ace
    
    var display: String {
        switch self {
        case .number(let num):
            return String(num)
        case .jack:
            return "J"
        case .queen:
            return "Q"
        case .king:
            return "K"
        case .ace:
            return "A"
        }
    }
}
```
### Step 3: Define the PlayingCard Model
The PlayingCard struct combines a suit and a rank to represent a single card.

```swift
struct PlayingCard {
    let suit: Suit
    let rank: Rank
}
```
### Step 4: Create a Reusable RankSuitView
Since the rank and suit appear in both the top-left and bottom-right corners of the card, we'll create a reusable RankSuitView to display them vertically.

```swift
struct RankSuitView: View {
    let rank: String
    let suit: String
    let cardWidth: CGFloat
    
    var body: some View {
        VStack {
            Text(rank)
                .font(.system(size: cardWidth * 0.1))
                .bold()
            Text(suit)
                .font(.system(size: cardWidth * 0.08)) 
        }
    }
}
```
### Step 5: Create the CardView
The CardView is the main SwiftUI view that displays the playing card. It uses a ZStack to layer a white rectangle with a black border as the background and a VStack with HStacks to position the rank and suit in the corners. The bottom-right corner is rotated 180 degrees to mimic a standard playing card's appearance.

```swift
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
    func symbolPositions(for rank: Int) -> [(CGFloat, CGFloat)] { ... }
}
```

#### The highlight of this code is the function symbolPositions (for rank: Int), which returns an array of rank  (x, y) tuples representing positions as fractions of the card’s width and height:

```swift
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
                (0.25, 0.25),  // Top left
                (0.75, 0.25),  // Top right
                (0.5, 0.5),    // Center
                (0.25, 0.75),  // Bottom left
                (0.75, 0.75)   // Bottom right
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
```
The ForEach loop places a Text(card.suit.rawValue) at each position, scaled by the card’s width and height.

## Step 6: Example Usage
To see the card in action, you can use it in a ContentView like this:

```swift
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
```

## Conclusion

* Grok 3 did a great job of creating a playing card in SwiftUI, suggesting that the symbolPositions(for rank: Int) function returns an array of rank tuples (x, y) representing the suit symbol positions as a fraction of the card's width and height to place the suit symbols on rank 2-10 cards.

* This implementation provides accurate and traditional symbol placement for ranks 2-10, ensuring that your playing cards look professional and follow a standard design.

* All CardView content is wrapped in a GeometryReader, providing access to geometry.size.width and geometry.size.height and automatically adjusting font sizes based on the playing card size. This creates a design that easily adapts to different card sizes.


