class SwCompBase {
    constructor(name) {
        this._compName = name;
    }
    getDom(el) {
        return typeof el === 'string' ? document.querySelector(el) : el;
    }
    injectStyle(style) {
        if (!style) return;
        const styleId = `sw_${this._compName}_style`;
        const s = document.getElementById(styleId);
        if (!s) {
            const d = document.createElement('style');
            d.id = styleId;
            document.head.appendChild(d);
            d.innerHTML = style;
        }
    }
}
class SwRender extends SwCompBase {
    /**
     *  @param {HTMLELement|string}  el 传入组件实例或querySelector选择器
     **/
    constructor(el, isSSR) {
        super('SwRender');
        this._root = typeof el === 'string' ? document.querySelector(el) : el;
        if (!isSSR) {
            const observer = new MutationObserver(this.callback.bind(this));
            observer.observe(this._root, {attributes: true, childList: true, subtree: true});
            window.addEventListener('unload', () => {
                observer.disconnect();
            });
        }
    }

    callback(mutationsList, observer) {
        console.log(mutationsList, observer);
    }
}
const render = new SwRender('#root');

class SwButton extends SwCompBase {
    /**
@param {HTMLELement|string}  el 传入组件实例或querySelector选择器
 @param {boolean} isWrap el内包裹组件，还是当前组件，默认当前组件
 **/

    constructor(el, isWrap) {
        super('SwButton');
        const elmt = this.getDom(el);

        if (isWrap) {
            const child = document.createElement('button');
            elmt.appendChild(child);
            this._dom = child;
        } else {
            this._dom = elmt;
        }

        this._dom.classList.add('sw-button');
        this.injectStyle(
            `.sw-button{background:red;border:none;color:white;border-radius:4px;height:40px;padding:0 20px;}.sw-button:hover{filter:saturate(0.5);}`
        );
    }
}
const btns = document.getElementById('btns');
for (let i = 0; i < 10; i++) {
    new SwButton('#my-btn', true);
}
