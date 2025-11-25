import { application } from "./application"

import HelloController from "./hello_controller"
import DropdownController from "./dropdown_controller"
import NotificationController from "./notification_controller"
import ThemeToggleController from "./theme_toggle_controller"

application.register("hello", HelloController)
application.register("dropdown", DropdownController)
application.register("notification", NotificationController)
application.register("theme-toggle", ThemeToggleController)
