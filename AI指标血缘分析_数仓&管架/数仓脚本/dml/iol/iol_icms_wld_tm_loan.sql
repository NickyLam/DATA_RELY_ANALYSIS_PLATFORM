/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wld_tm_loan
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_wld_tm_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wld_tm_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_tm_loan_op purge;
drop table ${iol_schema}.icms_wld_tm_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_tm_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_tm_loan where 0=1;

create table ${iol_schema}.icms_wld_tm_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_tm_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_tm_loan_cl(
            org -- 机构号
            ,loanid -- 借据id
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,refnbr -- 交易参考号
            ,logicalcardno -- 逻辑卡号
            ,cardno -- 卡号
            ,registerdate -- 贷款注册日期
            ,requesttime -- 请求日期时间
            ,loantype -- 贷款类型
            ,loanstatus -- 贷款状态
            ,lastloanstatus -- 贷款上次状态
            ,loaninitterm -- 贷款总期数
            ,currterm -- 当前期数
            ,remainterm -- 剩余期数
            ,loaninitprin -- 贷款总本金
            ,loanfixedpmtprin -- 贷款每期应还本金
            ,loanfirsttermprin -- 贷款首期应还本金
            ,loanfinaltermprin -- 贷款末期应还本金
            ,loaninitfee1 -- 贷款总手续费
            ,loanfixedfee1 -- 贷款每期手续费
            ,loanfirsttermfee1 -- 贷款首期手续费
            ,loanfinaltermfee1 -- 贷款末期手续费
            ,unearnedprin -- 贷款账单的本金
            ,unearnedfee1 -- 贷款账单手续费
            ,paidoutdate -- 还清日期
            ,terminatedate -- 提前终止日期
            ,terminatereasoncd -- 贷款终止原因代码
            ,prinpaid -- 已偿还本金
            ,integerpaid -- 已偿还利息
            ,feepaid -- 已偿还费用
            ,loancurrbal -- 贷款当前总余额
            ,loanbalxfrout -- 贷款未到期余额
            ,loanbalxfrin -- 贷款已到期余额
            ,loanbalprincipal -- 欠款总本金
            ,loanbalintegererest -- 欠款总利息
            ,loanbalpenalty -- 欠款总罚息
            ,loanprinxfrout -- 贷款未到期本金
            ,loanprinxfrin -- 贷款已到期本金
            ,loanfee1xfrout -- 贷款未到期手续费
            ,loanfee1xfrin -- 贷款已到期手续费
            ,origtxnamt -- 原始交易币种金额
            ,origtransdate -- 原始交易日期
            ,origauthcode -- 原始交易授权码
            ,jpaversion -- 乐观锁版本号
            ,loancode -- 贷款产品号
            ,registerid -- 贷款申请顺序号
            ,reschinitprin -- 展期本金金额
            ,reschdate -- 展期生效日期
            ,befreschfixedpmtprin -- 展期前每期应还本金
            ,befreschinitterm -- 展期前总期数
            ,befreschfirsttermprin -- 展期前贷款首期应还本金
            ,befreschfinaltermprin -- 展期前贷款末期应还本金
            ,befreschinitfee1 -- 展期前贷款总手续费
            ,befreschfixedfee1 -- 贷款每期手续费
            ,befreschfirsttermfee1 -- 展期前贷款首期手续费
            ,befreschfinaltermfee1 -- 展期前贷款末期手续费
            ,reschfirsttermfee1 -- 展期后首期手续费
            ,loanfeemethod -- 贷款手续费收取方式
            ,integererestrate -- 基础利率
            ,penaltyrate -- 罚息利率
            ,compoundrate -- 复利利率
            ,floatrate -- 浮动比例
            ,loanreceiptnbr -- 借据号
            ,loanexpiredate -- 贷款到期日期
            ,loancd -- 贷款逾期最大期数
            ,paymenthist -- 24个月还款状态
            ,ctdpaymentamt -- 当期还款额
            ,pastreschcnt -- 已展期次数
            ,pastshortedcnt -- 已缩期次数
            ,advpmtamt -- 提前还款金额
            ,lastactiondate -- 上次行动日期
            ,lastactiontype -- 上次行动类型
            ,lastmodifieddatetime -- 修改时间
            ,activatedate -- 激活日期
            ,integererestcalcbase -- 计息基数
            ,firstbilldate -- 首个到期还款日
            ,agecd -- 账龄
            ,recalcind -- 利率重算标志
            ,recalcdate -- 利率重算日
            ,gracedate -- 宽限日期
            ,canceldate -- 撤销日期
            ,cancelreason -- 贷款撤销原因
            ,bankgroupid -- 参贷方案编号
            ,duedays -- 当前逾期天数
            ,contractver -- 合同版本号
            ,loaninitintegererest -- 贷款总利息
            ,befinitintegererest -- 原贷款总利息
            ,bankproportion -- 银行出资比例
            ,writeoffdate -- 核销日期
            ,hxloaninitprin -- 核销本金
            ,loanintrpenalty -- 核销利息罚息
            ,wldcustid -- 微粒贷客户号
            ,customerid -- 客户编号
            ,productid -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_tm_loan_op(
            org -- 机构号
            ,loanid -- 借据id
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,refnbr -- 交易参考号
            ,logicalcardno -- 逻辑卡号
            ,cardno -- 卡号
            ,registerdate -- 贷款注册日期
            ,requesttime -- 请求日期时间
            ,loantype -- 贷款类型
            ,loanstatus -- 贷款状态
            ,lastloanstatus -- 贷款上次状态
            ,loaninitterm -- 贷款总期数
            ,currterm -- 当前期数
            ,remainterm -- 剩余期数
            ,loaninitprin -- 贷款总本金
            ,loanfixedpmtprin -- 贷款每期应还本金
            ,loanfirsttermprin -- 贷款首期应还本金
            ,loanfinaltermprin -- 贷款末期应还本金
            ,loaninitfee1 -- 贷款总手续费
            ,loanfixedfee1 -- 贷款每期手续费
            ,loanfirsttermfee1 -- 贷款首期手续费
            ,loanfinaltermfee1 -- 贷款末期手续费
            ,unearnedprin -- 贷款账单的本金
            ,unearnedfee1 -- 贷款账单手续费
            ,paidoutdate -- 还清日期
            ,terminatedate -- 提前终止日期
            ,terminatereasoncd -- 贷款终止原因代码
            ,prinpaid -- 已偿还本金
            ,integerpaid -- 已偿还利息
            ,feepaid -- 已偿还费用
            ,loancurrbal -- 贷款当前总余额
            ,loanbalxfrout -- 贷款未到期余额
            ,loanbalxfrin -- 贷款已到期余额
            ,loanbalprincipal -- 欠款总本金
            ,loanbalintegererest -- 欠款总利息
            ,loanbalpenalty -- 欠款总罚息
            ,loanprinxfrout -- 贷款未到期本金
            ,loanprinxfrin -- 贷款已到期本金
            ,loanfee1xfrout -- 贷款未到期手续费
            ,loanfee1xfrin -- 贷款已到期手续费
            ,origtxnamt -- 原始交易币种金额
            ,origtransdate -- 原始交易日期
            ,origauthcode -- 原始交易授权码
            ,jpaversion -- 乐观锁版本号
            ,loancode -- 贷款产品号
            ,registerid -- 贷款申请顺序号
            ,reschinitprin -- 展期本金金额
            ,reschdate -- 展期生效日期
            ,befreschfixedpmtprin -- 展期前每期应还本金
            ,befreschinitterm -- 展期前总期数
            ,befreschfirsttermprin -- 展期前贷款首期应还本金
            ,befreschfinaltermprin -- 展期前贷款末期应还本金
            ,befreschinitfee1 -- 展期前贷款总手续费
            ,befreschfixedfee1 -- 贷款每期手续费
            ,befreschfirsttermfee1 -- 展期前贷款首期手续费
            ,befreschfinaltermfee1 -- 展期前贷款末期手续费
            ,reschfirsttermfee1 -- 展期后首期手续费
            ,loanfeemethod -- 贷款手续费收取方式
            ,integererestrate -- 基础利率
            ,penaltyrate -- 罚息利率
            ,compoundrate -- 复利利率
            ,floatrate -- 浮动比例
            ,loanreceiptnbr -- 借据号
            ,loanexpiredate -- 贷款到期日期
            ,loancd -- 贷款逾期最大期数
            ,paymenthist -- 24个月还款状态
            ,ctdpaymentamt -- 当期还款额
            ,pastreschcnt -- 已展期次数
            ,pastshortedcnt -- 已缩期次数
            ,advpmtamt -- 提前还款金额
            ,lastactiondate -- 上次行动日期
            ,lastactiontype -- 上次行动类型
            ,lastmodifieddatetime -- 修改时间
            ,activatedate -- 激活日期
            ,integererestcalcbase -- 计息基数
            ,firstbilldate -- 首个到期还款日
            ,agecd -- 账龄
            ,recalcind -- 利率重算标志
            ,recalcdate -- 利率重算日
            ,gracedate -- 宽限日期
            ,canceldate -- 撤销日期
            ,cancelreason -- 贷款撤销原因
            ,bankgroupid -- 参贷方案编号
            ,duedays -- 当前逾期天数
            ,contractver -- 合同版本号
            ,loaninitintegererest -- 贷款总利息
            ,befinitintegererest -- 原贷款总利息
            ,bankproportion -- 银行出资比例
            ,writeoffdate -- 核销日期
            ,hxloaninitprin -- 核销本金
            ,loanintrpenalty -- 核销利息罚息
            ,wldcustid -- 微粒贷客户号
            ,customerid -- 客户编号
            ,productid -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org, o.org) as org -- 机构号
    ,nvl(n.loanid, o.loanid) as loanid -- 借据id
    ,nvl(n.acctno, o.acctno) as acctno -- 账户编号
    ,nvl(n.accttype, o.accttype) as accttype -- 账户类型
    ,nvl(n.refnbr, o.refnbr) as refnbr -- 交易参考号
    ,nvl(n.logicalcardno, o.logicalcardno) as logicalcardno -- 逻辑卡号
    ,nvl(n.cardno, o.cardno) as cardno -- 卡号
    ,nvl(n.registerdate, o.registerdate) as registerdate -- 贷款注册日期
    ,nvl(n.requesttime, o.requesttime) as requesttime -- 请求日期时间
    ,nvl(n.loantype, o.loantype) as loantype -- 贷款类型
    ,nvl(n.loanstatus, o.loanstatus) as loanstatus -- 贷款状态
    ,nvl(n.lastloanstatus, o.lastloanstatus) as lastloanstatus -- 贷款上次状态
    ,nvl(n.loaninitterm, o.loaninitterm) as loaninitterm -- 贷款总期数
    ,nvl(n.currterm, o.currterm) as currterm -- 当前期数
    ,nvl(n.remainterm, o.remainterm) as remainterm -- 剩余期数
    ,nvl(n.loaninitprin, o.loaninitprin) as loaninitprin -- 贷款总本金
    ,nvl(n.loanfixedpmtprin, o.loanfixedpmtprin) as loanfixedpmtprin -- 贷款每期应还本金
    ,nvl(n.loanfirsttermprin, o.loanfirsttermprin) as loanfirsttermprin -- 贷款首期应还本金
    ,nvl(n.loanfinaltermprin, o.loanfinaltermprin) as loanfinaltermprin -- 贷款末期应还本金
    ,nvl(n.loaninitfee1, o.loaninitfee1) as loaninitfee1 -- 贷款总手续费
    ,nvl(n.loanfixedfee1, o.loanfixedfee1) as loanfixedfee1 -- 贷款每期手续费
    ,nvl(n.loanfirsttermfee1, o.loanfirsttermfee1) as loanfirsttermfee1 -- 贷款首期手续费
    ,nvl(n.loanfinaltermfee1, o.loanfinaltermfee1) as loanfinaltermfee1 -- 贷款末期手续费
    ,nvl(n.unearnedprin, o.unearnedprin) as unearnedprin -- 贷款账单的本金
    ,nvl(n.unearnedfee1, o.unearnedfee1) as unearnedfee1 -- 贷款账单手续费
    ,nvl(n.paidoutdate, o.paidoutdate) as paidoutdate -- 还清日期
    ,nvl(n.terminatedate, o.terminatedate) as terminatedate -- 提前终止日期
    ,nvl(n.terminatereasoncd, o.terminatereasoncd) as terminatereasoncd -- 贷款终止原因代码
    ,nvl(n.prinpaid, o.prinpaid) as prinpaid -- 已偿还本金
    ,nvl(n.integerpaid, o.integerpaid) as integerpaid -- 已偿还利息
    ,nvl(n.feepaid, o.feepaid) as feepaid -- 已偿还费用
    ,nvl(n.loancurrbal, o.loancurrbal) as loancurrbal -- 贷款当前总余额
    ,nvl(n.loanbalxfrout, o.loanbalxfrout) as loanbalxfrout -- 贷款未到期余额
    ,nvl(n.loanbalxfrin, o.loanbalxfrin) as loanbalxfrin -- 贷款已到期余额
    ,nvl(n.loanbalprincipal, o.loanbalprincipal) as loanbalprincipal -- 欠款总本金
    ,nvl(n.loanbalintegererest, o.loanbalintegererest) as loanbalintegererest -- 欠款总利息
    ,nvl(n.loanbalpenalty, o.loanbalpenalty) as loanbalpenalty -- 欠款总罚息
    ,nvl(n.loanprinxfrout, o.loanprinxfrout) as loanprinxfrout -- 贷款未到期本金
    ,nvl(n.loanprinxfrin, o.loanprinxfrin) as loanprinxfrin -- 贷款已到期本金
    ,nvl(n.loanfee1xfrout, o.loanfee1xfrout) as loanfee1xfrout -- 贷款未到期手续费
    ,nvl(n.loanfee1xfrin, o.loanfee1xfrin) as loanfee1xfrin -- 贷款已到期手续费
    ,nvl(n.origtxnamt, o.origtxnamt) as origtxnamt -- 原始交易币种金额
    ,nvl(n.origtransdate, o.origtransdate) as origtransdate -- 原始交易日期
    ,nvl(n.origauthcode, o.origauthcode) as origauthcode -- 原始交易授权码
    ,nvl(n.jpaversion, o.jpaversion) as jpaversion -- 乐观锁版本号
    ,nvl(n.loancode, o.loancode) as loancode -- 贷款产品号
    ,nvl(n.registerid, o.registerid) as registerid -- 贷款申请顺序号
    ,nvl(n.reschinitprin, o.reschinitprin) as reschinitprin -- 展期本金金额
    ,nvl(n.reschdate, o.reschdate) as reschdate -- 展期生效日期
    ,nvl(n.befreschfixedpmtprin, o.befreschfixedpmtprin) as befreschfixedpmtprin -- 展期前每期应还本金
    ,nvl(n.befreschinitterm, o.befreschinitterm) as befreschinitterm -- 展期前总期数
    ,nvl(n.befreschfirsttermprin, o.befreschfirsttermprin) as befreschfirsttermprin -- 展期前贷款首期应还本金
    ,nvl(n.befreschfinaltermprin, o.befreschfinaltermprin) as befreschfinaltermprin -- 展期前贷款末期应还本金
    ,nvl(n.befreschinitfee1, o.befreschinitfee1) as befreschinitfee1 -- 展期前贷款总手续费
    ,nvl(n.befreschfixedfee1, o.befreschfixedfee1) as befreschfixedfee1 -- 贷款每期手续费
    ,nvl(n.befreschfirsttermfee1, o.befreschfirsttermfee1) as befreschfirsttermfee1 -- 展期前贷款首期手续费
    ,nvl(n.befreschfinaltermfee1, o.befreschfinaltermfee1) as befreschfinaltermfee1 -- 展期前贷款末期手续费
    ,nvl(n.reschfirsttermfee1, o.reschfirsttermfee1) as reschfirsttermfee1 -- 展期后首期手续费
    ,nvl(n.loanfeemethod, o.loanfeemethod) as loanfeemethod -- 贷款手续费收取方式
    ,nvl(n.integererestrate, o.integererestrate) as integererestrate -- 基础利率
    ,nvl(n.penaltyrate, o.penaltyrate) as penaltyrate -- 罚息利率
    ,nvl(n.compoundrate, o.compoundrate) as compoundrate -- 复利利率
    ,nvl(n.floatrate, o.floatrate) as floatrate -- 浮动比例
    ,nvl(n.loanreceiptnbr, o.loanreceiptnbr) as loanreceiptnbr -- 借据号
    ,nvl(n.loanexpiredate, o.loanexpiredate) as loanexpiredate -- 贷款到期日期
    ,nvl(n.loancd, o.loancd) as loancd -- 贷款逾期最大期数
    ,nvl(n.paymenthist, o.paymenthist) as paymenthist -- 24个月还款状态
    ,nvl(n.ctdpaymentamt, o.ctdpaymentamt) as ctdpaymentamt -- 当期还款额
    ,nvl(n.pastreschcnt, o.pastreschcnt) as pastreschcnt -- 已展期次数
    ,nvl(n.pastshortedcnt, o.pastshortedcnt) as pastshortedcnt -- 已缩期次数
    ,nvl(n.advpmtamt, o.advpmtamt) as advpmtamt -- 提前还款金额
    ,nvl(n.lastactiondate, o.lastactiondate) as lastactiondate -- 上次行动日期
    ,nvl(n.lastactiontype, o.lastactiontype) as lastactiontype -- 上次行动类型
    ,nvl(n.lastmodifieddatetime, o.lastmodifieddatetime) as lastmodifieddatetime -- 修改时间
    ,nvl(n.activatedate, o.activatedate) as activatedate -- 激活日期
    ,nvl(n.integererestcalcbase, o.integererestcalcbase) as integererestcalcbase -- 计息基数
    ,nvl(n.firstbilldate, o.firstbilldate) as firstbilldate -- 首个到期还款日
    ,nvl(n.agecd, o.agecd) as agecd -- 账龄
    ,nvl(n.recalcind, o.recalcind) as recalcind -- 利率重算标志
    ,nvl(n.recalcdate, o.recalcdate) as recalcdate -- 利率重算日
    ,nvl(n.gracedate, o.gracedate) as gracedate -- 宽限日期
    ,nvl(n.canceldate, o.canceldate) as canceldate -- 撤销日期
    ,nvl(n.cancelreason, o.cancelreason) as cancelreason -- 贷款撤销原因
    ,nvl(n.bankgroupid, o.bankgroupid) as bankgroupid -- 参贷方案编号
    ,nvl(n.duedays, o.duedays) as duedays -- 当前逾期天数
    ,nvl(n.contractver, o.contractver) as contractver -- 合同版本号
    ,nvl(n.loaninitintegererest, o.loaninitintegererest) as loaninitintegererest -- 贷款总利息
    ,nvl(n.befinitintegererest, o.befinitintegererest) as befinitintegererest -- 原贷款总利息
    ,nvl(n.bankproportion, o.bankproportion) as bankproportion -- 银行出资比例
    ,nvl(n.writeoffdate, o.writeoffdate) as writeoffdate -- 核销日期
    ,nvl(n.hxloaninitprin, o.hxloaninitprin) as hxloaninitprin -- 核销本金
    ,nvl(n.loanintrpenalty, o.loanintrpenalty) as loanintrpenalty -- 核销利息罚息
    ,nvl(n.wldcustid, o.wldcustid) as wldcustid -- 微粒贷客户号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,case when
            n.refnbr is null
            and n.logicalcardno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.refnbr is null
            and n.logicalcardno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.refnbr is null
            and n.logicalcardno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wld_tm_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wld_tm_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.refnbr = n.refnbr
            and o.logicalcardno = n.logicalcardno
where (
        o.refnbr is null
        and o.logicalcardno is null
    )
    or (
        n.refnbr is null
        and n.logicalcardno is null
    )
    or (
        o.org <> n.org
        or o.loanid <> n.loanid
        or o.acctno <> n.acctno
        or o.accttype <> n.accttype
        or o.cardno <> n.cardno
        or o.registerdate <> n.registerdate
        or o.requesttime <> n.requesttime
        or o.loantype <> n.loantype
        or o.loanstatus <> n.loanstatus
        or o.lastloanstatus <> n.lastloanstatus
        or o.loaninitterm <> n.loaninitterm
        or o.currterm <> n.currterm
        or o.remainterm <> n.remainterm
        or o.loaninitprin <> n.loaninitprin
        or o.loanfixedpmtprin <> n.loanfixedpmtprin
        or o.loanfirsttermprin <> n.loanfirsttermprin
        or o.loanfinaltermprin <> n.loanfinaltermprin
        or o.loaninitfee1 <> n.loaninitfee1
        or o.loanfixedfee1 <> n.loanfixedfee1
        or o.loanfirsttermfee1 <> n.loanfirsttermfee1
        or o.loanfinaltermfee1 <> n.loanfinaltermfee1
        or o.unearnedprin <> n.unearnedprin
        or o.unearnedfee1 <> n.unearnedfee1
        or o.paidoutdate <> n.paidoutdate
        or o.terminatedate <> n.terminatedate
        or o.terminatereasoncd <> n.terminatereasoncd
        or o.prinpaid <> n.prinpaid
        or o.integerpaid <> n.integerpaid
        or o.feepaid <> n.feepaid
        or o.loancurrbal <> n.loancurrbal
        or o.loanbalxfrout <> n.loanbalxfrout
        or o.loanbalxfrin <> n.loanbalxfrin
        or o.loanbalprincipal <> n.loanbalprincipal
        or o.loanbalintegererest <> n.loanbalintegererest
        or o.loanbalpenalty <> n.loanbalpenalty
        or o.loanprinxfrout <> n.loanprinxfrout
        or o.loanprinxfrin <> n.loanprinxfrin
        or o.loanfee1xfrout <> n.loanfee1xfrout
        or o.loanfee1xfrin <> n.loanfee1xfrin
        or o.origtxnamt <> n.origtxnamt
        or o.origtransdate <> n.origtransdate
        or o.origauthcode <> n.origauthcode
        or o.jpaversion <> n.jpaversion
        or o.loancode <> n.loancode
        or o.registerid <> n.registerid
        or o.reschinitprin <> n.reschinitprin
        or o.reschdate <> n.reschdate
        or o.befreschfixedpmtprin <> n.befreschfixedpmtprin
        or o.befreschinitterm <> n.befreschinitterm
        or o.befreschfirsttermprin <> n.befreschfirsttermprin
        or o.befreschfinaltermprin <> n.befreschfinaltermprin
        or o.befreschinitfee1 <> n.befreschinitfee1
        or o.befreschfixedfee1 <> n.befreschfixedfee1
        or o.befreschfirsttermfee1 <> n.befreschfirsttermfee1
        or o.befreschfinaltermfee1 <> n.befreschfinaltermfee1
        or o.reschfirsttermfee1 <> n.reschfirsttermfee1
        or o.loanfeemethod <> n.loanfeemethod
        or o.integererestrate <> n.integererestrate
        or o.penaltyrate <> n.penaltyrate
        or o.compoundrate <> n.compoundrate
        or o.floatrate <> n.floatrate
        or o.loanreceiptnbr <> n.loanreceiptnbr
        or o.loanexpiredate <> n.loanexpiredate
        or o.loancd <> n.loancd
        or o.paymenthist <> n.paymenthist
        or o.ctdpaymentamt <> n.ctdpaymentamt
        or o.pastreschcnt <> n.pastreschcnt
        or o.pastshortedcnt <> n.pastshortedcnt
        or o.advpmtamt <> n.advpmtamt
        or o.lastactiondate <> n.lastactiondate
        or o.lastactiontype <> n.lastactiontype
        or o.lastmodifieddatetime <> n.lastmodifieddatetime
        or o.activatedate <> n.activatedate
        or o.integererestcalcbase <> n.integererestcalcbase
        or o.firstbilldate <> n.firstbilldate
        or o.agecd <> n.agecd
        or o.recalcind <> n.recalcind
        or o.recalcdate <> n.recalcdate
        or o.gracedate <> n.gracedate
        or o.canceldate <> n.canceldate
        or o.cancelreason <> n.cancelreason
        or o.bankgroupid <> n.bankgroupid
        or o.duedays <> n.duedays
        or o.contractver <> n.contractver
        or o.loaninitintegererest <> n.loaninitintegererest
        or o.befinitintegererest <> n.befinitintegererest
        or o.bankproportion <> n.bankproportion
        or o.writeoffdate <> n.writeoffdate
        or o.hxloaninitprin <> n.hxloaninitprin
        or o.loanintrpenalty <> n.loanintrpenalty
        or o.wldcustid <> n.wldcustid
        or o.customerid <> n.customerid
        or o.productid <> n.productid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_tm_loan_cl(
            org -- 机构号
            ,loanid -- 借据id
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,refnbr -- 交易参考号
            ,logicalcardno -- 逻辑卡号
            ,cardno -- 卡号
            ,registerdate -- 贷款注册日期
            ,requesttime -- 请求日期时间
            ,loantype -- 贷款类型
            ,loanstatus -- 贷款状态
            ,lastloanstatus -- 贷款上次状态
            ,loaninitterm -- 贷款总期数
            ,currterm -- 当前期数
            ,remainterm -- 剩余期数
            ,loaninitprin -- 贷款总本金
            ,loanfixedpmtprin -- 贷款每期应还本金
            ,loanfirsttermprin -- 贷款首期应还本金
            ,loanfinaltermprin -- 贷款末期应还本金
            ,loaninitfee1 -- 贷款总手续费
            ,loanfixedfee1 -- 贷款每期手续费
            ,loanfirsttermfee1 -- 贷款首期手续费
            ,loanfinaltermfee1 -- 贷款末期手续费
            ,unearnedprin -- 贷款账单的本金
            ,unearnedfee1 -- 贷款账单手续费
            ,paidoutdate -- 还清日期
            ,terminatedate -- 提前终止日期
            ,terminatereasoncd -- 贷款终止原因代码
            ,prinpaid -- 已偿还本金
            ,integerpaid -- 已偿还利息
            ,feepaid -- 已偿还费用
            ,loancurrbal -- 贷款当前总余额
            ,loanbalxfrout -- 贷款未到期余额
            ,loanbalxfrin -- 贷款已到期余额
            ,loanbalprincipal -- 欠款总本金
            ,loanbalintegererest -- 欠款总利息
            ,loanbalpenalty -- 欠款总罚息
            ,loanprinxfrout -- 贷款未到期本金
            ,loanprinxfrin -- 贷款已到期本金
            ,loanfee1xfrout -- 贷款未到期手续费
            ,loanfee1xfrin -- 贷款已到期手续费
            ,origtxnamt -- 原始交易币种金额
            ,origtransdate -- 原始交易日期
            ,origauthcode -- 原始交易授权码
            ,jpaversion -- 乐观锁版本号
            ,loancode -- 贷款产品号
            ,registerid -- 贷款申请顺序号
            ,reschinitprin -- 展期本金金额
            ,reschdate -- 展期生效日期
            ,befreschfixedpmtprin -- 展期前每期应还本金
            ,befreschinitterm -- 展期前总期数
            ,befreschfirsttermprin -- 展期前贷款首期应还本金
            ,befreschfinaltermprin -- 展期前贷款末期应还本金
            ,befreschinitfee1 -- 展期前贷款总手续费
            ,befreschfixedfee1 -- 贷款每期手续费
            ,befreschfirsttermfee1 -- 展期前贷款首期手续费
            ,befreschfinaltermfee1 -- 展期前贷款末期手续费
            ,reschfirsttermfee1 -- 展期后首期手续费
            ,loanfeemethod -- 贷款手续费收取方式
            ,integererestrate -- 基础利率
            ,penaltyrate -- 罚息利率
            ,compoundrate -- 复利利率
            ,floatrate -- 浮动比例
            ,loanreceiptnbr -- 借据号
            ,loanexpiredate -- 贷款到期日期
            ,loancd -- 贷款逾期最大期数
            ,paymenthist -- 24个月还款状态
            ,ctdpaymentamt -- 当期还款额
            ,pastreschcnt -- 已展期次数
            ,pastshortedcnt -- 已缩期次数
            ,advpmtamt -- 提前还款金额
            ,lastactiondate -- 上次行动日期
            ,lastactiontype -- 上次行动类型
            ,lastmodifieddatetime -- 修改时间
            ,activatedate -- 激活日期
            ,integererestcalcbase -- 计息基数
            ,firstbilldate -- 首个到期还款日
            ,agecd -- 账龄
            ,recalcind -- 利率重算标志
            ,recalcdate -- 利率重算日
            ,gracedate -- 宽限日期
            ,canceldate -- 撤销日期
            ,cancelreason -- 贷款撤销原因
            ,bankgroupid -- 参贷方案编号
            ,duedays -- 当前逾期天数
            ,contractver -- 合同版本号
            ,loaninitintegererest -- 贷款总利息
            ,befinitintegererest -- 原贷款总利息
            ,bankproportion -- 银行出资比例
            ,writeoffdate -- 核销日期
            ,hxloaninitprin -- 核销本金
            ,loanintrpenalty -- 核销利息罚息
            ,wldcustid -- 微粒贷客户号
            ,customerid -- 客户编号
            ,productid -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_tm_loan_op(
            org -- 机构号
            ,loanid -- 借据id
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,refnbr -- 交易参考号
            ,logicalcardno -- 逻辑卡号
            ,cardno -- 卡号
            ,registerdate -- 贷款注册日期
            ,requesttime -- 请求日期时间
            ,loantype -- 贷款类型
            ,loanstatus -- 贷款状态
            ,lastloanstatus -- 贷款上次状态
            ,loaninitterm -- 贷款总期数
            ,currterm -- 当前期数
            ,remainterm -- 剩余期数
            ,loaninitprin -- 贷款总本金
            ,loanfixedpmtprin -- 贷款每期应还本金
            ,loanfirsttermprin -- 贷款首期应还本金
            ,loanfinaltermprin -- 贷款末期应还本金
            ,loaninitfee1 -- 贷款总手续费
            ,loanfixedfee1 -- 贷款每期手续费
            ,loanfirsttermfee1 -- 贷款首期手续费
            ,loanfinaltermfee1 -- 贷款末期手续费
            ,unearnedprin -- 贷款账单的本金
            ,unearnedfee1 -- 贷款账单手续费
            ,paidoutdate -- 还清日期
            ,terminatedate -- 提前终止日期
            ,terminatereasoncd -- 贷款终止原因代码
            ,prinpaid -- 已偿还本金
            ,integerpaid -- 已偿还利息
            ,feepaid -- 已偿还费用
            ,loancurrbal -- 贷款当前总余额
            ,loanbalxfrout -- 贷款未到期余额
            ,loanbalxfrin -- 贷款已到期余额
            ,loanbalprincipal -- 欠款总本金
            ,loanbalintegererest -- 欠款总利息
            ,loanbalpenalty -- 欠款总罚息
            ,loanprinxfrout -- 贷款未到期本金
            ,loanprinxfrin -- 贷款已到期本金
            ,loanfee1xfrout -- 贷款未到期手续费
            ,loanfee1xfrin -- 贷款已到期手续费
            ,origtxnamt -- 原始交易币种金额
            ,origtransdate -- 原始交易日期
            ,origauthcode -- 原始交易授权码
            ,jpaversion -- 乐观锁版本号
            ,loancode -- 贷款产品号
            ,registerid -- 贷款申请顺序号
            ,reschinitprin -- 展期本金金额
            ,reschdate -- 展期生效日期
            ,befreschfixedpmtprin -- 展期前每期应还本金
            ,befreschinitterm -- 展期前总期数
            ,befreschfirsttermprin -- 展期前贷款首期应还本金
            ,befreschfinaltermprin -- 展期前贷款末期应还本金
            ,befreschinitfee1 -- 展期前贷款总手续费
            ,befreschfixedfee1 -- 贷款每期手续费
            ,befreschfirsttermfee1 -- 展期前贷款首期手续费
            ,befreschfinaltermfee1 -- 展期前贷款末期手续费
            ,reschfirsttermfee1 -- 展期后首期手续费
            ,loanfeemethod -- 贷款手续费收取方式
            ,integererestrate -- 基础利率
            ,penaltyrate -- 罚息利率
            ,compoundrate -- 复利利率
            ,floatrate -- 浮动比例
            ,loanreceiptnbr -- 借据号
            ,loanexpiredate -- 贷款到期日期
            ,loancd -- 贷款逾期最大期数
            ,paymenthist -- 24个月还款状态
            ,ctdpaymentamt -- 当期还款额
            ,pastreschcnt -- 已展期次数
            ,pastshortedcnt -- 已缩期次数
            ,advpmtamt -- 提前还款金额
            ,lastactiondate -- 上次行动日期
            ,lastactiontype -- 上次行动类型
            ,lastmodifieddatetime -- 修改时间
            ,activatedate -- 激活日期
            ,integererestcalcbase -- 计息基数
            ,firstbilldate -- 首个到期还款日
            ,agecd -- 账龄
            ,recalcind -- 利率重算标志
            ,recalcdate -- 利率重算日
            ,gracedate -- 宽限日期
            ,canceldate -- 撤销日期
            ,cancelreason -- 贷款撤销原因
            ,bankgroupid -- 参贷方案编号
            ,duedays -- 当前逾期天数
            ,contractver -- 合同版本号
            ,loaninitintegererest -- 贷款总利息
            ,befinitintegererest -- 原贷款总利息
            ,bankproportion -- 银行出资比例
            ,writeoffdate -- 核销日期
            ,hxloaninitprin -- 核销本金
            ,loanintrpenalty -- 核销利息罚息
            ,wldcustid -- 微粒贷客户号
            ,customerid -- 客户编号
            ,productid -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.loanid -- 借据id
    ,o.acctno -- 账户编号
    ,o.accttype -- 账户类型
    ,o.refnbr -- 交易参考号
    ,o.logicalcardno -- 逻辑卡号
    ,o.cardno -- 卡号
    ,o.registerdate -- 贷款注册日期
    ,o.requesttime -- 请求日期时间
    ,o.loantype -- 贷款类型
    ,o.loanstatus -- 贷款状态
    ,o.lastloanstatus -- 贷款上次状态
    ,o.loaninitterm -- 贷款总期数
    ,o.currterm -- 当前期数
    ,o.remainterm -- 剩余期数
    ,o.loaninitprin -- 贷款总本金
    ,o.loanfixedpmtprin -- 贷款每期应还本金
    ,o.loanfirsttermprin -- 贷款首期应还本金
    ,o.loanfinaltermprin -- 贷款末期应还本金
    ,o.loaninitfee1 -- 贷款总手续费
    ,o.loanfixedfee1 -- 贷款每期手续费
    ,o.loanfirsttermfee1 -- 贷款首期手续费
    ,o.loanfinaltermfee1 -- 贷款末期手续费
    ,o.unearnedprin -- 贷款账单的本金
    ,o.unearnedfee1 -- 贷款账单手续费
    ,o.paidoutdate -- 还清日期
    ,o.terminatedate -- 提前终止日期
    ,o.terminatereasoncd -- 贷款终止原因代码
    ,o.prinpaid -- 已偿还本金
    ,o.integerpaid -- 已偿还利息
    ,o.feepaid -- 已偿还费用
    ,o.loancurrbal -- 贷款当前总余额
    ,o.loanbalxfrout -- 贷款未到期余额
    ,o.loanbalxfrin -- 贷款已到期余额
    ,o.loanbalprincipal -- 欠款总本金
    ,o.loanbalintegererest -- 欠款总利息
    ,o.loanbalpenalty -- 欠款总罚息
    ,o.loanprinxfrout -- 贷款未到期本金
    ,o.loanprinxfrin -- 贷款已到期本金
    ,o.loanfee1xfrout -- 贷款未到期手续费
    ,o.loanfee1xfrin -- 贷款已到期手续费
    ,o.origtxnamt -- 原始交易币种金额
    ,o.origtransdate -- 原始交易日期
    ,o.origauthcode -- 原始交易授权码
    ,o.jpaversion -- 乐观锁版本号
    ,o.loancode -- 贷款产品号
    ,o.registerid -- 贷款申请顺序号
    ,o.reschinitprin -- 展期本金金额
    ,o.reschdate -- 展期生效日期
    ,o.befreschfixedpmtprin -- 展期前每期应还本金
    ,o.befreschinitterm -- 展期前总期数
    ,o.befreschfirsttermprin -- 展期前贷款首期应还本金
    ,o.befreschfinaltermprin -- 展期前贷款末期应还本金
    ,o.befreschinitfee1 -- 展期前贷款总手续费
    ,o.befreschfixedfee1 -- 贷款每期手续费
    ,o.befreschfirsttermfee1 -- 展期前贷款首期手续费
    ,o.befreschfinaltermfee1 -- 展期前贷款末期手续费
    ,o.reschfirsttermfee1 -- 展期后首期手续费
    ,o.loanfeemethod -- 贷款手续费收取方式
    ,o.integererestrate -- 基础利率
    ,o.penaltyrate -- 罚息利率
    ,o.compoundrate -- 复利利率
    ,o.floatrate -- 浮动比例
    ,o.loanreceiptnbr -- 借据号
    ,o.loanexpiredate -- 贷款到期日期
    ,o.loancd -- 贷款逾期最大期数
    ,o.paymenthist -- 24个月还款状态
    ,o.ctdpaymentamt -- 当期还款额
    ,o.pastreschcnt -- 已展期次数
    ,o.pastshortedcnt -- 已缩期次数
    ,o.advpmtamt -- 提前还款金额
    ,o.lastactiondate -- 上次行动日期
    ,o.lastactiontype -- 上次行动类型
    ,o.lastmodifieddatetime -- 修改时间
    ,o.activatedate -- 激活日期
    ,o.integererestcalcbase -- 计息基数
    ,o.firstbilldate -- 首个到期还款日
    ,o.agecd -- 账龄
    ,o.recalcind -- 利率重算标志
    ,o.recalcdate -- 利率重算日
    ,o.gracedate -- 宽限日期
    ,o.canceldate -- 撤销日期
    ,o.cancelreason -- 贷款撤销原因
    ,o.bankgroupid -- 参贷方案编号
    ,o.duedays -- 当前逾期天数
    ,o.contractver -- 合同版本号
    ,o.loaninitintegererest -- 贷款总利息
    ,o.befinitintegererest -- 原贷款总利息
    ,o.bankproportion -- 银行出资比例
    ,o.writeoffdate -- 核销日期
    ,o.hxloaninitprin -- 核销本金
    ,o.loanintrpenalty -- 核销利息罚息
    ,o.wldcustid -- 微粒贷客户号
    ,o.customerid -- 客户编号
    ,o.productid -- 产品编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_wld_tm_loan_bk o
    left join ${iol_schema}.icms_wld_tm_loan_op n
        on
            o.refnbr = n.refnbr
            and o.logicalcardno = n.logicalcardno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wld_tm_loan_cl d
        on
            o.refnbr = d.refnbr
            and o.logicalcardno = d.logicalcardno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wld_tm_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wld_tm_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wld_tm_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wld_tm_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wld_tm_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_wld_tm_loan_cl;
alter table ${iol_schema}.icms_wld_tm_loan exchange partition p_20991231 with table ${iol_schema}.icms_wld_tm_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wld_tm_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_tm_loan_op purge;
drop table ${iol_schema}.icms_wld_tm_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wld_tm_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wld_tm_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
