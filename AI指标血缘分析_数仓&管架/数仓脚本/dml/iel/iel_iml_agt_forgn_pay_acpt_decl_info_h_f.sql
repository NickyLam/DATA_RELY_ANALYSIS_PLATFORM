: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_forgn_pay_acpt_decl_info_h_f
CreateDate: 20231110
FileName:   ${iel_data_path}/agt_forgn_pay_acpt_decl_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.decl_id,chr(13),''),chr(10),'') as decl_id
,replace(replace(t1.temp_decl_flow_id,chr(13),''),chr(10),'') as temp_decl_flow_id
,replace(replace(t1.init_enty_id,chr(13),''),chr(10),'') as init_enty_id
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t1.modif_rs_comnt,chr(13),''),chr(10),'') as modif_rs_comnt
,replace(replace(t1.decl_num,chr(13),''),chr(10),'') as decl_num
,replace(replace(t1.recver_permt_cty_rg_cd,chr(13),''),chr(10),'') as recver_permt_cty_rg_cd
,replace(replace(t1.pay_type_cd,chr(13),''),chr(10),'') as pay_type_cd
,replace(replace(t1.tran_id_1,chr(13),''),chr(10),'') as tran_id_1
,tran_amt_1
,replace(replace(t1.tran_postsc_1,chr(13),''),chr(10),'') as tran_postsc_1
,replace(replace(t1.tran_id_2,chr(13),''),chr(10),'') as tran_id_2
,tran_amt_2
,replace(replace(t1.tran_postsc_2,chr(13),''),chr(10),'') as tran_postsc_2
,replace(replace(t1.unbond_cargo_inco_flg,chr(13),''),chr(10),'') as unbond_cargo_inco_flg
,replace(replace(t1.decl_ps_name,chr(13),''),chr(10),'') as decl_ps_name
,replace(replace(t1.decl_ps_tel_num,chr(13),''),chr(10),'') as decl_ps_tel_num
,decl_dt
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id

from ${iml_schema}.agt_forgn_pay_acpt_decl_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_forgn_pay_acpt_decl_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
