import React from 'react';
import './App.css';
import Game from './Components/Game';

function App() {
  return (
    <div className="container" id="parent">
      <div className="container d-flex">
        <div className="jumbotron flex-fill d-flex justify-content-center player1 active" id="player-ctn">Player 1</div>
        <div className="jumbotron flex-fill d-flex justify-content-center player2"  id="player-ctn">Player 2</div>
      </div>
      <Game />
    </div>
  );
}

export default App;
