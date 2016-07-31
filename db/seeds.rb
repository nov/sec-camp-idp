Scope.create [
  {name: 'openid' },
  {name: 'profile'},
  {name: 'email'  },
  {name: 'address'},
  {name: 'phone'  }
]

case Rails.env
when 'production'
  Client.create [{
    identifier: '1735ae91cb46163c0cb9cf8044888962',
    secret: '25b28b72d1c067e156de71e8b2f33b59d671c22553750483ccf9ece1828adf9f',
    name: 'RP (response_type=code)',
    redirect_uri: 'https://sec-camp-rp-code.herokuapp.com/callback'
  }, {
    identifier: 'a27052c127be1edcd5b815ad91a22ea2',
    secret: 'b3ef8cc42fee95ffbee0a5278c725739be5f54cc52451e3105b96ed351c56811',
    name: 'RP (response_type=token+id_token)',
    redirect_uri: 'https://sec-camp-rp-implicit.herokuapp.com/callback'
  }]
when 'development'
  Client.create [{
    identifier: '8d6c384015481a2e1e6151bcd283a64d',
    secret: 'ad1d3c5c4948fb0b06952c5075e53ed46ba86d93c1d501633cc4fd24a99c229b',
    name: 'RP (response_type=code)',
    redirect_uri: 'http://sec-rp-code.dev/callback'
  }, {
    identifier: 'ec427a44c1076c0653a48f6162b044d6',
    secret: '932692979933e82156199ea051564e1914809af3255f35b82cae0cf016d6c69f',
    name: 'RP (response_type=token+id_token)',
    redirect_uri: 'http://sec-rp-implicit.dev/callback'
  }]
end

Account.create [{
  name: 'Nov Victim',
  email: 'nov@victim.example.com',
  phone: '(+81) 0123456789',
  address: 'Tokyo, Japan',
  password: 'pass#nov'
}, {
  name: 'Michael Victim',
  email: 'mike@victim.example.com',
  phone: '(+1) 0123456789',
  address: 'Shiattle, US',
  password: 'pass#mike'
}, {
  name: 'Nat Attacker',
  email: 'nat@attacker.example.com',
  phone: '(+81) 9876543210',
  address: 'Tokyo, Japan',
  password: 'pass#nat'
}, {
  name: 'John Attacker',
  email: 'john@attacker.example.com',
  phone: '(+56) 9876543210',
  address: 'Santiago, Chile',
  password: 'pass#john'
}]