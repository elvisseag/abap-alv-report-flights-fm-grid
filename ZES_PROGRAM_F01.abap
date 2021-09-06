*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT carrid connid cityfrom cityto
    INTO TABLE gtd_spfli
    FROM spfli
    WHERE carrid IN s_carr.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat .

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'CARRID'.
  gwa_fieldcat-seltext_l = 'Airline Code'. "40
  "gwa_fieldcat-seltext_m = 'Airline Code'. "20
  "gwa_fieldcat-seltext_s = 'Airline Code'. "10
  gwa_fieldcat-key       = 'X'. "Columna clave
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'CONNID'.
  gwa_fieldcat-seltext_l = 'Flight Number'.
  gwa_fieldcat-key       = 'X'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'CITYFROM'.
  gwa_fieldcat-seltext_l = 'Departure city'.
  gwa_fieldcat-outputlen = 20.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'CITYTO'.
  gwa_fieldcat-seltext_l = 'Arrival city'.
  gwa_fieldcat-outputlen = 20.
  gwa_fieldcat-hotspot   = 'X'. "permite click
  gwa_fieldcat-just      = 'C'. "center
  APPEND gwa_fieldcat TO gtd_fieldcat.


ENDFORM.                    " BUILD_FIELDCAT

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv_grid .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
*     i_callback_pf_status_set = 'SET_PF_STATUS'
*     i_callback_user_command  = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE   = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' ' 
      i_grid_title             = 'Resultados'
*     I_GRID_SETTINGS          =
      is_layout                = gwa_layout
      it_fieldcat              = gtd_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
      it_events                = gtd_events
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = gtd_spfli
*   EXCEPTIONS
*     PROGRAM_ERROR            = 1
*     OTHERS                   = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
    WRITE 'Exception error'.
  ENDIF.


ENDFORM.                    " DISPLAY_ALV_GRID
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_layout .

  CLEAR: gwa_layout.
  gwa_layout-zebra = 'X'.
  gwa_layout-box_fieldname = 'CHECKED'. "permite selección 'X' el campo checked en la tabla alv
*  gwa_layout-edit  = 'X'. "Celdas editables

ENDFORM.                    " BUILD_LAYOUT


*&---------------------------------------------------------------------*
*&      Form  ADD_EVENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM add_events .

  CLEAR: gwa_events.
  gwa_events-name = 'TOP_OF_PAGE'.
  gwa_events-form = 'TOP_OF_PAGE'.
  APPEND gwa_events TO gtd_events.

  CLEAR: gwa_events.
  gwa_events-name = 'PF_STATUS_SET'.
  gwa_events-form = 'PF_STATUS_SET'.
  APPEND gwa_events TO gtd_events.

  CLEAR: gwa_events.
  gwa_events-name = 'USER_COMMAND'.
  gwa_events-form = 'USER_COMMAND'.
  APPEND gwa_events TO gtd_events.

ENDFORM.                    " ADD_EVENTS

FORM user_command USING p_ucomm    LIKE sy-ucomm
                        p_selfield TYPE slis_selfield.

  DATA: ln_nrorow(6)   TYPE n,
        ls_namecol(30) TYPE c,
        ls_value(60)   TYPE c,
        lst_message    TYPE string.

  ln_nrorow  = p_selfield-tabindex.
  ls_namecol = p_selfield-fieldname.
  ls_value   = p_selfield-value.

  CONDENSE: ln_nrorow, ls_namecol, ls_value.

  IF p_ucomm EQ '&INF'.
    MESSAGE 'Detalles del vuelo' TYPE'I'.
  ENDIF.


  "rs_selfield-refresh = 'X'. "refrescar ALV



  CONCATENATE 'Row [' ln_nrorow '], Field [' ls_namecol '], Value [' ls_value ']'
         INTO lst_message RESPECTING BLANKS.

  MESSAGE lst_message TYPE 'S'.

ENDFORM.

FORM pf_status_set USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'STATUS_0100'.

ENDFORM.

FORM top_of_page.

  REFRESH: gtd_list_commentary.

  CLEAR: gwa_list_commentary.
  gwa_list_commentary-typ = 'H'.
  gwa_list_commentary-info = 'Available Flights'.
  APPEND gwa_list_commentary TO gtd_list_commentary.

  CLEAR: gwa_list_commentary.
  gwa_list_commentary-typ = 'S'.
  CONCATENATE 'User: ' sy-uname INTO gwa_list_commentary-info RESPECTING BLANKS.
  APPEND gwa_list_commentary TO gtd_list_commentary.

  CLEAR: gwa_list_commentary.
  gwa_list_commentary-typ = 'A'.
  CONCATENATE 'User: ' sy-uname INTO gwa_list_commentary-info RESPECTING BLANKS.
  APPEND gwa_list_commentary TO gtd_list_commentary.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary       = gtd_list_commentary
*         I_LOGO                   =
*         I_END_OF_LIST_GRID       =
*         I_ALV_FORM               =
                .

ENDFORM.