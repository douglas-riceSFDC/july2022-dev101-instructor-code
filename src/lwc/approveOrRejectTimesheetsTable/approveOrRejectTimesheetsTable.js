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

    handleSelectedRows(event) {
        let selectedRows = event.detail.selectedRows;
        console.log(JSON.parse(JSON.stringify(selectedRows)));

        this.selectedTimesheets = selectedRows;
    }

    approveTimesheets() {
        // approve the selected rows
    }

    rejectTimesheets() {

    }

    toggleModal() {
        this.modalShown = !this.modalShown;
    }
}