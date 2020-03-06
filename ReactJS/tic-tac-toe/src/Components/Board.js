import React, { Component } from 'react';
import Square from './Square';

// Returns a Board component
class Board extends Component {

    // Function that renders Square component from Square.js at index i
    renderSquare = (i) => {
        return <Square value={this.props.squares[i]}
        onClick={() => this.props.onClick(i)} />
    };

    // Renders 3 rows of 3 Square componenets
    render() {
        return(
            <div>
                <div className="row">
                    {this.renderSquare(0)}
                    {this.renderSquare(1)}
                    {this.renderSquare(2)}
                </div>
                <div className="row">
                    {this.renderSquare(3)}
                    {this.renderSquare(4)}
                    {this.renderSquare(5)}
                </div>
                <div className="row">
                    {this.renderSquare(6)}
                    {this.renderSquare(7)}
                    {this.renderSquare(8)}
                </div>
            </div>
        )
    };
};

export default Board;