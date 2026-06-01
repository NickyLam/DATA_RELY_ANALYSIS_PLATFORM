: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_fin_gl_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_fin_gl_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(rtrim(t1.org_id),chr(13),''),chr(10),'') as org_id
,replace(replace(rtrim(t1.accting_coa_id),chr(13),''),chr(10),'') as accting_coa_id
,replace(replace(rtrim(t1.ccy_cd),chr(13),''),chr(10),'') as ccy_cd
,decode(t1.etl_dt,date'0001-01-01',cast('' as date),t1.etl_dt) as etl_dt
,decode(t1.acct_dt,date'0001-01-01',cast('' as date),t1.acct_dt) as acct_dt
,replace(replace(rtrim(t1.stl_cali_cd),chr(13),''),chr(10),'') as stl_cali_cd
,replace(replace(rtrim(t1.carr_ind_cd),chr(13),''),chr(10),'') as carr_ind_cd
,t1.debit_bal as debit_bal
,t1.cr_bal as cr_bal
,t1.debit_amt as debit_amt
,t1.cr_amt as cr_amt
,t1.d_rpt_d_bal as d_rpt_d_bal
,t1.d_rpt_c_bal as d_rpt_c_bal
,t1.yestd_d_bal as yestd_d_bal
,t1.yestd_c_bal as yestd_c_bal
,t1.yestd_rpt_d_bal as yestd_rpt_d_bal
,t1.yestd_rpt_c_bal as yestd_rpt_c_bal
,t1.days10_begin_d_bal as days10_begin_d_bal
,t1.days10_begin_c_bal as days10_begin_c_bal
,t1.m_begin_d_bal as m_begin_d_bal
,t1.m_begin_c_bal as m_begin_c_bal
,t1.m_begin_d_rpt_bal as m_begin_d_rpt_bal
,t1.m_begin_c_rpt_bal as m_begin_c_rpt_bal
,t1.m_amt_debit as m_amt_debit
,t1.m_amt_cr as m_amt_cr
,t1.q_begin_d_bal as q_begin_d_bal
,t1.q_begin_c_bal as q_begin_c_bal
,t1.q_begin_d_rpt_bal as q_begin_d_rpt_bal
,t1.q_begin_c_rpt_bal as q_begin_c_rpt_bal
,t1.q_amt_debit as q_amt_debit
,t1.q_amt_cr as q_amt_cr
,t1.hy_begin_d_bal as hy_begin_d_bal
,t1.hy_begin_c_bal as hy_begin_c_bal
,t1.hy_begin_d_rpt_bal as hy_begin_d_rpt_bal
,t1.hy_begin_c_rpt_bal as hy_begin_c_rpt_bal
,t1.hy_amt_d as hy_amt_d
,t1.hy_amt_c as hy_amt_c
,t1.y_begin_d_bal as y_begin_d_bal
,t1.y_begin_c_bal as y_begin_c_bal
,t1.y_begin_d_rpt_bal as y_begin_d_rpt_bal
,t1.y_begin_c_rpt_bal as y_begin_c_rpt_bal
,t1.y_amt_d as y_amt_d
,t1.y_amt_c as y_amt_c
,replace(replace(rtrim(t1.src_sys_name),chr(13),''),chr(10),'') as src_sys_name
,replace(replace(rtrim(t1.data_src_cd),chr(13),''),chr(10),'') as data_src_cd
from iml.fin_gl_info@tmp_hdwdb t1
where etl_dt >= to_date('20210101','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_fin_gl_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes