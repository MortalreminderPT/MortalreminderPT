const dayStyles = {
    "--secondary-color": "0deg",
    "--dark-saturation": "25%",
    "--darkest-saturation": "0%",
    "--dark-lightness": "85%",
    "--darkest-lightness": "92%",
    "--gray-lightness": "24%",
    "--light-gray-lightness": "7%",
    "--white-lightness": "5%",
    "--background-saturation": "20%",
    "--background-lightness": "93%",
    "--middle-grey-lightness": "100%"
}

const nightStyles = {
    "--secondary-color": "0deg",
    "--dark-saturation": "25%",
    "--darkest-saturation": "0%",
    "--dark-lightness": "10%",
    "--darkest-lightness": "8%",
    "--gray-lightness": "76%",
    "--light-gray-lightness": "93%",
    "--white-lightness": "100%",
    "--background-saturation": "20%",
    "--background-lightness": "7%",
    "--middle-grey-lightness": "100%"
}

document.addEventListener("DOMContentLoaded", function() {
    // 检测浏览器是否支持prefers-color-scheme媒体特性
    if (isNight()) {
        // night
        Object.entries(nightStyles).forEach(([key, value]) => {
            document.documentElement.style.setProperty(key, value);
        });  
    } else {
        // day
        Object.entries(dayStyles).forEach(([key, value]) => {
            document.documentElement.style.setProperty(key, value);
        });  
    }
});

function isNight() {
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        return true;
    } else {    
        var now = new Date();
        var hour = now.getHours();
        return hour < 6 || hour >= 18;
    }
}