: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ibms_tcb_bond_eval_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ibms_tcb_bond_eval.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.i_code
,t1.a_type
,t1.m_type
,t1.beg_date
,t1.end_date
,t1.netprice
,t1.ai
,t1.yield
,t1.term
,t1.modified_d
,t1.convexity
,t1.dvbp
,t1.rd_modified
,t1.rd_convexity
,t1.r_modified
,t1.r_convexity
,t1.fullprice
,t1.is_onedate
,t1.imp_date
,t1.pipe_id
,t1.rd_yield
from ${idl_schema}.hdws_ibms_tcb_bond_eval t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ibms_tcb_bond_eval.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes