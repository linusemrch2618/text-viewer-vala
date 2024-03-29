/* application.vala
 *
 * Copyright 2022 Linus Emmerich
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace TextViewer {
    public class Application : Adw.Application {
        public Application () {
            Object (application_id: "com.linusemrch2618.TextViewer", flags: ApplicationFlags.FLAGS_NONE);
        }

        construct {
            ActionEntry[] action_entries = {
                { "about", this.on_about_action },
                { "preferences", this.on_preferences_action },
                { "quit", this.quit }
            };
            this.add_action_entries (action_entries, this);
            this.set_accels_for_action ("app.quit", {"<primary>q"});
            this.set_accels_for_action ("win.open", { "<Ctrl>o" });
            this.set_accels_for_action ("win.save-as", { "<Ctrl><Shift>s" });
        }

        public override void activate () {
            base.activate ();
            var win = this.active_window;
            if (win == null) {
                win = new TextViewer.Window (this);
            }
            win.present ();
        }

        private void on_about_action () {
            string[] developers = { "Linus Emmerich" };
            var about = new Adw.AboutWindow () {
                transient_for = this.active_window,
                application_name = " Text Viewer",
                application_icon = "com.linusemrch2618.TextViewer",
                developer_name = "Linus Emmerich",
                developers = developers,
                copyright = "© 2022 Linus Emmerich",
                version =  Config.VERSION,
                comments = "A simple Text Editor",
                website = Config.PACKAGE_URL,
                license_type = Gtk.License.GPL_3_0,
            };

            about.present ();
        }

        private void on_preferences_action () {
            message ("app.preferences action activated");
        }
    }
}
