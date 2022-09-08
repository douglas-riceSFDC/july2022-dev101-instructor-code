import { LightningElement, api } from 'lwc';
import STATUS_FIELD from '@salesforce/schema/Timesheet__c.Status__c';
import PROJECT_FIELD from '@salesforce/schema/Timesheet__c.Project__c';
import TIMESHEET_INSERTION_SUCCESS_MESSAGE from '@salesforce/label/c.Timesheet_Insertion_Success_Message';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class ApproveOrRejectTimesheetsTable extends LightningElement {
    @api timesheets;

    statusField = STATUS_FIELD;
    projectField = PROJECT_FIELD;

    modalShown = false;
    isInsertNewTimesheetShown = false;
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

    toggleModalBody() {
        this.isInsertNewTimesheetShown = !this.isInsertNewTimesheetShown;
    }

    handleSuccessfulInsert(event) {
        this.dispatchEvent(new ShowToastEvent({
            title:  'Success',
            message: TIMESHEET_INSERTION_SUCCESS_MESSAGE,
            messageData: [event.detail.id],
            variant: 'success',
            mode: 'pester'
        }));

        let eventPayload = {
            detail: {
                message: "success"
            }
        };

        this.dispatchEvent(new CustomEvent('refreshapexevent', eventPayload));

        this.toggleModalBody();
    }

    handleCreateNewTimesheet() {
        this.template.querySelector('lightning-record-edit-form').submit();
    }
}