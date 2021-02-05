var stripe = Stripe('{!API_KEY}'); 
  
  const $emptyError = $("#emptyFieldError");
    
  
  
  function selectCard(selectIndex){ 
      
      switch (selectIndex) {
case 1:
  $(".card_bottom1").removeClass("selected");
  $(".card_bottom2").addClass("selected");
  $(".card_bottom3").removeClass("selected");
  break;
case 2:
  $(".card_bottom1").removeClass("selected");
  $(".card_bottom2").removeClass("selected");
  $(".card_bottom3").addClass("selected");
  break;
case 3:
  $(".card_bottom1").addClass("selected");
  $(".card_bottom2").removeClass("selected");
  $(".card_bottom3").removeClass("selected");
  break;
default:
  $(".card_bottom1").removeClass("selected");
  $(".card_bottom2").removeClass("selected");
  $(".card_bottom3").removeClass("selected");
}
      
      
  }
  
  
  
  function test(selector, value, cardSelector){     
      $("#form").show(500);
      $("select option[value=" + selector + "]").prop('selected', 'true').text(value);
      $("." + cardSelector + "").addClass("selected");
      
      switch (cardSelector) {
case 'card_bottom1':
  $(".card_bottom2").removeClass("selected");
  $(".card_bottom3").removeClass("selected");             
  break;
case 'card_bottom2':
  $(".card_bottom1").removeClass("selected");
  $(".card_bottom3").removeClass("selected");  
  break;
case 'card_bottom3':
  $(".card_bottom1").removeClass("selected");
  $(".card_bottom2").removeClass("selected"); 
  break;
default:
  alert( "" );
}
  }
  
  function processToCheckout() { 
      var ticketTypeConfirm = document.getElementById("ticketType").value;  
      if(validate()){
          let isConfirmed = confirm("You have selected the " + $("select option[value=" + ticketTypeConfirm + "]").text() + " ticket.\n Please click 'Ok' to proceed with Checkout or 'Cancel' to select another ticket type.");
          if(isConfirmed){
              $("#loader").show(100); 
              var fname = document.getElementById("fName").value;
              var lname = document.getElementById("lName").value;
              var email = document.getElementById("email").value;
              var jobTitle = document.getElementById("jobTitle").value;
              var company = document.getElementById("company").value;
              var phone = document.getElementById("phone").value;  
              var ticketType = document.getElementById("ticketType").value; 
              var ticketAccessType = $("select option[value=" + ticketType + "]").text();        
              
              
              Visualforce.remoting.Manager.invokeAction(
                  "{!$RemoteAction.RegistrationPageController.checkIsNotBlank}",  
                  ticketType,
                  function(result, event){
                      if (event.status) { 
                          if(result){ 
                              insertEventParticipant(fname, lname, email, jobTitle, company, phone, ticketType, ticketAccessType);
                          }
                          else{ 
                              stripeCallout(fname, lname, email, jobTitle, company, phone, ticketType, ticketAccessType);
                          }
                      } else if (event.type === 'exception') {  
                            $emptyError.text("Registration failed. Please refresh the page and register again.");
                          $emptyError.css("margin-left", "29%");
                      } else {   
                      }
                  }, 
                  {escape: true}
              ); 
          }
      }
  }
  
  function stripeCallout(fname, lname, email, jobTitle, company, phone, ticketType, ticketAccessType){
  Visualforce.remoting.Manager.invokeAction(
                  "{!$RemoteAction.RegistrationPageController.startRequest}", 
                  fname, lname, email, jobTitle, company, phone, ticketType, ticketAccessType, 
                  function(result, event){
                      if (event.status) { 
                          redirect(result);
                            
                      } else if (event.type === 'exception') {   
                          $emptyError.text("Registration failed. Please refresh the page and register again.");
                          $emptyError.css("margin-left", "29%"); 
                      } else {   
                      }
                  }, 
                  {escape: true}
              ); 
  }
  
  function insertEventParticipant(fname, lname, email, jobTitle, company, phone, ticketType, ticketAccessType){
  Visualforce.remoting.Manager.invokeAction(
                  "{!$RemoteAction.RegistrationPageController.insertEventParticipant}", 
                  fname, lname, email, jobTitle, company, phone, ticketType, ticketAccessType, 
                  function(result, event){
                      if (event.status) { 
                            window.location.replace(result);
                      } else if (event.type === 'exception') {  
                            $emptyError.text("Registration failed. Please refresh the page and register again.");
                          $emptyError.css("margin-left", "29%");
                      } else {   
                      }
                  }, 
                  {escape: true}
              ); 
  }
  
  function redirect(id){ 
      stripe.redirectToCheckout({ 
          sessionId: id 
      }).then(function (result) { 
          
      });
  }
    
  document.getElementById("phone").addEventListener("keypress", function (evt) {
  if (evt.which < 48 || evt.which > 57)
  {
      evt.preventDefault();
  }
});
  
  
  
  function validateEmail(email) {
      const re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(email);
  }
    
  
  function validate() {
      
      var allFieldsFIlledIn = true;
      
        const $emptyError = $("#emptyFieldError");
      
      
  $('#registrationForm select').filter (function()
                                    {
                                        if( this.value === 'Select' ) {
                                            $(this).css("border", "1px solid red"); 
                                            if($(this)[0].id === 'ticketType'){
                                                $emptyError.text("Select the Ticket Type");
                                            $emptyError.css("margin-left", "29%");
                                            }
                                            else{
                                                $emptyError.text("Select the Annual Revenue");
                                            $emptyError.css("margin-left", "29%");
                                            }
                                            allFieldsFIlledIn = false;
                                        } else {
                                            $(this).css("border", "1px solid #d5dbd9");
                                        }
                                    });
  
  $('#registrationForm input').filter (function()
                                    { 
                                        if( !this.value ) {
                                            $(this).css("border", "1px solid red");
                                            $emptyError.text("Fill in all the required fields");
                                            $emptyError.css("margin-left", "29%");
                                            allFieldsFIlledIn = false;
                                        } else {
                                            if($(this)[0].id === 'email' && $(this)[0].value.length !== 0)
                                            { 
                                                const $result = $("#emailError");
                                                const $emailfield = $("#email");
                                                const email = $("#email").val();
                                                $result.text("");
                                                
                                                if (validateEmail(email)) { 
                                                    $emailfield.css("border", "1px solid #d5dbd9");
                                                } else {
                                                    $result.text("Email Address is invalid");
                                                    $result.css("margin-left", "29%");
                                                    $emailfield.css("border", "1px solid red"); 
                                                }
                                            }
                                            else{
                                                $(this).css("border", "1px solid #d5dbd9");
                                            }
                                            
                                            
                                            
                                        }
                                    });
  
            
      return allFieldsFIlledIn;
  }
  
  $("#register").on("click", validate); 
  
  
  $('#registrationForm select').blur (function()
                                    {
                                        if( this.value === 'Select' ) {
                                            $(this).css("border", "1px solid red"); 
                                            if($(this)[0].id === 'ticketType'){
                                                $emptyError.text("Select the Ticket Type");
                                            $emptyError.css("margin-left", "29%");
                                            }
                                            else{
                                                $emptyError.text("Select the Annual Revenue");
                                            $emptyError.css("margin-left", "29%");
                                            }
                                            
                                        } else {
                                            $(this).css("border", "1px solid #d5dbd9");
                                        }
                                    });

  
  $('#registrationForm input').blur (function()
                                    { 
                                        if( !this.value ) {
                                            $(this).css("border", "1px solid red");
                                            $emptyError.text("Fill in all the required fields");
                                            $emptyError.css("margin-left", "29%");
                                        } else {
                                            if($(this)[0].id === 'email' && $(this)[0].value.length !== 0)
                                            {

                                                const $result = $("#emailError");
                                                const $emailfield = $("#email");
                                                const email = $("#email").val();
                                                $result.text("");
                                                
                                                if (validateEmail(email)) {
                                                    
                                                    $emailfield.css("border", "1px solid #d5dbd9");
                                                } else {
                                                    $result.text("Email Address is invalid");
                                                    $result.css("margin-left", "29%");
                                                    $emailfield.css("border", "1px solid red"); 
                                                }
                                            }
                                            else{
                                                $(this).css("border", "1px solid #d5dbd9");
                                                $emptyError.text("");
                                            }
                                            
                                            
                                            
                                        }
                                    });