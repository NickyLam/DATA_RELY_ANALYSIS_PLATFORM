: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_mfd_business_table_d_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_mfd_business_table_d_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,branch_code
,curr_code
,acc_code
,itemna
,blncdn
,last_day_dr_bal
,last_day_cr_bal
,last_mon_dr_bal
,last_mon_cr_bal
,last_quar_dr_bal
,last_quar_cr_bal
,last_hyear_dr_bal
,last_hyear_cr_bal
,last_year_dr_bal
,last_year_cr_bal
,cur_day_dr_amt
,cur_day_cr_amt
,mon_dr_amt_cml
,mon_cr_amt_cml
,quar_dr_amt_cml
,quar_cr_amt_cml
,hyear_dr_amt_cml
,hyear_cr_amt_cml
,year_dr_amt_cml
,year_cr_amt_cml
,cur_day_dr_bal
,cur_day_cr_bal
,mon_dr_bal_cml
,mon_cr_bal_cml
,quar_dr_bal_cml
,quar_cr_bal_cml
,hyear_dr_bal_cml
,hyear_cr_bal_cml
,year_dr_bal_cml
,year_cr_bal_cml
from ${idl_schema}.orws_m_mfd_business_table_d
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_mfd_business_table_d_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes