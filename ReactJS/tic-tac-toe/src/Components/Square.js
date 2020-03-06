import React from 'react';

// Returns a Square component
const sqr = (props) => {
    return(
        <button className="square" onClick={props.onClick}>
            {props.value}
        </button>
    );
};

export default sqr;