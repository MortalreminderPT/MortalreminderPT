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

function isNight() {
    const theme = sessionStorage.getItem("theme");
    var night = false;
    if (theme === 'night') {
        night = true;
    } else if (theme === 'day') {
        night = false;
    } else if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        night = true;
    } else {
        var now = new Date();
        var hour = now.getHours();
        night = hour < 6 || hour >= 18;
    }
    console.log("night = " + night);
    return night;
};

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

var ThemeSwitch = {
    init: function() {
        var switchButton = document.getElementById('js-theme-switch');
        switchButton.addEventListener('click', this.switchTheme);
        var switchPopButton = document.getElementById('js-theme-switch-pop');
        switchPopButton.addEventListener('click', this.switchTheme);
    },

    switchTheme: function() {
        if (isNight()) {
            sessionStorage.setItem("theme", "day");
        } else {
            sessionStorage.setItem("theme", "night");
        }
        location.reload();
    }
};