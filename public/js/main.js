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
        var startY = ($('.navbar').height() - $('#navbar').height()) * 2;

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
        $.getJSON('https://api.darujme.sk/v1/feeds/6bdda09c-356b-4328-9953-103eb78aa44d/donors', function (data) {
            var table = '<table class="table table-condensed table-supporters"><tbody>';
            var sum = 0;
            $.each(data.response.donors, function (i, donor) {
                table += '<tr><td>' + donor.donor_name + '</td><td class="text-right">' + donor.amount + ' &euro;</td></tr>';
                sum += donor.amount;
            });

            table += '</tbody>';
            table += '<tfoot><tr><td>Spolu</td><td class="text-right">' + sum + ' &euro; </td></tr></tfoot>'
            table += '</table>';
            elm.after(table);
        })
    });
});
