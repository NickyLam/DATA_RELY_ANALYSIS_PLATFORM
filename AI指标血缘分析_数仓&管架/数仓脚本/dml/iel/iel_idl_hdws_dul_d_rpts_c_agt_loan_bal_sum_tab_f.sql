: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_c_agt_loan_bal_sum_tab_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_c_agt_loan_bal_sum_tab.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(dbill_num,chr(10),''),chr(13),'') as dbill_num
      ,loan_bal
      ,mon_accum
      ,qtr_accum
      ,year_accum
      ,mavg
      ,qavg
      ,yavg
      ,last_bal
      ,last_mon_accum
      ,last_qtr_accum
      ,last_year_accum
      ,last_mavg
      ,last_qavg
      ,last_yavg
      ,last_me_bal
      ,last_me_mon_accum
      ,last_me_qtr_accum
      ,last_me_year_accum
      ,last_me_mavg
      ,last_me_qavg
      ,last_me_yavg
      ,last_qtr_bal
      ,last_qtr_mon_accum
      ,last_qtr_qtr_accum
      ,last_qtr_year_accum
      ,last_qtr_mavg
      ,last_qtr_qavg
      ,last_qtr_yavg
      ,last_year_bal
      ,last_year_mon_accum
      ,last_year_qtr_accum
      ,last_year_year_accum
      ,last_year_mavg
      ,last_year_qavg
      ,last_year_yavg 
from idl.hdws_dul_d_rpts_c_agt_loan_bal_sum_tab 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_c_agt_loan_bal_sum_tab.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes