/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_jdjr_acc_loan
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
create table ${iol_schema}.icms_jdjr_acc_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_jdjr_acc_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_acc_loan_op purge;
drop table ${iol_schema}.icms_jdjr_acc_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_acc_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_jdjr_acc_loan where 0=1;

create table ${iol_schema}.icms_jdjr_acc_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_jdjr_acc_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_jdjr_acc_loan_cl(
            contno -- 客户签订的合同号码，即借据号、出资方贷款单号
            ,countenchashfee -- 应计取现手续费
            ,laonrealityrate -- 借款执行利率
            ,limitno -- 客户额度编号
            ,cusid -- 客户号
            ,prdcode -- 产品编号(行内)
            ,enchashfeerate -- 取现手续费利率
            ,cusno -- 京东pin
            ,loanterms -- 贷款期数
            ,lpr -- LPR
            ,instovdinterest -- 改分期逾期利息
            ,volfeerate -- 违约金利率
            ,loaninneraccount -- 贷款入帐账号
            ,ratefloatmode -- 利率浮动方式
            ,iswhite -- 
            ,bussdate -- 数据日期
            ,instpricbalance -- 改分期本金余额
            ,loanrepayaccount -- 还款账号
            ,execrate -- 执行年利率，京东推送日利率X360
            ,floatratebp -- 利率浮动点差BP
            ,loanserno -- 放款流水号
            ,certno -- 证件号
            ,intovdstartdt -- 利息逾期日期
            ,loanovdbalance -- 逾期贷款余额
            ,inpnltamt -- 应计罚息
            ,withenchashfeeday -- 当日计提取现手续费
            ,repayinthz -- 利息还款频率
            ,prinovdstartdt -- 本金逾期日期
            ,loanoutintbalance -- 表外欠息
            ,loanrate -- 借款利率
            ,laonrealityratetype -- 借款执行利率类型
            ,feeratetype -- 手续费费率类型D、日M、月W、周
            ,isbankrel -- 是否关联人1是2否
            ,currency -- 参见币种表
            ,instpricovdbalance -- 改分期本金逾期余额
            ,migtflag -- 
            ,loanenddt -- 业务到期日期
            ,prdno -- 产品编号
            ,loanstartdt -- 放款日期
            ,localarea -- 贷款资金使用位置
            ,intnextpaydt -- 下一付息日
            ,intflag -- 计息标志
            ,repaychangetype -- 新增还款变更类型
            ,volfeeratetype -- 违约金费率类型
            ,loanno -- 借据号
            ,ovdterms -- 逾期期数
            ,countvolfee -- 应计违约金
            ,loanstatus -- 贷款状态
            ,pnltrate -- 罚息利率
            ,loanratetype -- 借款利率类型
            ,instinterest -- 改分期利息
            ,volfeeday -- 当日违约金
            ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
            ,selfpayamt -- 自主支付金额
            ,todaypnltintamt -- 当日罚息
            ,instintpenalty -- 改分期罚息
            ,busmodel -- 业务模式
            ,loanamt -- 贷款放款金额
            ,repayprinhz -- 本金还款频率
            ,ratetype -- 利率调整方式
            ,todayintamt -- 当日利息
            ,cusname -- 客户姓名
            ,ratelprtype -- 利率类型1基准利率2LPR
            ,loansucessreceivedate -- 放款成功接收日期YYYYMMMMDD
            ,loanbalance -- 贷款余额
            ,loanovdintbalance -- 逾期利息
            ,granttype -- 贷款担保方式
            ,repaytype -- 还款方式
            ,ordinterest -- 普通利息
            ,ordovdinterest -- 普通逾期利息
            ,ordintpenalty -- 普通罚息
            ,unrepaysterms -- 待还期数
            ,outterms -- 表外期数
            ,ovdflag -- 贷款逾期标志
            ,intamt -- 应计利息
            ,inputid -- 所属客户经理
            ,ordpricbalance -- 普通本金余额
            ,ovddays -- 逾期天数
            ,ordpricovdbalance -- 普通本金逾期余额
            ,pnltratetype -- 罚息利率类型
            ,loanuseway -- 借款用途
            ,entrustedpayamt -- 受托支付金额
            ,extenddays -- 逾期宽限天数
            ,cleardate -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_jdjr_acc_loan_op(
            contno -- 客户签订的合同号码，即借据号、出资方贷款单号
            ,countenchashfee -- 应计取现手续费
            ,laonrealityrate -- 借款执行利率
            ,limitno -- 客户额度编号
            ,cusid -- 客户号
            ,prdcode -- 产品编号(行内)
            ,enchashfeerate -- 取现手续费利率
            ,cusno -- 京东pin
            ,loanterms -- 贷款期数
            ,lpr -- LPR
            ,instovdinterest -- 改分期逾期利息
            ,volfeerate -- 违约金利率
            ,loaninneraccount -- 贷款入帐账号
            ,ratefloatmode -- 利率浮动方式
            ,iswhite -- 
            ,bussdate -- 数据日期
            ,instpricbalance -- 改分期本金余额
            ,loanrepayaccount -- 还款账号
            ,execrate -- 执行年利率，京东推送日利率X360
            ,floatratebp -- 利率浮动点差BP
            ,loanserno -- 放款流水号
            ,certno -- 证件号
            ,intovdstartdt -- 利息逾期日期
            ,loanovdbalance -- 逾期贷款余额
            ,inpnltamt -- 应计罚息
            ,withenchashfeeday -- 当日计提取现手续费
            ,repayinthz -- 利息还款频率
            ,prinovdstartdt -- 本金逾期日期
            ,loanoutintbalance -- 表外欠息
            ,loanrate -- 借款利率
            ,laonrealityratetype -- 借款执行利率类型
            ,feeratetype -- 手续费费率类型D、日M、月W、周
            ,isbankrel -- 是否关联人1是2否
            ,currency -- 参见币种表
            ,instpricovdbalance -- 改分期本金逾期余额
            ,migtflag -- 
            ,loanenddt -- 业务到期日期
            ,prdno -- 产品编号
            ,loanstartdt -- 放款日期
            ,localarea -- 贷款资金使用位置
            ,intnextpaydt -- 下一付息日
            ,intflag -- 计息标志
            ,repaychangetype -- 新增还款变更类型
            ,volfeeratetype -- 违约金费率类型
            ,loanno -- 借据号
            ,ovdterms -- 逾期期数
            ,countvolfee -- 应计违约金
            ,loanstatus -- 贷款状态
            ,pnltrate -- 罚息利率
            ,loanratetype -- 借款利率类型
            ,instinterest -- 改分期利息
            ,volfeeday -- 当日违约金
            ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
            ,selfpayamt -- 自主支付金额
            ,todaypnltintamt -- 当日罚息
            ,instintpenalty -- 改分期罚息
            ,busmodel -- 业务模式
            ,loanamt -- 贷款放款金额
            ,repayprinhz -- 本金还款频率
            ,ratetype -- 利率调整方式
            ,todayintamt -- 当日利息
            ,cusname -- 客户姓名
            ,ratelprtype -- 利率类型1基准利率2LPR
            ,loansucessreceivedate -- 放款成功接收日期YYYYMMMMDD
            ,loanbalance -- 贷款余额
            ,loanovdintbalance -- 逾期利息
            ,granttype -- 贷款担保方式
            ,repaytype -- 还款方式
            ,ordinterest -- 普通利息
            ,ordovdinterest -- 普通逾期利息
            ,ordintpenalty -- 普通罚息
            ,unrepaysterms -- 待还期数
            ,outterms -- 表外期数
            ,ovdflag -- 贷款逾期标志
            ,intamt -- 应计利息
            ,inputid -- 所属客户经理
            ,ordpricbalance -- 普通本金余额
            ,ovddays -- 逾期天数
            ,ordpricovdbalance -- 普通本金逾期余额
            ,pnltratetype -- 罚息利率类型
            ,loanuseway -- 借款用途
            ,entrustedpayamt -- 受托支付金额
            ,extenddays -- 逾期宽限天数
            ,cleardate -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.contno, o.contno) as contno -- 客户签订的合同号码，即借据号、出资方贷款单号
    ,nvl(n.countenchashfee, o.countenchashfee) as countenchashfee -- 应计取现手续费
    ,nvl(n.laonrealityrate, o.laonrealityrate) as laonrealityrate -- 借款执行利率
    ,nvl(n.limitno, o.limitno) as limitno -- 客户额度编号
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号(行内)
    ,nvl(n.enchashfeerate, o.enchashfeerate) as enchashfeerate -- 取现手续费利率
    ,nvl(n.cusno, o.cusno) as cusno -- 京东pin
    ,nvl(n.loanterms, o.loanterms) as loanterms -- 贷款期数
    ,nvl(n.lpr, o.lpr) as lpr -- LPR
    ,nvl(n.instovdinterest, o.instovdinterest) as instovdinterest -- 改分期逾期利息
    ,nvl(n.volfeerate, o.volfeerate) as volfeerate -- 违约金利率
    ,nvl(n.loaninneraccount, o.loaninneraccount) as loaninneraccount -- 贷款入帐账号
    ,nvl(n.ratefloatmode, o.ratefloatmode) as ratefloatmode -- 利率浮动方式
    ,nvl(n.iswhite, o.iswhite) as iswhite -- 
    ,nvl(n.bussdate, o.bussdate) as bussdate -- 数据日期
    ,nvl(n.instpricbalance, o.instpricbalance) as instpricbalance -- 改分期本金余额
    ,nvl(n.loanrepayaccount, o.loanrepayaccount) as loanrepayaccount -- 还款账号
    ,nvl(n.execrate, o.execrate) as execrate -- 执行年利率，京东推送日利率X360
    ,nvl(n.floatratebp, o.floatratebp) as floatratebp -- 利率浮动点差BP
    ,nvl(n.loanserno, o.loanserno) as loanserno -- 放款流水号
    ,nvl(n.certno, o.certno) as certno -- 证件号
    ,nvl(n.intovdstartdt, o.intovdstartdt) as intovdstartdt -- 利息逾期日期
    ,nvl(n.loanovdbalance, o.loanovdbalance) as loanovdbalance -- 逾期贷款余额
    ,nvl(n.inpnltamt, o.inpnltamt) as inpnltamt -- 应计罚息
    ,nvl(n.withenchashfeeday, o.withenchashfeeday) as withenchashfeeday -- 当日计提取现手续费
    ,nvl(n.repayinthz, o.repayinthz) as repayinthz -- 利息还款频率
    ,nvl(n.prinovdstartdt, o.prinovdstartdt) as prinovdstartdt -- 本金逾期日期
    ,nvl(n.loanoutintbalance, o.loanoutintbalance) as loanoutintbalance -- 表外欠息
    ,nvl(n.loanrate, o.loanrate) as loanrate -- 借款利率
    ,nvl(n.laonrealityratetype, o.laonrealityratetype) as laonrealityratetype -- 借款执行利率类型
    ,nvl(n.feeratetype, o.feeratetype) as feeratetype -- 手续费费率类型D、日M、月W、周
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否关联人1是2否
    ,nvl(n.currency, o.currency) as currency -- 参见币种表
    ,nvl(n.instpricovdbalance, o.instpricovdbalance) as instpricovdbalance -- 改分期本金逾期余额
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.loanenddt, o.loanenddt) as loanenddt -- 业务到期日期
    ,nvl(n.prdno, o.prdno) as prdno -- 产品编号
    ,nvl(n.loanstartdt, o.loanstartdt) as loanstartdt -- 放款日期
    ,nvl(n.localarea, o.localarea) as localarea -- 贷款资金使用位置
    ,nvl(n.intnextpaydt, o.intnextpaydt) as intnextpaydt -- 下一付息日
    ,nvl(n.intflag, o.intflag) as intflag -- 计息标志
    ,nvl(n.repaychangetype, o.repaychangetype) as repaychangetype -- 新增还款变更类型
    ,nvl(n.volfeeratetype, o.volfeeratetype) as volfeeratetype -- 违约金费率类型
    ,nvl(n.loanno, o.loanno) as loanno -- 借据号
    ,nvl(n.ovdterms, o.ovdterms) as ovdterms -- 逾期期数
    ,nvl(n.countvolfee, o.countvolfee) as countvolfee -- 应计违约金
    ,nvl(n.loanstatus, o.loanstatus) as loanstatus -- 贷款状态
    ,nvl(n.pnltrate, o.pnltrate) as pnltrate -- 罚息利率
    ,nvl(n.loanratetype, o.loanratetype) as loanratetype -- 借款利率类型
    ,nvl(n.instinterest, o.instinterest) as instinterest -- 改分期利息
    ,nvl(n.volfeeday, o.volfeeday) as volfeeday -- 当日违约金
    ,nvl(n.assetthreetypecd, o.assetthreetypecd) as assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,nvl(n.selfpayamt, o.selfpayamt) as selfpayamt -- 自主支付金额
    ,nvl(n.todaypnltintamt, o.todaypnltintamt) as todaypnltintamt -- 当日罚息
    ,nvl(n.instintpenalty, o.instintpenalty) as instintpenalty -- 改分期罚息
    ,nvl(n.busmodel, o.busmodel) as busmodel -- 业务模式
    ,nvl(n.loanamt, o.loanamt) as loanamt -- 贷款放款金额
    ,nvl(n.repayprinhz, o.repayprinhz) as repayprinhz -- 本金还款频率
    ,nvl(n.ratetype, o.ratetype) as ratetype -- 利率调整方式
    ,nvl(n.todayintamt, o.todayintamt) as todayintamt -- 当日利息
    ,nvl(n.cusname, o.cusname) as cusname -- 客户姓名
    ,nvl(n.ratelprtype, o.ratelprtype) as ratelprtype -- 利率类型1基准利率2LPR
    ,nvl(n.loansucessreceivedate, o.loansucessreceivedate) as loansucessreceivedate -- 放款成功接收日期YYYYMMMMDD
    ,nvl(n.loanbalance, o.loanbalance) as loanbalance -- 贷款余额
    ,nvl(n.loanovdintbalance, o.loanovdintbalance) as loanovdintbalance -- 逾期利息
    ,nvl(n.granttype, o.granttype) as granttype -- 贷款担保方式
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.ordinterest, o.ordinterest) as ordinterest -- 普通利息
    ,nvl(n.ordovdinterest, o.ordovdinterest) as ordovdinterest -- 普通逾期利息
    ,nvl(n.ordintpenalty, o.ordintpenalty) as ordintpenalty -- 普通罚息
    ,nvl(n.unrepaysterms, o.unrepaysterms) as unrepaysterms -- 待还期数
    ,nvl(n.outterms, o.outterms) as outterms -- 表外期数
    ,nvl(n.ovdflag, o.ovdflag) as ovdflag -- 贷款逾期标志
    ,nvl(n.intamt, o.intamt) as intamt -- 应计利息
    ,nvl(n.inputid, o.inputid) as inputid -- 所属客户经理
    ,nvl(n.ordpricbalance, o.ordpricbalance) as ordpricbalance -- 普通本金余额
    ,nvl(n.ovddays, o.ovddays) as ovddays -- 逾期天数
    ,nvl(n.ordpricovdbalance, o.ordpricovdbalance) as ordpricovdbalance -- 普通本金逾期余额
    ,nvl(n.pnltratetype, o.pnltratetype) as pnltratetype -- 罚息利率类型
    ,nvl(n.loanuseway, o.loanuseway) as loanuseway -- 借款用途
    ,nvl(n.entrustedpayamt, o.entrustedpayamt) as entrustedpayamt -- 受托支付金额
    ,nvl(n.extenddays, o.extenddays) as extenddays -- 逾期宽限天数
    ,nvl(n.cleardate, o.cleardate) as cleardate -- 结清日期
    ,case when
            n.contno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.contno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.contno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_jdjr_acc_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_jdjr_acc_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.contno = n.contno
where (
        o.contno is null
    )
    or (
        n.contno is null
    )
    or (
        o.countenchashfee <> n.countenchashfee
        or o.laonrealityrate <> n.laonrealityrate
        or o.limitno <> n.limitno
        or o.cusid <> n.cusid
        or o.prdcode <> n.prdcode
        or o.enchashfeerate <> n.enchashfeerate
        or o.cusno <> n.cusno
        or o.loanterms <> n.loanterms
        or o.lpr <> n.lpr
        or o.instovdinterest <> n.instovdinterest
        or o.volfeerate <> n.volfeerate
        or o.loaninneraccount <> n.loaninneraccount
        or o.ratefloatmode <> n.ratefloatmode
        or o.iswhite <> n.iswhite
        or o.bussdate <> n.bussdate
        or o.instpricbalance <> n.instpricbalance
        or o.loanrepayaccount <> n.loanrepayaccount
        or o.execrate <> n.execrate
        or o.floatratebp <> n.floatratebp
        or o.loanserno <> n.loanserno
        or o.certno <> n.certno
        or o.intovdstartdt <> n.intovdstartdt
        or o.loanovdbalance <> n.loanovdbalance
        or o.inpnltamt <> n.inpnltamt
        or o.withenchashfeeday <> n.withenchashfeeday
        or o.repayinthz <> n.repayinthz
        or o.prinovdstartdt <> n.prinovdstartdt
        or o.loanoutintbalance <> n.loanoutintbalance
        or o.loanrate <> n.loanrate
        or o.laonrealityratetype <> n.laonrealityratetype
        or o.feeratetype <> n.feeratetype
        or o.isbankrel <> n.isbankrel
        or o.currency <> n.currency
        or o.instpricovdbalance <> n.instpricovdbalance
        or o.migtflag <> n.migtflag
        or o.loanenddt <> n.loanenddt
        or o.prdno <> n.prdno
        or o.loanstartdt <> n.loanstartdt
        or o.localarea <> n.localarea
        or o.intnextpaydt <> n.intnextpaydt
        or o.intflag <> n.intflag
        or o.repaychangetype <> n.repaychangetype
        or o.volfeeratetype <> n.volfeeratetype
        or o.loanno <> n.loanno
        or o.ovdterms <> n.ovdterms
        or o.countvolfee <> n.countvolfee
        or o.loanstatus <> n.loanstatus
        or o.pnltrate <> n.pnltrate
        or o.loanratetype <> n.loanratetype
        or o.instinterest <> n.instinterest
        or o.volfeeday <> n.volfeeday
        or o.assetthreetypecd <> n.assetthreetypecd
        or o.selfpayamt <> n.selfpayamt
        or o.todaypnltintamt <> n.todaypnltintamt
        or o.instintpenalty <> n.instintpenalty
        or o.busmodel <> n.busmodel
        or o.loanamt <> n.loanamt
        or o.repayprinhz <> n.repayprinhz
        or o.ratetype <> n.ratetype
        or o.todayintamt <> n.todayintamt
        or o.cusname <> n.cusname
        or o.ratelprtype <> n.ratelprtype
        or o.loansucessreceivedate <> n.loansucessreceivedate
        or o.loanbalance <> n.loanbalance
        or o.loanovdintbalance <> n.loanovdintbalance
        or o.granttype <> n.granttype
        or o.repaytype <> n.repaytype
        or o.ordinterest <> n.ordinterest
        or o.ordovdinterest <> n.ordovdinterest
        or o.ordintpenalty <> n.ordintpenalty
        or o.unrepaysterms <> n.unrepaysterms
        or o.outterms <> n.outterms
        or o.ovdflag <> n.ovdflag
        or o.intamt <> n.intamt
        or o.inputid <> n.inputid
        or o.ordpricbalance <> n.ordpricbalance
        or o.ovddays <> n.ovddays
        or o.ordpricovdbalance <> n.ordpricovdbalance
        or o.pnltratetype <> n.pnltratetype
        or o.loanuseway <> n.loanuseway
        or o.entrustedpayamt <> n.entrustedpayamt
        or o.extenddays <> n.extenddays
        or o.cleardate <> n.cleardate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_jdjr_acc_loan_cl(
            contno -- 客户签订的合同号码，即借据号、出资方贷款单号
            ,countenchashfee -- 应计取现手续费
            ,laonrealityrate -- 借款执行利率
            ,limitno -- 客户额度编号
            ,cusid -- 客户号
            ,prdcode -- 产品编号(行内)
            ,enchashfeerate -- 取现手续费利率
            ,cusno -- 京东pin
            ,loanterms -- 贷款期数
            ,lpr -- LPR
            ,instovdinterest -- 改分期逾期利息
            ,volfeerate -- 违约金利率
            ,loaninneraccount -- 贷款入帐账号
            ,ratefloatmode -- 利率浮动方式
            ,iswhite -- 
            ,bussdate -- 数据日期
            ,instpricbalance -- 改分期本金余额
            ,loanrepayaccount -- 还款账号
            ,execrate -- 执行年利率，京东推送日利率X360
            ,floatratebp -- 利率浮动点差BP
            ,loanserno -- 放款流水号
            ,certno -- 证件号
            ,intovdstartdt -- 利息逾期日期
            ,loanovdbalance -- 逾期贷款余额
            ,inpnltamt -- 应计罚息
            ,withenchashfeeday -- 当日计提取现手续费
            ,repayinthz -- 利息还款频率
            ,prinovdstartdt -- 本金逾期日期
            ,loanoutintbalance -- 表外欠息
            ,loanrate -- 借款利率
            ,laonrealityratetype -- 借款执行利率类型
            ,feeratetype -- 手续费费率类型D、日M、月W、周
            ,isbankrel -- 是否关联人1是2否
            ,currency -- 参见币种表
            ,instpricovdbalance -- 改分期本金逾期余额
            ,migtflag -- 
            ,loanenddt -- 业务到期日期
            ,prdno -- 产品编号
            ,loanstartdt -- 放款日期
            ,localarea -- 贷款资金使用位置
            ,intnextpaydt -- 下一付息日
            ,intflag -- 计息标志
            ,repaychangetype -- 新增还款变更类型
            ,volfeeratetype -- 违约金费率类型
            ,loanno -- 借据号
            ,ovdterms -- 逾期期数
            ,countvolfee -- 应计违约金
            ,loanstatus -- 贷款状态
            ,pnltrate -- 罚息利率
            ,loanratetype -- 借款利率类型
            ,instinterest -- 改分期利息
            ,volfeeday -- 当日违约金
            ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
            ,selfpayamt -- 自主支付金额
            ,todaypnltintamt -- 当日罚息
            ,instintpenalty -- 改分期罚息
            ,busmodel -- 业务模式
            ,loanamt -- 贷款放款金额
            ,repayprinhz -- 本金还款频率
            ,ratetype -- 利率调整方式
            ,todayintamt -- 当日利息
            ,cusname -- 客户姓名
            ,ratelprtype -- 利率类型1基准利率2LPR
            ,loansucessreceivedate -- 放款成功接收日期YYYYMMMMDD
            ,loanbalance -- 贷款余额
            ,loanovdintbalance -- 逾期利息
            ,granttype -- 贷款担保方式
            ,repaytype -- 还款方式
            ,ordinterest -- 普通利息
            ,ordovdinterest -- 普通逾期利息
            ,ordintpenalty -- 普通罚息
            ,unrepaysterms -- 待还期数
            ,outterms -- 表外期数
            ,ovdflag -- 贷款逾期标志
            ,intamt -- 应计利息
            ,inputid -- 所属客户经理
            ,ordpricbalance -- 普通本金余额
            ,ovddays -- 逾期天数
            ,ordpricovdbalance -- 普通本金逾期余额
            ,pnltratetype -- 罚息利率类型
            ,loanuseway -- 借款用途
            ,entrustedpayamt -- 受托支付金额
            ,extenddays -- 逾期宽限天数
            ,cleardate -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_jdjr_acc_loan_op(
            contno -- 客户签订的合同号码，即借据号、出资方贷款单号
            ,countenchashfee -- 应计取现手续费
            ,laonrealityrate -- 借款执行利率
            ,limitno -- 客户额度编号
            ,cusid -- 客户号
            ,prdcode -- 产品编号(行内)
            ,enchashfeerate -- 取现手续费利率
            ,cusno -- 京东pin
            ,loanterms -- 贷款期数
            ,lpr -- LPR
            ,instovdinterest -- 改分期逾期利息
            ,volfeerate -- 违约金利率
            ,loaninneraccount -- 贷款入帐账号
            ,ratefloatmode -- 利率浮动方式
            ,iswhite -- 
            ,bussdate -- 数据日期
            ,instpricbalance -- 改分期本金余额
            ,loanrepayaccount -- 还款账号
            ,execrate -- 执行年利率，京东推送日利率X360
            ,floatratebp -- 利率浮动点差BP
            ,loanserno -- 放款流水号
            ,certno -- 证件号
            ,intovdstartdt -- 利息逾期日期
            ,loanovdbalance -- 逾期贷款余额
            ,inpnltamt -- 应计罚息
            ,withenchashfeeday -- 当日计提取现手续费
            ,repayinthz -- 利息还款频率
            ,prinovdstartdt -- 本金逾期日期
            ,loanoutintbalance -- 表外欠息
            ,loanrate -- 借款利率
            ,laonrealityratetype -- 借款执行利率类型
            ,feeratetype -- 手续费费率类型D、日M、月W、周
            ,isbankrel -- 是否关联人1是2否
            ,currency -- 参见币种表
            ,instpricovdbalance -- 改分期本金逾期余额
            ,migtflag -- 
            ,loanenddt -- 业务到期日期
            ,prdno -- 产品编号
            ,loanstartdt -- 放款日期
            ,localarea -- 贷款资金使用位置
            ,intnextpaydt -- 下一付息日
            ,intflag -- 计息标志
            ,repaychangetype -- 新增还款变更类型
            ,volfeeratetype -- 违约金费率类型
            ,loanno -- 借据号
            ,ovdterms -- 逾期期数
            ,countvolfee -- 应计违约金
            ,loanstatus -- 贷款状态
            ,pnltrate -- 罚息利率
            ,loanratetype -- 借款利率类型
            ,instinterest -- 改分期利息
            ,volfeeday -- 当日违约金
            ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
            ,selfpayamt -- 自主支付金额
            ,todaypnltintamt -- 当日罚息
            ,instintpenalty -- 改分期罚息
            ,busmodel -- 业务模式
            ,loanamt -- 贷款放款金额
            ,repayprinhz -- 本金还款频率
            ,ratetype -- 利率调整方式
            ,todayintamt -- 当日利息
            ,cusname -- 客户姓名
            ,ratelprtype -- 利率类型1基准利率2LPR
            ,loansucessreceivedate -- 放款成功接收日期YYYYMMMMDD
            ,loanbalance -- 贷款余额
            ,loanovdintbalance -- 逾期利息
            ,granttype -- 贷款担保方式
            ,repaytype -- 还款方式
            ,ordinterest -- 普通利息
            ,ordovdinterest -- 普通逾期利息
            ,ordintpenalty -- 普通罚息
            ,unrepaysterms -- 待还期数
            ,outterms -- 表外期数
            ,ovdflag -- 贷款逾期标志
            ,intamt -- 应计利息
            ,inputid -- 所属客户经理
            ,ordpricbalance -- 普通本金余额
            ,ovddays -- 逾期天数
            ,ordpricovdbalance -- 普通本金逾期余额
            ,pnltratetype -- 罚息利率类型
            ,loanuseway -- 借款用途
            ,entrustedpayamt -- 受托支付金额
            ,extenddays -- 逾期宽限天数
            ,cleardate -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.contno -- 客户签订的合同号码，即借据号、出资方贷款单号
    ,o.countenchashfee -- 应计取现手续费
    ,o.laonrealityrate -- 借款执行利率
    ,o.limitno -- 客户额度编号
    ,o.cusid -- 客户号
    ,o.prdcode -- 产品编号(行内)
    ,o.enchashfeerate -- 取现手续费利率
    ,o.cusno -- 京东pin
    ,o.loanterms -- 贷款期数
    ,o.lpr -- LPR
    ,o.instovdinterest -- 改分期逾期利息
    ,o.volfeerate -- 违约金利率
    ,o.loaninneraccount -- 贷款入帐账号
    ,o.ratefloatmode -- 利率浮动方式
    ,o.iswhite -- 
    ,o.bussdate -- 数据日期
    ,o.instpricbalance -- 改分期本金余额
    ,o.loanrepayaccount -- 还款账号
    ,o.execrate -- 执行年利率，京东推送日利率X360
    ,o.floatratebp -- 利率浮动点差BP
    ,o.loanserno -- 放款流水号
    ,o.certno -- 证件号
    ,o.intovdstartdt -- 利息逾期日期
    ,o.loanovdbalance -- 逾期贷款余额
    ,o.inpnltamt -- 应计罚息
    ,o.withenchashfeeday -- 当日计提取现手续费
    ,o.repayinthz -- 利息还款频率
    ,o.prinovdstartdt -- 本金逾期日期
    ,o.loanoutintbalance -- 表外欠息
    ,o.loanrate -- 借款利率
    ,o.laonrealityratetype -- 借款执行利率类型
    ,o.feeratetype -- 手续费费率类型D、日M、月W、周
    ,o.isbankrel -- 是否关联人1是2否
    ,o.currency -- 参见币种表
    ,o.instpricovdbalance -- 改分期本金逾期余额
    ,o.migtflag -- 
    ,o.loanenddt -- 业务到期日期
    ,o.prdno -- 产品编号
    ,o.loanstartdt -- 放款日期
    ,o.localarea -- 贷款资金使用位置
    ,o.intnextpaydt -- 下一付息日
    ,o.intflag -- 计息标志
    ,o.repaychangetype -- 新增还款变更类型
    ,o.volfeeratetype -- 违约金费率类型
    ,o.loanno -- 借据号
    ,o.ovdterms -- 逾期期数
    ,o.countvolfee -- 应计违约金
    ,o.loanstatus -- 贷款状态
    ,o.pnltrate -- 罚息利率
    ,o.loanratetype -- 借款利率类型
    ,o.instinterest -- 改分期利息
    ,o.volfeeday -- 当日违约金
    ,o.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,o.selfpayamt -- 自主支付金额
    ,o.todaypnltintamt -- 当日罚息
    ,o.instintpenalty -- 改分期罚息
    ,o.busmodel -- 业务模式
    ,o.loanamt -- 贷款放款金额
    ,o.repayprinhz -- 本金还款频率
    ,o.ratetype -- 利率调整方式
    ,o.todayintamt -- 当日利息
    ,o.cusname -- 客户姓名
    ,o.ratelprtype -- 利率类型1基准利率2LPR
    ,o.loansucessreceivedate -- 放款成功接收日期YYYYMMMMDD
    ,o.loanbalance -- 贷款余额
    ,o.loanovdintbalance -- 逾期利息
    ,o.granttype -- 贷款担保方式
    ,o.repaytype -- 还款方式
    ,o.ordinterest -- 普通利息
    ,o.ordovdinterest -- 普通逾期利息
    ,o.ordintpenalty -- 普通罚息
    ,o.unrepaysterms -- 待还期数
    ,o.outterms -- 表外期数
    ,o.ovdflag -- 贷款逾期标志
    ,o.intamt -- 应计利息
    ,o.inputid -- 所属客户经理
    ,o.ordpricbalance -- 普通本金余额
    ,o.ovddays -- 逾期天数
    ,o.ordpricovdbalance -- 普通本金逾期余额
    ,o.pnltratetype -- 罚息利率类型
    ,o.loanuseway -- 借款用途
    ,o.entrustedpayamt -- 受托支付金额
    ,o.extenddays -- 逾期宽限天数
    ,o.cleardate -- 结清日期
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
from ${iol_schema}.icms_jdjr_acc_loan_bk o
    left join ${iol_schema}.icms_jdjr_acc_loan_op n
        on
            o.contno = n.contno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_jdjr_acc_loan_cl d
        on
            o.contno = d.contno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_jdjr_acc_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_jdjr_acc_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_jdjr_acc_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_jdjr_acc_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_jdjr_acc_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_jdjr_acc_loan_cl;
alter table ${iol_schema}.icms_jdjr_acc_loan exchange partition p_20991231 with table ${iol_schema}.icms_jdjr_acc_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_jdjr_acc_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_jdjr_acc_loan_op purge;
drop table ${iol_schema}.icms_jdjr_acc_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_jdjr_acc_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_jdjr_acc_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
