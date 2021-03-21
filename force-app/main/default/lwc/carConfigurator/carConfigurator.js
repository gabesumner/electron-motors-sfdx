import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FLASH_URL from '@salesforce/resourceUrl/flash';
import FLARE_URL from '@salesforce/resourceUrl/flare';
import FLINT_URL from '@salesforce/resourceUrl/flint';
const fields = [
    'Vehicle__c.Model__c',
    'Vehicle__c.Paint__c',
    'Vehicle__c.Battery__c'
];

export default class CarConfigurator extends LightningElement {
    model; color; battery;
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields }) 
    getVehicle({error, data}) {
        if (error) {
            console.log(WorkSchedule.getErrorMessage(error));
        } else if (data) {
            this.model = data.fields.Model__c.value
            this.color = data.fields.Paint__c.value
            this.battery = data.fields.Battery__c.value
        }
    }

    get getFlintButtonClass() {
        return this.getModelButtonClassFor('Flint')
    }

    get getFlashButtonClass() {
        return this.getModelButtonClassFor('Flash')
    }

    get getFlareButtonClass() {
        return this.getModelButtonClassFor('Flare')
    }

    get getRedButtonClass() {
        return `color red ${this.color == 0 ? 'selected' : ''}`
    }

    get getBlueButtonClass() {
        return `color blue ${this.color == 230 ? 'selected' : ''}`
    }

    get getGreenButtonClass() {
        return `color green ${this.color == 130 ? 'selected' : ''}`
    }
    
    get getPurpleButtonClass() {
        return `color purple ${this.color == 1000 ? 'selected' : ''}`
    }

    get getTealButtonClass() {
        return `color teal ${this.color == 4150 ? 'selected' : ''}`
    }  
    
    get getBrownButtonClass() {
        return `color brown ${this.color == 55 ? 'selected' : ''}`
    }

    get get75BatteryButtonClass() {
        return this.getBatteryButtonClassFor('75 kWh')
    }

    get get100BatteryButtonClass() {
        return this.getBatteryButtonClassFor('100 kWh')
    }

    get get100PBatteryButtonClass() {
        return this.getBatteryButtonClassFor('100P kWh')
    }

    get getModelPhotoUrl() {
        switch(this.model) {
            case "Flint":
                return FLINT_URL;
            case "Flare":
                return FLARE_URL;
            case "Flash":
                return FLASH_URL;
        }
    }

    get getModelStyle() {
        return `filter:hue-rotate(${this.color}deg)`
    }

    getModelButtonClassFor(model) {
        return `slds-button ${model === this.model ? 'slds-button_brand' : 'slds-button_neutral'}`
    }

    getBatteryButtonClassFor(battery) {
        return `slds-button ${battery === this.battery ? 'slds-button_brand' : 'slds-button_neutral'}`
    }    

    getColorButtonClassFor(event) {
        switch(event.target.dataset.value) {
            case 0:
                return `color red ${this.color === 0 ? 'selected' : ''}`
            case 55:
                return `color brown ${this.color === 55 ? 'selected' : ''}`
            case 130:
                return `color green ${this.color === 130 ? 'selected' : ''}`
            case 230:
                return `color blue ${this.color === 230 ? 'selected' : ''}`
            case 1000:
                return `color purple ${this.color === 1000 ? 'selected' : ''}`
            case 4150:
                return `color teal ${this.color === 4150 ? 'selected' : ''}`
        }
    }

    handleModelClick(event) {
        this.model = event.target.dataset.value
        this.updateVehicle()
    }

    handleColorClick(event) {
        this.color = event.target.dataset.value
        this.updateVehicle()
    }

    handleBatteryClick(event) {
        console.log('handleBatteryClick')
        this.battery = event.target.dataset.value
        this.updateVehicle()
    }    

    updateVehicle() {
        let vehicle = {
            fields: {
                Id: this.recordId,
                Model__c: this.model,
                Paint__c: this.color,
                Battery__c: this.battery
            }
        };
        updateRecord(vehicle)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Vehicle updated.',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.message.body,
                        variant: 'error',
                    }),
                );
            }
        );
    } 
}