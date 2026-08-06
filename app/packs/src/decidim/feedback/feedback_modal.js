document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("feedbackModal");
  const form = modal?.querySelector(".feedback-form");
  const rating = form?.querySelector(".rating-field");

  if (!modal || !form || !rating) {
    return
  };

  const validateRating = () => {
    const checked = rating.querySelector("input:checked");
    const ratingValue = checked
      ? parseInt(checked.value, 10)
      : 0;

    const label = rating.querySelector("label");
    const error = rating.querySelector(".form-error-general");

    if (ratingValue) {
      label?.classList.remove("is-invalid-label");
      error?.classList.remove("is-visible");
    } else {
      label?.classList.add("is-invalid-label");
      error?.classList.add("is-visible");
      form.dataset.formValid = "false";
    }
  };

  const openFeedbackModal = (attemptsLeft = 20) => {
    const dialog = window.Decidim?.currentDialogs?.feedbackModal;
    if (dialog) {
      dialog.open();
    } else if (attemptsLeft > 0) {
      requestAnimationFrame(() => openFeedbackModal(attemptsLeft - 1));
    } else {
      return;
    }
  }

  openFeedbackModal();

  form.dataset.formValid = "false";

  rating.querySelectorAll("input").forEach((input) => {
    input.addEventListener("change", validateRating);
  })

  form.addEventListener("formvalid.formvalidator", () => {
    form.dataset.formValid = "true";
    validateRating();
  })

  form.addEventListener("forminvalid.formvalidator", () => {
    form.dataset.formValid = "false";
    validateRating();
  })

  form.addEventListener("submit", () => {
    if (form.dataset.formValid === "true") {
      form.classList.add("hidden");
      modal.querySelector(".feedback-success")?.classList.remove("hidden");
    }
  })
});
