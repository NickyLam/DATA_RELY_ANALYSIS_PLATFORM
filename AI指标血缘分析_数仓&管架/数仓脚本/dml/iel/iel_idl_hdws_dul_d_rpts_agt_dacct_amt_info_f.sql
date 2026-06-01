: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_dacct_amt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_dacct_amt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(dpst_acct_id,chr(10),''),chr(13),'') as dpst_acct_id
      ,replace(replace(agt_modf,chr(10),''),chr(13),'') as agt_modf
      ,etl_dt
      ,last_update_dt
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,open_amt
      ,prcp_amt
      ,acct_bal
      ,usable_bal
      ,dacct_acct_frz_amt
      ,lowest_bal
      ,rtain_amt
      ,depo_amt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_rpts_agt_dacct_amt_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_dacct_amt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes