: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_corp_cust_shard_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_corp_cust_shard_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,cust_id
,shard_cust_id
,shard_name
,shard_type_cd
,shard_orgnz_type_cd
,shard_local_nation_cd
,shard_orgnz_cd
,shard_bus_lics_id
,contrior_econ_compnt_cd
,nature_ps_shard_cert_type_cd
,nature_ps_shard_cert_no
,ghb_shard_flg
,unify_soci_crdt_cd
,share_ratio
,contri_way_cd
,contri_curr_cd
,contri_amt
,hold_dt
,shard_valid_flg
from ${idl_schema}.aml_cmm_corp_cust_shard_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_corp_cust_shard_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes