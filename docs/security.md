## Security Map

|Controller      |Method          |Public|Logged|Admin
| ---            | ---            |:---: |:---: |:---:
|AccessController| login          | Y    |      |
|                | attempt_login  | Y    |      |
|                | logout         | Y    |      |
|                | reset_request  | Y    |      |
|                | reset          | Y    |      |
|ApiuiController | index          |      | Y    | Y
|EventsController| index          |      |      | Y
|                | show           |      |      | Y
|                | new            |      |      | Y
|                | edit           |      |      | Y
|                | create         |      |      | Y
|                | update         |      |      | Y
|                | destroy        |      |      | Y
|MainController  | index          | Y    |      |
|                | letsencrypt    | Y    |      |
|GuestsController| index          |      |      |
|                | show           |      |      |
|                | new            |      |      |
|                | edit           |      |      |
|                | create         |      |      |
|                | update         |      |      |
|                | destroy        |      |      |
|RegistriesCtrl  | index          |      |      |
|                | show           |      |      |
|                | new            |      |      |
|                | edit           |      |      |
|                | create         |      |      |
|                | update         |      |      |
|                | destroy        |      |      |
|                | list_lodging   |      |      |
|                | list_transport |      |      |
|                | totals         |      |      |
|                | totals_food    |      |      |
|                | edit_payment   |      |      |
|ReportsControllr| badge          |      |      | Y
|                | badge_bulk     |      |      | Y
|UsersController | index          |      |      |
|                | show           |      |      |
|                | new            |      |      |
|                | edit           |      |      |
|                | create         |      |      |
|                | update         |      |      |
|                | destroy        |      |      |
|                | payments       |      |      |