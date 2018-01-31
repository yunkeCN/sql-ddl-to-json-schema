const ava = require('ava');
const Parser = require('../lib');

const tests = {
  'Should create test database': {
    queries: [
      'CREATE DATABASE test',
      'CREATE DATABASE IF EXISTS test',
      'CREATE DATABASE IF NOT EXISTS test',
      'CREATE DATABASE `test`',

      'create database test',
      'create database if exists test',
      'create database if not exists test',
      'create database `test`',

      'create database test CHARACTER SET utf8',
      'create database test CHARACTER SET = utf8',

      'create database test COLLATE utf8_general_ci ',
      'create database test COLLATE = utf8_general_ci',
    ],
    expect: {
      type: 'main',
      def: [
        {
          type: 'P_DDS',
          def: {
            type: 'P_CREATE_DB',
            def: {
              database: 'test'
            }
          }
        }
      ]
    }
  }
};

Object.getOwnPropertyNames(tests).forEach(description => {
  const test = tests[description];

  test.queries.forEach(query => {

    const testname = `${description} | ${query}`;

    const parser = new Parser();
    parser.feed(query);

    ava(testname, t => {
      const value = parser.results;
      t.deepEqual(value, test.expect);
    });
  });
});

