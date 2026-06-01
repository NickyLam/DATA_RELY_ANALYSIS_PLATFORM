: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_log_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_log_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.log_bus_id,chr(13),''),chr(10),'') as log_bus_id
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,log_effect_dt
,full_amt_pay_dt
,indent_dt
,log_invalid_dt
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
,replace(replace(t1.edit_id,chr(13),''),chr(10),'') as edit_id
,replace(replace(t1.log_open_type_cd,chr(13),''),chr(10),'') as log_open_type_cd
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cancel_rs_cd,chr(13),''),chr(10),'') as cancel_rs_cd
,decrs_lmt_amt
,replace(replace(t1.decrs_lmt_curr_cd,chr(13),''),chr(10),'') as decrs_lmt_curr_cd
,decrs_lmt_dt
,replace(replace(t1.bal_curr_cd,chr(13),''),chr(10),'') as bal_curr_cd
,bal
,replace(replace(t1.acpt_flg,chr(13),''),chr(10),'') as acpt_flg
,acpt_ratio
,open_dt
,replace(replace(t1.acpt_way_cd,chr(13),''),chr(10),'') as acpt_way_cd
,replace(replace(t1.log_kind_cd,chr(13),''),chr(10),'') as log_kind_cd
,charge_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.decrs_lmt_flg,chr(13),''),chr(10),'') as decrs_lmt_flg
,margin_recvbl_ratio
,replace(replace(t1.mtg_bus_flg,chr(13),''),chr(10),'') as mtg_bus_flg
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,margin_actl_recv_ratio
,replace(replace(t1.fin_log_flg,chr(13),''),chr(10),'') as fin_log_flg
,replace(replace(t1.open_type_cd,chr(13),''),chr(10),'') as open_type_cd
,create_dt
,update_dt

from ${iml_schema}.agt_log_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_log_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
