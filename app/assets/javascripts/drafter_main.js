var ready;

ready = function() {  
        	$('<span class="to_top_button"><span class="transparent_button"></span></span>').insertBefore('.content_all');
        	$('.to_top_button').fadeOut();
        	$(window).scroll(function() {
           	if ($(this).scrollTop() >= 800) {
           		$('.to_top_button').fadeIn();
           	}
        		else {
               $('.to_top_button').fadeOut();
           	};
        	});
          $('.to_top_button').click(function() {
          	$('html, body').animate( {
          		scrollTop: 0
          	})
          })
           
           
          $('.clh1').click(function(){
            var parentclass = $( this ).parent().get( 0 ).className;
            alert(parentclass);
          });

        };

$(document).ready(ready);
$(document).on('page:load', ready);