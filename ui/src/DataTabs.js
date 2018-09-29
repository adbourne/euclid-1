import React from 'react';
import PropTypes from 'prop-types';
import Button from '@material-ui/core/Button';

import {withStyles} from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';
import Typography from '@material-ui/core/Typography';
import SaveIcon from '@material-ui/icons/Save';
import classNames from 'classnames';


import "./DataTabs.css";

function TabContainer(props) {
    return (
        <Typography component="div" style={{color: 'white', padding: 8 * 3, 'min-height': '500px'}}>
            {props.children}
        </Typography>
    );
}

TabContainer.propTypes = {
    children: PropTypes.node.isRequired,
};

const styles = theme => ({
    root: {
        flexGrow: 1,
        width: '100%',
        backgroundColor: "#383732",
        color: 'white',
    }
});

class DataTabs extends React.Component {
    state = {
        value: 0,
    };

    geojsonData = {
        "type": "Feature",
        "geometry": {
            "type": "Point",
            "coordinates": [125.6, 10.1]
        },
        "properties": {
            "name": "Dinagat Islands"
        }
    };

    topjsonData = {
        "type": "Topology",
        "transform": {
            "scale": [0.036003600360036005, 0.017361589674592462],
            "translate": [-180, -89.99892578124998]
        },
        "objects": {
            "aruba": {
                "type": "Polygon",
                "arcs": [[0]],
                "id": 533
            }
        },
        "arcs": [
            [[3058, 5901], [0, -2], [-2, 1], [-1, 3], [-2, 3], [0, 3], [1, 1], [1, -3], [2, -5], [1, -1]]
        ]
    };

    gmlData = '<Feature   fid="142" featureType="school"  Description="A middle school"> \n' +
        '        <Polygon name="extent" srsName="epsg:27354"> \n' +
        '            <LineString name="extent" srsName="epsg:27354"> \n' +
        '                <CData> \n' +
        '                  491888.999999459,5458045.99963358 491904.999999458,5458044.99963358 \n' +
        '                  491908.999999462,5458064.99963358 491924.999999461,5458064.99963358 \n' +
        '                  491925.999999462,5458079.99963359 491977.999999466,5458120.9996336 \n' +
        '                  491953.999999466,5458017.99963357 </CData> \n' +
        '            </LineString> \n' +
        '        </Polygon> \n' +
        '</Feature>';

    handleChange = (event, value) => {
        this.setState({value});
    };

    render() {
        const {classes} = this.props;
        const {value} = this.state;

        return (
            <div className={classes.root}>
                <AppBar position="static" color="default">
                    <Tabs
                        value={value}
                        onChange={this.handleChange}
                        indicatorColor="primary"
                        textColor="primary"
                        scrollable
                        scrollButtons="auto"
                    >
                        <Tab label="GeoJSON" color="white"/>
                        <Tab label="TopoJSON"/>
                        <Tab label="GML"/>
                        <Tab label="Shapefile"/>
                    </Tabs>
                </AppBar>
                {value === 0 && <TabContainer>
                    <div>
                        <pre>{JSON.stringify(this.geojsonData, null, 2)}</pre>
                    </div>
                </TabContainer>}
                {value === 1 && <TabContainer>
                    <div>
                        <pre>{JSON.stringify(this.topjsonData, null, 2)}</pre>
                    </div>
                </TabContainer>}
                {value === 2 && <TabContainer>
                    <div>
                        <pre>{this.gmlData}</pre>
                    </div>
                </TabContainer>}
                {value === 3 && <TabContainer>
                    <pre>Shapefile is a binary format, download the file here:</pre>
                    <Button variant="contained" size="small" className={classes.button}>
                        <SaveIcon className={classNames(classes.leftIcon, classes.iconSmall)}/>
                        Save
                    </Button>
                </TabContainer>}
            </div>
        );
    }
}

DataTabs.propTypes = {
    classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(DataTabs);