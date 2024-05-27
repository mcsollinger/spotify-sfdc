import { LightningElement, api } from 'lwc';

export default class SpotifyTrackResult extends LightningElement {
    @api artist;
    @api name;
    @api trackId;
    @api albumImageUrl;

    handleSongClick() {
        this.dispatchEvent(
            new CustomEvent('songclicked', {
                detail: {
                    trackId: this.trackId
                }
            })
        );
    }
}
