-------------------------------------------------------------------------------
-- PATH
-------------------------------------------------------------------------------

package.path  = package.path .. ";app/models/?.lua"
package.path  = package.path .. ";app/controllers/?.lua"
package.path  = package.path .. ";app/helpers/?.lua"
package.path  = package.path .. ";lib/?.lua"

-------------------------------------------------------------------------------
-- GLOBALS
-------------------------------------------------------------------------------

CHARON_TASK  = false
APP_PATH     = os.pwd()
CHARON_ENV   = os.getenv("CHARON_ENV") or "development"
Object       = require('charon.oop.Object')
Class        = require('charon.oop.Class')
ActiveRecord = require "charon.ActiveRecord"

-------------------------------------------------------------------------------
-- ACTIVE RECORD
-------------------------------------------------------------------------------

ActiveRecord.query_prefix = "app/"
ActiveRecord.debug        = (CHARON_ENV == 'development')

-------------------------------------------------------------------------------
-- LOCALE
-------------------------------------------------------------------------------

os.setlocale("C", "numeric")
