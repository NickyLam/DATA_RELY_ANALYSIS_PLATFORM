: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_institution_ext_f
CreateDate: 20230106
FileName:   ${iel_data_path}/ibms_ttrd_institution_ext.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_id,chr(13),''),chr(10),'') as i_id
,replace(replace(t1.h_datefield,chr(13),''),chr(10),'') as h_datefield
,replace(replace(t1.h_textfield,chr(13),''),chr(10),'') as h_textfield
,h_numberfield
,replace(replace(t1.h_combobox,chr(13),''),chr(10),'') as h_combobox
,replace(replace(t1.h_textarea,chr(13),''),chr(10),'') as h_textarea
,replace(replace(t1.hx_industy,chr(13),''),chr(10),'') as hx_industy
,replace(replace(t1.hx_industy_detail,chr(13),''),chr(10),'') as hx_industy_detail
,replace(replace(t1.rh_custeconomypart,chr(13),''),chr(10),'') as rh_custeconomypart
,replace(replace(t1.rh_businesstype,chr(13),''),chr(10),'') as rh_businesstype
,replace(replace(t1.rh_isrelevancy,chr(13),''),chr(10),'') as rh_isrelevancy
,replace(replace(t1.rh_code,chr(13),''),chr(10),'') as rh_code
,replace(replace(t1.rh_institutioncode,chr(13),''),chr(10),'') as rh_institutioncode
,replace(replace(t1.rh_depositaccount,chr(13),''),chr(10),'') as rh_depositaccount
,replace(replace(t1.rh_economicsector,chr(13),''),chr(10),'') as rh_economicsector
,replace(replace(t1.rh_bankname,chr(13),''),chr(10),'') as rh_bankname
,replace(replace(t1.rh_regist,chr(13),''),chr(10),'') as rh_regist
,replace(replace(t1.rh_innerrate,chr(13),''),chr(10),'') as rh_innerrate
,replace(replace(t1.rh_firmsize,chr(13),''),chr(10),'') as rh_firmsize
,replace(replace(t1.rh_begindate,chr(13),''),chr(10),'') as rh_begindate
,replace(replace(t1.rh_registcode,chr(13),''),chr(10),'') as rh_registcode
,replace(replace(t1.rh_codetype,chr(13),''),chr(10),'') as rh_codetype
,replace(replace(t1.rh_custtype,chr(13),''),chr(10),'') as rh_custtype
,replace(replace(t1.hx_juridical_p_cert_type,chr(13),''),chr(10),'') as hx_juridical_p_cert_type
,replace(replace(t1.hx_juridical_p_cert_code,chr(13),''),chr(10),'') as hx_juridical_p_cert_code
,replace(replace(t1.hx_pd_of_vali4juridical_p_cert,chr(13),''),chr(10),'') as hx_pd_of_vali4juridical_p_cert
,replace(replace(t1.funds_prsv,chr(13),''),chr(10),'') as funds_prsv
,replace(replace(t1.prim_org_ptyid,chr(13),''),chr(10),'') as prim_org_ptyid
,replace(replace(t1.spv_cd,chr(13),''),chr(10),'') as spv_cd
,replace(replace(t1.spv_name,chr(13),''),chr(10),'') as spv_name
,replace(replace(t1.spv_type,chr(13),''),chr(10),'') as spv_type
,replace(replace(t1.rh_businesstype_m,chr(13),''),chr(10),'') as rh_businesstype_m
,replace(replace(t1.rh_economicsector_m,chr(13),''),chr(10),'') as rh_economicsector_m
,replace(replace(t1.hx_adminiarea,chr(13),''),chr(10),'') as hx_adminiarea
,replace(replace(t1.hx_deteilarea,chr(13),''),chr(10),'') as hx_deteilarea
,replace(replace(t1.hx_deteiladdress,chr(13),''),chr(10),'') as hx_deteiladdress

from ${iol_schema}.ibms_ttrd_institution_ext t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_institution_ext.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
