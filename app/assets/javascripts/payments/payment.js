$(function() {
  $("button").on("click", function(){
    var form = $("#payments_form");
    var creditCardData = {
      name: form.find("#name").val(),
      card_number: form.find("#card_num").val(),
      expiration_month: form.find("#exp_month").val(),
      expiration_year: form.find("#exp_year").val(),
      postal_code: form.find("#post_code").val()
    }
    balanced.card.create(creditCardData, function(response) {
      $.post("/payments", response.data);
    });
  });
});
