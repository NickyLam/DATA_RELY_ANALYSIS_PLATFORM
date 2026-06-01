: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_fft_tran_tot_tab_f
CreateDate: 20230804
FileName:   ${iel_data_path}/agt_fft_tran_tot_tab.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,dubil_cnt
,tran_sell_recvbl_amt_tot
,tran_sell_dubil_amt_tot
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.ts_flg,chr(13),''),chr(10),'') as ts_flg
,replace(replace(t1.tran_comnt,chr(13),''),chr(10),'') as tran_comnt

from ${iml_schema}.agt_fft_tran_tot_tab t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_fft_tran_tot_tab.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
