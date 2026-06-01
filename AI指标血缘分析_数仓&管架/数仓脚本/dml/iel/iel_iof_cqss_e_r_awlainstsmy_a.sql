: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_awlainstsmy_a
CreateDate: 20250225
FileName:   ${iel_data_path}/cqss_e_r_awlainstsmy.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
,replace(replace(t1.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t1.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t1.wrnt_bnctg_sbdvsn,chr(13),''),chr(10),'') as wrnt_bnctg_sbdvsn
,replace(replace(t1.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,not_clsg_acc
,bal
,wrntacc30dinnrexpsbal
,wrntacc60dinnrexpsbal
,wrntacc90dinnrexpsbal
,wrntacc90dyafexps_bal
,alrdy_clsg_acc
,replace(replace(t1.adcsh_ind,chr(13),''),chr(10),'') as adcsh_ind
,crt_dt_tm

from ${iol_schema}.cqss_e_r_awlainstsmy t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_awlainstsmy.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
