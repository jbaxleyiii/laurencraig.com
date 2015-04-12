###

  @function isMobile()

  @return {Boolean} true if Mobile

  ###
junction.isMobile = =>
  /(Android|iPhone|iPad|iPod|IEMobile)/g.test( navigator.userAgent )
