/* window.vala
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
 */

namespace TextViewer {
    [GtkTemplate (ui = "/com/linusemrch2618/TextViewer/ui/window.ui")]
    public class Window : Adw.ApplicationWindow {


        private Settings settings = new Settings ("com.linusemrch2618.TextViewer");

        [GtkChild]
        private unowned Gtk.Label cursor_pos;
        [GtkChild]
        private unowned Adw.ToastOverlay toast_overlay;
        [GtkChild]
        private unowned Gtk.TextView main_text_view;


        public Window (Gtk.Application app) {
            Object (application: app);
        }
        construct {
            var open_action = new SimpleAction ("open", null);
            open_action.activate.connect (this.open_file_dialog);
            this.add_action (open_action);

            var save_as_action = new SimpleAction ("save-as", null);
            save_as_action.activate.connect (this.save_file_dialog);
            this.add_action (save_as_action);

            Gtk.TextBuffer buffer = this.main_text_view.buffer;
            buffer.notify["cursor-position"].connect (this.update_cursor_position);

            this.settings.bind ("window-width", this, "default-width", SettingsBindFlags.DEFAULT);
            this.settings.bind ("window-height", this, "default-height", SettingsBindFlags.DEFAULT);
            this.settings.bind ("window-maximized", this, "maximized", SettingsBindFlags.DEFAULT);
        }


        private void open_file_dialog (Variant? parameter) {
            var filechooser = new Gtk.FileChooserNative ("Open File", null, Gtk.FileChooserAction.OPEN, "_Open", "_Cancel") {
                transient_for = this
            };
            filechooser.response.connect ((dialog, response) => {
                if (response == Gtk.ResponseType.ACCEPT)
                    this.open_file (filechooser.get_file ());
            });
            filechooser.show ();
        }
        private void open_file (File file) {
            file.load_contents_async.begin (null, (object, result) => {
                string display_name;
                try {
                    FileInfo? info = file.query_info ("standard::displayname", FileQueryInfoFlags.NONE);
                    display_name = info.get_attribute_string ("standard::displayname");
                } catch (Error e) {
                    display_name = file.get_basename ();
                }
                if (display_name == null || display_name.length == 0)
                    display_name = file.get_basename ();
                
                uint8[] contents;
                try {
                    file.load_contents_async.end (result, out contents, null);
                } catch (Error e) {
                    this.toast_overlay.add_toast (new Adw.Toast (@"Unable to open “$display_name“"));
                }

                if (!((string) contents).validate ())
                    this.toast_overlay.add_toast (new Adw.Toast (@"Invalid text encoding for “$display_name“"));

                Gtk.TextBuffer buffer = this.main_text_view.buffer;
                buffer.text = (string) contents;

                Gtk.TextIter start;
                buffer.get_start_iter (out start);
                buffer.place_cursor (start);

                this.title = display_name;

                this.toast_overlay.add_toast (new Adw.Toast (@"Opened “$display_name“"));
            });
        }

        private void save_file_dialog (Variant? parameter) {
            var filechooser = new Gtk.FileChooserNative ("Save File As", this, Gtk.FileChooserAction.SAVE, "_Save", "_Cancel");
            filechooser.response.connect ((dialog, response) => {
                if (response == Gtk.ResponseType.ACCEPT) {
                    this.save_file (filechooser.get_file ());
                }
            });
            filechooser.show ();
        }
        private void save_file (File file) {
            Gtk.TextBuffer buffer = this.main_text_view.buffer;
            Gtk.TextIter start;
            buffer.get_start_iter (out start);
            Gtk.TextIter end;
            buffer.get_end_iter (out end);

            string? text = buffer.get_text (start, end, false);
            if (text == null || text.length == 0)
                return;

            var bytes = new Bytes.take ((uint8[]) text.data);
            file.replace_contents_bytes_async.begin (bytes, null, false, FileCreateFlags.NONE, null, (object, result) => {
                string display_name;
                try {
                    FileInfo info = file.query_info ("standard::display-name", FileQueryInfoFlags.NONE);
                    display_name = info.get_attribute_string ("standard::display-name");
                } catch (Error e) {
                    display_name = file.get_basename ();
                }
                if (display_name == null || display_name.length == 0)
                    display_name = file.get_basename ();
                
                string message;
                try {
                    file.replace_contents_async.end (result, null);
                    message = @"Saved as “$display_name“";
                } catch (Error e) {
                    message = @"Unable to save as “$display_name“";
                }
                this.toast_overlay.add_toast (new Adw.Toast (message));
            });
        }

        private void update_cursor_position (Object source_object, ParamSpec pspec) {
            var buffer = source_object as Gtk.TextBuffer;
            int cursor_position = buffer.cursor_position;
            Gtk.TextIter iter;
            buffer.get_iter_at_offset (out iter, cursor_position);

            this.cursor_pos.label = @"Ln $(iter.get_line ()), Col $(iter.get_line_offset ())";
        }
    }
}
