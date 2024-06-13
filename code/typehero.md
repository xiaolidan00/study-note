<https://typehero.dev/>

# Beginner

## Generic Function Arguments

```ts
import { Expect, Equal } from 'type-testing';

/** temporary */
const expect = <T>(a: T) => ({
  toEqual: (b: T) => a === b
});

const identity_string = identity("this is a string");
expect(identity_string).toEqual("this is a string");
type test_identity_string = Expect<Equal<
  typeof identity_string,
  "this is a string"
>>;

const identity_number = identity(123.45);
expect(identity_number).toEqual(123.45);
type test_identity_number = Expect<Equal<
  typeof identity_number,
  123.45
>>;

const identity_boolean = identity(false);
expect(identity_boolean).toEqual(false);
type test_identity_boolean = Expect<Equal<
  typeof identity_boolean,
  false
>>;

const strings = ['1', '1', '2', '3', '5'];
const numbers = [1, 1, 2, 3, 5];

const stringsToNumbers = mapArray(strings, str => parseInt(str));
expect(stringsToNumbers).toEqual(numbers);
type test_stringsToNumber = Expect<Equal<
  typeof stringsToNumbers,
  number[]
>>;

const numbersToStrings = mapArray(numbers, num => `${num}`);
expect(numbersToStrings).toEqual(strings)
type test_numbersToStrings = Expect<Equal<
  typeof numbersToStrings,
  string[]
>>;

const numbersToNumbers = mapArray(numbers, num => num + 1);
expect(numbersToNumbers).toEqual([2, 2, 3, 4, 6])
type test_numbersToNumbers = Expect<Equal<
  typeof numbersToNumbers,
  number[]
>>;

const stringsToStrings = mapArray(strings, str => `${str}!`);
expect(stringsToStrings).toEqual(['1!', '1!', '2!', '3!', '5!'])
type test_stringsToStrings = Expect<Equal<
  typeof stringsToStrings,
  string[]
>>;

```

```ts
const identity = <T>(a:T)=>a;

const mapArray = <T,K>(arr:T[], fn:(a:T)=>K ) => arr.map(fn);
```

## Generic Type Arguments

```ts
import { Expect, Equal } from 'type-testing';

type test_CapreseSaladName = Expect<Equal<
  CapreseSalad['name'],
  'Caprese Salad'
>>;

type test_CapreseSaladPrice = Expect<Equal<
  CapreseSalad['price'],
  14.99
>>;

type test_CapreseSaladInStock = Expect<Equal<
  CapreseSalad['inStock'],
  true
>>;

type test_KrogerDetroit = Expect<Equal<
  GroceryStore<'Kroger', 'Detroit'>,
  { name: 'Kroger', city: 'Detroit' }
>>;

type test_StopNShopMassachusetts = Expect<Equal<
  GroceryStore<'Stop \'N Shop', 'Massachusetts'>,
  { name: 'Stop \'N Shop', city: 'Massachusetts' }
>>;

```

```ts
type GroceryStore<Name, String> = {
 name: Name;
 city: String;
};

type GroceryItem<Name, Price, InStock> = {
 name: Name;
 price: Price;
 inStock: InStock;
};

type CapreseSalad = GroceryItem<"Caprese Salad", 14.99, true>;
```

## Generic Type Constraints

```ts
import { Expect, Equal } from 'type-testing';

type test_AllowStringString = Expect<Equal<
  AllowString<string>,
  string
>>;

// @ts-expect-error invalid input
type error_AllowStringNumber = AllowString<number>;

// @ts-expect-error invalid input
type error_AllowStringBoolean = AllowString<boolean>;

// @ts-expect-error invalid input
type error_AllowNumberString = AllowNumber<string>;

type test_AllowNumberNumber = Expect<Equal<
  AllowNumber<number>,
  number
>>;

// @ts-expect-error invalid input
type error_AllowNumberBoolean = AllowNumber<boolean>;

type test_CreateLogger = Expect<Equal<
  CreateLogger<(a: number) => void>,
  {
    log: (a: number) => void;
    exit: () => void;
  }
>>;

// @ts-expect-error invalid input
type error_CreateLoggerString = CreateLogger<string>;

type error_CreateLoggerStringArg =
  // @ts-expect-error invalid input
  CreateLogger<(a: string) => void>;

type error_CreateLoggerTwoArgs =
  // @ts-expect-error invalid input
  CreateLogger<(a: number, b: number) => void>;

```

```ts
type AllowString<T extends string> = T;
type AllowNumber<T extends number> = T;

type CreateLogger<T extends (a: number) => void> = {
 log: T;
 exit: () => void;
};
```

## Index Signatures

```ts
const groceryList: GroceryList = {
  carrots: 5,
  potatoes: 12,
  sweetPotatoes: 2,
  turnips: 1,
  parsnips: 1,
  beets: 10,
  radishes: 2,
  rutabagas: 1,
  onions: 3,
  garlic: 2,

  // @ts-expect-error intentionally invalid because the value is a string, not a number
  shouldError: "because it's a string",

  // @ts-expect-error intentionally invalid because the value is a boolean, not a number
  shouldAlsoError: true,
};

const inappropriateActionBySituation: InappropriateActionBySituation = {
  funeral: [
    'excessive laughter',
    'bringing up personal achievements',
    'insisting everyone joins you in loudly singing the 1991 Queen track "The Show Must Go On"',
  ],
  medicalDiagnosis: [
    'jokes about American healthcare',
    'arguing that WebMD says otherwise',
    'doomscrolling twitter instead of listening',
  ],
  leetcodeInterview: [
    'praise of CSS',
    'citing XKCD comics by number from memory',
    'use of emojis in whiteboard exercises followed by pontificating about your deep knowledge of UTF-16',
  ],
  friendExperiencingHeartbreak: [
    'victory dance because you hated their S.O.',
    'offers to turn on the 1999 cinematic masterpiece, The Mummy, with Brendan Fraser and Rachel Weisz',
  ],

  // @ts-expect-error intentionally invalid because the value is a string, not a string array
  romanticDate: 'checking your phone incessantly for a new Primeagen video to drop', // cspell:disable-line
};

const charactersById: CharactersById = {
  1: {
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
  },
  2: {
    id: 2,
    name: 'Morty Smith',
    status: 'Alive',
    species: 'Human',
  },
  3: {
    id: 3,
    name: 'Summer Smith',
    status: 'Alive',
    species: 'Human',
  },
  4: {
    id: 4,
    name: 'Beth Smith',
    status: 'Alive',
    species: 'Human',
  },
  5: {
    id: 5,
    name: 'Jerry Smith',
    status: 'Alive',
    species: 'Human',
  },

  // @ts-expect-error string keys are not allowed
  unity: {
    id: 6,
    status: 'Alive',
    species: 'Hive Mind',
  },
};

```

```ts
type GroceryList = Record<string,number>;

type InappropriateActionBySituation =  Record<string,string[]>;

type CharactersById = {
 [n: number]: {
  id: number;
  name: string;
  status: "Alive";
  species:  "Human";
 };
};
```

## Indexed Types

```ts
import { Expect, Equal } from 'type-testing';

type Cars = ["Bugatti", "Ferarri", "Lambo", "Porsche", "Toyota Corolla"]

type Donations = {
  "Bono": 15_000_000,
  "J.K. Rowling": 160_000_000,
  "Taylor Swift": 45_000_000,
  "Elton John": 600_000_000,
  "Angelina Jolie and Brad Pitt": 100_000_000,
};

type test_TheCoolestCarEverMade = Expect<Equal<
  TheCoolestCarEverMade,
  "Toyota Corolla"
>>;

type test_TruckDriverBonusGiver = Expect<Equal<
  TruckDriverBonusGiver,
  45_000_000
>>;
```

```ts
type TheCoolestCarEverMade =Cars[4];
type TruckDriverBonusGiver = Donations["Taylor Swift"];
```

## The `keyof` operator

```ts
const casettesByArtist = {
  'Alanis Morissette': 2,
  'Mariah Carey': 8,
  'Nirvana': 3,
  'Oasis': 2,
  'Radiohead': 3,
  'No Doubt': 3,
  'Backstreet Boys': 3,
  'Spice Girls': 2,
  'Green Day': 2,
  'Pearl Jam': 5,
  'Metallica': 5,
  'Guns N\' Roses': 2,
  'U2': 3,
  'Aerosmith': 4,
  'R.E.M.': 4,
  'Blur': 3,
  'The Smashing Pumpkins': 5,
  'Britney Spears': 3,
  'Whitney Houston': 3,
};

const getCasetteCount = (artist: Artist) => {
  return casettesByArtist[artist];
}

// should work just fine for a valid artist
getCasetteCount('Mariah Carey');

// should error for artists that are not part of the original
// @ts-expect-error
getCasetteCount('Red Hot Chili Peppers')

```

```ts
type Artist = keyof typeof casettesByArtist;
```

## Literal Types

```ts
import { Expect, Equal } from 'type-testing';

type test_LiteralString = Expect<Equal<
  LiteralString,
  'chocolate chips'
>>;

type test_LiteralTrue = Expect<Equal<
  LiteralTrue,
  true
>>;

type test_LiteralNumber = Expect<Equal<
  LiteralNumbers,
  1 | 2 | 3 | 4 | 5 | 6
>>;

type test_LiteralObject = Expect<Equal<
  LiteralObject,
  {
    name: 'chocolate chips',
    inStock: true,
    kilograms: 5,
  }
>>;

type test_LiteralFunction = Expect<Equal<
  LiteralFunction,
  (a: number, b: number) => number
>>;

type test_literalString = Expect<Equal<
  typeof literalString,
  'Ziltoid the Omniscient'
>>;

type test_literalTrue = Expect<Equal<
  typeof literalTrue,
  true
>>;

type test_literalNumber = Expect<Equal<
  typeof literalNumber,
  1 | 2
>>;

type test_almostPi = Expect<Equal<
  typeof almostPi,
  3.14159
>>;

type test_literalObject = Expect<Equal<
  typeof literalObject,
  {
    origin: string,
    command: string,
    item: string,
    time: string
  }
>>;

type test_literalFunction = Expect<Equal<
  typeof literalFunction,
  (a: number, b: string) => string | number
>>;

```

```ts
type LiteralString = 'chocolate chips';
type LiteralTrue = true;
type LiteralNumbers =  1 | 2 | 3 | 4 | 5 | 6;
type LiteralObject = {
    name: 'chocolate chips',
    inStock: true,
    kilograms: 5,
  };
type LiteralFunction = (a: number, b: number) => number;

const literalString = 'Ziltoid the Omniscient';
const literalTrue = true;
const literalNumber = Math.random() > 0.5 ? 1 : 2;
const literalObject = {
    origin: 'string',
    command: 'string',
    item: 'string',
    time: 'string'
  };
const literalFunction = (a: number, b: string) => a|| b
const almostPi=  3.14159
```

## Mapped Object Types

```ts
import { Expect, Equal } from 'type-testing';

type MoviesByGenre = {
  action: 'Die Hard';
  comedy: 'Groundhog Day';
  sciFi: 'Blade Runner';
  fantasy: 'The Lord of the Rings: The Fellowship of the Ring';
  drama: 'The Shawshank Redemption';
  horror: 'The Shining';
  romance: 'Titanic';
  animation: 'Toy Story';
  thriller: 'The Silence of the Lambs';
};

const test_MoviesInfoByGenre: MovieInfoByGenre<MoviesByGenre> = {
  action: {
    name: 'Die Hard',
    year: 1988,
    director: 'John McTiernan',
  },
  comedy: {
    name: 'Groundhog Day',
    year: 1993,
    director: 'Harold Ramis',
  },
  sciFi: {
    name: 'Blade Runner',
    year: 1982,
    director: 'Ridley Scott',
  },
  fantasy: {
    name: 'The Lord of the Rings: The Fellowship of the Ring',
    year: 2001,
    director: 'Peter Jackson',
  },
  drama: {
    name: 'The Shawshank Redemption',
    year: 1994,
    director: 'Frank Darabont',
  },
  horror: {
    name: 'The Shining',
    year: 1980,
    director: 'Stanley Kubrick',
  },
  romance: {
    name: 'Titanic',
    year: 1997,
    director: 'James Cameron',
  },
  animation: {
    name: 'Toy Story',
    year: 1995,
    director: 'John Lasseter',
  },
  thriller: {
    name: 'The Silence of the Lambs',
    year: 1991,
    director: 'Jonathan Demme',
  },
};

type test_MovieInfoByGenre = Expect<Equal<
  MovieInfoByGenre<MoviesByGenre>,
  {
    action: {
        name: string;
        year: number;
        director: string;
    };
    comedy: {
        name: string;
        year: number;
        director: string;
    };
    sciFi: {
        name: string;
        year: number;
        director: string;
    };
    fantasy: {
        name: string;
        year: number;
        director: string;
    };
    drama: {
        name: string;
        year: number;
        director: string;
    };
    horror: {
        name: string;
        year: number;
        director: string;
    };
    romance: {
        name: string;
        year: number;
        director: string;
    };
    animation: {
        name: string;
        year: number;
        director: string;
    };
    thriller: {
        name: string;
        year: number;
        director: string;
    };
  }
>>;

```

```ts
type MovieInfoByGenre<T extends MoviesByGenre> = {
 [n in keyof  T]:{
        name: string;
        year: number;
        director: string;
    }
};
```

## Primitive Data Types

```ts
import { Expect, Equal, Extends } from 'type-testing';

/*/////

Don't worry if you don't quite understand how these types work.

Just do your best to add type annotations wherever you can.

And if nothing else, there's no shame in looking at the solutions at this point. You're just getting warmed up!

/////*/

// this is correct! :)
playSong('Demiurge', 2012);

// @ts-expect-error this is incorrect because the first argument should not be a number
playSong(8675309, 1982);

// @ts-expect-error this is incorrect because the second argument should not be a string
playSong('Blood and Thunder', '2006');

type test_playSong_Parameters = Expect<Equal<
  Parameters<typeof playSong>,
  [string, number]
>>;

type test_playSong_ReturnType = Expect<Equal<
  ReturnType<typeof playSong>,
  string
>>;

type test_age = Expect<Extends<number, typeof age>>;
type test_artistName = Expect<Extends<string, typeof artistName>>;

type test_Musician_artistName = Expect<Equal<
  Musician['artistName'],
  string
>>;

type test_Musician_age = Expect<Equal<
  Musician['age'],
  number
>>;

type test_Musician_deceased = Expect<Equal<
  Musician['deceased'],
  boolean
>>;

type test_musicianInfo_Parameters = Expect<Equal<
  Parameters<typeof musicianInfo>[0],
  Musician
>>;

type test_musicianInfo_ReturnType = Expect<Equal<
  ReturnType<typeof musicianInfo>,
  string
>>;
```

```ts
const playSong = (artistName:string, year:number) => {
  return `${artistName} was released in the year ${year}`;
};

const artistName:string = 'Frank Zappa';

const age:number = 52;

interface Musician {
  artistName: string;
age:number,
deceased:boolean
  // add the rest
}

const musicianInfo = ({ artistName, age, deceased }:Musician) => {
  return `${artistName}, age ${age}${deceased ? ' (deceased)' : ''}`;
};

musicianInfo({
  artistName,
  age,
  deceased: true,
});
```

## Type Aliases

```ts
import { Expect, Equal } from 'type-testing';

type test_Name = Expect<Equal<Name, string>>;
type test_Year = Expect<Equal<Year, number>>;
type test_Count = Expect<Equal<Count, number>>;
type test_IsOperational = Expect<Equal<IsOperational, boolean>>;

type test_PayloadName = Expect<Equal<
  Payload['name'],
  string
>>;

type test_Kilograms = Expect<Equal<
  Kilograms,
  number
>>;

type test_PayloadMass = Expect<Equal<
  Payload['mass'],
  Kilograms
>>;

interface Spacecraft {
  name: Name;
  yearBuilt: Year;
  crewCapacity: Count;
  launchDate: Date;
  isOperational: IsOperational;
  propulsionSystem: string[];
  payload: Payload[];
}

const voyager1 = {
  name: "Voyager 1",
  yearBuilt: 1977,
  crewCapacity: 0,
  launchDate: new Date("1977 09 05"),
  isOperational: true,
  propulsionSystem: ["RTG (Radioisotope Thermoelectric Generator)"],
  payload: [
    { name: "Golden Record", mass: 0.3 },
    { name: "Instruments", mass: 721 },
  ],
} satisfies Spacecraft;

```

```ts
// We completed the first alias (`Name`) for you to see as an example
type Name = string;

// Now try replacing `unknown` with a primitive data type that might be appropriate for `Year`
type Year = number;
type Count=number
type IsOperational = boolean;
type Kilograms=number
type Payload = {
  name: Name;
mass:Kilograms
  // the tests show that you need a `mass` property here
  // but first you might need to create an alias for `Kilograms`
  // because that's the value of `mass`
};
```

## The `typeof` Operator

```ts
import { Expect, Equal } from 'type-testing';

const height = 500;
const width = 700;

type test_Width = Expect<Equal<
  Width,
  700
>>;

const margin = {
  top: 20,
  right: 30,
  bottom: 40,
  left: 50,
};

type test_Margin = Expect<Equal<
  Margin,
  { top: number, right: number, bottom: number, left: number }
>>;

const d3ChartConfig = {
  width,
  height,
  margin,
  data: [
    { category: 'A', value: 30 },
    { category: 'B', value: 45 },
    { category: 'C', value: 60 },
    { category: 'D', value: 25 },
    { category: 'E', value: 50 },
  ],
  xScale: {
    type: 'band',
    domain: [0, 100],
    range: [0, width - margin.right - margin.left],
  },
  yScale: {
    type: 'linear',
    domain: [0, 100],
    range: [height - margin.bottom, margin.top],
  },
  xAxis: {
    label: 'Categories',
    tickSize: 5,
  },
  yAxis: {
    label: 'Values',
    tickSize: 5,
  },
  bar: {
    fill: 'rebeccapurple',
  },
};

type test_Data = Expect<Equal<
  Data,
  { category: string, value: number }[]
>>;

type test_YScale = Expect<Equal<
  YScale,
  {
    type: string;
    domain: number[];
    range: number[];
  }
>>;

type test_d3ChartConfig = Expect<Equal<
  D3ChartConfig,
  {
    width: number;
    height: number;
    margin: Margin;
    data: Data;
    xScale: {
      type: string;
      domain: number[];
      range: number[];
    };
    yScale: {
      type: string;
      domain: number[];
      range: number[];
    };
    xAxis: {
      label: string;
      tickSize: number;
    };
    yAxis: {
      label: string;
      tickSize: number;
    };
    bar: {
      fill: string;
    };
  }
>>;

```

```ts
type Width = typeof width;
type Margin = { top: number, right: number, bottom: number, left: number };
type Data = Array<{ category: string, value: number }>;
type YScale = {
    type: string;
    domain: number[];
    range: number[];
  };
type XAxis={
       label: string;
      tickSize: number;
    }
type D3ChartConfig = {
    width: number;
    height: number;
    margin: Margin;
    data: Data;
    xScale:YScale ;
    yScale: YScale;
    xAxis: XAxis;
    yAxis: XAxis;
    bar: {
      fill: string;
    };
  };
```

## Default Generic Arguments

```ts
import { Expect, Equal } from 'type-testing';

type test_ApiRequest_explicitPost = Expect<
  Equal<ApiRequest<string, 'POST'>, { data: string; method: 'POST' }>
>;

type test_ApiRequest_implicitGet = Expect<
  Equal<ApiRequest<number>, { data: number; method: 'GET' }>
>;

type test_TSConfig_default = Expect<Equal<TSConfig, { strict: true }>>;

type test_TSConfig_true = Expect<Equal<TSConfig<{ strict: true }>, { strict: true }>>;

type test_TSConfig_false = Expect<Equal<TSConfig<{ strict: false }>, { strict: false }>>;

type test_TSConfig_boolean = Expect<Equal<TSConfig<{ strict: boolean }>, { strict: boolean }>>;

```

```ts
type ApiRequest<T, METHOD = "GET"> = {
 data: T;
 method: METHOD;
};
type TSConfig<T = { strict: true }> = T;
```

## Type Unions

```ts
import { Expect, Extends } from 'type-testing';

/** temporary */
const expect = <T>(a: T) => ({
  toEqual: (b: T) => a === b
});

const getDistanceInMeters = (distance: Distance) => {
  switch (distance.unit) {
    case 'miles':
      return {
        unit: 'meters',
        value: distance.value / 1609.34,
      } satisfies Meters;

    case 'meters':
      return {
        unit: 'meters',
        value: distance.value,
      } satisfies Meters;

    case 'feet':
      return {
        unit: 'meters',
        value: distance.value * 3.28084,
      } satisfies Meters;

    default:
      // @ts-expect-error (in production codebases, we'd assert an unreachable case here but that's beyond the scope of this lesson)
      throw new Error(`unrecognized unit: ${distance.unit}`)
  }
}

const lowMarsOrbit = {
  unit: 'meters',
  value: 300_000
} satisfies Meters;

const mediumMarsOrbit = {
  unit: 'meters',
  value: 2_000_000
} satisfies Meters;

const highMarsOrbit = {
  unit: 'meters',
  value: 5_000_000
} satisfies Meters;


expect(getDistanceInMeters({
  unit: 'miles',
  value: 186.41182099494205,
})).toEqual(lowMarsOrbit);

expect(getDistanceInMeters({
  unit: 'meters',
  value: 2_000_000,
})).toEqual(mediumMarsOrbit);

expect(getDistanceInMeters({
  unit: 'feet',
  value: 1523999.9512320017,
})).toEqual(highMarsOrbit);


/////////////////////////////////////////////////
// Part 2

interface AbsolutePosition {
  top?: number;
  right?: number;
  bottom?: number;
  left?: number;
}

const positionElement = (position: Position): AbsolutePosition => {
  switch (position) {
    case 'topLeft':
      return { top: 0, left: 0 };

    case 'top':
      return { top: 0 };

    case 'topRight':
      return { top: 0, right: 0 };

    case 'left':
      return { left: 0 };

    case 'center':
      return { top: 0, left: 0, bottom: 0, right: 0 };

    case 'right':
      return { right: 0 };

    case 'bottomLeft':
      return { bottom: 0, left: 0 };

    case 'bottom':
      return { bottom: 0 };

    case 'bottomRight':
      return { bottom: 0, right: 0 };

    default:
      return {}
  }
}

type test_topLeft = Expect<Extends<'topLeft', Position>>;
type test_top = Expect<Extends<'top', Position>>;
type test_topRight = Expect<Extends<'topRight', Position>>;
type test_left = Expect<Extends<'left', Position>>;
type test_center = Expect<Extends<'center', Position>>;
type test_right = Expect<Extends<'right', Position>>;
type test_bottomLeft = Expect<Extends<'bottomLeft', Position>>;
type test_bottom = Expect<Extends<'bottom', Position>>;
type test_bottomRight = Expect<Extends<'bottomRight', Position>>;


```

```ts
// Part 1: Meters
type Meters = {
  unit: 'meters'|'feet';
  value: number;
};

type Miles = {
  unit: 'miles';
  value: number;
};

 
type Distance = Meters | Miles;

/////////////////////////////////////////////////
// Part 2: position
type Position = 'top' | 'topLeft' | 'topRight'|'left'|'center'|'right'|'bottomLeft'|'bottom'|'bottomRight';
```

# Easy

## Readonly

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<MyReadonly<Todo1>, Readonly<Todo1>>>,
]

interface Todo1 {
  title: string
  description: string
  completed: boolean
  meta: {
    author: string
  }
}
```

```ts
type MyReadonly<T> = {
 readonly[K in keyof T]:T[K]
}
```

## Tuple to Object

```ts
import type { Equal, Expect } from '@type-challenges/utils'

const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const
const tupleNumber = [1, 2, 3, 4] as const
const sym1 = Symbol(1)
const sym2 = Symbol(2)
const tupleSymbol = [sym1, sym2] as const
const tupleMix = [1, '2', 3, '4', sym1] as const

type cases = [
  Expect<Equal<TupleToObject<typeof tuple>, { 'tesla': 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y' }>>,
  Expect<Equal<TupleToObject<typeof tupleNumber>, { 1: 1, 2: 2, 3: 3, 4: 4 }>>,
  Expect<Equal<TupleToObject<typeof tupleSymbol>, { [sym1]: typeof sym1, [sym2]: typeof sym2 }>>,
  Expect<Equal<TupleToObject<typeof tupleMix>, { 1: 1, '2': '2', 3: 3, '4': '4', [sym1]: typeof sym1 }>>,
]

// @ts-expect-error
type error = TupleToObject<[[1, 2], {}]>
```

```ts
type TupleToObject<T extends readonly (string|number|symbol)[]> = {
 [n in T[number]]:n
}
```

## First of Array

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<First<[3, 2, 1]>, 3>>,
  Expect<Equal<First<[() => 123, { a: string }]>, () => 123>>,
  Expect<Equal<First<[]>, never>>,
  Expect<Equal<First<[undefined]>, undefined>>,
]

type errors = [
  // @ts-expect-error
  First<'notArray'>,
  // @ts-expect-error
  First<{ 0: 'arrayLike' }>,
]
```

```ts
type First<T extends any[]> =T extends []?never: T[0]
```

## Length of Tuple

```ts
import type { Equal, Expect } from '@type-challenges/utils'

const tesla = ['tesla', 'model 3', 'model X', 'model Y'] as const
const spaceX = ['FALCON 9', 'FALCON HEAVY', 'DRAGON', 'STARSHIP', 'HUMAN SPACEFLIGHT'] as const

type cases = [
  Expect<Equal<Length<typeof tesla>, 4>>,
  Expect<Equal<Length<typeof spaceX>, 5>>,
  // @ts-expect-error
  Length<5>,
  // @ts-expect-error
  Length<'hello world'>,
]
```

```ts
type Length<T extends readonly unknown[]> = T['length']
```

## Exclude

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<MyExclude<'a' | 'b' | 'c', 'a'>, 'b' | 'c'>>,
  Expect<Equal<MyExclude<'a' | 'b' | 'c', 'a' | 'b'>, 'c'>>,
  Expect<Equal<MyExclude<string | number | (() => void), Function>, string | number>>,
]
```

```ts
type MyExclude<T, U> = T extends U?never:T
```

## Awaited

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type X = Promise<string>
type Y = Promise<{ field: number }>
type Z = Promise<Promise<string | number>>
type Z1 = Promise<Promise<Promise<string | boolean>>>
type T = { then: (onfulfilled: (arg: number) => any) => any }

type cases = [
  Expect<Equal<MyAwaited<X>, string>>,
  Expect<Equal<MyAwaited<Y>, { field: number }>>,
  Expect<Equal<MyAwaited<Z>, string | number>>,
  Expect<Equal<MyAwaited<Z1>, string | boolean>>,
  Expect<Equal<MyAwaited<T>, number>>,
]

// @ts-expect-error
type error = MyAwaited<number>
```

```ts
type MyAwaited<T extends PromiseLike<any>> = T extends PromiseLike<infer Inner> 
  ? Inner extends PromiseLike<any> 
  ? MyAwaited<Inner> 
  : Inner
 : never;
```

## If

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<If<true, 'a', 'b'>, 'a'>>,
  Expect<Equal<If<false, 'a', 2>, 2>>,
]

// @ts-expect-error
type error = If<null, 'a', 'b'>
```

```ts
type If<C extends boolean, T, F> = C extends true ? T : F;
```

## Concat

```ts
import type { Equal, Expect } from '@type-challenges/utils'

const tuple = [1] as const

type cases = [
  Expect<Equal<Concat<[], []>, []>>,
  Expect<Equal<Concat<[], [1]>, [1]>>,
  Expect<Equal<Concat<typeof tuple, typeof tuple>, [1, 1]>>,
  Expect<Equal<Concat<[1, 2], [3, 4]>, [1, 2, 3, 4]>>,
  Expect<Equal<Concat<['1', 2, '3'], [false, boolean, '4']>, ['1', 2, '3', false, boolean, '4']>>,
]

// @ts-expect-error
type error = Concat<null, undefined>
```

```ts
type Concat<T extends readonly any[], U extends readonly any[]> = [...T,...U]
```

## Includes

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<Includes<['Kars', 'Esidisi', 'Wamuu', 'Santana'], 'Kars'>, true>>,
  Expect<Equal<Includes<['Kars', 'Esidisi', 'Wamuu', 'Santana'], 'Dio'>, false>>,
  Expect<Equal<Includes<[1, 2, 3, 5, 6, 7], 7>, true>>,
  Expect<Equal<Includes<[1, 2, 3, 5, 6, 7], 4>, false>>,
  Expect<Equal<Includes<[1, 2, 3], 2>, true>>,
  Expect<Equal<Includes<[1, 2, 3], 1>, true>>,
  Expect<Equal<Includes<[{}], { a: 'A' }>, false>>,
  Expect<Equal<Includes<[boolean, 2, 3, 5, 6, 7], false>, false>>,
  Expect<Equal<Includes<[true, 2, 3, 5, 6, 7], boolean>, false>>,
  Expect<Equal<Includes<[false, 2, 3, 5, 6, 7], false>, true>>,
  Expect<Equal<Includes<[{ a: 'A' }], { readonly a: 'A' }>, false>>,
  Expect<Equal<Includes<[{ readonly a: 'A' }], { a: 'A' }>, false>>,
  Expect<Equal<Includes<[1], 1 | 2>, false>>,
  Expect<Equal<Includes<[1 | 2], 1>, false>>,
  Expect<Equal<Includes<[null], undefined>, false>>,
  Expect<Equal<Includes<[undefined], null>, false>>,
]
```

```ts
type Includes<T extends readonly any[], U> = T extends [infer H, ...infer T]
 ? Equal<U, H> extends true
  ? true
  : Includes<T, U>
 : false;

 type Equal<X, Y> =
    (<T>() => (T extends X ? 1 : 2)) extends /**/
    (<T>() => (T extends Y ? 1 : 2))
        ? true 
        : false;
```

## Push

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<Push<[], 1>, [1]>>,
  Expect<Equal<Push<[1, 2], '3'>, [1, 2, '3']>>,
  Expect<Equal<Push<['1', 2, '3'], boolean>, ['1', 2, '3', boolean]>>,
]
```

```ts
type Push<T extends any[], U> = [...T,U]
```

## Unshift

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<Unshift<[], 1>, [1]>>,
  Expect<Equal<Unshift<[1, 2], 0>, [0, 1, 2]>>,
  Expect<Equal<Unshift<['1', 2, '3'], boolean>, [boolean, '1', 2, '3']>>,
]
```

```ts
type Unshift<T extends readonly any[], U> = [U,...T]
```

## Parameters

```ts
import type { Equal, Expect } from '@type-challenges/utils'

function foo(arg1: string, arg2: number): void {}
function bar(arg1: boolean, arg2: { a: 'A' }): void {}
function baz(): void {}

type cases = [
  Expect<Equal<MyParameters<typeof foo>, [string, number]>>,
  Expect<Equal<MyParameters<typeof bar>, [boolean, { a: 'A' }]>>,
  Expect<Equal<MyParameters<typeof baz>, []>>,
]
```

```ts
type MyParameters<T extends (...args:readonly any[]) => void> =T extends (...args:infer P)=>any?P:never
```

## The `Pick` builtin

```ts
interface Pokemon {
  name: string;
  type: string;
  hitPoints: number;
  stage: string;
  evolutionStage: number;
  attacks: string[];
  weakness: string;
  resilience: string;
}

const pickYourPokemon = (
  pokemon: MyPick<Pokemon, 'name' | 'type'>
) => {
  const { type, name } = pokemon;
  return `You picked the ${type}-type Pokemon ${name}!`
}

const pikachu = {
  name: 'Pikachu',
  type: 'Electric',
}

console.log(pickYourPokemon(pikachu))
// => `You picked the Electric-type Pokemon Pikachu!`

/** Selecting an invalid property should be an error. */
const pokemonAttacks = (
  // @ts-expect-error
  pokemon: MyPick<Pokemon, 'attacks' | 'age'>
) => {
  return 'Oops! WE ';
}

/** It's also totally fine to select a single property */
const recallPokemon = (pokemon: MyPick<Pokemon, 'name'>) => {
  return `You recalled ${pokemon.name}!`
}

```

```ts
type MyPick<T, K extends keyof T> = {
 [n in K]:T[n]
};
```

# Medium

## Get Return Type

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<string, MyReturnType<() => string>>>,
  Expect<Equal<123, MyReturnType<() => 123>>>,
  Expect<Equal<ComplexObject, MyReturnType<() => ComplexObject>>>,
  Expect<Equal<Promise<boolean>, MyReturnType<() => Promise<boolean>>>>,
  Expect<Equal<() => 'foo', MyReturnType<() => () => 'foo'>>>,
  Expect<Equal<1 | 2, MyReturnType<typeof fn>>>,
  Expect<Equal<1 | 2, MyReturnType<typeof fn1>>>,
]

type ComplexObject = {
  a: [12, 'foo']
  bar: 'hello'
  prev(): number
}

const fn = (v: boolean) => v ? 1 : 2
const fn1 = (v: boolean, w: any) => v ? 1 : 2
```

```ts
type MyReturnType<T> = T extends (...args:any[])=>infer R?R:never
```

## Omit

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<Expected1, MyOmit<Todo, 'description'>>>,
  Expect<Equal<Expected2, MyOmit<Todo, 'description' | 'completed'>>>,
]

// @ts-expect-error
type error = MyOmit<Todo, 'description' | 'invalid'>

interface Todo {
  title: string
  description: string
  completed: boolean
}

interface Expected1 {
  title: string
  completed: boolean
}

interface Expected2 {
  title: string
}
```

```ts
type MyOmit<T, K extends keyof T> = {
 [n in Exclude<keyof T,K>]:T[n]
}

```

## Readonly 2

```ts
import type { Alike, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Alike<MyReadonly2<Todo1>, Readonly<Todo1>>>,
  Expect<Alike<MyReadonly2<Todo1, 'title' | 'description'>, Expected>>,
  Expect<Alike<MyReadonly2<Todo2, 'title' | 'description'>, Expected>>,
  Expect<Alike<MyReadonly2<Todo2, 'description' >, Expected>>,
]

// @ts-expect-error
type error = MyReadonly2<Todo1, 'title' | 'invalid'>

interface Todo1 {
  title: string
  description?: string
  completed: boolean
}

interface Todo2 {
  readonly title: string
  description?: string
  completed: boolean
}

interface Expected {
  readonly title: string
  readonly description?: string
  completed: boolean
}
```

```ts
type MyReadonly2<T, K extends keyof T=keyof T> = Readonly<Pick<T, K>>&Omit<T,K>
```

## Deep Readonly

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<DeepReadonly<X1>, Expected1>>,
  Expect<Equal<DeepReadonly<X2>, Expected2>>,
]

type X1 = {
  a: () => 22
  b: string
  c: {
    d: boolean
    e: {
      g: {
        h: {
          i: true
          j: 'string'
        }
        k: 'hello'
      }
      l: [
        'hi',
        {
          m: ['hey']
        },
      ]
    }
  }
}

type X2 = { a: string } | { b: number }

type Expected1 = {
  readonly a: () => 22
  readonly b: string
  readonly c: {
    readonly d: boolean
    readonly e: {
      readonly g: {
        readonly h: {
          readonly i: true
          readonly j: 'string'
        }
        readonly k: 'hello'
      }
      readonly l: readonly [
        'hi',
        {
          readonly m: readonly ['hey']
        },
      ]
    }
  }
}

type Expected2 = { readonly a: string } | { readonly b: number }
```

```ts
type DeepReadonly<T extends Record<string, any>> =
    {
        readonly [n in keyof T]: keyof T[n] extends never
            ? T[n]
            : DeepReadonly<T[n]>
    }
```

## Tuple to Union

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<TupleToUnion<[123, '456', true]>, 123 | '456' | true>>,
  Expect<Equal<TupleToUnion<[123]>, 123>>,
]
```

```ts
type TupleToUnion<T extends any[]> = T extends [infer F, ...infer R] ? F | TupleToUnion<R> : never;

```

## Chainable Options

```ts
import type { Alike, Expect } from '@type-challenges/utils'

declare const a: Chainable

const result1 = a
  .option('foo', 123)
  .option('bar', { value: 'Hello World' })
  .option('name', 'type-challenges')
  .get()

const result2 = a
  .option('name', 'another name')
  // @ts-expect-error
  .option('name', 'last name')
  .get()

const result3 = a
  .option('name', 'another name')
  // @ts-expect-error
  .option('name', 123)
  .get()

type cases = [
  Expect<Alike<typeof result1, Expected1>>,
  Expect<Alike<typeof result2, Expected2>>,
  Expect<Alike<typeof result3, Expected3>>,
]

type Expected1 = {
  foo: number
  bar: {
    value: string
  }
  name: string
}

type Expected2 = {
  name: string
}

type Expected3 = {
  name: number
}
```

```ts
type Chainable<T = {}> = {
 option<K extends string, V>(key: Exclude<K,keyof T>, value: V): Chainable<Omit< T,K> & { [n in K]: V }>;
 get(): T;
};
```

## Last of Array

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<Last<[2]>, 2>>,
  Expect<Equal<Last<[3, 2, 1]>, 1>>,
  Expect<Equal<Last<[() => 123, { a: string }]>, { a: string }>>,
]
```

```ts
type Last<T extends any[]> = T extends [...any[],infer U]?U:never;
```

## Pop

```ts
import type { Equal, Expect } from '@type-challenges/utils'

type cases = [
  Expect<Equal<Pop<[3, 2, 1]>, [3, 2]>>,
  Expect<Equal<Pop<['a', 'b', 'c', 'd']>, ['a', 'b', 'c']>>,
  Expect<Equal<Pop<[]>, []>>,
]
```

```ts
type Pop<T extends any[]> = T extends [...infer U,any]?U:[]

```

## Promise.all

```ts
import type { Equal, Expect } from '@type-challenges/utils'

const promiseAllTest1 = PromiseAll([1, 2, 3] as const)
const promiseAllTest2 = PromiseAll([1, 2, Promise.resolve(3)] as const)
const promiseAllTest3 = PromiseAll([1, 2, Promise.resolve(3)])
const promiseAllTest4 = PromiseAll<Array<number | Promise<number>>>([1, 2, 3])

type cases = [
  Expect<Equal<typeof promiseAllTest1, Promise<[1, 2, 3]>>>,
  Expect<Equal<typeof promiseAllTest2, Promise<[1, 2, number]>>>,
  Expect<Equal<typeof promiseAllTest3, Promise<[number, number, number]>>>,
  Expect<Equal<typeof promiseAllTest4, Promise<number[]>>>,
]
```

```ts
type MyAwaited<T> = T extends PromiseLike<infer R> ? R : T;

declare function PromiseAll<T extends unknown[]>(
  values: readonly [...T]
): Promise<{ [K in keyof T]: MyAwaited<T[K]> }>;
```

## Type Lookup

```ts
import type { Equal, Expect } from '@type-challenges/utils'

interface Cat {
  type: 'cat'
  breeds: 'Abyssinian' | 'Shorthair' | 'Curl' | 'Bengal'
}

interface Dog {
  type: 'dog'
  breeds: 'Hound' | 'Brittany' | 'Bulldog' | 'Boxer'
  color: 'brown' | 'white' | 'black'
}

type Animal = Cat | Dog

type cases = [
  Expect<Equal<LookUp<Animal, 'dog'>, Dog>>,
  Expect<Equal<LookUp<Animal, 'cat'>, Cat>>,
]
```

```ts
type LookUp<U extends { type: string }, T> = U extends { type: T } ? U : never;
```
