include SessionsHelper
include NotificationsHelper
include ProductsHelper

# Configure alarm scheduler which is used to close the bid at specified time
SCHEDULER = Rufus::Scheduler.start_new
