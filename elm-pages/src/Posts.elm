module Posts exposing (all)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob


all : DataSource (List String)
all =
    Glob.succeed identity
        |> Glob.match (Glob.literal "../content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match
            (Glob.oneOf
                ( ( "", () )
                , [ ( "/index", () ) ]
                )
            )
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
