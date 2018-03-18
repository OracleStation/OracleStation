# `/datum/oracle_ui`

This datum is a replacement for tgui which does not use any Node.js dependencies, and works entirely through raw HTML, JS and CSS. It's designed to be reasonably easy to port something from tgui to oracle_ui.

### How to create a UI

For this example, we're going to port the disposals bin from tgui to oracle_ui.

#### Step 1

In order to create a UI, you will first need to create an instance of `/datum/oracle_ui` or one of its subclasses, in this case `/datum/oracle_ui/themed/nano`.

You need to pass in `src`, the width of the window, the height of the window, and the template to render from. You can optionally set some flags to disallow window resizing and whether to automatically refresh the UI.

`code/modules/recycling/disposal-unit.dm`
```dm
/obj/machinery/disposal/bin/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()
	ui = new /datum/oracle_ui/themed/nano(src, 330, 190, "disposal_bin")
	ui.auto_refresh = TRUE
	ui.can_resize = FALSE
```

#### Step 2

You will now need to make a template in `html/oracle_ui/content/{template_name}`.

Values defined as `@{value}` will get replaced at runtime by oracle_ui.

`html/oracle_ui/content/disposal_bin/index.html`
```html
<div class='display'>
	<section>
		<span class='label'>State:</span>
		<div class='content' id="full_pressure">@{full_pressure}</div>
	</section>
    <section>
		<span class='label'>Pressure:</span>
		<div class='content'>
			<div class='progressBar' id='per'>
				<div class='progressFill' style="width: @{per}"></div>
				<div class='progressLabel'>@{per}</div>
			</div>
		</div>
	</section>
    <section>
		<span class='label'>Handle:</span>
		<div class='content' id="flush">@{flush}</div>
	</section>
	<section>
		<span class='label'>Eject:</span>
		<div class='content' id="contents">@{contents}</div>
	</section>
	<section>
		<span class='label'>Compressor:</span>
		<div class='content' id="pressure_charging">@{pressure_charging}</div>
	</section>
</div>
```

#### Step 3

Now you need to implement the methods that provide data to oracle_ui. `oui_data` can be adapted from the `ui_data` proc that tgui uses.

The `act` proc generates a hyperlink that will result in `oui_act` getting called on your object when clicked. The `class` argument defines a css class to be added to the hyperlink, and disabled determines whether the hyperlink will be disabled or not.

Calling `soft_update_fields` will result in the UI being updated on all clients, which is useful when the object changes state.

`code/modules/recycling/disposal-unit.dm`
```dm
/obj/machinery/disposal/bin/oui_data(mob/user)
	var/list/data = list()
	data["flush"] = flush ? ui.act("Disengage", user, "handle-0", class="active") : ui.act("Engage", user, "handle-1")
	data["full_pressure"] = full_pressure ? "Ready" : (pressure_charging ? "Pressurizing" : "Off")
	data["pressure_charging"] = pressure_charging ? ui.act("Turn Off", user, "pump-0", class="active", disabled=full_pressure) : ui.act("Turn On", user, "pump-1", disabled=full_pressure)
	var/per = full_pressure ? 100 : Clamp(100* air_contents.return_pressure() / (SEND_PRESSURE), 0, 99)
	data["per"] = "[round(per, 1)]%"
	data["contents"] = ui.act("Eject Contents", user, "eject", disabled=contents.len < 1)
	data["isai"] = isAI(user)
	return data

/obj/machinery/disposal/bin/oui_act(mob/user, action, list/params)
	if(..())
		return
	switch(action)
		if("handle-0")
			flush = FALSE
			update_icon()
			. = TRUE
		if("handle-1")
			if(!panel_open)
				flush = TRUE
				update_icon()
			. = TRUE
		if("pump-0")
			if(pressure_charging)
				pressure_charging = FALSE
				update_icon()
			. = TRUE
		if("pump-1")
			if(!pressure_charging)
				pressure_charging = TRUE
				update_icon()
			. = TRUE
		if("eject")
			eject()
			. = TRUE
	ui.soft_update_fields()
```

#### Step 4

You now need to hook in and ensure oracle_ui is invoked upon clicking. `render` should be used to open the UI for a user, typically on click.

`code/modules/recycling/disposal-unit.dm`
```dm
/obj/machinery/disposal/bin/ui_interact(mob/user, state)
	if(stat & BROKEN)
		return
	if(user.loc == src)
		to_chat(user, "<span class='warning'>You cannot reach the controls from inside!</span>")
		return
	ui.render(user)
```

#### Done

You should have a functional UI at this point. Some additional odds and ends can be discovered throughout `code/modules/recycling/disposal-unit.dm`. For a full diff of the changes made to it, refer to [the original pull request on GitHub](https://github.com/OracleStation/OracleStation/pull/702/files#diff-4b6c20ec7d37222630e7524d9577e230).
