import { LightningElement, api } from 'lwc';

export default class ApproveOrRejectTimesheetsTable extends LightningElement {
    @api timesheets;
    modalShown = false;

    toggleModal() {
        this.modalShown = !this.modalShown;
    }
}