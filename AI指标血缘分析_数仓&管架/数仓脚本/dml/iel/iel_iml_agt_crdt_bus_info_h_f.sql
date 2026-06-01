: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_crdt_bus_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_crdt_bus_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_crdt_stage_cd,chr(13),''),chr(10),'') as curr_crdt_stage_cd
,replace(replace(t1.init_src_sys_cd,chr(13),''),chr(10),'') as init_src_sys_cd
,replace(replace(t1.init_src_bus_id,chr(13),''),chr(10),'') as init_src_bus_id
,replace(replace(t1.happ_way_cd,chr(13),''),chr(10),'') as happ_way_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,open_amt
,nmal_amt
,exec_nmal_amt
,exec_open_amt
,aval_nmal_amt
,aval_open_amt
,crdt_nmal_bal
,crdt_open_bal
,exec_dr_open_amt
,replace(replace(t1.dr_open_curr_cd,chr(13),''),chr(10),'') as dr_open_curr_cd
,dr_open_amt
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
,amt_convt_coef
,effect_dt
,exp_dt
,replace(replace(t1.ocup_idf_cd,chr(13),''),chr(10),'') as ocup_idf_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,day_tenor
,mon_tenor
,acm_distr_amt
,acm_repay_amt
,actl_invalid_dt
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.mgmt_teller_id,chr(13),''),chr(10),'') as mgmt_teller_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,margin_amt
,pm_rat
,float_int_rat
,bal_update_tm
,actl_ocup_pre_ocup_nmal_amt
,actl_ocup_pre_ocup_open_amt
,replace(replace(t1.pre_ocup_id,chr(13),''),chr(10),'') as pre_ocup_id

from ${iml_schema}.agt_crdt_bus_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_crdt_bus_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
