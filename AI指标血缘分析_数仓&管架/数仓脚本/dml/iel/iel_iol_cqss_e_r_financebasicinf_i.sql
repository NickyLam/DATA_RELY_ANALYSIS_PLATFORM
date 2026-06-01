: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_financebasicinf_i
CreateDate: 20241216
FileName:   ${iel_data_path}/cqss_e_r_financebasicinf.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.inf_unit_tp,chr(13),''),chr(10),'') as inf_unit_tp
,replace(replace(t1.fnrpt_prj_id,chr(13),''),chr(10),'') as fnrpt_prj_id
,replace(replace(t1.bsmgt_inst_tp,chr(13),''),chr(10),'') as bsmgt_inst_tp
,replace(replace(t1.bsmgt_insid,chr(13),''),chr(10),'') as bsmgt_insid
,replace(replace(t1.yr_yyyy,chr(13),''),chr(10),'') as yr_yyyy
,replace(replace(t1.rpt_tp,chr(13),''),chr(10),'') as rpt_tp
,replace(replace(t1.rptfrmtp_sbdvsn,chr(13),''),chr(10),'') as rptfrmtp_sbdvsn
,crt_dt_tm

from ${iol_schema}.cqss_e_r_financebasicinf t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_financebasicinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
