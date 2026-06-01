: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_dms_elec_chn_active_acct_chg_rat_f
CreateDate: 20180529
FileName:   ${iel_data_path}/monitor_${batch_date}_3.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select chn_type
      ,chn_id
      ,chn_tran_qtty 
  from idl.dms_elec_chn_active_acct_chg_rat 
 where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|" record="0x0a"  \
        file="${iel_data_path}/monitor_${batch_date}_3.dat" \
        charset=zhs16gbk
        safe=yes