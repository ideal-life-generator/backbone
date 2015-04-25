define(function() {

  return function(masks) {
    this.masks = masks;
    var that = this;
    var lastString;
    return function(event) {
      var target = event.target,
          index,
          result = "",
          patter,
          sliced = "",
          string = target.value.replace(/[^0-9\.]+/g, ""),
          slicedString = target.value.slice(0, target.selectionStart).replace(/[^0-9\.]+/g, "");
      for (index = 0; index < that.masks.length; index++) {
        if (that.masks[index].code.indexOf(string.slice(0, that.masks[index].code.length)) !== -1) {
          patter = that.masks[index].mask.split("n");
        }
      }
      if (patter) {
        for (index = 0; index < slicedString.length && index < patter.length-1; index++) {
          sliced += patter[index] + string[index];
        }
        if (slicedString < string) {
          string = slicedString + string.slice(slicedString.length+1);
        }
        for (index = 0; index < string.length && index < patter.length-1; index++) {
          result += patter[index] + string[index];
        }
        if (lastString < result) {
          result += patter[index];
        }
        target.value = result;
        if (slicedString < string) {
          event.target.setSelectionRange(sliced.length, sliced.length);
        }
        lastString = result;
        return result;
      } else {
        target.value = string;
        lastString = string;
        return string;
      }
    }
  }

});