'use strict';
function initMinicolorsPicker(inputs, extra = {}) {
  return inputs.each(function() {
    let item, options;
    item = $(this);
    options = $.extend(extra, item.data('minicolors'));
    item.data('minicolors', null);
    return item.minicolors(options);
  });
};

$( document ).on('turbolinks:load', function() {
  initMinicolorsPicker($(".minicolors-input"));

  $(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
    return initMinicolorsPicker(fieldset.find('.minicolors-input'));
  });
});
