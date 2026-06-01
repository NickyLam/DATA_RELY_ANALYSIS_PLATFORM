: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_dbtcrtxnrlrrsplsmyinf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_dbtcrtxnrlrrsplsmyinf_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t.rel_repy_rspl_tp,chr(13),''),chr(10),'') as rel_repy_rspl_tp
,t.berecaccsrepyrspl_qot as berecaccsrepyrspl_qot
,t.be_rec_acc_tot as be_rec_acc_tot
,t.be_rec_bal_tot as be_rec_bal_tot
,t.othrdbtcrtrepyrsplqot as othrdbtcrtrepyrsplqot
,t.othr_dbtcr_tnac_num as othr_dbtcr_tnac_num
,t.othr_dbtcr_tnac_bal as othr_dbtcr_tnac_bal
,t.othrdbtcrtnafcscgybal as othrdbtcrtnafcscgybal
,t.othrdbtcrtnabadcgybal as othrdbtcrtnabadcgybal
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dbtcrtxnrlrrsplsmyinf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes