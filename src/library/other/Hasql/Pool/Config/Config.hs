module Hasql.Pool.Config.Config where

import Hasql.Pool.Observation (Observation)
import Hasql.Pool.Prelude

-- | Configufation for Hasql connection pool.
data Config = Config
  { size :: Int,
    acquisitionTimeout :: DiffTime,
    agingTimeout :: DiffTime,
    idlenessTimeout :: DiffTime,
    connectionStringProvider :: IO ByteString,
    observationHandler :: Observation -> IO ()
  }

-- | Reasonable defaults, which can be built upon.
standard :: Config
standard =
  Config
    { size = 3,
      acquisitionTimeout = 10,
      agingTimeout = 60 * 60 * 24,
      idlenessTimeout = 60 * 10,
      connectionStringProvider = pure "postgresql://postgres:postgres@localhost:5432/postgres",
      observationHandler = const (pure ())
    }
