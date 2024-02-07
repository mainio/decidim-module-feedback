$(() => {
  const $modal = $("#feedback-modal");
  const $form = $(".feedback-form", $modal);
  // const $cancelConfirm = $(".cancel-confirm", $modal);
  const $rating = $(".rating-field", $form);

  const validateRating = () => {
    const ratingValue = parseInt($("input:checked", $rating).val(), 10);
    if (!ratingValue || ratingValue === 0) {
      $("label", $rating).addClass("is-invalid-label");
      $(".form-error-general", $rating).addClass("is-visible");
      $form.data("form-valid", false);
    } else {
      $("label", $rating).removeClass("is-invalid-label");
      $(".form-error-general", $rating).removeClass("is-visible");
    }
  };

  $modal.foundation("open");
  $form.data("form-valid", false);

  // $(".cancel-feedback", $modal).on("click.decidim-feedback", (ev) => {
  //   ev.preventDefault();
  //   $form.addClass("hide");
  //   $cancelConfirm.removeClass("hide");
  // });
  // $(".cancel-feedback-discard", $modal).on("click.decidim-feedback", (ev) => {
  //   ev.preventDefault();
  //   $form.removeClass("hide");
  //   $cancelConfirm.addClass("hide");
  //   $("input[type='radio']:first", $rating).focus();
  // });
  if ($rating.length > 0) {
    $("input", $rating).on("change", validateRating);
  }

  $form.on("formvalid.zf.abide", () => {
    $form.data("form-valid", true);
    validateRating();
  });
  $form.on("forminvalid.zf.abide", () => {
    $form.data("form-valid", false);
    validateRating();
  });
  // Rails does not understand the remote option in the forms that are in
  // reveal modals because they are re-entered into the DOM. Therefore, we
  // will prevent the default submit action and fire the submit through
  // rails-ujs.
  $form.on("submit.decidim-feedback", (ev) => {
    ev.preventDefault();
    if ($form.data("form-valid")) {
      $form.off("submit.decidim-feedback");
      $(".actions button", $form).attr("disabled", true);
      Rails.fire($form[0], "submit");
    }
  });
});
