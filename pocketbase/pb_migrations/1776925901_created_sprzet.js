/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "wl1pfehntrfl8d3",
    "created": "2026-04-23 06:31:41.641Z",
    "updated": "2026-04-23 06:31:41.641Z",
    "name": "sprzet",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "g2qtykub",
        "name": "nazwa",
        "type": "text",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "min": 1,
          "max": 200,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "zpqdl5jc",
        "name": "kategoria",
        "type": "select",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "komputer",
            "monitor",
            "serwer",
            "siec",
            "peryferium",
            "telefon",
            "kabel",
            "narzedzie",
            "inne"
          ]
        }
      },
      {
        "system": false,
        "id": "jdif9wsu",
        "name": "lokalizacja",
        "type": "select",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "sala",
            "magazyn",
            "szafa",
            "biurko"
          ]
        }
      },
      {
        "system": false,
        "id": "avcynrze",
        "name": "producent",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": 100,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "jjo6iwhg",
        "name": "model",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": 100,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "zoggn6ey",
        "name": "numer_seryjny",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": 200,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "fixmzffo",
        "name": "numer_inw",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": 100,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "ojp3lacq",
        "name": "rok",
        "type": "number",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": 1990,
          "max": 2100,
          "noDecimal": true
        }
      },
      {
        "system": false,
        "id": "4dourmdz",
        "name": "ilosc",
        "type": "number",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": 1,
          "max": null,
          "noDecimal": true
        }
      },
      {
        "system": false,
        "id": "xprhgqqb",
        "name": "stan_fizyczny",
        "type": "select",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "dobry",
            "dostateczny",
            "zly",
            "sprawdzic"
          ]
        }
      },
      {
        "system": false,
        "id": "qaymawn8",
        "name": "stan_tech",
        "type": "select",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "dobry",
            "dostateczny",
            "zly",
            "sprawdzic"
          ]
        }
      },
      {
        "system": false,
        "id": "nqwvjqvk",
        "name": "kompletnosc",
        "type": "select",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "dobry",
            "dostateczny",
            "zly"
          ]
        }
      },
      {
        "system": false,
        "id": "nu3ynuak",
        "name": "zalecenie",
        "type": "select",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "zostaje",
            "naprawic",
            "wyrzucic",
            "decyzja"
          ]
        }
      },
      {
        "system": false,
        "id": "j7uruji6",
        "name": "uwagi",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": 2000,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "6adarf0d",
        "name": "sprawdzil",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": 100,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "tzwqunia",
        "name": "zdjecia",
        "type": "file",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "mimeTypes": [
            "image/jpeg",
            "image/png",
            "image/webp",
            "image/gif"
          ],
          "thumbs": null,
          "maxSelect": 5,
          "maxSize": 5242880,
          "protected": false
        }
      }
    ],
    "indexes": [],
    "listRule": "",
    "viewRule": "",
    "createRule": "",
    "updateRule": "",
    "deleteRule": "",
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("wl1pfehntrfl8d3");

  return dao.deleteCollection(collection);
})
