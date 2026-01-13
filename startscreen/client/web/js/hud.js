$(function () {
  const resourceName = GetParentResourceName ? GetParentResourceName() : "startscreen";

  window.addEventListener("message", function (event) {
    const item = event.data;

    if (item.containerJoins) {
      $("#containerJoin").fadeIn(0);
    }

    if (item.joinClick) {
      $("#containerJoin").fadeOut(500);
    }
  });

  $(".clickJoinButton").on("click", function (e) {
    e.preventDefault();
    $.post(`https://${resourceName}/joinServer`, JSON.stringify({}));
  });
});
