: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_loan_trans_detail_i
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_loan_trans_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.consumertransid,chr(13),''),chr(10),'') as consumertransid
,replace(replace(t1.systransid,chr(13),''),chr(10),'') as systransid
,replace(replace(t1.txnseq,chr(13),''),chr(10),'') as txnseq
,replace(replace(t1.txndate,chr(13),''),chr(10),'') as txndate
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.logicalcardno,chr(13),''),chr(10),'') as logicalcardno
,replace(replace(t1.lendingref,chr(13),''),chr(10),'') as lendingref
,replace(replace(t1.currcd,chr(13),''),chr(10),'') as currcd
,replace(replace(t1.txncode,chr(13),''),chr(10),'') as txncode
,replace(replace(t1.txndesc,chr(13),''),chr(10),'') as txndesc
,replace(replace(t1.dbcrind,chr(13),''),chr(10),'') as dbcrind
,postamt
,replace(replace(t1.postglind,chr(13),''),chr(10),'') as postglind
,replace(replace(t1.owningbranch,chr(13),''),chr(10),'') as owningbranch
,replace(replace(t1.subject,chr(13),''),chr(10),'') as subject
,replace(replace(t1.redflag,chr(13),''),chr(10),'') as redflag
,replace(replace(t1.queue,chr(13),''),chr(10),'') as queue
,replace(replace(t1.agegroup,chr(13),''),chr(10),'') as agegroup
,replace(replace(t1.bnpgroup,chr(13),''),chr(10),'') as bnpgroup
,replace(replace(t1.bankgroupid,chr(13),''),chr(10),'') as bankgroupid
,replace(replace(t1.bankno,chr(13),''),chr(10),'') as bankno
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.batchdate,chr(13),''),chr(10),'') as batchdate
,replace(replace(t1.txntime,chr(13),''),chr(10),'') as txntime
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,txnbalance
,replace(replace(t1.cashflag,chr(13),''),chr(10),'') as cashflag
,replace(replace(t1.postdate,chr(13),''),chr(10),'') as postdate
,replace(replace(t1.posttime,chr(13),''),chr(10),'') as posttime
,replace(replace(t1.youracctno,chr(13),''),chr(10),'') as youracctno
,replace(replace(t1.youracctname,chr(13),''),chr(10),'') as youracctname
,replace(replace(t1.yourbankid,chr(13),''),chr(10),'') as yourbankid
,replace(replace(t1.yourbankname,chr(13),''),chr(10),'') as yourbankname
,replace(replace(t1.qchannelid,chr(13),''),chr(10),'') as qchannelid
,replace(replace(t1.trasnuser,chr(13),''),chr(10),'') as trasnuser
,replace(replace(t1.uesrserno,chr(13),''),chr(10),'') as uesrserno
,replace(replace(t1.authuser,chr(13),''),chr(10),'') as authuser
,replace(replace(t1.vouchertype,chr(13),''),chr(10),'') as vouchertype
,replace(replace(t1.voucherno,chr(13),''),chr(10),'') as voucherno
,replace(replace(t1.transflag,chr(13),''),chr(10),'') as transflag
,replace(replace(t1.agentname,chr(13),''),chr(10),'') as agentname
,replace(replace(t1.agentidtype,chr(13),''),chr(10),'') as agentidtype
,replace(replace(t1.agentidno,chr(13),''),chr(10),'') as agentidno
,replace(replace(t1.payeracct,chr(13),''),chr(10),'') as payeracct
,replace(replace(t1.payername,chr(13),''),chr(10),'') as payername
,replace(replace(t1.payerbrno,chr(13),''),chr(10),'') as payerbrno
,replace(replace(t1.payerbrname,chr(13),''),chr(10),'') as payerbrname
,replace(replace(t1.payeeacct,chr(13),''),chr(10),'') as payeeacct
,replace(replace(t1.payeename,chr(13),''),chr(10),'') as payeename
,replace(replace(t1.payeebrno,chr(13),''),chr(10),'') as payeebrno
,replace(replace(t1.payeebrname,chr(13),''),chr(10),'') as payeebrname
,replace(replace(t1.settleid,chr(13),''),chr(10),'') as settleid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult

from ${iol_schema}.icms_wyd_loan_trans_detail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_loan_trans_detail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
