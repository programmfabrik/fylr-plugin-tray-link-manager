class TrayLinkManagerBaseConfig extends BaseConfigPlugin
  getFieldDefFromParm: (baseConfig, pname, def, parent_def) ->

    if def.plugin_type != "tray-link-manager"
      return

    # TODO: GENERIEREN NACH FRONDENDSPRACHEN
    # TODO: GENERIEREN NACH FRONDENDSPRACHEN
    # TODO: GENERIEREN NACH FRONDENDSPRACHEN
    # TODO: GENERIEREN NACH FRONDENDSPRACHEN
    
    multi_input_control = new CUI.MultiInputControl
        user_control: true
        preferred_key: "de-DE"
        keys: [
            name: "de-DE"
            tag: "DE"
            enabled: true
            tooltip: text: "de-DE"
        ,
            name: "en-US"
            tag: "EN"
            tooltip: text: "en-US"
        ,
            name: "fr-FR"
            tag: "FR"
            tooltip: text: "fr-FR"
        ]
    
    field =
      type: CUI.Form
      name: "tray_link_manager"
      fields: [
        type: CUI.DataTable
        name: "data_table"
        fields: [
          form:
            label: $$("baseconfig.validation.selector.objecttype.label")
          type: CUI.MultiInput
          name: "objecttype"
          control: multi_input_control
        ,
          form:
            label: $$("baseconfig.validation.selector.validierung.label")
          type: CUI.Checkbox
          text: $$("baseconfig.validation.selector.validierung.activate.label")
          name: "activate"
        ]
      ]
    field

CUI.ready =>
  BaseConfig.registerPlugin(new TrayLinkManagerBaseConfig())
