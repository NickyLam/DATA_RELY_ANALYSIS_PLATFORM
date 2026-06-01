: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_zts_a08tappdbphpyw_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_zts_a08tappdbphpyw_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select cmtno
,bustype
,servtype
,transdt
,businesstrace
,bphpbilldate
,bphpbillamt
,bphpapplyacct
,bphpapplyname
,bphpsettleamt
,bphpbalance
,bphpbilltype
,bphpbillnb
,syscd
,syhpflag from idl.pirs_o_zts_a08tappdbphpyw where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_zts_a08tappdbphpyw_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes