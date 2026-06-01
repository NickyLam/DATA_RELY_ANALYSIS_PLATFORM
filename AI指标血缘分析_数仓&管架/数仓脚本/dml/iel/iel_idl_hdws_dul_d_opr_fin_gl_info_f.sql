: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_fin_gl_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_fin_gl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
org_id
,accting_coa_id
,ccy_cd
,etl_dt
,acct_dt
,stl_cali_cd
,carr_ind_cd
,debit_bal
,cr_bal
,debit_amt
,cr_amt
,d_rpt_d_bal
,d_rpt_c_bal
,yestd_d_bal
,yestd_c_bal
,yestd_rpt_d_bal
,yestd_rpt_c_bal
,days10_begin_d_bal
,days10_begin_c_bal
,m_begin_d_bal
,m_begin_c_bal
,m_begin_d_rpt_bal
,m_begin_c_rpt_bal
,m_amt_debit
,m_amt_cr
,q_begin_d_bal
,q_begin_c_bal
,q_begin_d_rpt_bal
,q_begin_c_rpt_bal
,q_amt_debit
,q_amt_cr
,hy_begin_d_bal
,hy_begin_c_bal
,hy_begin_d_rpt_bal
,hy_begin_c_rpt_bal
,hy_amt_d
,hy_amt_c
,y_begin_d_bal
,y_begin_c_bal
,y_begin_d_rpt_bal
,y_begin_c_rpt_bal
,y_amt_d
,y_amt_c
,src_sys_name
,data_src_cd
from ${idl_schema}.hdws_dul_d_opr_fin_gl_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_fin_gl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes