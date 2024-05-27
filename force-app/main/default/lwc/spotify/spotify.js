import { LightningElement } from 'lwc';
import searchTrack from '@salesforce/apex/SpotifyController.searchTrack';
import getAudioFeatures from '@salesforce/apex/SpotifyController.getTrackAudioFeatures';

export default class Spotify extends LightningElement {
    showSpinner = false;
    trackQuery = '';
    trackSearchResults;
    selectedTrackId;
    audioFeatures;

    get disableSearchBtn() {
        return this.trackQuery.length === 0;
    }

    handleTrackQueryChange(event) {
        this.trackQuery = event.target.value;
    }

    handleSearchBtnClick() {
        this.searchTrack();
    }

    async searchTrack() {
        this.showSpinner = true;
        try {
            const searchResult = await searchTrack({ trackName: this.trackQuery });
            this.trackSearchResults = JSON.parse(searchResult);
        } catch (error) {
            console.error(error);
        }
        this.showSpinner = false;
    }

    handleTrackClicked(event) {
        this.selectedTrackId = event.detail.trackId;
        console.log(this.selectedTrackId);
        this.getSongFeatures();
    }

    async getSongFeatures() {
        this.showSpinner = true;
        try {
            const audioFeaturesResult = await getAudioFeatures({ trackId: this.selectedTrackId });
            this.audioFeatures = JSON.parse(audioFeaturesResult);
            console.log(JSON.stringify(this.audioFeatures));
        } catch (error) {
            console.error(error);
        }
        this.showSpinner = false;
    }
}
