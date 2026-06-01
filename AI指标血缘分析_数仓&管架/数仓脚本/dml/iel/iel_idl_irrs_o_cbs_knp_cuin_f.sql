: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_o_cbs_knp_cuin_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_o_cbs_knp_cuin_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
cuinme
,cuinna
,inrttp
,inrtmd
,ratios
,incmtm
,incmdy
,flortg
,daysmd
,calcmd
,intxtg
,ircvtg
,insgtg
,basetg
,acmltp
from idl.irrs_o_cbs_knp_cuin
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_o_cbs_knp_cuin_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes