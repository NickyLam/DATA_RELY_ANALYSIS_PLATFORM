: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_relrepyrldaawaismyinf_i
CreateDate: 20240827
FileName:   ${iel_data_path}/cqss_e_r_relrepyrldaawaismyinf.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
,replace(replace(t1.rel_repy_rspl_tp,chr(13),''),chr(10),'') as rel_repy_rspl_tp
,replace(replace(t1.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t1.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t1.repy_rspl_bnctg,chr(13),''),chr(10),'') as repy_rspl_bnctg
,replace(replace(t1.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,rel_repy_rspl_qot
,acc_num
,bal
,cur_odue_tamt
,cur_odue_pnp
,pbc_cr_lnd_amt
,replace(replace(t1.grnt_ctr_id,chr(13),''),chr(10),'') as grnt_ctr_id
,crt_dt_tm

from ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf t1
where to_char(t1.crt_dt_tm,'yyyymmdd') = '${batch_date}'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_relrepyrldaawaismyinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
