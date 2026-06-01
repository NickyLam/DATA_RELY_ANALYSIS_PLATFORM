: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_lp_od_acct_tran_dtl_i
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_lp_od_acct_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,tran_dt
,replace(replace(t1.core_tran_org_id,chr(13),''),chr(10),'') as core_tran_org_id
,tran_amt
,actl_tran_amt
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,tran_tm
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_lp_od_acct_tran_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_lp_od_acct_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
