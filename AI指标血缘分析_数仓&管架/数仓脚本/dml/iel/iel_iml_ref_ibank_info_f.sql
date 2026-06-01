: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_ibank_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_ibank_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bank_cls_id,chr(13),''),chr(10),'') as bank_cls_id
,replace(replace(t1.super_prtcpt_bank_no,chr(13),''),chr(10),'') as super_prtcpt_bank_no
,replace(replace(t1.super_bank_list,chr(13),''),chr(10),'') as super_bank_list
,replace(replace(t1.belong_bank_no,chr(13),''),chr(10),'') as belong_bank_no
,replace(replace(t1.prtcpt_type_cd,chr(13),''),chr(10),'') as prtcpt_type_cd
,replace(replace(t1.bank_type_cd,chr(13),''),chr(10),'') as bank_type_cd
,replace(replace(t1.node_cd,chr(13),''),chr(10),'') as node_cd
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.bank_fname,chr(13),''),chr(10),'') as bank_fname
,replace(replace(t1.bank_abbr,chr(13),''),chr(10),'') as bank_abbr
,replace(replace(t1.phys_addr,chr(13),''),chr(10),'') as phys_addr
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.elec_addr,chr(13),''),chr(10),'') as elec_addr
,effect_dt
,invalid_dt
,replace(replace(t1.cert_bind_cn_region,chr(13),''),chr(10),'') as cert_bind_cn_region
,replace(replace(t1.cert_bind_sn_region,chr(13),''),chr(10),'') as cert_bind_sn_region
,replace(replace(t1.cert_bind_status,chr(13),''),chr(10),'') as cert_bind_status
,cert_bind_effect_dt
,cert_bind_invalid_dt
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
,final_update_tm
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.ref_ibank_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ibank_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
