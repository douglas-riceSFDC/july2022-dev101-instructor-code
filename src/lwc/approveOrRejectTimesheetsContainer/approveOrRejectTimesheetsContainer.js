import { LightningElement, api } from 'lwc';
import getRelatedTimesheets from '@salesforce/apex/TimesheetsController.getRelatedTimesheets';

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
}