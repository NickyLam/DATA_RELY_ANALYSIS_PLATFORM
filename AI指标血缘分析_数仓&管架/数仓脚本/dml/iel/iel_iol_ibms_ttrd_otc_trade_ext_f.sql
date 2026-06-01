: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_otc_trade_ext_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_otc_trade_ext.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,sysordid
      ,replace(replace(h_textfield_03,chr(13),''),chr(10),'') as h_textfield_03
      ,replace(replace(h_textfield_04,chr(13),''),chr(10),'') as h_textfield_04
      ,replace(replace(h_textfield_01,chr(13),''),chr(10),'') as h_textfield_01
      ,replace(replace(h_textfield_02,chr(13),''),chr(10),'') as h_textfield_02
      ,replace(replace(s_textfield_01,chr(13),''),chr(10),'') as s_textfield_01
      ,replace(replace(s_textfield_02,chr(13),''),chr(10),'') as s_textfield_02
      ,replace(replace(s_textfield_03,chr(13),''),chr(10),'') as s_textfield_03
      ,replace(replace(s_textfield_04,chr(13),''),chr(10),'') as s_textfield_04
      ,h_numberfield_01
      ,h_numberfield_02
      ,h_numberfield_03
      ,h_numberfield_04
      ,s_numberfield_01
      ,s_numberfield_02
      ,s_numberfield_03
      ,s_numberfield_04
      ,replace(replace(h_datefield_01,chr(13),''),chr(10),'') as h_datefield_01
      ,replace(replace(h_datefield_02,chr(13),''),chr(10),'') as h_datefield_02
      ,replace(replace(h_datefield_03,chr(13),''),chr(10),'') as h_datefield_03
      ,replace(replace(h_datefield_04,chr(13),''),chr(10),'') as h_datefield_04
      ,replace(replace(s_datefield_01,chr(13),''),chr(10),'') as s_datefield_01
      ,replace(replace(s_datefield_02,chr(13),''),chr(10),'') as s_datefield_02
      ,replace(replace(s_datefield_03,chr(13),''),chr(10),'') as s_datefield_03
      ,replace(replace(s_datefield_04,chr(13),''),chr(10),'') as s_datefield_04
      ,replace(replace(h_combobox_01,chr(13),''),chr(10),'') as h_combobox_01
      ,replace(replace(h_combobox_02,chr(13),''),chr(10),'') as h_combobox_02
      ,replace(replace(h_combobox_03,chr(13),''),chr(10),'') as h_combobox_03
      ,replace(replace(h_combobox_04,chr(13),''),chr(10),'') as h_combobox_04
      ,replace(replace(s_combobox_01,chr(13),''),chr(10),'') as s_combobox_01
      ,replace(replace(s_combobox_02,chr(13),''),chr(10),'') as s_combobox_02
      ,replace(replace(s_combobox_03,chr(13),''),chr(10),'') as s_combobox_03
      ,replace(replace(s_combobox_04,chr(13),''),chr(10),'') as s_combobox_04
      ,replace(replace(h_textarea_01,chr(13),''),chr(10),'') as h_textarea_01
      ,replace(replace(h_textarea_02,chr(13),''),chr(10),'') as h_textarea_02
      ,replace(replace(s_textarea_01,chr(13),''),chr(10),'') as s_textarea_01
      ,replace(replace(s_textarea_02,chr(13),''),chr(10),'') as s_textarea_02
      ,replace(replace(h_dayrange_01,chr(13),''),chr(10),'') as h_dayrange_01
      ,replace(replace(h_dayrange_02,chr(13),''),chr(10),'') as h_dayrange_02
      ,replace(replace(h_dayrange_03,chr(13),''),chr(10),'') as h_dayrange_03
      ,replace(replace(h_dayrange_04,chr(13),''),chr(10),'') as h_dayrange_04
      ,replace(replace(h_dayrange_05,chr(13),''),chr(10),'') as h_dayrange_05
      ,replace(replace(h_hidden_01,chr(13),''),chr(10),'') as h_hidden_01
      ,h_amount_01
      ,h_amount_02
      ,h_amount_03
      ,h_amount_04
      ,h_rate_01
      ,h_rate_02
      ,h_rate_03
      ,h_rate_04
      ,h_rate_05
      ,h_rate_07_f4
  from ${iol_schema}.ibms_ttrd_otc_trade_ext t1
 where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_otc_trade_ext.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes