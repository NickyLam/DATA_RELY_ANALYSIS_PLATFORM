: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_vi_tbs_account_cptys_info_f
CreateDate: 20240131
FileName:   ${iel_data_path}/ctms_vi_tbs_account_cptys_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.biz_seq_num,chr(13),''),chr(10),'') as biz_seq_num
,replace(replace(t1.seq,chr(13),''),chr(10),'') as seq
,replace(replace(t1.tx_cntpty_acct_num,chr(13),''),chr(10),'') as tx_cntpty_acct_num
,replace(replace(t1.tx_cntpty_name,chr(13),''),chr(10),'') as tx_cntpty_name
,replace(replace(t1.cntpty_fin_inst_brac_cd,chr(13),''),chr(10),'') as cntpty_fin_inst_brac_cd
,replace(replace(t1.cntpty_fin_inst_brac_name,chr(13),''),chr(10),'') as cntpty_fin_inst_brac_name
,replace(replace(t1.dist,chr(13),''),chr(10),'') as dist
,replace(replace(t1.tx_cntpty_cert_type,chr(13),''),chr(10),'') as tx_cntpty_cert_type
,replace(replace(t1.tx_cntpty_cert_no,chr(13),''),chr(10),'') as tx_cntpty_cert_no
,replace(replace(t1.cpty_type,chr(13),''),chr(10),'') as cpty_type

from ${iol_schema}.ctms_vi_tbs_account_cptys_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_vi_tbs_account_cptys_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
