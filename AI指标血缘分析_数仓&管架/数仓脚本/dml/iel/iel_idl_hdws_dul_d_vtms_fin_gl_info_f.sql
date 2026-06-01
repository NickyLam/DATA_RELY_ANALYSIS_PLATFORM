: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_vtms_fin_gl_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_vtms_fin_gl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.org_code,chr(13),''),chr(10),'') as org_code
,replace(replace(t1.sub_code,chr(13),''),chr(10),'') as sub_code
,replace(replace(t1.cur_code,chr(13),''),chr(10),'') as cur_code
,replace(replace(t1.data_date,chr(13),''),chr(10),'') as data_date
,replace(replace(t1.account_year,chr(13),''),chr(10),'') as account_year
,replace(replace(t1.stl_cali_cd,chr(13),''),chr(10),'') as stl_cali_cd
,replace(replace(t1.carr_ind_cd,chr(13),''),chr(10),'') as carr_ind_cd
,t1.begin_dr_balance as begin_dr_balance
,t1.begin_cr_balance as begin_cr_balance
,t1.trans_amt_dr as trans_amt_dr
,t1.trans_amt_cr as trans_amt_cr
,t1.end_dr_balance as end_dr_balance
,t1.end_cr_balance as end_cr_balance
,t1.begin_dr_m_balance as begin_dr_m_balance
,t1.begin_cr_m_balance as begin_cr_m_balance
,t1.trans_amt_m_dr as trans_amt_m_dr
,t1.trans_amt_m_cr as trans_amt_m_cr
,t1.end_dr_m_balance as end_dr_m_balance
,t1.end_cr_m_balance as end_cr_m_balance
from ${idl_schema}.hdws_dul_d_vtms_fin_gl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_vtms_fin_gl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes