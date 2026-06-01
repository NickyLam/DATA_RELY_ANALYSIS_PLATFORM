: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_a_m_gl_base_ft_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_a_m_gl_base_ft_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select date_id
,period_id
,branch_code
,curr_code
,acc_code
,last_year_dr_bal
,last_year_cr_bal
,last_quar_dr_bal
,last_quar_cr_bal
,last_mon_dr_bal
,last_mon_cr_bal
,last_day_dr_bal
,last_day_cr_bal
,cur_day_dr_amt
,cur_day_cr_amt
,cur_day_dr_cnt
,cur_day_cr_cnt
,cur_day_dr_bal
,cur_day_cr_bal
,diff_bal
,bak_1
,bak_2
,bak_3
,flag
,last_hyear_dr_bal
,last_hyear_cr_bal 
from idl.pirs_a_m_gl_base_ft where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_a_m_gl_base_ft_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes