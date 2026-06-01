: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tcb_bond_eval_i
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_tcb_bond_eval.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,t1.netprice as netprice
,t1.ai as ai
,t1.yield as yield
,t1.term as term
,t1.modified_d as modified_d
,t1.convexity as convexity
,t1.dvbp as dvbp
,t1.rd_modified as rd_modified
,t1.rd_convexity as rd_convexity
,t1.r_modified as r_modified
,t1.r_convexity as r_convexity
,t1.fullprice as fullprice
,t1.is_onedate as is_onedate
,replace(replace(t1.imp_date,chr(13),''),chr(10),'') as imp_date
,t1.pipe_id as pipe_id
,t1.rd_yield as rd_yield

from ${iol_schema}.ibms_tcb_bond_eval t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tcb_bond_eval.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
