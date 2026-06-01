: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_o_cbs_rtbnkexe_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_o_cbs_rtbnkexe_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
bkno
,irbt
,irpd
,ircy
,efdt
,prmd
,irvl
,rirt
,rirb
,rirp
,ricy
,rifd
,rifm
,rifv
,udul
,udll
,upul
,upll
,eldt
from idl.irrs_o_cbs_rtbnkexe
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_o_cbs_rtbnkexe_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes