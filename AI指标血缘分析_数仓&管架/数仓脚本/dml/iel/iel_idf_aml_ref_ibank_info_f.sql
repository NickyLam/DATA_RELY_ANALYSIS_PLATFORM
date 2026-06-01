: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_ref_ibank_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_ref_ibank_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,ibank_no
,lp_id
,bank_cls_id
,super_prtcpt_bank_no
,super_bank_list
,belong_bank_no
,prtcpt_type_cd
,bank_type_cd
,node_cd
,rg_cd
,status_cd
,bank_fname
,bank_abbr
,phys_addr
,zip_cd
,tel_num
,elec_addr
,effect_dt
,invalid_dt
,cert_bind_cn_region
,cert_bind_sn_region
,cert_bind_status
,cert_bind_effect_dt
,cert_bind_invalid_dt
,final_modif_operr_id
,final_update_tm
,create_dt
,update_dt
,id_mark
from idl.aml_ref_ibank_info
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_ref_ibank_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes