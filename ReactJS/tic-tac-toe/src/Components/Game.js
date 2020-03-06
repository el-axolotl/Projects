import React, { Component } from 'react';
import Board from './Board';

// Provides functionallity for the game
class Game extends Component{
    constructor(props){
        super(props);
        this.state = {
            xIsNext: true,
            stepNumber: 0,
            history: [
                {squares: Array(9).fill(null)}
            ]
        };
    };

    // Renders a Board component
    render(){
        const history = this.state.history;
        const current = history[this.state.stepNumber];
        const winner = calcWinner(current.squares);
        /*const moves = history.map((step, move) => {
            const description = move ? 'Go to #' + move : 'Start the game';
            return(
                <li key={move}>
                    <button onClick={() => {this.jumpTo(move)}}>
                        {description}
                    </button>
                </li>
            )
        });*/
        let status;
        if(winner){
            if(!(this.state.xIsNext)){
                document.body.querySelector('.player1').textContent = 'WINNER';
                document.body.querySelector('.player1').classList.toggle('winner');
            }
            else{
                document.body.querySelector('.player2').textContent = 'WINNER';
                document.body.querySelector('.player2').classList.toggle('winner');
            }
        }
        else{
            status = 'Next player is ' + (this.state.xIsNext ? 'X' : 'O')
        }

        return(
            <div className="game">
                <div className="game-board">
                    <Board onClick={(i) => this.clickHandler(i)} squares={current.squares} />
                    <div className="container d-flex justify-content-center mt-5">
                        
                    </div>
                </div>
            </div>
        );
    };

    jumpTo(step){
        this.setState({
            stepNumber : step,
            xIsNext : (step % 2) === 0
        });
    };

    // Event handler for mouse clicks
    clickHandler = (i) => {
        const history = this.state.history.slice(0, this.state.stepNumber + 1);
        const current = history[history.length - 1];
        const squares = current.squares.slice();
        const winner = calcWinner(squares);

        // If we have a winner, no need to continue game.
        if(winner || squares[i]){
            return;
        }
        if(!(this.state.xIsNext)){
            document.body.querySelector('.player1').classList.toggle('active');
            document.body.querySelector('.player2').classList.toggle('active');
        }
        else{
            document.body.querySelector('.player1').classList.toggle('active');
            document.body.querySelector('.player2').classList.toggle('active');
        }
        // Fills the square that is click with either X or O
        squares[i] = this.state.xIsNext ? 'X' : 'O';
        this.setState({
            history: history.concat({
                squares: squares
            }),
            xIsNext: !this.state.xIsNext,
            stepNumber: history.length
        });
    };
};


// Calculates the winner 
function calcWinner(squares){
    const lines = [
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,8],
        [2,4,6]
    ];

    for(let i = 0; i < lines.length; i++){
        const [a,b,c] = lines[i];
        if(squares[a] && squares[a] === squares[b] && squares[b] === squares[c]){
            return squares[a];
        };
    };
    return null;
};

export default Game;