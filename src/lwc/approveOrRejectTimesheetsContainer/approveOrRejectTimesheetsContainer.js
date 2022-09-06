import { LightningElement, api, wire } from 'lwc';
import getRelatedTimesheets from '@salesforce/apex/TimesheetsController.getRelatedTimesheets';
import approveTimesheets from '@salesforce/apex/TimesheetsController.approveTimesheets';
import rejectTimesheets from '@salesforce/apex/TimesheetsController.rejectTimesheets';
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

    handleApproveTimesheets(event) {
        let timesheetsToApprove = event.detail.timesheetsToApprove;
        console.log('approve timesheets event handled');
        console.log(timesheetsToApprove);

        approveTimesheets( { timesheetsToApprove: timesheetsToApprove } )
            .then(result => {
                console.log('Timesheets approved successfully');
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Timesheets approved successfully!',
                    variant: 'success',
                    mode: 'pester'
                }));
                refreshApex(this.wiredTimesheets);
                this.template.querySelector('c-approve-or-reject-timesheets-table').toggleModal();

            })
            .catch(error => {
                console.warn(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'There was an issue.',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'sticky'
                }));
            });
    }

    handleRejectTimesheets(event) {
        let timesheetsToReject = event.detail.timesheetsToReject;

        let apexPayload = {
            timesheetsToReject: timesheetsToReject
        };

        let rejectTimesheetsCallback = (response) => {
            console.log('timesheets rejected successfully');
            console.log(response);
            refreshApex(this.wiredTimesheets);
            this.template.querySelector('c-approve-or-reject-timesheets-table').toggleModal();
        }

        let rejectTimesheetsErrorHandler = (error) => {
            console.warn(error);
        } 

        rejectTimesheets(apexPayload)
            .then(rejectTimesheetsCallback)
            .catch(rejectTimesheetsErrorHandler);
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
}