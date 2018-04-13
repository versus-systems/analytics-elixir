analytics-elixir
================

analytics-elixir is a non-supported third-party client for [Segment](https://segment.com).

This fork allows sending events with different write keys and, by default, sends events in batches for 
improved performance.  Batches are currently sent every 3 seconds.

## Install

Add the following to deps section of your mix.exs: `{:segment, github: "versus-systems/analytics-elixir"}`

and then `mix deps.get`

## Usage

There are then two ways to call the different methods on the API.
A basic way through `Segment.Analytics` or by passing a full Struct
with all the data for the API (allowing Context and Integrations to be set).

A `write_key` _must_ be provided to each struct or function call as the first argument.
There is no concept of a 'default' write key since we assume you will be using many. If you
have only one write key for your application, you can wrap calls to this library in your
application's interface.

## Usage in Phoenix


### Track
```elixir
Segment.Analytics.track(write_key, user_id, event, %{property1: "", property2: ""})
```
or the full way using a struct with all the possible options for the track call
```elixir
%Segment.Analytics.Track{
  write_key: "YOUR-WRITE-KEY",
  userId: "sdsds",
  event: "eventname",
  properties: %{property1: "", property2: ""}
}
|> Segment.Analytics.track
```

### Identify
```elixir
Segment.Analytics.identify(write_key, user_id, %{trait1: "", trait2: ""})
```
or the full way using a struct with all the possible options for the identify call
```elixir
%Segment.Analytics.Identify{
  write_key: "YOUR-WRITE-KEY",
  userId: "sdsds",
  traits: %{trait1: "", trait2: ""}
}
|> Segment.Analytics.identify
```

### Screen
```elixir
Segment.Analytics.screen(write_key, user_id, name)
```
or the full way using a struct with all the possible options for the screen call
```elixir
%Segment.Analytics.Screen{
  write_key: "YOUR-WRITE-KEY",
  userId: "sdsds",
  name: "dssd"
}
|> Segment.Analytics.screen
```

### Alias
```elixir
Segment.Analytics.alias(write_key, user_id, previous_id)
```
or the full way using a struct with all the possible options for the alias call
```elixir
%Segment.Analytics.Alias{
  write_key: "YOUR-WRITE-KEY",
  userId: "sdsds",
  previousId: "dssd"
}
|> Segment.Analytics.alias
```

### Group
```elixir
Segment.Analytics.group(write_key, user_id, group_id)
```
or the full way using a struct with all the possible options for the group call
```elixir
%Segment.Analytics.Group{
  write_key: "YOUR-WRITE-KEY",
  userId: "sdsds",
  groupId: "dssd"
}
|> Segment.Analytics.group
```

### Page
```elixir
Segment.Analytics.page(write_key, user_id, name)
```
or the full way using a struct with all the possible options for the page call
```elixir
%Segment.Analytics.Page{
  write_key: "YOUR-WRITE-KEY",
  userId: "sdsds",
  name:   "dssd"
}
|> Segment.Analytics.page
```

