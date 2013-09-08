$(function() {
  $("button").on("click", function(){
    var form = $("#bankaccount_form");
    var bankAccountData = {
      name: form.find("#name").val(),
      account_number: form.find("#account_num").val(),
      bank_code: form.find("#bank_code").val(),
      type: form.find("#account_type").val()
    }
    balanced.bankAccount.create(bankAccountData, function(response) {
      $.post("/bankaccounts", response.data);
    });
  });
});
