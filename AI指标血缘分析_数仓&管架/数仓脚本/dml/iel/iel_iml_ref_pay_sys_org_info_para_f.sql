: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_pay_sys_org_info_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_pay_sys_org_info_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pay_sys_org_info_id,chr(13),''),chr(10),'') as pay_sys_org_info_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prtcpt_org_bank_no,chr(13),''),chr(10),'') as prtcpt_org_bank_no
,replace(replace(t1.prtcpt_org_cate_cd,chr(13),''),chr(10),'') as prtcpt_org_cate_cd
,replace(replace(t1.bank_type_cd,chr(13),''),chr(10),'') as bank_type_cd
,replace(replace(t1.belong_dir_bk_num,chr(13),''),chr(10),'') as belong_dir_bk_num
,replace(replace(t1.belong_lp_id,chr(13),''),chr(10),'') as belong_lp_id
,replace(replace(t1.super_prtcpt_org_id,chr(13),''),chr(10),'') as super_prtcpt_org_id
,replace(replace(t1.udtake_bank_no,chr(13),''),chr(10),'') as udtake_bank_no
,replace(replace(t1.durdt_bank_no,chr(13),''),chr(10),'') as durdt_bank_no
,replace(replace(t1.belong_pay_sys_cd,chr(13),''),chr(10),'') as belong_pay_sys_cd
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t1.prtcpt_org_cn_name,chr(13),''),chr(10),'') as prtcpt_org_cn_name
,replace(replace(t1.tel_num_or_cable_addr,chr(13),''),chr(10),'') as tel_num_or_cable_addr
,replace(replace(t1.pbc_bigamt_bus_sys_flg,chr(13),''),chr(10),'') as pbc_bigamt_bus_sys_flg
,replace(replace(t1.effect_type_cd,chr(13),''),chr(10),'') as effect_type_cd
,effect_dt
,invalid_dt

from ${iml_schema}.ref_pay_sys_org_info_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_pay_sys_org_info_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
