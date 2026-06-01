: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_wrntaccundrwryrsplinf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_wrntaccundrwryrsplinf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.infrpt_dt as infrpt_dt
    ,replace(replace(t.acc_avy_st,chr(13),''),chr(10),'') as acc_avy_st
    ,t.bal as bal
    ,replace(replace(t.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
    ,t.entp_cr_rskesr as entp_cr_rskesr
    ,replace(replace(t.sbstrepy_or_adcsh_ind,chr(13),''),chr(10),'') as sbstrepy_or_adcsh_ind
    ,replace(replace(t.jnt_dbt_idr,chr(13),''),chr(10),'') as jnt_dbt_idr
    ,t.cls_dt as cls_dt
    ,t.crt_dt_tm as crt_dt_tm
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
from iol.cqss_e_r_wrntaccundrwryrsplinf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_wrntaccundrwryrsplinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes