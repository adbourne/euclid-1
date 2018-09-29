import React, {Component} from 'react';
import Nav from './Nav';
import DataTabs from './DataTabs';
import './DataViewer.css';

class DataViewer extends Component {
    render() {
        return (
            <div>

                <Nav/>

                <div className={"flex-container"}>
                    <div className={"left-panel"}>
                        <h2>Super Exciting Dataset</h2>

                        <dl>
                            <dt>Dataset Publisher</dt>
                            <dd>Some publisher</dd>

                            <dt>Last Updated</dt>
                            <dd>October 25 1985 10:00</dd>

                            <dt>License Definition</dt>
                            <dd>Some license definiton</dd>

                            <span className={"summary-header"}>Summary</span>
                            <p className={"summary"}>
                                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla
                                malesuada venenatis lacus dapibus convallis. Aenean eu sem nisl. Curabitur id est
                                sagittis, viverra est nec, mollis ligula. Donec augue nibh, faucibus et dignissim nec,
                                consectetur vel leo. Aliquam erat volutpat. Praesent euismod at neque eu ultricies.
                                Etiam placerat odio lacus, vel vestibulum nunc efficitur sed.
                            </p>
                        </dl>
                    </div>

                    <div className={"right-panel"}>
                        <DataTabs/>
                    </div>
                </div>

            </div>
        );
    }
}

export default DataViewer;