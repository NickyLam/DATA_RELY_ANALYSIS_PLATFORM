: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_org_int_org_addr_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_org_int_org_addr_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select org_id
,lp_id
,start_dt
,tel_num
,zip_cd
,cty_or_rg_cd
,prov_cd
,city_cd
,county_cd
,dtl_addr
,princ_emply_id
,princ_name
,ddd_area_cd
,end_dt
,id_mark
,src_table_name
,job_cd
,etl_timestamp from idl.aml_org_int_org_addr_h where start_dt<=to_date('${batch_date}','yyyymmdd') and end_dt>to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_org_int_org_addr_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes