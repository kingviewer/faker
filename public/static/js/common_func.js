!function (t) {
    "use strict";
    t(window).on("load", function () {
        t('[data-loader="circle-side"]').fadeOut(), t("#preloader").delay(100).fadeOut("slow"), t(".slide-animated").addClass("is-transitioned"), t(window).scroll()
    }), new LazyLoad({elements_selector: ".lazy"}), t(window).on("scroll", function () {
        1 < t(this).scrollTop() ? t(".element_to_stick").addClass("sticky") : t(".element_to_stick").removeClass("sticky")
    }), t(window).scroll(), t(".background-image").each(function () {
        t(this).css("background-image", t(this).attr("data-background"))
    }), t(".opacity-mask").each(function () {
        t(this).css("background-color", t(this).attr("data-opacity-mask"))
    }), t("a.open_close").on("click", function () {
        t(".main-menu").toggleClass("show"), t(".layer").toggleClass("layer-is-visible")
    }), t("a.show-submenu").on("click", function () {
        t(this).next().toggleClass("show_normal")
    }), scrollCue.init({duration: 300, interval: -100, percentage: .85}), t(".jarallax").jarallax({
        videoLazyLoading: !1,
        videoPlayOnlyVisible: !1
    }), t(".featured_carousel").owlCarousel({
        center: !1,
        loop: !1,
        margin: 25,
        dots: !1,
        items: 1,
        nav: !1,
        lazyLoad: !0,
        navText: ["<i class='bi bi-chevron-left'></i>", "<i class='bi bi-chevron-right'></i>"],
        responsive: {
            0: {nav: !1, dots: !0, items: 1},
            560: {nav: !1, dots: !0, items: 2},
            768: {nav: !1, dots: !0, items: 2},
            1025: {nav: !0, dots: !1, items: 3}
        }
    }), t(function () {
    }), t(".main_categories a").hover(function () {
        t(this).find("i").toggleClass("rotate-x")
    }), t(".custom_select select").niceSelect(), t('a[href^="#"].btn_scroll').on("click", function (e) {
        e.preventDefault();
        var o = this.hash, e = t(o);
        t("html, body").stop().animate({scrollTop: e.offset().top}, 800, "swing", function () {
            window.location.hash = o
        })
    }), t(".wish_bt").on("click", function (e) {
        e.preventDefault(), t(this).toggleClass("liked")
    }), [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]')).map(function (e) {
        return new bootstrap.Tooltip(e)
    }), t("[data-countdown]").each(function () {
        var o = t(this), e = t(this).data("countdown");
        o.countdown(e, function (e) {
            o.html(e.strftime("%DD %H:%M:%S"))
        })
    }), t(".modal_popup").magnificPopup({
        type: "inline",
        fixedContentPos: !0,
        fixedBgPos: !0,
        overflowY: "auto",
        closeBtnInside: !0,
        preloader: !1,
        midClick: !0,
        removalDelay: 300,
        closeMarkup: '<button title="%title%" type="button" class="mfp-close"></button>',
        mainClass: "my-mfp-zoom-in"
    }), t(".content_more").hide(), t(".show_hide").on("click", function () {
        var e = t(".content_more").is(":visible") ? "Read More" : "Read Less";
        t(this).text(e), t(this).prev(".content_more").slideToggle(200)
    }), t("#password, #password_sign, #password1, #password2").hidePassword("focus", {toggle: {className: "my-toggle"}}), setTimeout(function () {
        t(".popup_wrapper").css({opacity: "1", visibility: "visible"}), t(".popup_close").on("click", function () {
            t(".popup_wrapper").fadeOut(300)
        })
    }, 1500), t(window).scroll(function () {
        800 <= t(window).scrollTop() ? t("#toTop").addClass("visible") : t("#toTop").removeClass("visible")
    }), t("#toTop").on("click", function () {
        return t("html, body").animate({scrollTop: 0}, 500), !1
    })
}(window.jQuery);