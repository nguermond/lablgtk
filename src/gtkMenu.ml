(* $Id$ *)

open Gaux
open Gtk
open GtkBase

module MenuItem = struct
  let cast w : menu_item obj = Object.try_cast w "GtkMenuItem"
  external create : unit -> menu_item obj = "ml_gtk_menu_item_new"
  external create_with_label : string -> menu_item obj
      = "ml_gtk_menu_item_new_with_label"
  external create_with_mnemonic : string -> menu_item obj
      = "ml_gtk_menu_item_new_with_mnemonic"
  external tearoff_create : unit -> menu_item obj
      = "ml_gtk_tearoff_menu_item_new"
  let create ?(use_mnemonic=false) ?label () =
    match label with None -> create ()
    | Some label -> if use_mnemonic then 
	create_with_mnemonic label else create_with_label label
  external set_submenu : [>`menuitem] obj -> [>`menu] obj -> unit
      = "ml_gtk_menu_item_set_submenu"
  external get_submenu : [>`menuitem] obj -> widget obj option
      = "ml_gtk_menu_item_get_submenu"
  external remove_submenu : [>`menuitem] obj -> unit
      = "ml_gtk_menu_item_remove_submenu"
  external activate : [>`menuitem] obj -> unit
      = "ml_gtk_menu_item_activate"
  external select : [>`menuitem] obj -> unit
      = "ml_gtk_menu_item_select"
  external deselect : [>`menuitem] obj -> unit
      = "ml_gtk_menu_item_deselect"
  external set_right_justified : [>`menuitem] obj -> bool -> unit
      = "ml_gtk_menu_item_set_right_justified"
  external get_right_justified : [>`menuitem] obj -> bool
      = "ml_gtk_menu_item_get_right_justified"
  external set_accel_path : [> `menuitem] obj -> string -> unit
    = "ml_gtk_menu_item_set_accel_path"
  external toggle_size_request : [> `menuitem] obj -> int -> unit
    = "ml_gtk_menu_item_toggle_size_request"
  external toggle_size_allocate : [> `menuitem] obj -> int -> unit
    = "ml_gtk_menu_item_toggle_size_allocate"
  module Signals = struct
    open GtkSignal
    let activate =
      { name = "activate"; classe = `menuitem; marshaller = marshal_unit }
    let activate_item =
      { name = "activate_item"; classe = `menuitem; marshaller = marshal_unit }
    let toggle_size_allocate =
      { name = "toggle-size-allocate"; classe = `menuitem; 
	marshaller = marshal_int }
    let toggle_size_request =
      { name = "toggle-size-request"; classe = `menuitem; 
	marshaller = marshal_unit }
  end
end

module ImageMenuItem = struct
  let cast w : menu_item obj = Object.try_cast w "GtkImageMenuItem"
  external create : unit -> image_menu_item obj = "ml_gtk_image_menu_item_new"
  external create_with_label : string -> image_menu_item obj
      = "ml_gtk_image_menu_item_new_with_label"
  external create_with_mnemonic : string -> image_menu_item obj
      = "ml_gtk_image_menu_item_new_with_mnemonic"
  external create_from_stock : string -> accel_group option 
    -> image_menu_item obj = "ml_gtk_image_menu_item_new_from_stock"
  let create_from_stock ?accel_group s = 
    create_from_stock (GtkStock.convert_id s) accel_group
  let create ?label ?(use_mnemonic=false) ?stock ?accel_group () = 
    match stock with 
    | None -> 
	begin match label with
	| None -> create ()
	| Some l -> 
	    if use_mnemonic then create_with_mnemonic l 
	    else create_with_label l 
	end
    | Some s -> create_from_stock ?accel_group s
  external set_image : image_menu_item obj -> widget -> unit = "ml_gtk_image_menu_item_set_image"
  external get_image : image_menu_item obj -> widget = "ml_gtk_image_menu_item_get_image"

end

module CheckMenuItem = struct
  let cast w : check_menu_item obj = Object.try_cast w "GtkCheckMenuItem"
  external create : unit -> check_menu_item obj = "ml_gtk_check_menu_item_new"
  external create_with_label : string -> check_menu_item obj
      = "ml_gtk_check_menu_item_new_with_label"
  let create ?label () =
    match label with None -> create ()
    | Some label -> create_with_label label
  external set_active : [>`checkmenuitem] obj -> bool -> unit
      = "ml_gtk_check_menu_item_set_active"
  external get_active : [>`checkmenuitem] obj -> bool
      = "ml_gtk_check_menu_item_get_active"
  external set_inconsistent : [>`checkmenuitem] obj -> bool -> unit
      = "ml_gtk_check_menu_item_set_inconsistent"
  external get_inconsistent : [>`checkmenuitem] obj -> bool
      = "ml_gtk_check_menu_item_get_inconsistent"
  external set_show_toggle : [>`checkmenuitem] obj -> bool -> unit
      = "ml_gtk_check_menu_item_set_show_toggle"
  let set ?active ?show_toggle ?right_justified w =
    may active ~f:(set_active w);
    may show_toggle ~f:(set_show_toggle w);
    may right_justified ~f:(MenuItem.set_right_justified w)
  external toggled : [>`checkmenuitem] obj -> unit
      = "ml_gtk_check_menu_item_toggled"
  module Signals = struct
    open GtkSignal
    let toggled =
      { name = "toggled"; classe = `checkmenuitem; marshaller = marshal_unit }
  end
end

module RadioMenuItem = struct
  let cast w : radio_menu_item obj = Object.try_cast w "GtkRadioMenuItem"
  external create : radio_menu_item group -> radio_menu_item obj
      = "ml_gtk_radio_menu_item_new"
  external create_with_label :
      radio_menu_item group -> string -> radio_menu_item obj
      = "ml_gtk_radio_menu_item_new_with_label"
  external create_with_mnemonic :
      radio_menu_item group -> string -> radio_menu_item obj
      = "ml_gtk_radio_menu_item_new_with_mnemonic"
  let create ?(group = None) ?(use_mnemonic=false) ?label () =
    match label with None -> create group
    | Some label -> 
	if use_mnemonic then create_with_mnemonic group label
	else create_with_label group label
  external set_group : [>`radiomenuitem] obj -> radio_menu_item group -> unit
      = "ml_gtk_radio_menu_item_set_group"
end

module OptionMenu = struct
  let cast w : option_menu obj = Object.try_cast w "GtkOptionMenu"
  external create : unit -> option_menu obj = "ml_gtk_option_menu_new"
  external get_menu : [>`optionmenu] obj -> menu obj
      = "ml_gtk_option_menu_get_menu"
  external set_menu : [>`optionmenu] obj -> [>`menu] obj -> unit
      = "ml_gtk_option_menu_set_menu"
  external remove_menu : [>`optionmenu] obj -> unit
      = "ml_gtk_option_menu_remove_menu"
  external set_history : [>`optionmenu] obj -> int -> unit
      = "ml_gtk_option_menu_set_history"
  let set ?menu ?history w =
    may menu ~f:(set_menu w);
    may history ~f:(set_history w)
end

module MenuShell = struct
  let cast w : menu_shell obj = Object.try_cast w "GtkMenuShell"
  external append : [>`menushell] obj -> [>`widget] obj -> unit
      = "ml_gtk_menu_shell_append"
  external prepend : [>`menushell] obj -> [>`widget] obj -> unit
      = "ml_gtk_menu_shell_prepend"
  external insert : [>`menushell] obj -> [>`widget] obj -> pos:int -> unit
      = "ml_gtk_menu_shell_insert"
  external deactivate : [>`menushell] obj -> unit
      = "ml_gtk_menu_shell_deactivate"
  module Signals = struct
    open GtkSignal
    let deactivate =
      { name = "deactivate"; classe = `menushell; marshaller = marshal_unit }
  end
end

module Menu = struct
  let cast w : menu obj = Object.try_cast w "GtkMenu"
  external create : unit -> menu obj = "ml_gtk_menu_new"
  external popup :
      [>`menu] obj -> [>`menushell] optobj ->
      [>`menuitem] optobj -> button:int -> time:int32 -> unit
      = "ml_gtk_menu_popup"
  let popup ?parent_menu ?parent_item w =
    popup w (Gpointer.optboxed parent_menu) (Gpointer.optboxed parent_item)
  external popdown : [>`menu] obj -> unit = "ml_gtk_menu_popdown"
  external get_active : [>`menu] obj -> widget obj= "ml_gtk_menu_get_active"
  external set_active : [>`menu] obj -> int -> unit = "ml_gtk_menu_set_active"
  external set_accel_group : [>`menu] obj -> accel_group -> unit
      = "ml_gtk_menu_set_accel_group"
  external get_accel_group : [>`menu] obj -> accel_group
      = "ml_gtk_menu_get_accel_group"
  external set_accel_path : [> `menu] obj -> string -> unit
    = "ml_gtk_menu_set_accel_path"
  external attach_to_widget : [>`menu] obj -> [>`widget] obj -> unit
      = "ml_gtk_menu_attach_to_widget"
  external get_attach_widget : [>`menu] obj -> widget obj
      = "ml_gtk_menu_get_attach_widget"
  external detach : [>`menu] obj -> unit = "ml_gtk_menu_detach"
  let set ?active ?accel_group w =
    may active ~f:(set_active w);
    may accel_group ~f:(set_accel_group w)
end

module MenuBar = struct
  let cast w : menu_bar obj = Object.try_cast w "GtkMenuBar"
  external create : unit -> menu_bar obj = "ml_gtk_menu_bar_new"
end
