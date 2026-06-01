: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_tla_subj_f
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_tla_subj_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
,acctseq
,curcd
,insubjid
,outsubj
,subjnm
,subjtype
,subjlev
,upsubj
,amtto
,balto
,isdtlflg
,islstflg
,subjstore
,busitype
,ismerge
,iskjgflg
,isckzw from  ${idl_schema}.gzfh_tla_subj where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_tla_subj_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes