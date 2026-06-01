: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_awlainstsmy_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_awlainstsmy_w.i.${batch_date}.dat
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
,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t.wrnt_bnctg_sbdvsn,chr(13),''),chr(10),'') as wrnt_bnctg_sbdvsn
,replace(replace(t.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,t.not_clsg_acc as not_clsg_acc
,t.bal as bal
,t.wrntacc30dinnrexpsbal as wrntacc30dinnrexpsbal
,t.wrntacc60dinnrexpsbal as wrntacc60dinnrexpsbal
,t.wrntacc90dinnrexpsbal as wrntacc90dinnrexpsbal
,t.wrntacc90dyafexps_bal as wrntacc90dyafexps_bal
,t.alrdy_clsg_acc as alrdy_clsg_acc
,replace(replace(t.adcsh_ind,chr(13),''),chr(10),'') as adcsh_ind
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_awlainstsmy t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_awlainstsmy_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes