: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_prd_corp_crdt_prod_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_corp_crdt_prod_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.prod_id
,t.lp_id
,t.src_prod_id
,t.prod_name
,t.input_org_id
,t.input_tm
,t.prod_update_tm
,t.sellbl_prod_flg
,t.loan_size_ctrl_flg
,t.prod_catlg_id
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.prd_corp_crdt_prod t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_corp_crdt_prod_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes