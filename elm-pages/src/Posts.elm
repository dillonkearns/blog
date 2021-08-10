module Posts exposing (all)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob


type alias Post =
    { slug : String
    , filePath : String
    }


all : DataSource (List Post)
all =
    Glob.succeed Post
        |> Glob.match (Glob.literal "../content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match
            (Glob.oneOf
                ( ( "", () )
                , [ ( "/index", () ) ]
                )
            )
        |> Glob.match (Glob.literal ".md")
        |> Glob.captureFilePath
        |> Glob.toDataSource
