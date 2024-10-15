import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import checkAuthorization from '@salesforce/apex/SpotifyAuthorizeController.checkAuthorization';
import authorize from '@salesforce/apex/SpotifyAuthorizeController.authorize';
import reset from '@salesforce/apex/SpotifyAuthorizeController.resetAuthorization';

export default class SpotifyAuthorize extends NavigationMixin(LightningElement) {
    showSpinner = false;
    authorized;

    connectedCallback() {
        this.checkIfAuthorized();
    }

    get iconName() {
        return this.authorized ? 'action:check' : 'action:reject';
    }

    get authorizationStatus() {
        return this.authorized ? 'Authorized' : 'Not Authorized';
    }

    handleChange(event) {
        switch (event.target.dataset.name) {
            case 'clientid':
                this.clientId = event.target.value;
                break;
            case 'clientsecret':
                this.clientSecret = event.target.value;
                break;
            default:
        }
    }

    async checkIfAuthorized() {
        this.showSpinner = true;
        try {
            const result = await checkAuthorization();
            this.authorized = result;
        } catch (error) {
            console.error(error);
        }
        this.showSpinner = false;
    }

    async handleAuthorize() {
        this.showSpinner = true;
        try {
            const result = await authorize({ clientId: this.clientId, clientSecret: this.clientSecret });
            this[NavigationMixin.Navigate](
                {
                    type: 'standard__webPage',
                    attributes: {
                        url: result
                    }
                },
                false
            );
        } catch (error) {
            console.error(error);
        }
        this.showSpinner = false;
    }

    async handleReset() {
        this.showSpinner = true;
        try {
            await reset();
            this.authorized = false;
        } catch (error) {
            console.error(error);
        }
        this.showSpinner = false;
    }
}
