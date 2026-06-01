: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tcb_bond_eval_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tcb_bond_eval.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select i_code
,a_type
,m_type
,beg_date
,end_date
,netprice
,ai
,yield
,term
,modified_d
,convexity
,dvbp
,rd_modified
,rd_convexity
,r_modified
,r_convexity
,fullprice
,is_onedate
,imp_date
,pipe_id
,rd_yield
,etl_dt
,etl_timestamp from iol.ibms_tcb_bond_eval where etl_dt=TO_DATE('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tcb_bond_eval.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes