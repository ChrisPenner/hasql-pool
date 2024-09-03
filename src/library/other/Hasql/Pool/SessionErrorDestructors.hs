module Hasql.Pool.SessionErrorDestructors where

import Hasql.Pool.Prelude
import Hasql.Session qualified as Session

reset :: (Maybe ByteString -> x) -> x -> Session.SessionError -> x
reset withDetails other = \case
  Session.QueryError _ _ (Session.ClientError details) -> withDetails details
  Session.PipelineError (Session.ClientError details) -> withDetails details
  _ -> other
