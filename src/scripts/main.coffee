Main = (->

  init = () ->
    $('#slider').slick
      speed: 200,
      autoplay: true,
      autoplaySpeed: 6000

  return {
    init: init
  }
)()
