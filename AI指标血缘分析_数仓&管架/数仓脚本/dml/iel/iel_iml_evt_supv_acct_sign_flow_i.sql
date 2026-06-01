: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_supv_acct_sign_flow_i
CreateDate: 20230927
FileName:   ${iel_data_path}/evt_supv_acct_sign_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.supv_acct_id,chr(13),''),chr(10),'') as supv_acct_id
,sign_dt
,replace(replace(t1.supv_acct_name,chr(13),''),chr(10),'') as supv_acct_name
,replace(replace(t1.supv_status_cd,chr(13),''),chr(10),'') as supv_status_cd
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,open_acct_dt
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
,replace(replace(t1.proj_name,chr(13),''),chr(10),'') as proj_name
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.cotas_tel,chr(13),''),chr(10),'') as cotas_tel
,rels_dt
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t1.send_status_cd,chr(13),''),chr(10),'') as send_status_cd
,replace(replace(t1.oper_rest_cd,chr(13),''),chr(10),'') as oper_rest_cd
,replace(replace(t1.return_info_desc,chr(13),''),chr(10),'') as return_info_desc
,final_modif_tm
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.check_org_id,chr(13),''),chr(10),'') as check_org_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.auth_org_id,chr(13),''),chr(10),'') as auth_org_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.prpery_flow_num,chr(13),''),chr(10),'') as prpery_flow_num
,replace(replace(t1.sys_in_flow_num,chr(13),''),chr(10),'') as sys_in_flow_num
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_supv_acct_sign_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_supv_acct_sign_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
