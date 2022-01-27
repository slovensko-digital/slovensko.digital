$(document).ready(function () {
    $('[data-track-event-category]').each(function (i, elm) {
        var e = $(elm);
        ga('send', 'event',
            e.data('track-event-category'),
            e.data('track-event-action'),
            e.data('track-event-label'),
            e.data('track-event-value'),
            {nonInteraction: true}
        );
    });

    $('#contribute-price-other').focus(function () {
        $('#contribute-amount-other').prop('checked', true);
    });

    $('#newsletter-form').submit(function (evt) {
        var form = $(evt.target);
        var data = form.serialize();
        var button = form.find('button')[0];
        button.innerHTML = 'Prihlasujem...';

        $.ajax({
                type: 'POST',
                url: form.data('action'),
                data: data,
                dataType: 'json',
                success: function (data) {
                    if (data.result != undefined && data.result.result == 'success') {
                        form.remove();
                        $('#newsletter-success').removeClass('hidden');
                        ga('send', 'event', 'Newsletter', 'subscribe');
                    }
                },
                complete: function () {
                    button.innerHTML = 'Prihlásiť'
                }
            }
        );
        evt.preventDefault();
    });

    $('#contribute-form').submit(function (evt) {
        var amount = $('#contribute-form input[name=amount]:checked').val();
        if (amount == 'other') {
            amount = $('#contribute-form input[name=price_other]').val();
        }
        $('#contribute-form #contribute-form-price').val(amount);
        return true;
    });

    $('#contribute-form input[name=periodicity]').change(function () {
        if (this.value == 'onetime') {
            $('#contribute-form .payment-periodical').hide();
            $('#contribute-form .payment-onetime').show();
            $('#contribute-form .form-amount .payment-onetime').css('display', 'inline-block');
            $('#contribute-form .form-payment .payment-onetime input[type=radio]:visible').first().prop('checked', true);
            $('#contribute-form .form-amount .payment-onetime input[type=radio]:visible:eq(1)').first().prop('checked', true);
        } else {
            $('#contribute-form .payment-onetime').hide();
            $('#contribute-form .payment-periodical').show();
            $('#contribute-form .form-amount .payment-periodical').css('display', 'inline-block');
            $('#contribute-form .form-payment .payment-periodical input[type=radio]:visible').first().prop('checked', true);
            $('#contribute-form .form-amount .payment-periodical input[type=radio]:visible:eq(1)').first().prop('checked', true);
        }
    });


    /**
     * Listen to scroll to change header opacity class
     */
    function checkScroll() {
        var startY = ($('.navbar').height() - $('#navbar').height() - $('.navbar .alert').height()) * 2;

        if ($(window).scrollTop() > startY) {
            $('.navbar').addClass("nav-scrolled");
        } else {
            $('.navbar').removeClass("nav-scrolled");
        }
    }

    if ($('.navbar').length > 0) {
        $(window).on("scroll load resize", function () {
            checkScroll();
        });
    }

    /**
     * Sticky sidebar
     */


    $('.sidebar-menu').sticky({
        topSpacing: 150, // Space between element and top of the viewport
        zIndex: 100, // z-index
        stopper: ".support-us-left" // Id, class, or number value
    });

    /**
     * Prevent default navbar dropdown behavior on desktop and enable it on mobile
     */

    var $window = $(window),
        $target = $('.navbar .dropdown > a');

    function resize() {
        if ($window.width() > 768) {
            return $target.addClass('disabled');
        }
        $target.removeClass('disabled');
    }

    $window
        .resize(resize)
        .trigger('resize');

    /**
     * check all svg images for png fallback
     */

    svgeezy.init(false, 'png');


    /**
     * TabCollapsible
     */

    $('#audience-nav-tabs').tabCollapse();

    function toggleChevron(e) {
        $(e.target)
            .prev('.panel-heading')
            .find("i.glyphicon")
            .toggleClass('glyphicon-chevron-down glyphicon-chevron-up');
    }

    //change orientation of chevron
    $('#audience-nav-tabs-accordion').on('hidden.bs.collapse', toggleChevron);
    $('#audience-nav-tabs-accordion').on('shown.bs.collapse', toggleChevron);

    /**
     * Scroll to active accordion tab on mobile
     */

    $('#audience-nav-tabs-accordion').on('shown.bs.collapse', function (e) {
        var offset = $(this).find('.collapse.in').prev('.panel-heading');
        if(offset) {
            $('html,body').animate({
                scrollTop: $(offset).offset().top -60
            }, 500);
        }
    });

    $('#sukromne-osoby').each(function(i, e) {
        var elm = $(e);
        var additionalDonors = [
            {
                donor_name: "Peter Komorník",
                amount: 5000,
            },
            {
                donor_name: "Gabriel Lachmann",
                amount: 350,
            },
            {
                donor_name: "Róbert Dusík",
                amount: 350,
            },
            {
                donor_name: "Michal Barla",
                amount: 128,
            },
            {
                donor_name: "Peter Papp",
                amount: 100,
            },
            {
                donor_name: "Pavol Lukáč",
                amount: 100,
            },
        ];

        $.getJSON('https://api.darujme.sk/v1/feeds/6bdda09c-356b-4328-9953-103eb78aa44d/donors?per_page=500', function (data) {
            var anonymisedUUID = {
                '334815ad-a7e3-49f0-96e9-49823b494728': 'A. K.'
            };

            var donors = [...data.response.donors, ...additionalDonors].map((donor) => {
                if (donor.uuid && anonymisedUUID[donor.uuid]) {
                    donor.donor_name = anonymisedUUID[donor.uuid];
                }

                return donor;
            }).sort((a,b) => b.amount - a.amount);
            var total_amount = additionalDonors.reduce((total_amount, {amount}) => total_amount + amount, data.response.metadata.total_amount).toFixed(2);

            elm.after(buildDonorTable(donors, total_amount));
        })
    });

    function buildDonorTable(donors, total_amount) {
        function insertAlignedRow(first, second, target) {
            var row = target.insertRow();
            row.insertCell().innerText = first;

            var cell = row.insertCell();
            cell.classList.add("text-right");
            cell.innerText = second;
        }

        var table = document.createElement("table");
        // IE 11 doesn't support multiple parameters
        table.classList.add("table");
        table.classList.add("table-condensed");
        table.classList.add("table-supporters");
        var tbody = table.createTBody();

        $.each(donors, function (i, donor) {
            insertAlignedRow(donor.donor_name, donor.amount + " \u20AC", tbody);
        })

        var tfoot = table.createTFoot();
        insertAlignedRow("Spolu", total_amount + " \u20AC", tfoot);

        return table;
    }

    $('#activities #filter .btn').click(function() {
        $('#activities #filter .btn').removeClass('active');
        $(this).addClass('active');

        var category = $(this).data('category');
        onParticipationActivitiesCategoryChange(category, 150);
        history.replaceState({}, null, "#" + category)
    });

    function onParticipationActivitiesCategoryChange(category, animationDelay) {
        var allActivities = $('#activities .activity-card');

        $('#activities #list').fadeOut(animationDelay, function() {
            allActivities.hide();
            if (category === 'all') {
                allActivities.show();
            }
            $('#activities .activity-card[data-category="' + category + '"]').show();

            $('#activities #list').fadeIn(animationDelay);
        });
    }

    if (window.location.hash) {
        var categoryFromLocation = window.location.hash.substr(1);
        onParticipationActivitiesCategoryChange(categoryFromLocation, 0);

        $('#activities #filter .btn').removeClass('active');
        $('#activities #filter .btn[data-category="' + categoryFromLocation + '"]').addClass('active');
    }
});
