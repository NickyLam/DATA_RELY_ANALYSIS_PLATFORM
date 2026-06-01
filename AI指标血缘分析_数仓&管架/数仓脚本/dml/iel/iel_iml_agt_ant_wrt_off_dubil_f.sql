: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ant_wrt_off_dubil_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_ant_wrt_off_dubil.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(dubil_id,chr(13),''),chr(10),'')
,replace(replace(cust_id,chr(13),''),chr(10),'')
,dubil_amt
,curr_bal
,exp_dt
,exec_int_rat
,ovdue_days
,int
,pnlt
,replace(replace(repay_way_cd,chr(13),''),chr(10),'')
,tenor
,replace(replace(acct_instit_id,chr(13),''),chr(10),'')
,replace(replace(wrt_off_status_cd,chr(13),''),chr(10),'')
,replace(replace(bus_type_cd,chr(13),''),chr(10),'')
,distr_dt
,ovdue_dt
,coll_cnt
,insto_dt
,fir_wrt_off_dt
,recvbl_pric
,recvbl_off_bs_int
,replace(replace(remark,chr(13),''),chr(10),'')
,replace(replace(level5_cls_cd,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')
,advc_fee

from ${iml_schema}.agt_ant_wrt_off_dubil t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ant_wrt_off_dubil.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
