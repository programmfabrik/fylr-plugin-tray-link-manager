class TrayLinkManagerApp extends TrayApp
            
    is_allowed: =>
        true

    getTrayButtons: =>
        that = @
        buttons = []

        # remove selection if url-switch
        document.addEventListener('click', (event) ->
            # is a button in tray menu selected?
            setTimeout ->
                if buttons.length > 0
                    for button in buttons
                        if button.hasClass('cui-selected tray-link-manager-plugin')
                            windowPath = window.location.pathname + window.location.search
                            buttonPath = button.getValue()
                            if buttonPath.indexOf("ShowInMainMenuApp") != -1
                                buttonParts = buttonPath.split("/")
                                buttonPath = buttonParts[buttonParts.length - 1]
                                windowParts = windowPath.split("/")
                                windowPath = windowParts[windowParts.length - 1]
                            windowPath = windowPath.replace(/\//g, '')
                            buttonPath = buttonPath.replace(/\//g, '')
                            if windowPath != buttonPath
                                button.removeClass('cui-selected tray-link-manager-plugin')
            , 750
        , true)
                                
        # get all usergroups
        userGroups = ez5.session.user.getGroups().map((group) => group.id);
        
        # get frontendlanguage
        frontend_language = ez5.session.frontend_language
        baseConfigTemplates = ez5.session.config.base?.plugin['tray-link-manager']?.config['Tray-Link-Manager']?.templates
        
        # concordance of all pathes and appnames
        appPathNamesConcordance = {}
        appPathNamesConcordance['ShowInMainMenuApp'] = '_Class'
            
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
                if appPathNamesConcordance[pathFirstPart] || pathFirstPart == 'ShowInMainMenuApp'
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
                            value: template.url
                            onClick: ((template, pathFirstPart, appPathNamesConcordance) =>
                                (evt, button) =>
                                    # mark this button as clicked
                                    for oneButton in buttons
                                        oneButton.removeClass('cui-selected tray-link-manager-plugin')
                                    button.addClass('cui-selected tray-link-manager-plugin')
                                    # default apps?
                                    if pathFirstPart != 'ShowInMainMenuApp'
                                        full_path = window.easydb_base_prefix + template.url
                                        window.history["pushState"]({}, null, full_path)
                                        selectedApp = ez5.rootMenu.__apps.find (app) ->
                                            app.name is appPathNamesConcordance[pathFirstPart]
                                    # "show-in-main-menu"-apps
                                    if pathFirstPart == 'ShowInMainMenuApp'
                                         #'/ShowInMainMenuApp/fa-adress-book/defaultvalues'
                                        templateUrlParts = template.url.split '/'
                                        objecttype = templateUrlParts.pop()
                                        icon = templateUrlParts.pop()
                                        full_path = window.easydb_base_prefix + '/lists/' + objecttype
                                        window.history["pushState"]({}, null, full_path)
                                        selectedApp = ez5.rootMenu.__apps.find (app) ->
                                            app.name is appPathNamesConcordance[pathFirstPart] and app?.objecttype == objecttype
                                    ez5.rootMenu.loadApp(selectedApp, false)
                                    ez5.rootMenu.setActiveApp(selectedApp)
                            )(template, pathFirstPart, appPathNamesConcordance)
                        buttons.push button
        return buttons
        
        
    getDisplay: =>
        super()
        
        CUI.setTimeout
            ms: 1000
            call: =>
                @updateDisplay()
                
        CUI.dom.append(@display, null)
        
        
    updateDisplay: =>
        CUI.dom.empty(@display)
        CUI.dom.append(@display, @getTrayButtons())
        

ez5.session_ready ->
    ez5.tray.registerApp(new TrayLinkManagerApp())