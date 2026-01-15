(function () {
  var state = getStateLabel();
  var doc = getCurrentDocument();

  var type = doc.getItemValueAsString('type');
  var sp = [];
  if (state == '派单' || state == '接单' || state == '签发' || state == '收票' || state == '') {
    sp.push("const table = document.getElementById('daochangForm');table.style.display = 'none';");
  }

  if (
    state == '派单' ||
    state == '接单' ||
    state == '到场' ||
    state == '签发' ||
    state == '收票' ||
    state == ''
  ) {
    sp.push("const table = document.getElementById('anquanForm');table.style.display = 'none';");
  }
  if (type != '2') {
    sp.push("const table = document.getElementById('weixiuForm');table.style.display = 'none';");
  } else if (state != '处理' && state != '销单') {
    sp.push("const table = document.getElementById('weixiuForm');table.style.display = 'none';");
  }
  if (type != '1') {
    sp.push("const table = document.getElementById('xunjianForm');table.style.display = 'none';");
  } else if (state != '处理' && state != '销单') {
    sp.push("const table = document.getElementById('xunjianForm');table.style.display = 'none';");
  }
  if (type != '3') {
    sp.push("const table = document.getElementById('baoyangForm');table.style.display = 'none';");
  } else if (state != '处理' && state != '销单' && state != '验收') {
    sp.push("const table = document.getElementById('baoyangForm');table.style.display = 'none';");
  }
  var html =
    "<o-action action-type='script' exparams=''>" +
    sp.map((a) => '<script>' + a + '</script>').join('') +
    '</o-action>';
  return html;
})()(function () {
  var state = getStateLabel();
  var doc = getCurrentDocument();

  var type = doc.getItemValueAsString('type');
  var sp = [];
  if (state == '派单' || state == '接单' || state == '签发' || state == '收票' || state == '') {
    sp.push("const table = document.getElementById('daochangForm');table.style.display = 'none';");
  }

  if (
    state == '派单' ||
    state == '接单' ||
    state == '到场' ||
    state == '签发' ||
    state == '收票' ||
    state == ''
  ) {
    sp.push("const table = document.getElementById('anquanForm');table.style.display = 'none';");
  }
  if (type != '2') {
    sp.push("const table = document.getElementById('weixiuForm');table.style.display = 'none';");
  } else if (state != '处理' && state != '销单') {
    sp.push("const table = document.getElementById('weixiuForm');table.style.display = 'none';");
  }
  if (type != '1') {
    sp.push("const table = document.getElementById('xunjianForm');table.style.display = 'none';");
  } else if (state != '处理' && state != '销单') {
    sp.push("const table = document.getElementById('xunjianForm');table.style.display = 'none';");
  }
  if (type != '3') {
    sp.push("const table = document.getElementById('baoyangForm');table.style.display = 'none';");
  } else if (state != '处理' && state != '销单' && state != '验收') {
    sp.push("const table = document.getElementById('baoyangForm');table.style.display = 'none';");
  }
  var html = sp
    .map((a) => "<o-action action-type='script' exparams=''><script>" + a + '</script></o-action>')
    .join('');
  return html;
})()(function () {
  var state = getStateLabel();
  if (state == '派单' || state == '接单' || state == '签发' || state == '收票' || state == '') {
    return true;
  }
  return false;
})();
(function () {
  var state = getStateLabel();
  if (
    state == '派单' ||
    state == '接单' ||
    state == '到场' ||
    state == '签发' ||
    state == '收票' ||
    state == ''
  ) {
    return true;
  }
  return false;
})();

(function () {
  var doc = getCurrentDocument();

  var type = doc.getItemValueAsString('type');
  //非维修工单隐藏
  if (type != '2') return true;
  var state = getStateLabel();
  if (state != '处理' && state != '销单') {
    return true;
  }
  return false;
})();

(function () {
  var doc = getCurrentDocument();

  var type = doc.getItemValueAsString('type');
  //非巡检工单隐藏
  if (type != '1') return true;
  var state = getStateLabel();
  if (state != '处理' && state != '销单') {
    return true;
  }
  return false;
})();

(function () {
  var doc = getCurrentDocument();
  var type = doc.getItemValueAsString('type');
  //非保养工单隐藏
  if (type != '3') return true;
  var state = getStateLabel();
  if (state != '处理' && state != '销单' && state != '验收') {
    return true;
  }
  return false;
})();
