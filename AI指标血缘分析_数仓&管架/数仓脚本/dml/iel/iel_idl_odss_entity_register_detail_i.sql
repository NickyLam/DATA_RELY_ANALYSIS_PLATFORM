: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_entity_register_detail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_entity_register_detail_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,txtype
,receive_date
,stdbusstyp
,draft_id
,stdbilltyp
,stdbillnum
,df_isscur
,stdpmmoney
,stdappdate
,stdduedate
,stdaccpdat
,stdaccpnam
,stdaccpbnm
,stddrwrnam
,stdpyeenam
,stddshndat
,stddshncod
,stddshnrsn
,stdlsthldr
,stdspaytyp
,stdapaydat
,stdapaynam
,stdrvapnam
,stdrmsptyp
,stdrmspdat
,stdaprspnm
,stdrmspnam
,stdrturndt
,setstddscntdt
,setstdpropnme
,setstdodirbnm
,setstddsbknme
,setstddsbkbnm
,setstdcoltdat
,setstdcoltnam
,setstdcobknam
,setstdcobkbnm
,setstdrcoltdt
,setstdocoltnm
,setstdocobknm
,setstdocolbnm
,setstdcoltndt
,setstdendscnt
,setstdcltbknm
,setstdctbkbnm
,setstdprncpln
,setstdsttlmdt
,std400memo
,std400rlno
,std400clno
,details_id
,send_status
,cm_status
,cm_err_procd
,swt_biz_id
,input_operid
,input_date
,aprove_operid
,aprove_date
,operator_id
,txn_date
,cancel_operid
,cancel_date
,mod_operno
,mod_date
,branch_id
,mis
,last_upd_oper_id
,last_upd_time
,ecds_prc_cd
,ecds_prc_msg
,txn_qry_id
,swt_main_id
,queries_cnt
,stdtxctrmb
,stdinvctnb
,stdagrmtnb
,query_seqno
,src_type
,intrst_rate
from ${idl_schema}.odss_entity_register_detail
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_entity_register_detail_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes