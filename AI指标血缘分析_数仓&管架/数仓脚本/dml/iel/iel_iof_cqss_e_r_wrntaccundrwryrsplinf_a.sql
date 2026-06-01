: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_wrntaccundrwryrsplinf_a
CreateDate: 20250313
FileName:   ${iel_data_path}/cqss_e_r_wrntaccundrwryrsplinf.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,infrpt_dt
,replace(replace(t1.acc_avy_st,chr(13),''),chr(10),'') as acc_avy_st
,bal
,replace(replace(t1.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,entp_cr_rskesr
,replace(replace(t1.sbstrepy_or_adcsh_ind,chr(13),''),chr(10),'') as sbstrepy_or_adcsh_ind
,replace(replace(t1.jnt_dbt_idr,chr(13),''),chr(10),'') as jnt_dbt_idr
,cls_dt
,crt_dt_tm
,replace(replace(t1.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id

from ${iol_schema}.cqss_e_r_wrntaccundrwryrsplinf t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_wrntaccundrwryrsplinf.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
