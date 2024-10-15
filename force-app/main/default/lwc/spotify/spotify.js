import { LightningElement } from 'lwc';

export default class Spotify extends LightningElement {
    selectedItem = 'authorize';

    get showAuthorize() {
        return this.selectedItem === 'authorize';
    }

    get showTrackFeatures() {
        return this.selectedItem === 'trackFeatures';
    }

    handleSelect(event) {
        this.selectedItem = event.detail.name;
    }
}
