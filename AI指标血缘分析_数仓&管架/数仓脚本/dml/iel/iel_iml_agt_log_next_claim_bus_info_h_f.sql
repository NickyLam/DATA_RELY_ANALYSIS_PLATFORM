: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_log_next_claim_bus_info_h_f
CreateDate: 20231110
FileName:   ${iel_data_path}/agt_log_next_claim_bus_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.intnal_id,chr(13),''),chr(10),'') as intnal_id
,replace(replace(t1.log_claim_id,chr(13),''),chr(10),'') as log_claim_id
,replace(replace(t1.log_agt_id,chr(13),''),chr(10),'') as log_agt_id
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,appl_dt
,create_date
,effect_dt
,invalid_dt
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.claim_kind_cd,chr(13),''),chr(10),'') as claim_kind_cd
,replace(replace(t1.claim_type_cd,chr(13),''),chr(10),'') as claim_type_cd
,claim_dt
,replace(replace(t1.cancel_log_next_pay_flg,chr(13),''),chr(10),'') as cancel_log_next_pay_flg
,refuse_revid_msg_dt
,replace(replace(t1.payer_type_id,chr(13),''),chr(10),'') as payer_type_id
,replace(replace(t1.accptor_type_id,chr(13),''),chr(10),'') as accptor_type_id
,replace(replace(t1.free_pay_flg,chr(13),''),chr(10),'') as free_pay_flg
,replace(replace(t1.bus_oper_org_id,chr(13),''),chr(10),'') as bus_oper_org_id
,replace(replace(t1.bus_belong_org_id,chr(13),''),chr(10),'') as bus_belong_org_id
,replace(replace(t1.nra_pay_flg,chr(13),''),chr(10),'') as nra_pay_flg
,replace(replace(t1.clear_chn_cd,chr(13),''),chr(10),'') as clear_chn_cd

from ${iml_schema}.agt_log_next_claim_bus_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_log_next_claim_bus_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
