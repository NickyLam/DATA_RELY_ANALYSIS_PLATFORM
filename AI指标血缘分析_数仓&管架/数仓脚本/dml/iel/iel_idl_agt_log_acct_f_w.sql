: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_log_acct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_log_acct_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.log_cont_id
,t1.out_acct_acct_id
,t1.acct_subj_id
,t1.log_type_cd
,t1.guar_org_id
,t1.applit_stl_acct_id
,t1.value_dt
,t1.exp_dt
,t1.curr_cd
,t1.log_amt
,t1.benefc_acct_id
,t1.benefc_name
,t1.benefc_open_bank_name
,t1.ovdue_int_rat
,t1.comm_fee_fee_rat
,t1.open_dt
,t1.open_flow_num
,t1.log_acct_id
,t1.wrtoff_dt
,t1.wrtoff_flow_num
,t1.wrtoff_way_cd
,t1.compens_amt
,t1.recvbl_acct_id
,t1.advc_flg
,t1.advc_dubil_id
,t1.advc_amt
,t1.remark
,t1.agt_status_cd
,t1.guar_way_cd
,t1.margin_amt
,t1.int_accr_way_cd
,t1.crdt_cont_id
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_log_acct t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_log_acct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes