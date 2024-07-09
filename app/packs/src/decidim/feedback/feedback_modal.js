$(() => {
  const $modal = $("#feedbackModal");
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

  window.Decidim.currentDialogs.feedbackModal.open()

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

  $form.on("submit.decidim-feedback", () => {
    if ($form.data("form-valid")) {
      $(".feedback-form").addClass("hidden");
      $(".feedback-success").removeClass("hidden");
    }
  });
});
