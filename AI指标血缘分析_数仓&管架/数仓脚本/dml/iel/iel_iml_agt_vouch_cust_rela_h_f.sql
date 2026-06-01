: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_vouch_cust_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_vouch_cust_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
    ,replace(replace(t.vouch_no,chr(13),''),chr(10),'') as vouch_no
    ,replace(replace(t.vouch_mgmt_id,chr(13),''),chr(10),'') as vouch_mgmt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.vouch_pay_org_id,chr(13),''),chr(10),'') as vouch_pay_org_id
    ,t.vouch_pay_dt as vouch_pay_dt
    ,replace(replace(t.vouch_pay_flow_id,chr(13),''),chr(10),'') as vouch_pay_flow_id
    ,replace(replace(t.vouch_rela_cust_id,chr(13),''),chr(10),'') as vouch_rela_cust_id
    ,replace(replace(t.vouch_rela_acct_id,chr(13),''),chr(10),'') as vouch_rela_acct_id
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_vouch_cust_rela_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_vouch_cust_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes