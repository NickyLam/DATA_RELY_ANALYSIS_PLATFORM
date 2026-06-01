: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_account_draw_details_i
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_bok_account_draw_details.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.drawdate as drawdate
,replace(replace(t1.accountid,chr(13),''),chr(10),'') as accountid
,replace(replace(t1.businessseqno,chr(13),''),chr(10),'') as businessseqno
,replace(replace(t1.businessid,chr(13),''),chr(10),'') as businessid
,replace(replace(t1.moduleid,chr(13),''),chr(10),'') as moduleid
,replace(replace(t1.ptype,chr(13),''),chr(10),'') as ptype
,t1.gendate as gendate
,t1.updatedate as updatedate
,t1.cashamt as cashamt
,t1.assetamt as assetamt
,t1.prinamt as prinamt
,t1.balanceflag as balanceflag
,t1.yield as yield
,t1.tddraw_add as tddraw_add
,t1.tddraw_intpay_adj as tddraw_intpay_adj
,t1.tddraw_repay_adj as tddraw_repay_adj
,t1.perioddraw as perioddraw
,t1.totaldraw as totaldraw
,t1.tdtounpaydraw as tdtounpaydraw
,t1.tdtoactpaydraw as tdtoactpaydraw
,t1.totaltounpaydraw as totaltounpaydraw
,t1.totaldraw_unadj as totaldraw_unadj
,t1.tdactpayint as tdactpayint
,t1.totalactpayint as totalactpayint
,t1.totalunpayint as totalunpayint
,t1.lstmntdate as lstmntdate
,t1.unpayamt as unpayamt
,t1.ystperioddraw as ystperioddraw
,t1.ysttotaldraw as ysttotaldraw
,t1.ysttotaltounpaydraw as ysttotaltounpaydraw
,t1.ysttotaldraw_unadj as ysttotaldraw_unadj
,t1.ysttotalactpayint as ysttotalactpayint
,t1.ysttotalunpayint as ysttotalunpayint
,t1.payunpayintamt as payunpayintamt
,t1.tdycosta as tdycosta
,t1.ystcosta as ystcosta
,t1.tdyprofitlossa as tdyprofitlossa
,t1.ystprofitlossa as ystprofitlossa
,t1.tdycostcostb as tdycostcostb
,t1.ystcostcostb as ystcostcostb
,t1.tdycostintb as tdycostintb
,t1.ystcostintb as ystcostintb
,t1.tdyprofitlossb as tdyprofitlossb
,t1.ystprofitlossb as ystprofitlossb
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_bok_account_draw_details t1
where t1.drawdate = TO_DATE('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_account_draw_details.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes