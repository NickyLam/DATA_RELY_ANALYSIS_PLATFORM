: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_civiljudgement_a
CreateDate: 20241107
FileName:   ${iel_data_path}/cqss_i_r_civiljudgement.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.crjdgmtputorcdcourtnm,chr(13),''),chr(10),'') as crjdgmtputorcdcourtnm
,replace(replace(t1.cr_jdgmt_cs_rsn,chr(13),''),chr(10),'') as cr_jdgmt_cs_rsn
,cr_jdgmt_putonrcrd_dt
,replace(replace(t1.cr_jdgmt_endcs_mtdcd,chr(13),''),chr(10),'') as cr_jdgmt_endcs_mtdcd
,replace(replace(t1.cr_jdgmt_jdgmtrst,chr(13),''),chr(10),'') as cr_jdgmt_jdgmtrst
,cr_jdgmt_jdgmt_efdt
,replace(replace(t1.cr_jdgmt_ltgtn_obj,chr(13),''),chr(10),'') as cr_jdgmt_ltgtn_obj
,crjdgmt_ltgtn_obj_amt
,annttn_and_sttmnt_num
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,crt_dt_tm

from ${iol_schema}.cqss_i_r_civiljudgement t1
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_civiljudgement.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
