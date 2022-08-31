import { LightningElement, api } from 'lwc';
import getRelatedTimesheets from '@salesforce/apex/TimesheetsController.getRelatedTimesheets';
import approveTimesheets from '@salesforce/apex/TimesheetsController.approveTimesheets';

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
            })
            .catch(error => {
                console.warn(error);
            });
    }
}