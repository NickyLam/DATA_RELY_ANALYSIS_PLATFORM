: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_liab_acct_inpwn_rgst_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_liab_acct_inpwn_rgst_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.inpwn_id,chr(13),''),chr(10),'') as inpwn_id
,replace(replace(t.parent_inpwn_id,chr(13),''),chr(10),'') as parent_inpwn_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.prod_sub_acct_id,chr(13),''),chr(10),'') as prod_sub_acct_id
,replace(replace(t.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id
,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,t.mtg_amt as mtg_amt
,replace(replace(t.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t.froz_flow_num,chr(13),''),chr(10),'') as froz_flow_num
,t.froz_dt as froz_dt
,replace(replace(t.req_tran_flow_num,chr(13),''),chr(10),'') as req_tran_flow_num
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_liab_acct_inpwn_rgst_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_liab_acct_inpwn_rgst_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes