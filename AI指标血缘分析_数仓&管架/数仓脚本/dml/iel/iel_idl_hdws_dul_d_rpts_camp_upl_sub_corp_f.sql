: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_camp_upl_sub_corp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_camp_upl_sub_corp.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,co_sub_corp_id
,co_sub_corp_name
,physical_address
,cont_tel
,valid_flg
,oprt_emp_id
,input_dt
,input_org_id
,upda_pers_cnstr_id
,upda_dt
,super_corp_id
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_camp_upl_sub_corp
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_camp_upl_sub_corp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes