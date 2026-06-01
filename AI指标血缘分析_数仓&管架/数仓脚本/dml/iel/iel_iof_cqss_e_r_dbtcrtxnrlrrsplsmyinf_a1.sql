: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_dbtcrtxnrlrrsplsmyinf_a1
CreateDate: 20250704
FileName:   ${iel_data_path}/cqss_e_r_dbtcrtxnrlrrsplsmyinf.i.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.rel_repy_rspl_tp,chr(13),''),chr(10),'') as rel_repy_rspl_tp
,berecaccsrepyrspl_qot
,be_rec_acc_tot
,be_rec_bal_tot
,othrdbtcrtrepyrsplqot
,othr_dbtcr_tnac_num
,othr_dbtcr_tnac_bal
,othrdbtcrtnafcscgybal
,othrdbtcrtnabadcgybal
,crt_dt_tm

from ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dbtcrtxnrlrrsplsmyinf.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
