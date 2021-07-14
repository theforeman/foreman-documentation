function addPageFilter(refSelector, selectorToFilter) {
    var ref = $(refSelector);
    if (!ref || !ref[0]) return;

    var parentNode = ref.parent()[0];
    var filter = $('<input placeholder="Filter..." class="form-control" style="margin: 20px 0;width: 70%;"">')[0]
    parentNode.insertBefore(filter, ref[0]);

    function filterElements(term, elem) {
        var noMatch = elem.text().search(new RegExp(term, "i")) < 0;
        if (noMatch) {
            elem.hide();
        } else {
            elem[0].style.fontWeight = "900";
            elem.show();
        }
        if (term === '') {
            elem[0].style.fontWeight = "unset";
        }
    }

    $(filter).keyup(function () {
        var term = $(this).val();
        if (Array.isArray(selectorToFilter)) {
            selectorToFilter.forEach(selector => {
                $(selector).each((i, elem) => filterElements(term, $(elem)))
            });
        } else {
            $(selectorToFilter).each((i, elem) => filterElements(term, $(elem)))
        }
    });

    return filter;
};
