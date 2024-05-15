document.addEventListener("DOMContentLoaded", function() {
  var currentDate = new Date();
  var currentDay = currentDate.getDay();
  switch (currentDay) {
    case 0: // 星期日
      colorDegree = 0;
      break;
    case 1: // 星期一
      colorDegree = 60;
      break;
    case 2: // 星期二
      colorDegree = 120;
      break;
    case 3: // 星期三
      colorDegree = 180;
      break;
    case 4: // 星期四
      colorDegree = 240;
      break;
    case 5: // 星期五
      colorDegree = 300;
      break;
    case 6: // 星期六
      colorDegree = 360;
      break;
    default:
      colorDegree = 0;
      break;
  }
  const colorThief = new ColorThief();
  const img = new Image();
  img.src = 'https://bing.biturl.top/?resolution=1920&format=image&index=0&mkt=en-US';
  img.crossOrigin = 'Anonymous';
  img.addEventListener('load', function() {
    rgb = colorThief.getColor(img);
    document.documentElement.style.setProperty('--primary-color', (rgbToHsl(rgb[0], rgb[1], rgb[2]))+'deg');
  });
});

function rgbToHsl(r, g, b) {
  r /= 255, g /= 255, b /= 255;
  let max = Math.max(r, g, b), min = Math.min(r, g, b);
  let h = (max + min) / 2;
  if (max === min) {
    h = 0; // achromatic
  } else {
    let d = max - min;
    switch (max) {
      case r: h = (g - b) / d + (g < b ? 6 : 0); break;
      case g: h = (b - r) / d + 2; break;
      case b: h = (r - g) / d + 4; break;
    }
  }
  return 60*h;
}
