: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_cust_shard_info_f
CreateDate: 20241014
FileName:   ${iel_data_path}/cmm_corp_cust_shard_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.shard_cust_id,chr(13),''),chr(10),'') as shard_cust_id
,replace(replace(t1.shard_name,chr(13),''),chr(10),'') as shard_name
,replace(replace(t1.shard_type_cd,chr(13),''),chr(10),'') as shard_type_cd
,replace(replace(t1.shard_orgnz_type_cd,chr(13),''),chr(10),'') as shard_orgnz_type_cd
,replace(replace(t1.shard_local_nation_cd,chr(13),''),chr(10),'') as shard_local_nation_cd
,replace(replace(t1.shard_orgnz_cd,chr(13),''),chr(10),'') as shard_orgnz_cd
,replace(replace(t1.shard_bus_lics_id,chr(13),''),chr(10),'') as shard_bus_lics_id
,replace(replace(t1.contrior_econ_compnt_cd,chr(13),''),chr(10),'') as contrior_econ_compnt_cd
,replace(replace(t1.nature_ps_shard_cert_type_cd,chr(13),''),chr(10),'') as nature_ps_shard_cert_type_cd
,replace(replace(t1.nature_ps_shard_cert_no,chr(13),''),chr(10),'') as nature_ps_shard_cert_no
,replace(replace(t1.ghb_shard_flg,chr(13),''),chr(10),'') as ghb_shard_flg
,replace(replace(t1.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd
,share_ratio
,replace(replace(t1.contri_way_cd,chr(13),''),chr(10),'') as contri_way_cd
,replace(replace(t1.contri_curr_cd,chr(13),''),chr(10),'') as contri_curr_cd
,contri_amt
,hold_dt
,replace(replace(t1.shard_valid_flg,chr(13),''),chr(10),'') as shard_valid_flg
,replace(replace(t1.actl_ctrler_flg,chr(13),''),chr(10),'') as actl_ctrler_flg
,replace(replace(t1.rela_ps_id,chr(13),''),chr(10),'') as rela_ps_id
,replace(replace(t1.contrior_type_cd,chr(13),''),chr(10),'') as contrior_type_cd
,replace(replace(t1.contrior_idti_cate_cd,chr(13),''),chr(10),'') as contrior_idti_cate_cd
,update_dt
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,shard_contri_ratio
,shard_hold_shares_qtty

from ${icl_schema}.cmm_corp_cust_shard_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_cust_shard_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
