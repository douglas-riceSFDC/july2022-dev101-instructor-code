import { LightningElement, api } from 'lwc';
import getRelatedTimesheets from '@salesforce/apex/TimesheetsController.getRelatedTimesheets';
import approveTimesheets from '@salesforce/apex/TimesheetsController.approveTimesheets';
import rejectTimesheets from '@salesforce/apex/TimesheetsController.rejectTimesheets';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ApproveOrRejectTimesheetsContainer extends LightningElement {
    @api recordId;
    timesheets;

    connectedCallback() {
        getRelatedTimesheets( { projectId: this.recordId } )
            .then(result => {
                this.timesheets = result;
                console.log(result);
            })
            .catch(error => {
                console.warn(error);
            });
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

        let rejectTimesheetsCallback = function(response) {
            console.log('timesheets rejected successfully');
            console.log(response);
        }

        let rejectTimesheetsErrorHandler = (error) => {
            console.warn(error);
        } 

        rejectTimesheets(apexPayload)
            .then(rejectTimesheetsCallback)
            .catch(rejectTimesheetsErrorHandler);
    }
}