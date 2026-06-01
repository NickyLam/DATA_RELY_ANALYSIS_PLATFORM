: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_imp_fin_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_imp_fin_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.intnal_id,chr(13),''),chr(10),'') as intnal_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,t1.base_rat as base_rat
,t1.actl_int_rat as actl_int_rat
,t1.exec_int_rat as exec_int_rat
,t1.value_dt as value_dt
,t1.last_int_stl_dt as last_int_stl_dt
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,t1.ovdue_int_rat as ovdue_int_rat
,t1.ovdue_dt as ovdue_dt
,t1.ovdue_begin_dt as ovdue_begin_dt
,replace(replace(t1.rela_obj_name,chr(13),''),chr(10),'') as rela_obj_name
,replace(replace(t1.rela_obj_id,chr(13),''),chr(10),'') as rela_obj_id
,replace(replace(t1.parent_bus_id,chr(13),''),chr(10),'') as parent_bus_id
,replace(replace(t1.parent_bus_descb,chr(13),''),chr(10),'') as parent_bus_descb
,t1.tran_oper_dt as tran_oper_dt
,t1.tran_cmplt_dt as tran_cmplt_dt
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.fin_type_cd,chr(13),''),chr(10),'') as fin_type_cd
,t1.fin_amt_ratio as fin_amt_ratio
,replace(replace(t1.fin_invo_cty_rg_cd,chr(13),''),chr(10),'') as fin_invo_cty_rg_cd
,replace(replace(t1.fin_curr_cd,chr(13),''),chr(10),'') as fin_curr_cd
,replace(replace(t1.fin_status_cd,chr(13),''),chr(10),'') as fin_status_cd
,t1.fin_days as fin_days
,t1.fin_exp_dt as fin_exp_dt
,t1.fin_rgst_dt as fin_rgst_dt
,replace(replace(t1.imp_fin_payfan_type_cd,chr(13),''),chr(10),'') as imp_fin_payfan_type_cd
,t1.payfan_nomal_int_rat as payfan_nomal_int_rat
,t1.payfan_value_dt as payfan_value_dt
,replace(replace(t1.bal_pay_type_cd,chr(13),''),chr(10),'') as bal_pay_type_cd
,t1.bal_pay_amt as bal_pay_amt
,replace(replace(t1.manuf_prd_type_cd,chr(13),''),chr(10),'') as manuf_prd_type_cd
,replace(replace(t1.mtg_flg,chr(13),''),chr(10),'') as mtg_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_imp_fin_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_imp_fin_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes