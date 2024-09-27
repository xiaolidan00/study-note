[storybook暗色风格](https://storybook.js.org/docs/configure/user-interface/theming)

[event action](https://storybook.js.org/docs/essentials/actions#api)
[输入类型](https://github.com/storybookjs/storybook/blob/91e9dee33faa8eff0b342a366845de7100415367/addons/controls/README.md#control-annotations)
[control输入类型](https://storybook.js.org/docs/6/essentials/controls#choosing-the-control-type)

| Data Type   | Control        | Description                                                  |
| :---------- | :------------- | :----------------------------------------------------------- |
| **boolean** | `boolean`      | Provides a toggle for switching between possible states. `argTypes: { active: { control: 'boolean' }}` |
| **number**  | `number`       | Provides a numeric input to include the range of all possible values. `argTypes: { even: { control: { type: 'number', min:1, max:30, step: 2 } }}` |
|             | `range`        | Provides a range slider component to include all possible values. `argTypes: { odd: { control: { type: 'range', min: 1, max: 30, step: 3 } }}` |
| **object**  | `object`       | Provides a JSON-based editor component to handle the object's values. Also allows edition in raw mode. `argTypes: { user: { control: 'object' }}` |
| **array**   | `object`       | Provides a JSON-based editor component to handle the values of the array. Also allows edition in raw mode. `argTypes: { odd: { control: 'object' }}` |
|             | `file`         | Provides a file input component that returns an array of URLs. Can be further customized to accept specific file types. `argTypes: { avatar: { control: { type: 'file', accept: '.png' } }}` |
| **enum**    | `radio`        | Provides a set of radio buttons based on the available options. `argTypes: { contact: { control: 'radio', options: ['email', 'phone', 'mail'] }}` |
|             | `inline-radio` | Provides a set of inlined radio buttons based on the available options. `argTypes: { contact: { control: 'inline-radio', options: ['email', 'phone', 'mail'] }}` |
|             | `check`        | Provides a set of checkbox components for selecting multiple options. `argTypes: { contact: { control: 'check', options: ['email', 'phone', 'mail'] }}` |
|             | `inline-check` | Provides a set of inlined checkbox components for selecting multiple options. `argTypes: { contact: { control: 'inline-check', options: ['email', 'phone', 'mail'] }}` |
|             | `select`       | Provides a drop-down list component to handle single value selection. `argTypes: { age: { control: 'select', options: [20, 30, 40, 50] }}` |
|             | `multi-select` | Provides a drop-down list that allows multiple selected values. `argTypes: { countries: { control: 'multi-select', options: ['USA', 'Canada', 'Mexico'] }}` |
| **string**  | `text`         | Provides a freeform text input. `argTypes: { label: { control: 'text' }}` |
|             | `color`        | Provides a color picker component to handle color values. Can be additionally configured to include a set of color presets. `argTypes: { color: { control: { type: 'color', presetColors: ['red', 'green']} }}` |
|             | `date`         | Provides a datepicker component to handle date selection. `argTypes: { startDate: { control: 'date' }}` |

```ts
export default {
  /* 👇 The title prop is optional.
   * See https://storybook.js.org/docs/6/configure#configure-story-loading
   * to learn how to generate automatic titles
   */
  title: 'Gizmo',
  component: Gizmo,
  argTypes: {
    canRotate: {
      control: 'boolean',
    },
    width: {
      control: { type: 'number', min: 400, max: 1200, step: 50 },
    },
    height: {
      control: { type: 'range', min: 200, max: 1500, step: 50 },
    },
    rawData: {
      control: 'object',
    },
    coordinates: {
      control: 'object',
    },
    texture: {
      control: {
        type: 'file',
        accept: '.png',
      },
    },
    position: {
      control: 'radio',
      options: ['left', 'right', 'center'],
    },
    rotationAxis: {
      control: {
        type: 'check',
        options: ['x', 'y', 'z'],
      },
    },
    scaling: {
      control: 'select',
      options: [10, 50, 75, 100, 200],
    },
    label: {
      control: 'text',
    },
    meshColors: {
      control: {
        type: 'color',
        presetColors: ['#ff0000', '#00ff00', '#0000ff'],
      },
    },
    revisionDate: {
      control: 'date',
    },
  },
};
```

