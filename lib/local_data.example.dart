const formulasData = [
  {
    "slug": "brand-flavour-freebase",
    "name": "Brand Flavour Freebase",
    "brand": "Brand",
    "chillType": "NON_CHILLED",
    "nicType": "FREEBASE",
    "nicProfiles": [
      {
        "slug": "brand-flavour-freebase-3mg-old-mix",
        "name": "3MG",
        "fullName": "Brand Flavour Freebase - 3MG - Old Mix",
        "isOldMix": true,
        "targetNicStr": 0.011,
        "targetVg": 0.605,
        "targetPg": 0.395,
        "nicBaseNicStr": 1,
        "nicBases": [
          {
            "nicBaseOption": {
              "code": "TEST1C",
              "name": "Test VG Nic Base",
              "isVg": true,
            },
            "ratio": 1.0,
          },
        ],
        "flavorings": [
          {
            "flavoringOption": {
              "slug": "test-flavouring",
              "name": "Test Flavouring",
              "isVg": false
            },
            "ratio": 0.0010,
          },
        ],
      },
    ],
  },
];

const nicBaseOptionsData = [
  {
    'code': 'TEST1C',
    'name': 'Test VG Nic Base',
    'isVg': true,
  },
];
