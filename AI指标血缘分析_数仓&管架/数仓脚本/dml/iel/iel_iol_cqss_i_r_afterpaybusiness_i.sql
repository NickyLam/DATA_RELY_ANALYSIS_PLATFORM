: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_afterpaybusiness_i
CreateDate: 20241107
FileName:   ${iel_data_path}/cqss_i_r_afterpaybusiness.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.acctpid,chr(13),''),chr(10),'') as acctpid
,replace(replace(t1.inst_nm,chr(13),''),chr(10),'') as inst_nm
,replace(replace(t1.af_py_acc_btp_cd,chr(13),''),chr(10),'') as af_py_acc_btp_cd
,stdt
,replace(replace(t1.pyf_stcd,chr(13),''),chr(10),'') as pyf_stcd
,inarr_cost_amt
,replace(replace(t1.bookentr_yrmo,chr(13),''),chr(10),'') as bookentr_yrmo
,replace(replace(t1.rctly24etrsmopyf_rcrd,chr(13),''),chr(10),'') as rctly24etrsmopyf_rcrd
,annttn_and_sttmnt_num
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,crt_dt_tm

from ${iol_schema}.cqss_i_r_afterpaybusiness t1
where to_char(crt_dt_tm,'yyyymmdd') = '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_afterpaybusiness.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
