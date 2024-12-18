var LangSwitch = {
    init: function() {
        var switchButtons = document.getElementsByClassName('js-lang-switch');
        for (let i = 0; i < switchButtons.length; i++) {
            switchButtons[i].addEventListener('click', this.switchLang);
        }
    },

    switchLang: function() {
        var currentUrl = window.location;
        console.log(currentUrl)
        var pathname = currentUrl.pathname;
        var segments = pathname.split('/');

        // segments[0] 是空字符串，因为 pathname 以 '/' 开头
        if (segments[1] === 'zh-cn') {
            // 如果一级路径是 'zh-cn'，则移除它
            segments.splice(1, 1);
        } else {
            // 否则，在一级路径添加 'zh-cn'
            segments.splice(1, 0, 'zh-cn');
        }

        // 重新组装路径
        var newPath = segments.join('/') || '/';
        // 保持查询参数和哈希不变
        var newUrl = currentUrl.origin + newPath + currentUrl.search + currentUrl.hash;

        // 跳转到新的 URL
        window.location.href = newUrl;
    }
};