module Example exposing (suite)

import Expect
import Test exposing (Test, test)


suite : Test
suite =
    test "True is True"
        (\_ -> Expect.equal True True)
