: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_org_int_org_f
CreateDate: 20221021
FileName:   ${iel_data_path}/org_int_org.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(org_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(org_name,chr(13),''),chr(10),'')
,replace(replace(org_abbr,chr(13),''),chr(10),'')
,replace(replace(org_type_cd,chr(13),''),chr(10),'')
,org_found_dt
,org_close_dt
,replace(replace(enty_org_flg,chr(13),''),chr(10),'')
,replace(replace(accti_org_flg,chr(13),''),chr(10),'')
,replace(replace(bus_org_flg,chr(13),''),chr(10),'')
,replace(replace(admin_org_flg,chr(13),''),chr(10),'')
,replace(replace(acct_instit_flg,chr(13),''),chr(10),'')
,replace(replace(vtual_org_flg,chr(13),''),chr(10),'')
,replace(replace(org_lev_cd,chr(13),''),chr(10),'')
,replace(replace(org_status_cd,chr(13),''),chr(10),'')
,replace(replace(org_bus_status_cd,chr(13),''),chr(10),'')
,replace(replace(unify_orgnz_id,chr(13),''),chr(10),'')
,replace(replace(fin_lics_num,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')

from ${iml_schema}.org_int_org t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/org_int_org.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
