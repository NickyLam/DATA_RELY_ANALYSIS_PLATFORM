: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_loan_guar_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_loan_guar_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,replace(replace(t1.assoc_guar_contr_id,chr(13),''),chr(10),'') as assoc_guar_contr_id
,replace(replace(t1.assoc_agt_modf,chr(13),''),chr(10),'') as assoc_agt_modf
,t1.etl_dt as etl_dt
,t1.last_update_dt as last_update_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_agt_loan_guar_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_loan_guar_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes