*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS slis.

TYPES:
  BEGIN OF gty_spfli,
    carrid   TYPE s_carr_id,
    connid   TYPE s_conn_id,
    cityfrom TYPE s_from_cit,
    cityto   TYPE s_to_city,
    checked  TYPE c,
  END OF gty_spfli.

DATA: gtd_spfli           TYPE TABLE OF gty_spfli,
      gtd_fieldcat        TYPE slis_t_fieldcat_alv,
      gwa_fieldcat        TYPE slis_fieldcat_alv,
      gwa_layout          TYPE slis_layout_alv,
      gtd_events          TYPE slis_t_event,
      gwa_events          TYPE slis_alv_event,
      gtd_list_commentary TYPE slis_t_listheader,
      gwa_list_commentary TYPE slis_listheader.