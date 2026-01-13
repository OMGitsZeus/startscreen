$(function () {
  const resourceName = GetParentResourceName ? GetParentResourceName() : "startscreen";

  $("#containerJoin").show();

  window.addEventListener("message", function (event) {
    const item = event.data;
    const music = document.getElementById("cinematicMusic");

    if (item.containerJoins) {
      $("#containerJoin").fadeIn(0);
    }

    if (item.joinClick) {
      $("#containerJoin").fadeOut(500);
    }

    if (item.playMusic && music) {
      music.pause();
      music.currentTime = 0;
      music.src = `audio/${item.playMusic}.ogg`;
      music.volume = item.volume ?? 0.07;
      music.play().catch(() => {});
    }

    if (item.stopMusic && music) {
      music.pause();
      music.currentTime = 0;
    }
  });

  $(".clickJoinButton").on("click", function (e) {
    e.preventDefault();
    $.post(`https://${resourceName}/joinServer`, JSON.stringify({}));
  });
});
