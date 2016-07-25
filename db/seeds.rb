Scope.create [
  {name: 'openid' },
  {name: 'profile'},
  {name: 'email'  },
  {name: 'address'},
  {name: 'phone'  }
]

Client.create [{
  identifier: '8d6c384015481a2e1e6151bcd283a64d',
  secret: 'ad1d3c5c4948fb0b06952c5075e53ed46ba86d93c1d501633cc4fd24a99c229b',
  name: 'RP (response_type=code)',
  redirect_uri: 'http://sec-rp-code.dev/callback'
}, {
  identifier: 'ec427a44c1076c0653a48f6162b044d6',
  secret: '932692979933e82156199ea051564e1914809af3255f35b82cae0cf016d6c69f',
  name: 'RP (response_type=token)',
  redirect_uri: 'http://sec-rp-token.dev/callback'
}, {
  identifier: 'c1e8e740a49e327231da8e844fb161bf',
  secret: 'c10382b806f513c49059aca5e2696a621a9dbeef5555fa628c5d1619aa442a5d',
  name: 'RP (response_type=id_token)',
  redirect_uri: 'http://sec-rp-id-token.dev/callback'
}]

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