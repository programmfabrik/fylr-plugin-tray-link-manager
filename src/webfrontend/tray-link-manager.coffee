class TOBIExampleTrayApp extends TrayApp
    is_allowed: =>
        true

    getDisplay: =>
        super()
        
        # get all usergroups
        userGroups = ez5.session.user.getGroups().map((group) => group.id);
        
        # get frontendlanguage
        frontend_language = ez5.session.frontend_language
        baseConfigTemplates = ez5.session.config.base?.plugin['tray-link-manager']?.config['Tray-Link-Manager']?.templates
        
        # concordance of all pathes and appnames
        appPathNamesConcordance = {}
        for app in ez5.rootMenu.__apps
            if app.getPathname() != ''
                appPathNamesConcordance[app.getPathname().replace('/','')] = app.name
        if baseConfigTemplates
            for template, templateKey in baseConfigTemplates
                # label (l10n)
                loca_label = template?.name[frontend_language] ? ''
                # icon
                icon = template?.icon ? ''
                # check if first part of template.url is a valid path
                path = template.url
                if path[0] != '/'
                    path = '/' + path
                pathParts = path.split('/')
                pathFirstPart = pathParts[1];
                # if url has parameters
                if pathFirstPart.indexOf('?') != -1
                    pathFirstPartParts = pathFirstPart.split('?')
                    pathFirstPart = pathFirstPartParts[0]
                if appPathNamesConcordance[pathFirstPart]
                    # get allowed groups from template
                    templateGroups = template.groups.map((group) => group.group);
                    groupMatches = userGroups.some((value) ->
                        templateGroups.includes(value)
                    )
                    # if groups match
                    if groupMatches || templateGroups.length == 0
                        button = new LocaButton
                            text: loca_label # FROM CONFIG
                            icon_left: new CUI.Icon(class: icon)
                            onClick: ((template, pathFirstPart, appPathNamesConcordance) =>
                                () =>
                                    full_path = window.easydb_base_prefix + template.url
                                    window.history["pushState"]({}, null, full_path)
                                    selectedApp = ez5.rootMenu.__apps.find (app) ->
                                        app.name is appPathNamesConcordance[pathFirstPart]
                                    ez5.rootMenu.loadApp(selectedApp, false)
                            )(template, pathFirstPart, appPathNamesConcordance)

                        CUI.dom.append(@display, button)

ez5.session_ready ->
    ez5.tray.registerApp(new TOBIExampleTrayApp())
