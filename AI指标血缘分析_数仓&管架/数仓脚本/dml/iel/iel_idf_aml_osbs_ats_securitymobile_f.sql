: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_osbs_ats_securitymobile_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_osbs_ats_securitymobile.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,asm_cstno
,asm_userno
,asm_mobile
,asm_create_date
,asm_update_date
,asm_state from idl.aml_osbs_ats_securitymobile where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_osbs_ats_securitymobile.f.${batch_date}.dat" \
        charset=utf8
        safe=yes