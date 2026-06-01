: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bill_discount_dtl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_discount_dtl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.discount_dtl_id as discount_dtl_id
,t.cont_id as cont_id
,t.bill_id as bill_id
,t.bill_amt as bill_amt
,t.bill_exp_dt as bill_exp_dt
,t.actl_exp_dt as actl_exp_dt
,t.surp_tenor as surp_tenor
,t.exp_surp_tenor as exp_surp_tenor
,t.int_paybl as int_paybl
,t.exp_int_paybl as exp_int_paybl
,t.stl_amt as stl_amt
,t.exp_stl_amt as exp_stl_amt
,t.lmt_ocup_status_cd as lmt_ocup_status_cd
,t.proc_status_cd as proc_status_cd
,t.entry_status_cd as entry_status_cd
,t.valid_flg as valid_flg
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_bill_discount_dtl t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discount_dtl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes