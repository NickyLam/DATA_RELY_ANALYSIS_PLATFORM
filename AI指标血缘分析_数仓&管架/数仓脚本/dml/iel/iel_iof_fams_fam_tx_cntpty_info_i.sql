: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fams_fam_tx_cntpty_info_i
CreateDate: 20240131
FileName:   ${iel_data_path}/fams_fam_tx_cntpty_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,cdate
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.biz_seq_num,chr(13),''),chr(10),'') as biz_seq_num
,replace(replace(t1.tran_num,chr(13),''),chr(10),'') as tran_num
,replace(replace(t1.tx_cntpty_acct_num,chr(13),''),chr(10),'') as tx_cntpty_acct_num
,replace(replace(t1.tx_cntpty_name,chr(13),''),chr(10),'') as tx_cntpty_name
,replace(replace(t1.cntpty_fin_inst_brac_cd,chr(13),''),chr(10),'') as cntpty_fin_inst_brac_cd
,replace(replace(t1.cntpty_fin_inst_brac_name,chr(13),''),chr(10),'') as cntpty_fin_inst_brac_name
,replace(replace(t1.tx_cntpty_dist,chr(13),''),chr(10),'') as tx_cntpty_dist
,replace(replace(t1.tx_cntpty_cert_type,chr(13),''),chr(10),'') as tx_cntpty_cert_type
,replace(replace(t1.tx_cntpty_cert_no,chr(13),''),chr(10),'') as tx_cntpty_cert_no
,replace(replace(t1.tx_cntpty_cd_type,chr(13),''),chr(10),'') as tx_cntpty_cd_type

from ${iol_schema}.fams_fam_tx_cntpty_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fam_tx_cntpty_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
