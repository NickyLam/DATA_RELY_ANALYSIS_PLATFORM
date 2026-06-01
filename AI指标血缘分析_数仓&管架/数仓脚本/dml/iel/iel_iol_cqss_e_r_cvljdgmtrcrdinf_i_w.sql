: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_cvljdgmtrcrdinf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_cvljdgmtrcrdinf_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
,replace(replace(t.crjdgmtputorcdcourtnm,chr(13),''),chr(10),'') as crjdgmtputorcdcourtnm
,replace(replace(t.fileno,chr(13),''),chr(10),'') as fileno
,t.cr_jdgmt_putonrcrd_dt as cr_jdgmt_putonrcrd_dt
,replace(replace(t.csoatn,chr(13),''),chr(10),'') as csoatn
,replace(replace(t.ltgtn_pos,chr(13),''),chr(10),'') as ltgtn_pos
,replace(replace(t.trial_prgm,chr(13),''),chr(10),'') as trial_prgm
,replace(replace(t.cr_jdgmt_ltgtn_obj,chr(13),''),chr(10),'') as cr_jdgmt_ltgtn_obj
,t.crjdgmt_ltgtn_obj_amt as crjdgmt_ltgtn_obj_amt
,replace(replace(t.cr_jdgmt_endcs_mtdcd,chr(13),''),chr(10),'') as cr_jdgmt_endcs_mtdcd
,t.cr_jdgmt_jdgmt_efdt as cr_jdgmt_jdgmt_efdt
,replace(replace(t.cr_jdgmt_jdgmtrst,chr(13),''),chr(10),'') as cr_jdgmt_jdgmtrst
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_cvljdgmtrcrdinf t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_cvljdgmtrcrdinf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes