: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tcb_bond_eval_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tcb_bond_eval_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(beg_date,chr(10),''),chr(13),'') as beg_date
,replace(replace(end_date,chr(10),''),chr(13),'') as end_date
,replace(replace(netprice,chr(10),''),chr(13),'') as netprice
,replace(replace(ai,chr(10),''),chr(13),'') as ai
,replace(replace(yield,chr(10),''),chr(13),'') as yield
,replace(replace(term,chr(10),''),chr(13),'') as term
,replace(replace(modified_d,chr(10),''),chr(13),'') as modified_d
,replace(replace(convexity,chr(10),''),chr(13),'') as convexity
,replace(replace(dvbp,chr(10),''),chr(13),'') as dvbp
,replace(replace(rd_modified,chr(10),''),chr(13),'') as rd_modified
,replace(replace(rd_convexity,chr(10),''),chr(13),'') as rd_convexity
,replace(replace(r_modified,chr(10),''),chr(13),'') as r_modified
,replace(replace(r_convexity,chr(10),''),chr(13),'') as r_convexity
,replace(replace(fullprice,chr(10),''),chr(13),'') as fullprice
,replace(replace(is_onedate,chr(10),''),chr(13),'') as is_onedate
,replace(replace(imp_date,chr(10),''),chr(13),'') as imp_date
,replace(replace(pipe_id,chr(10),''),chr(13),'') as pipe_id
,replace(replace(rd_yield,chr(10),''),chr(13),'') as rd_yield
,etl_dt
,etl_timestamp
from iol.ibms_tcb_bond_eval where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tcb_bond_eval_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes