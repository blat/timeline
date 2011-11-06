$(document).ready(function() {

    var load = false;
    var hasMore = true;

    $(window).scroll(function() {

        var needMore = $('.post:last').offset().top-$(window).height() <= $(window).scrollTop();

        if (needMore && !load && hasMore) {

            load = true;
            $('.loading').show();

            $.ajax({
                url: '/ajax',
                type: 'get',
                data: 'limit=20&offset=' + $('.post').size(),
                success: function(data) {
                    if (data.length > 0) {
                        $('.posts').append(data);
                    } else {
                        hasMore = false;
                        $('#footer').show();
                    }
                    load = false;
                    $('.loading').hide();
                }
            });
        }
    });


    $('.posts a').attr('target', '_blank');
});
