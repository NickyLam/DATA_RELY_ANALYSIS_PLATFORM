/**
 * DEV ONLY - Do not include in production builds
 * 指标血缘点击诊断脚本
 * 在 Console 中执行此脚本，定位点击事件拦截问题
 */
(function() {
    console.log('=== 指标血缘点击诊断 ===');

    // 1. 检查容器和结果项是否存在
    const container = document.getElementById('indicatorSearchResults');
    console.log('容器存在:', !!container);
    if (!container) return;

    const items = container.querySelectorAll('.indicator-result-item');
    console.log('结果项数量:', items.length);

    if (items.length === 0) {
        console.log('❌ 没有结果项可诊断，请先搜索');
        return;
    }

    // 2. 检查第一个结果项的 computed style
    const firstItem = items[0];
    const style = window.getComputedStyle(firstItem);
    console.log('--- 第一个结果项样式 ---');
    console.log('display:', style.display);
    console.log('visibility:', style.visibility);
    console.log('opacity:', style.opacity);
    console.log('pointer-events:', style.pointerEvents);
    console.log('z-index:', style.zIndex);
    console.log('position:', style.position);
    console.log('width:', style.width, 'height:', style.height);

    // 3. 检查元素位置和大小
    const rect = firstItem.getBoundingClientRect();
    console.log('--- 元素几何信息 ---');
    console.log('top:', rect.top, 'left:', rect.left);
    console.log('width:', rect.width, 'height:', rect.height);
    console.log('是否可见:', rect.width > 0 && rect.height > 0);

    // 4. 检查是否有元素覆盖在上面（从中心点向上查找）
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;
    const elementsAtPoint = document.elementsFromPoint(centerX, centerY);
    console.log('--- 中心点堆叠元素（前5个） ---');
    elementsAtPoint.slice(0, 5).forEach((el, i) => {
        const classes = el.className ? '.' + el.className.split(' ').join('.') : '';
        const id = el.id ? '#' + el.id : '';
        console.log(`  ${i}: <${el.tagName.toLowerCase()}${id}${classes}>`);
    });

    // 5. 全局点击监听（捕获阶段），看点击时事件目标是什么
    console.log('--- 已安装全局点击捕获监听器 ---');
    console.log('请现在点击一个结果项，然后看下面的输出...');

    document.addEventListener('click', function(e) {
        const target = e.target;
        const closest = target.closest('.indicator-result-item');
        const classes = target.className ? '.' + target.className.split(' ').join('.') : '';
        const id = target.id ? '#' + target.id : '';

        console.log('--- 点击事件捕获 ---');
        console.log('目标元素:', `<${target.tagName.toLowerCase()}${id}${classes}>`);
        console.log('目标 textContent:', target.textContent?.substring(0, 30));
        console.log('是否在结果项内:', !!closest);
        console.log('事件坐标:', e.clientX, e.clientY);

        if (closest) {
            console.log('关联的结果项 indexNo:', closest.dataset.indexNo);
            console.log('结果项 pointer-events:', window.getComputedStyle(closest).pointerEvents);
        }
    }, true);  // true = capture phase

    // 6. 手动触发测试
    console.log('--- 手动触发第一个结果项点击 ---');
    const clickEvent = new MouseEvent('click', {
        bubbles: true,
        cancelable: true,
        view: window
    });
    firstItem.dispatchEvent(clickEvent);
    console.log('手动 click 事件已 dispatch');

})();
