# CompanyChallenge
This repository was a code challenge designed as a take home for a company and is a Rest API with a CRUD and authentication.

## Endpoints:

All Endpoints with their answers are available at this link [![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/16360675-a7aaed84-b98b-4495-b6f2-541d8e2add7f?action=collection%2Ffork&collection-url=entityId%3D16360675-a7aaed84-b98b-4495-b6f2-541d8e2add7f%26entityType%3Dcollection%26workspaceId%3D576bcf45-7ce8-43b4-a76b-5a929ca6a986) where you can use Postman to view the routes and the possible responses.

## Instructions for running the app

To be able to use the project, you need to follow the steps below:
 
      - Have installed Erlang
      - Have installed Elixir
      - Postgres database with username `postgres` and password `postgres`, if the username or password are different you must change it in the files of `config/dev.exs` and `config/test.exs`.
      - Clone the project by executing the command `git clone https://github.com/ThiagoPMaceda/iza-seguros-challenge.git.git`.
      - Install the dependencies `mix deps.get`
      - To create and migrate the database `mix ecto.setup`
      - To start the project `mix phoenix.server`
      - With this you can go to the url [`localhost:4000`](http://localhost:4000) in your browser.
