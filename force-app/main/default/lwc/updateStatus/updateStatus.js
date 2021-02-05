import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import readCSV from '@salesforce/apex/UpdateStatusController.readCSVFile';

const columns = [
    { label: 'Name', fieldName: 'Name' }, 
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Rating', fieldName: 'Rating'}, 
    { label: 'Type', fieldName: 'Type'}, 
    { label: 'Website', fieldName: 'Website', type:'url'}
];

export default class UpdateStatus extends LightningElement {
    @api recordId;
    @track error; 

    // accepted parameters
    get acceptedFormats() {
        return ['.csv'];
    }
    
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        // calling apex class
        console.log('this.recordId = ' + this.recordId);
        readCSV({idContentDocument : uploadedFiles[0].documentId,
                 argyleGroupEventId : this.recordId})
        .then(result => {  
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Event Participant Statuses are updated to Attended based on CSV file!!!',
                    variant: 'success',
                }),
            );
 
            this.dispatchEvent(new CustomEvent('closeparentauracomponent')); 

        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );     
        })

    }
}