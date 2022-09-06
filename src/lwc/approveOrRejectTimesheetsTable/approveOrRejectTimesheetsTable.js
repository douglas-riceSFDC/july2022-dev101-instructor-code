import { LightningElement, api } from 'lwc';

export default class ApproveOrRejectTimesheetsTable extends LightningElement {
    @api timesheets;
    modalShown = false;
    selectedTimesheets = [];

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Times Rejected', fieldName: 'Number_of_Times_Rejected__c' }
    ];

    get noTimesheetsSelected() {
        return this.selectedTimesheets.length === 0;
    }

    handleSelectedRows(event) {
        let selectedRows = event.detail.selectedRows;
        console.log(JSON.parse(JSON.stringify(selectedRows)));

        this.selectedTimesheets = selectedRows;
    }

    approveTimesheets() {
        const evt = new CustomEvent('approvetimesheets', {
            detail: {
                timesheetsToApprove: this.selectedTimesheets
            }
        });

        this.dispatchEvent(evt);

        console.log('approve timesheets event fired');
    }

    rejectTimesheets() {
        let timesheets = this.selectedTimesheets;

        let eventPayload = {
            detail: {}
        };

        eventPayload.detail.timesheetsToReject = timesheets;

        this.dispatchEvent(new CustomEvent('rejecttimesheets', eventPayload));
    }

    updateTimeSheets(event){
        let status = event.currentTarget.dataset.status;
        let timesheets = this.selectedTimesheets;
        let eventPayload = {
            detail: {
                timesheets: timesheets,
                status: status
            }
        };
        this.dispatchEvent(new CustomEvent('updatetimesheets', eventPayload));
    }

    @api toggleModal() {
        this.modalShown = !this.modalShown;
    }
}