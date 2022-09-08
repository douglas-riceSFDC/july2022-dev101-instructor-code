import { LightningElement, api, wire } from 'lwc';
import getRelatedTimesheets from '@salesforce/apex/TimesheetsController.getRelatedTimesheets';
import updateTimesheets from '@salesforce/apex/TimesheetsController.updateTimesheets';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ApproveOrRejectTimesheetsContainer extends LightningElement {
    @api recordId;
    wiredTimesheets;
    timesheets;

    connectedCallback() {

    }

    @wire(getRelatedTimesheets,  { projectId: '$recordId' } )
    wiredGetRelatedTimesheets(response) {
        this.wiredTimesheets = response;
        if (response.data) {
            this.timesheets = response.data;
            console.log(response.data);
        }
        else if (response.error) {
            console.warn(response.data);
        }
    }


    handleUpdateTimesheets(event) {
        let timesheetsToUpdate = event.detail.timesheets;
        let status = event.detail.status;

        updateTimesheets({
            timesheets: timesheetsToUpdate,
            status: status
        }).then(result => {
            console.log('Successfully Updated');
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Timesheets updated successfully',
                variant: 'success',
                mode: 'pester'
            }));
            refreshApex(this.wiredTimesheets);
            this.template.querySelector('c-approve-or-reject-timesheets-table').toggleModal();
        }).catch(error => {
            console.warn(error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error',
                mode: 'pester'
            }));
        });
    }

    handleRefreshApexEvent(event) {
        if(event.detail.message === 'success') {
            refreshApex(this.wiredTimesheets);
        }
    }
}