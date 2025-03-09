function pop(src, nom, w, h) {
  open(
    src,
    nom,
    "directories=no,location=no,menubar=no,status=no,titlebar=no,toolbar=no,left=0,top=0,width=" +
      w +
      ",height=" +
      h,
  );
}

function setCookie(c_name, value, expiredays) {
  var exdate = new Date();
  exdate.setDate(exdate.getDate() + expiredays);
  document.cookie =
    c_name +
    "=" +
    encodeURIComponent(value) +
    (expiredays == null ? "" : ";expires=" + exdate.toGMTString()) +
    ';path="/"';
}

function Get_Cookie(check_name) {
  // first we'll split this cookie up into name/value pairs
  // note: document.cookie only returns name=value, not the other components
  var a_all_cookies = document.cookie.split(";");
  var a_temp_cookie = "";
  var cookie_name = "";
  var cookie_value = "";
  var b_cookie_found = false; // set boolean t/f default f

  for (i = 0; i < a_all_cookies.length; i++) {
    // now we'll split apart each name=value pair
    a_temp_cookie = a_all_cookies[i].split("=");

    // and trim left/right whitespace while we're at it
    cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, "");

    // if the extracted name matches passed check_name
    if (cookie_name == check_name) {
      b_cookie_found = true;
      // we need to handle case where cookie has no value but exists (no = sign, that is):
      if (a_temp_cookie.length > 1) {
        cookie_value = encodeURIComponent(
          a_temp_cookie[1].replace(/^\s+|\s+$/g, ""),
        );
      }
      // note that in cases where cookie is initialized but no value, null is returned
      return cookie_value;
    }

    a_temp_cookie = null;
    cookie_name = "";
  }
  if (!b_cookie_found) {
    return null;
  }
}

(function ($) {
  $(document).ready(function () {
    function pi_slideUp() {
      $("pre").slideUp();
      $("input.hsa").attr({ value: "Show All Codes" });
      $("input.hst").attr({ value: "Show Code" });
    }

    // $("pre").slideUp();
    $("input.hsa").click(function () {
      if ($("pre:first").is(":hidden")) {
        $("pre").show("slow");
        $("input.hsa").attr({ value: "Hide All Codes" });
        $("input.hst").attr({ value: "Hide Code" });
        setCookie("pi_extended", "1", 365);
      } else {
        pi_slideUp();
        setCookie("pi_extended", "0", 365);
      }
    });
    $("input.hst").click(function () {
      var tid = $(this).attr("name");
      if ($("pre#pre" + tid).is(":hidden")) {
        $("pre#pre" + tid).show("slow");
        $("input#" + tid).attr({ value: "Hide Code" });
      } else {
        $("pre#" + tid).slideUp();
        $("input#" + tid).attr({ value: "Show Code" });
      }
    });

    if (Get_Cookie("pi_extended") == "0") {
      pi_slideUp();
    }
  });
})(jQuery);
