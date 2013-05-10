$(function() {

    //-----------------------------------------
    // Timeline

    $('#timeline').masonry({
        itemSelector : '.item'
    });

    var posts = $('#timeline').find('.post');
    $.each(posts, function(index, post) {
        var left = $(post).css('left');
        if (left == '0px') {
            html = '<span class="arrow arrow-right"></span>';
            html += '<span class="marker marker-right"></span>';
            $(post).prepend(html); 
        } else {
            html = '<span class="arrow arrow-left"></span>';
            html += '<span class="marker marker-left"></span>';
            $(post).prepend(html);
        }
    });

    $('#timeline .post').fancybox({
        maxWidth    : 800,
        maxHeight   : 600,
        fitToView   : false,
        width       : '60%',
        height      : '90%',
        autoSize    : false,
        closeClick  : false,
        openEffect  : 'none',
        closeEffect : 'none',
        type        : 'ajax',
        padding     : 10,
        afterLoad   : function(obj) {
            obj.content = $('<div>').attr('id', 'post').addClass('nano').append(
                $('<div>').addClass('content').html(
                    $(obj.content).find('#post').html()
                )
            );
        },
        afterShow   : function() {
            $('.nano').nanoScroller();
        }
    });

    $('#timeline .post a').click(function() {
        window.open($(this).attr('href'));
        return false;
    });

    //-----------------------------------------
    // Header

    $('body').scrollTop(75);

    var limit = $('.headline').offset().top;
    $(window).scroll(function() {
        var scroll = $('body').scrollTop();
        if (scroll > limit) {
            $('#header').addClass('header-fixed');
        } else {
            $('#header').removeClass('header-fixed');
        }

    });

    $('a').attr('target', '_blank');
});
