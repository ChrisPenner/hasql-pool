-- | Interface for processing observations of the status of the pool.
--
-- Provides a flexible mechanism for monitoring the healthiness of the pool via logs and metrics without any opinionated choices on the actual monitoring technologies.
-- Specific interpreters are encouraged to be created as extension libraries.
module Hasql.Pool.Observation where

import Hasql.Pool.Prelude

-- | An observation of a change of the state of a pool.
data Observation
  = -- | Status of one of the pool's connections has changed.
    ConnectionObservation
      -- | Generated connection ID.
      -- For grouping the observations by one connection.
      UUID
      -- | Status that the connection has entered.
      ConnectionStatus
  deriving (Show, Eq)

-- | Status of a connection.
data ConnectionStatus
  = -- | Connection is being established.
    --
    -- This is the initial status of every connection.
    ConnectingConnectionStatus
  | -- | Connection is established and not occupied.
    ReadyForUseConnectionStatus
      -- | Whether the connection has just been established.
      ConnectionReadyForUseReason
  | -- | Is being used by some session.
    --
    -- After it's done the status will transition to 'ReadyForUseConnectionStatus' or 'TerminatedConnectionStatus'.
    InUseConnectionStatus
  | -- | Connection terminated.
    TerminatedConnectionStatus ConnectionTerminationReason
  deriving (Show, Eq)

data ConnectionReadyForUseReason
  = -- | Connection just got established.
    EstablishedConnectionReadyForUseReason
  | -- | Session execution ended with a failure that does not require a connection reset.
    SessionFailedConnectionReadyForUseReason
  | -- | Session execution ended with success.
    SessionSucceededConnectionReadyForUseReason
  deriving (Show, Eq)

-- | Explanation of why a connection was terminated.
data ConnectionTerminationReason
  = -- | The age timeout of the connection has passed.
    AgingConnectionTerminationReason
  | -- | The timeout of how long a connection may remain idle in the pool has passed.
    IdlenessConnectionTerminationReason
  | -- | Connectivity issues with the server.
    NetworkErrorConnectionTerminationReason (Maybe Text)
  | -- | User has invoked the 'Hasql.Pool.release' procedure.
    ReleaseConnectionTerminationReason
  deriving (Show, Eq)
