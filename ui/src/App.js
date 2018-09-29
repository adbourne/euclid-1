import React, {Component} from 'react';
import DataViewer from './DataViewer';
import './App.css';

class App extends Component {
    render() {
        return (
            <div className={"wrapper"}>
                <DataViewer/>
            </div>
        );
    }
}

export default App;
