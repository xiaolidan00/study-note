//https://github.com/umeshkathiriya/Web-Component-InputElement/blob/main/custom-input.js
export default class CustomInput extends HTMLElement {
  static formAssociated = true;
  static get observedAttributes() {
    return [
      'type',
      'value',
      'placeholder',
      'autocomplete',
      'required',
      'min',
      'max',
      'minlength',
      'maxlength',
      'pattern',
      'disabled'
    ];
  }
  constructor() {
    super();
    this.attachShadow({mode: 'open', delegatesFocus: true});
    this.shadowRoot.innerHTML = `
        <style>
                :host{
                    box-sizing: border-box; 
                    display: inline-block;
                    border: 1px solid rgb(118,118,118);
                    cursor: text;
                    width:139px;
                    height:21px;
                    vertical-align:middle;
                    border-radius: 2px;
                    text-indent: 2px;
                    vertical-align: middle;
                    font-size: 13.3px;
                }
                :host(:focus){

                }
                :host([disabled]){
                    background-color:#f8f8f8;
                    border-color:#d1d1d1;
                }
                :host > .edit{
                    height:20px;
                }

                :host >.edit:empty::before{
                    display:block;
                    content: attr(placeholder);
                    text-wrap: nowrap;
                    overflow: hidden;
                    color:rgb(117,117,117);
                }
            </style>
            <div 
                class="edit" 
                contenteditable

            ></div>
        `;

    this.internals = this.attachInternals();
    this.focusMessage = this.shadowRoot.querySelector('div');

    this.input = document.createElement('input');

    this.editor = this.shadowRoot.querySelector('.edit');

    this.editor.addEventListener('input', (e) => {
      const value = e.target.textContent;
      this.input.value = value;
      this.internals.setFormValue(this.value);
      this.setValidity();
    });
  }
  connectedCallback() {
    this.setValidity();
  }
  get value() {
    return this.input.value;
  }
  set value(val) {
    this.input.value = val;
    this.internals.setFormValue(val);
    this.editor.textContent = this.value;
    this.setValidity();
  }
  attributeChangedCallback(name, oldValue, newValue) {
    console.log(name, oldValue, newValue);
    this.input[name] = name == 'required' ? true : newValue;
    if (name == 'value') {
      this.value = newValue;
    }
    if (['disabled', 'readonly'].includes(name)) {
      this.editor.setAttribute('contenteditable', newValue ? false : true);
    }
    if (name == 'placeholder') {
      this.editor.setAttribute(name, newValue);
    }
  }
  get validationMessage() {
    return this.internals.validationMessage;
  }
  get validity() {
    return this.internals.validity;
  }
  get willValidate() {
    return this.internals.willValidate;
  }

  checkValidity() {
    return this.internals.checkValidity();
  }

  reportValidity() {
    return this.internals.reportValidity();
  }

  setValidity() {
    return this.internals.setValidity(
      this.input.validity,
      this.input.validationMessage,
      this.focusMessage
    );
  }

  setCustomValidity(message) {
    this.input.setCustomValidity(message);
    return this.setValidity();
  }
}
