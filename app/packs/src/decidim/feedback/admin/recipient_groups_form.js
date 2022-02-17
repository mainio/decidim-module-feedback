import AutoLabelByPositionComponent from "src/decidim/admin/auto_label_by_position.component";
import createDynamicFields from "src/decidim/admin/dynamic_fields.component";

const dynamicFieldDefinitions = [
  {
    placeHolderId: "recipient-id",
    wrapperSelector: ".recipient-group-recipients",
    fieldSelector: ".feedback-recipient",
    addFieldSelector: ".add-recipient"
  },
  {
    placeHolderId: "condition-id",
    wrapperSelector: ".recipient-group-conditions",
    fieldSelector: ".group-condition",
    addFieldSelector: ".add-condition"
  }
];

dynamicFieldDefinitions.forEach((section) => {
  const fieldSelectorSuffix = section.fieldSelector.replace(".", "");

  const autoLabelByPosition = new AutoLabelByPositionComponent({
    listSelector: `${section.fieldSelector}:not(.hidden)`,
    labelSelector: ".card-title span:first",
    onPositionComputed: (el, idx) => {
      $(el).find("input[name$=\\[position\\]]").val(idx);
    }
  });

  const hideDeletedItem = ($target) => {
    const inputDeleted = $target.find("input[name$=\\[deleted\\]]").val();

    if (inputDeleted === "true") {
      $target.addClass("hidden");
      $target.hide();

      // Allows re-submitting of the form
      $("input", $target).removeAttr("required");
    }
  };

  createDynamicFields({
    placeholderId: section.placeHolderId,
    wrapperSelector: section.wrapperSelector,
    containerSelector: `${section.wrapperSelector}-list`,
    fieldSelector: section.fieldSelector,
    addFieldButtonSelector: section.addFieldSelector,
    removeFieldButtonSelector: `.remove-${fieldSelectorSuffix}`,
    onAddField: () => {
      autoLabelByPosition.run();
    },
    onRemoveField: ($field) => {
      autoLabelByPosition.run();

      // Allows re-submitting of the form
      $("input", $field).removeAttr("required");
    }
  });

  $(section.fieldSelector).each((_idx, el) => {
    const $target = $(el);

    hideDeletedItem($target);
  });

  autoLabelByPosition.run();
});
