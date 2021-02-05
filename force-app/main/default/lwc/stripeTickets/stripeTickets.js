import { LightningElement } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import StripeResource from '@salesforce/resourceUrl/Stripe';

export default class stripeTickets extends LightningElement {
    
    
    stripeJsLoaded = false;
    stripe; 
  
    renderedCallback(){
        if(!this.stripeJsLoaded){
            Promise.all([ 
                loadScript(this, StripeResource)
            ]).then(() =>{ 
                this.stripeJsLoaded = true; 
                this.stripe = Stripe('pk_test_8fGsF5QgzVyFCAa6aheJHQq9');
                //console.log(Stripe('pk_test_8fGsF5QgzVyFCAa6aheJHQq9'));
            }).catch((error =>{
                this.showToast('ERROR', error.body.message, 'error');
            }));
        }
    }

    redirectCheck(){
        console.log('redirect');
        console.log(this.stripe);
        this.stripe.redirectToCheckout({ 
            sessionId: 'cs_test_Zb6oPPDpINUSmBxdOKXjy0slef5gKyyw8vc7sFiGWaESru5aJM9jIylE'
          })
          .then((result) =>{ 
            console.log('then');
            console.log(result);
            // If `redirectToCheckout` fails due to a browser or network
            // error, display the localized error message to your customer
            // using `result.error.message`.
          })
          .catch(error => {
              console.log(error);
              console.log(JSON.stringify(error));
          });
          console.log('end');
    }
}

// price_1HEthIIAJJKm4vZ4feFpHISI
// price_1HEtMPIAJJKm4vZ4J4wJ4F7r