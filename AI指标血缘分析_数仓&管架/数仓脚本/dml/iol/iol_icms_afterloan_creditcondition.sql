/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_afterloan_creditcondition
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
create table ${iol_schema}.icms_afterloan_creditcondition_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_afterloan_creditcondition
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_creditcondition_op purge;
drop table ${iol_schema}.icms_afterloan_creditcondition_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_creditcondition_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_creditcondition where 0=1;

create table ${iol_schema}.icms_afterloan_creditcondition_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_creditcondition where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_creditcondition_cl(
            serialno -- 流水号
            ,inputuserid -- 登记人
            ,customerid -- 借款人ID(信贷系统唯一标识)
            ,xqorgnum -- 发生信贷交易机构数(新增，对接二代征信)
            ,totalbalance -- 使用敞口余额
            ,updatedate -- 更新日期
            ,overdueprincipal -- 逾期本金(新增，对接二代征信)
            ,berecoverbalance -- 被追偿业务余额（万元）(新增，对接二代征信)
            ,balance -- 授信余额
            ,otherduebusbalance -- 其他借贷交易余额（万元）(新增，对接二代征信)
            ,certid -- 身份证号
            ,orgnum -- 授信机构数量（个）
            ,resourcechange -- 他行授信策略变化情况
            ,inputorgid -- 登记机构
            ,creditorgchange -- 借款人同业授信银行数变化
            ,certtype -- 贷款证件类型
            ,otherloanwatchful -- 对外担保关注类余额（新增）
            ,otherloanharmful -- 对外担保不良类余额（新增）
            ,advancenum -- 垫款笔数(新增，对接二代征信)
            ,balancechange -- 授信余额变化情况
            ,inputdate -- 登记日期
            ,watchfulbalance -- 关注余额
            ,overduebalance -- 欠息余额(含：逾期、垫款、欠息)
            ,customertype -- 借款人类型
            ,reportno -- 报告编号
            ,businesssumable -- 剩余可用授信额度（新增）
            ,duebusbalance -- 借贷交易被追偿余额（万元）(新增，对接二代征信)
            ,loanflag -- 贷款卡状态
            ,businesssum -- 授信额度
            ,classifyresult -- 最低五级分类
            ,loancardno -- 贷款卡号
            ,classifyflit -- 他行五级分类迁徙情况
            ,otherloanassureamount -- 对外担保金额
            ,advancebalance -- 垫款余额(新增，对接二代征信)
            ,mfcustomerid -- 核心客户号
            ,disposalbalance -- 由资产管理公司处置余额(新增，对接二代征信)
            ,customername -- 借款人名称
            ,harmfulbalance -- 不良余额
            ,querydate -- 查询日期
            ,guabusbalance -- 担保交易余额（万元）(新增，对接二代征信)
            ,adoverduebalance -- 逾期利息(新增，对接二代征信)
            ,hpncrlntxnsinstnum -- 逾期利息(新增，对接二代征信)
            ,crnotclsglninstnum -- 逾期利息(新增，对接二代征信)
            ,dbtcrtxnbal -- 逾期利息(新增，对接二代征信)
            ,berecsdbtcrtxnbal -- 逾期利息(新增，对接二代征信)
            ,wrnttxnbalbal -- 逾期利息(新增，对接二代征信)
            ,astdspbsnbal -- 逾期利息(新增，对接二代征信)
            ,adcshbsnacc -- 逾期利息(新增，对接二代征信)
            ,adcshbsnbal -- 逾期利息(新增，对接二代征信)
            ,curoduepnp -- 逾期利息(新增，对接二代征信)
            ,odinadoth -- 逾期利息(新增，对接二代征信)
            ,berecbaltot -- 逾期利息(新增，对接二代征信)
            ,othrdbtcrtnacbal -- 逾期利息(新增，对接二代征信)
            ,bal -- 逾期利息(新增，对接二代征信)
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_creditcondition_op(
            serialno -- 流水号
            ,inputuserid -- 登记人
            ,customerid -- 借款人ID(信贷系统唯一标识)
            ,xqorgnum -- 发生信贷交易机构数(新增，对接二代征信)
            ,totalbalance -- 使用敞口余额
            ,updatedate -- 更新日期
            ,overdueprincipal -- 逾期本金(新增，对接二代征信)
            ,berecoverbalance -- 被追偿业务余额（万元）(新增，对接二代征信)
            ,balance -- 授信余额
            ,otherduebusbalance -- 其他借贷交易余额（万元）(新增，对接二代征信)
            ,certid -- 身份证号
            ,orgnum -- 授信机构数量（个）
            ,resourcechange -- 他行授信策略变化情况
            ,inputorgid -- 登记机构
            ,creditorgchange -- 借款人同业授信银行数变化
            ,certtype -- 贷款证件类型
            ,otherloanwatchful -- 对外担保关注类余额（新增）
            ,otherloanharmful -- 对外担保不良类余额（新增）
            ,advancenum -- 垫款笔数(新增，对接二代征信)
            ,balancechange -- 授信余额变化情况
            ,inputdate -- 登记日期
            ,watchfulbalance -- 关注余额
            ,overduebalance -- 欠息余额(含：逾期、垫款、欠息)
            ,customertype -- 借款人类型
            ,reportno -- 报告编号
            ,businesssumable -- 剩余可用授信额度（新增）
            ,duebusbalance -- 借贷交易被追偿余额（万元）(新增，对接二代征信)
            ,loanflag -- 贷款卡状态
            ,businesssum -- 授信额度
            ,classifyresult -- 最低五级分类
            ,loancardno -- 贷款卡号
            ,classifyflit -- 他行五级分类迁徙情况
            ,otherloanassureamount -- 对外担保金额
            ,advancebalance -- 垫款余额(新增，对接二代征信)
            ,mfcustomerid -- 核心客户号
            ,disposalbalance -- 由资产管理公司处置余额(新增，对接二代征信)
            ,customername -- 借款人名称
            ,harmfulbalance -- 不良余额
            ,querydate -- 查询日期
            ,guabusbalance -- 担保交易余额（万元）(新增，对接二代征信)
            ,adoverduebalance -- 逾期利息(新增，对接二代征信)
            ,hpncrlntxnsinstnum -- 逾期利息(新增，对接二代征信)
            ,crnotclsglninstnum -- 逾期利息(新增，对接二代征信)
            ,dbtcrtxnbal -- 逾期利息(新增，对接二代征信)
            ,berecsdbtcrtxnbal -- 逾期利息(新增，对接二代征信)
            ,wrnttxnbalbal -- 逾期利息(新增，对接二代征信)
            ,astdspbsnbal -- 逾期利息(新增，对接二代征信)
            ,adcshbsnacc -- 逾期利息(新增，对接二代征信)
            ,adcshbsnbal -- 逾期利息(新增，对接二代征信)
            ,curoduepnp -- 逾期利息(新增，对接二代征信)
            ,odinadoth -- 逾期利息(新增，对接二代征信)
            ,berecbaltot -- 逾期利息(新增，对接二代征信)
            ,othrdbtcrtnacbal -- 逾期利息(新增，对接二代征信)
            ,bal -- 逾期利息(新增，对接二代征信)
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.customerid, o.customerid) as customerid -- 借款人ID(信贷系统唯一标识)
    ,nvl(n.xqorgnum, o.xqorgnum) as xqorgnum -- 发生信贷交易机构数(新增，对接二代征信)
    ,nvl(n.totalbalance, o.totalbalance) as totalbalance -- 使用敞口余额
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.overdueprincipal, o.overdueprincipal) as overdueprincipal -- 逾期本金(新增，对接二代征信)
    ,nvl(n.berecoverbalance, o.berecoverbalance) as berecoverbalance -- 被追偿业务余额（万元）(新增，对接二代征信)
    ,nvl(n.balance, o.balance) as balance -- 授信余额
    ,nvl(n.otherduebusbalance, o.otherduebusbalance) as otherduebusbalance -- 其他借贷交易余额（万元）(新增，对接二代征信)
    ,nvl(n.certid, o.certid) as certid -- 身份证号
    ,nvl(n.orgnum, o.orgnum) as orgnum -- 授信机构数量（个）
    ,nvl(n.resourcechange, o.resourcechange) as resourcechange -- 他行授信策略变化情况
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.creditorgchange, o.creditorgchange) as creditorgchange -- 借款人同业授信银行数变化
    ,nvl(n.certtype, o.certtype) as certtype -- 贷款证件类型
    ,nvl(n.otherloanwatchful, o.otherloanwatchful) as otherloanwatchful -- 对外担保关注类余额（新增）
    ,nvl(n.otherloanharmful, o.otherloanharmful) as otherloanharmful -- 对外担保不良类余额（新增）
    ,nvl(n.advancenum, o.advancenum) as advancenum -- 垫款笔数(新增，对接二代征信)
    ,nvl(n.balancechange, o.balancechange) as balancechange -- 授信余额变化情况
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.watchfulbalance, o.watchfulbalance) as watchfulbalance -- 关注余额
    ,nvl(n.overduebalance, o.overduebalance) as overduebalance -- 欠息余额(含：逾期、垫款、欠息)
    ,nvl(n.customertype, o.customertype) as customertype -- 借款人类型
    ,nvl(n.reportno, o.reportno) as reportno -- 报告编号
    ,nvl(n.businesssumable, o.businesssumable) as businesssumable -- 剩余可用授信额度（新增）
    ,nvl(n.duebusbalance, o.duebusbalance) as duebusbalance -- 借贷交易被追偿余额（万元）(新增，对接二代征信)
    ,nvl(n.loanflag, o.loanflag) as loanflag -- 贷款卡状态
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 授信额度
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 最低五级分类
    ,nvl(n.loancardno, o.loancardno) as loancardno -- 贷款卡号
    ,nvl(n.classifyflit, o.classifyflit) as classifyflit -- 他行五级分类迁徙情况
    ,nvl(n.otherloanassureamount, o.otherloanassureamount) as otherloanassureamount -- 对外担保金额
    ,nvl(n.advancebalance, o.advancebalance) as advancebalance -- 垫款余额(新增，对接二代征信)
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.disposalbalance, o.disposalbalance) as disposalbalance -- 由资产管理公司处置余额(新增，对接二代征信)
    ,nvl(n.customername, o.customername) as customername -- 借款人名称
    ,nvl(n.harmfulbalance, o.harmfulbalance) as harmfulbalance -- 不良余额
    ,nvl(n.querydate, o.querydate) as querydate -- 查询日期
    ,nvl(n.guabusbalance, o.guabusbalance) as guabusbalance -- 担保交易余额（万元）(新增，对接二代征信)
    ,nvl(n.adoverduebalance, o.adoverduebalance) as adoverduebalance -- 逾期利息(新增，对接二代征信)
    ,nvl(n.hpncrlntxnsinstnum, o.hpncrlntxnsinstnum) as hpncrlntxnsinstnum -- 逾期利息(新增，对接二代征信)
    ,nvl(n.crnotclsglninstnum, o.crnotclsglninstnum) as crnotclsglninstnum -- 逾期利息(新增，对接二代征信)
    ,nvl(n.dbtcrtxnbal, o.dbtcrtxnbal) as dbtcrtxnbal -- 逾期利息(新增，对接二代征信)
    ,nvl(n.berecsdbtcrtxnbal, o.berecsdbtcrtxnbal) as berecsdbtcrtxnbal -- 逾期利息(新增，对接二代征信)
    ,nvl(n.wrnttxnbalbal, o.wrnttxnbalbal) as wrnttxnbalbal -- 逾期利息(新增，对接二代征信)
    ,nvl(n.astdspbsnbal, o.astdspbsnbal) as astdspbsnbal -- 逾期利息(新增，对接二代征信)
    ,nvl(n.adcshbsnacc, o.adcshbsnacc) as adcshbsnacc -- 逾期利息(新增，对接二代征信)
    ,nvl(n.adcshbsnbal, o.adcshbsnbal) as adcshbsnbal -- 逾期利息(新增，对接二代征信)
    ,nvl(n.curoduepnp, o.curoduepnp) as curoduepnp -- 逾期利息(新增，对接二代征信)
    ,nvl(n.odinadoth, o.odinadoth) as odinadoth -- 逾期利息(新增，对接二代征信)
    ,nvl(n.berecbaltot, o.berecbaltot) as berecbaltot -- 逾期利息(新增，对接二代征信)
    ,nvl(n.othrdbtcrtnacbal, o.othrdbtcrtnacbal) as othrdbtcrtnacbal -- 逾期利息(新增，对接二代征信)
    ,nvl(n.bal, o.bal) as bal -- 逾期利息(新增，对接二代征信)
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_afterloan_creditcondition_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_afterloan_creditcondition where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.inputuserid <> n.inputuserid
        or o.customerid <> n.customerid
        or o.xqorgnum <> n.xqorgnum
        or o.totalbalance <> n.totalbalance
        or o.updatedate <> n.updatedate
        or o.overdueprincipal <> n.overdueprincipal
        or o.berecoverbalance <> n.berecoverbalance
        or o.balance <> n.balance
        or o.otherduebusbalance <> n.otherduebusbalance
        or o.certid <> n.certid
        or o.orgnum <> n.orgnum
        or o.resourcechange <> n.resourcechange
        or o.inputorgid <> n.inputorgid
        or o.creditorgchange <> n.creditorgchange
        or o.certtype <> n.certtype
        or o.otherloanwatchful <> n.otherloanwatchful
        or o.otherloanharmful <> n.otherloanharmful
        or o.advancenum <> n.advancenum
        or o.balancechange <> n.balancechange
        or o.inputdate <> n.inputdate
        or o.watchfulbalance <> n.watchfulbalance
        or o.overduebalance <> n.overduebalance
        or o.customertype <> n.customertype
        or o.reportno <> n.reportno
        or o.businesssumable <> n.businesssumable
        or o.duebusbalance <> n.duebusbalance
        or o.loanflag <> n.loanflag
        or o.businesssum <> n.businesssum
        or o.classifyresult <> n.classifyresult
        or o.loancardno <> n.loancardno
        or o.classifyflit <> n.classifyflit
        or o.otherloanassureamount <> n.otherloanassureamount
        or o.advancebalance <> n.advancebalance
        or o.mfcustomerid <> n.mfcustomerid
        or o.disposalbalance <> n.disposalbalance
        or o.customername <> n.customername
        or o.harmfulbalance <> n.harmfulbalance
        or o.querydate <> n.querydate
        or o.guabusbalance <> n.guabusbalance
        or o.adoverduebalance <> n.adoverduebalance
        or o.hpncrlntxnsinstnum <> n.hpncrlntxnsinstnum
        or o.crnotclsglninstnum <> n.crnotclsglninstnum
        or o.dbtcrtxnbal <> n.dbtcrtxnbal
        or o.berecsdbtcrtxnbal <> n.berecsdbtcrtxnbal
        or o.wrnttxnbalbal <> n.wrnttxnbalbal
        or o.astdspbsnbal <> n.astdspbsnbal
        or o.adcshbsnacc <> n.adcshbsnacc
        or o.adcshbsnbal <> n.adcshbsnbal
        or o.curoduepnp <> n.curoduepnp
        or o.odinadoth <> n.odinadoth
        or o.berecbaltot <> n.berecbaltot
        or o.othrdbtcrtnacbal <> n.othrdbtcrtnacbal
        or o.bal <> n.bal
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_creditcondition_cl(
            serialno -- 流水号
            ,inputuserid -- 登记人
            ,customerid -- 借款人ID(信贷系统唯一标识)
            ,xqorgnum -- 发生信贷交易机构数(新增，对接二代征信)
            ,totalbalance -- 使用敞口余额
            ,updatedate -- 更新日期
            ,overdueprincipal -- 逾期本金(新增，对接二代征信)
            ,berecoverbalance -- 被追偿业务余额（万元）(新增，对接二代征信)
            ,balance -- 授信余额
            ,otherduebusbalance -- 其他借贷交易余额（万元）(新增，对接二代征信)
            ,certid -- 身份证号
            ,orgnum -- 授信机构数量（个）
            ,resourcechange -- 他行授信策略变化情况
            ,inputorgid -- 登记机构
            ,creditorgchange -- 借款人同业授信银行数变化
            ,certtype -- 贷款证件类型
            ,otherloanwatchful -- 对外担保关注类余额（新增）
            ,otherloanharmful -- 对外担保不良类余额（新增）
            ,advancenum -- 垫款笔数(新增，对接二代征信)
            ,balancechange -- 授信余额变化情况
            ,inputdate -- 登记日期
            ,watchfulbalance -- 关注余额
            ,overduebalance -- 欠息余额(含：逾期、垫款、欠息)
            ,customertype -- 借款人类型
            ,reportno -- 报告编号
            ,businesssumable -- 剩余可用授信额度（新增）
            ,duebusbalance -- 借贷交易被追偿余额（万元）(新增，对接二代征信)
            ,loanflag -- 贷款卡状态
            ,businesssum -- 授信额度
            ,classifyresult -- 最低五级分类
            ,loancardno -- 贷款卡号
            ,classifyflit -- 他行五级分类迁徙情况
            ,otherloanassureamount -- 对外担保金额
            ,advancebalance -- 垫款余额(新增，对接二代征信)
            ,mfcustomerid -- 核心客户号
            ,disposalbalance -- 由资产管理公司处置余额(新增，对接二代征信)
            ,customername -- 借款人名称
            ,harmfulbalance -- 不良余额
            ,querydate -- 查询日期
            ,guabusbalance -- 担保交易余额（万元）(新增，对接二代征信)
            ,adoverduebalance -- 逾期利息(新增，对接二代征信)
            ,hpncrlntxnsinstnum -- 逾期利息(新增，对接二代征信)
            ,crnotclsglninstnum -- 逾期利息(新增，对接二代征信)
            ,dbtcrtxnbal -- 逾期利息(新增，对接二代征信)
            ,berecsdbtcrtxnbal -- 逾期利息(新增，对接二代征信)
            ,wrnttxnbalbal -- 逾期利息(新增，对接二代征信)
            ,astdspbsnbal -- 逾期利息(新增，对接二代征信)
            ,adcshbsnacc -- 逾期利息(新增，对接二代征信)
            ,adcshbsnbal -- 逾期利息(新增，对接二代征信)
            ,curoduepnp -- 逾期利息(新增，对接二代征信)
            ,odinadoth -- 逾期利息(新增，对接二代征信)
            ,berecbaltot -- 逾期利息(新增，对接二代征信)
            ,othrdbtcrtnacbal -- 逾期利息(新增，对接二代征信)
            ,bal -- 逾期利息(新增，对接二代征信)
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_creditcondition_op(
            serialno -- 流水号
            ,inputuserid -- 登记人
            ,customerid -- 借款人ID(信贷系统唯一标识)
            ,xqorgnum -- 发生信贷交易机构数(新增，对接二代征信)
            ,totalbalance -- 使用敞口余额
            ,updatedate -- 更新日期
            ,overdueprincipal -- 逾期本金(新增，对接二代征信)
            ,berecoverbalance -- 被追偿业务余额（万元）(新增，对接二代征信)
            ,balance -- 授信余额
            ,otherduebusbalance -- 其他借贷交易余额（万元）(新增，对接二代征信)
            ,certid -- 身份证号
            ,orgnum -- 授信机构数量（个）
            ,resourcechange -- 他行授信策略变化情况
            ,inputorgid -- 登记机构
            ,creditorgchange -- 借款人同业授信银行数变化
            ,certtype -- 贷款证件类型
            ,otherloanwatchful -- 对外担保关注类余额（新增）
            ,otherloanharmful -- 对外担保不良类余额（新增）
            ,advancenum -- 垫款笔数(新增，对接二代征信)
            ,balancechange -- 授信余额变化情况
            ,inputdate -- 登记日期
            ,watchfulbalance -- 关注余额
            ,overduebalance -- 欠息余额(含：逾期、垫款、欠息)
            ,customertype -- 借款人类型
            ,reportno -- 报告编号
            ,businesssumable -- 剩余可用授信额度（新增）
            ,duebusbalance -- 借贷交易被追偿余额（万元）(新增，对接二代征信)
            ,loanflag -- 贷款卡状态
            ,businesssum -- 授信额度
            ,classifyresult -- 最低五级分类
            ,loancardno -- 贷款卡号
            ,classifyflit -- 他行五级分类迁徙情况
            ,otherloanassureamount -- 对外担保金额
            ,advancebalance -- 垫款余额(新增，对接二代征信)
            ,mfcustomerid -- 核心客户号
            ,disposalbalance -- 由资产管理公司处置余额(新增，对接二代征信)
            ,customername -- 借款人名称
            ,harmfulbalance -- 不良余额
            ,querydate -- 查询日期
            ,guabusbalance -- 担保交易余额（万元）(新增，对接二代征信)
            ,adoverduebalance -- 逾期利息(新增，对接二代征信)
            ,hpncrlntxnsinstnum -- 逾期利息(新增，对接二代征信)
            ,crnotclsglninstnum -- 逾期利息(新增，对接二代征信)
            ,dbtcrtxnbal -- 逾期利息(新增，对接二代征信)
            ,berecsdbtcrtxnbal -- 逾期利息(新增，对接二代征信)
            ,wrnttxnbalbal -- 逾期利息(新增，对接二代征信)
            ,astdspbsnbal -- 逾期利息(新增，对接二代征信)
            ,adcshbsnacc -- 逾期利息(新增，对接二代征信)
            ,adcshbsnbal -- 逾期利息(新增，对接二代征信)
            ,curoduepnp -- 逾期利息(新增，对接二代征信)
            ,odinadoth -- 逾期利息(新增，对接二代征信)
            ,berecbaltot -- 逾期利息(新增，对接二代征信)
            ,othrdbtcrtnacbal -- 逾期利息(新增，对接二代征信)
            ,bal -- 逾期利息(新增，对接二代征信)
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.inputuserid -- 登记人
    ,o.customerid -- 借款人ID(信贷系统唯一标识)
    ,o.xqorgnum -- 发生信贷交易机构数(新增，对接二代征信)
    ,o.totalbalance -- 使用敞口余额
    ,o.updatedate -- 更新日期
    ,o.overdueprincipal -- 逾期本金(新增，对接二代征信)
    ,o.berecoverbalance -- 被追偿业务余额（万元）(新增，对接二代征信)
    ,o.balance -- 授信余额
    ,o.otherduebusbalance -- 其他借贷交易余额（万元）(新增，对接二代征信)
    ,o.certid -- 身份证号
    ,o.orgnum -- 授信机构数量（个）
    ,o.resourcechange -- 他行授信策略变化情况
    ,o.inputorgid -- 登记机构
    ,o.creditorgchange -- 借款人同业授信银行数变化
    ,o.certtype -- 贷款证件类型
    ,o.otherloanwatchful -- 对外担保关注类余额（新增）
    ,o.otherloanharmful -- 对外担保不良类余额（新增）
    ,o.advancenum -- 垫款笔数(新增，对接二代征信)
    ,o.balancechange -- 授信余额变化情况
    ,o.inputdate -- 登记日期
    ,o.watchfulbalance -- 关注余额
    ,o.overduebalance -- 欠息余额(含：逾期、垫款、欠息)
    ,o.customertype -- 借款人类型
    ,o.reportno -- 报告编号
    ,o.businesssumable -- 剩余可用授信额度（新增）
    ,o.duebusbalance -- 借贷交易被追偿余额（万元）(新增，对接二代征信)
    ,o.loanflag -- 贷款卡状态
    ,o.businesssum -- 授信额度
    ,o.classifyresult -- 最低五级分类
    ,o.loancardno -- 贷款卡号
    ,o.classifyflit -- 他行五级分类迁徙情况
    ,o.otherloanassureamount -- 对外担保金额
    ,o.advancebalance -- 垫款余额(新增，对接二代征信)
    ,o.mfcustomerid -- 核心客户号
    ,o.disposalbalance -- 由资产管理公司处置余额(新增，对接二代征信)
    ,o.customername -- 借款人名称
    ,o.harmfulbalance -- 不良余额
    ,o.querydate -- 查询日期
    ,o.guabusbalance -- 担保交易余额（万元）(新增，对接二代征信)
    ,o.adoverduebalance -- 逾期利息(新增，对接二代征信)
    ,o.hpncrlntxnsinstnum -- 逾期利息(新增，对接二代征信)
    ,o.crnotclsglninstnum -- 逾期利息(新增，对接二代征信)
    ,o.dbtcrtxnbal -- 逾期利息(新增，对接二代征信)
    ,o.berecsdbtcrtxnbal -- 逾期利息(新增，对接二代征信)
    ,o.wrnttxnbalbal -- 逾期利息(新增，对接二代征信)
    ,o.astdspbsnbal -- 逾期利息(新增，对接二代征信)
    ,o.adcshbsnacc -- 逾期利息(新增，对接二代征信)
    ,o.adcshbsnbal -- 逾期利息(新增，对接二代征信)
    ,o.curoduepnp -- 逾期利息(新增，对接二代征信)
    ,o.odinadoth -- 逾期利息(新增，对接二代征信)
    ,o.berecbaltot -- 逾期利息(新增，对接二代征信)
    ,o.othrdbtcrtnacbal -- 逾期利息(新增，对接二代征信)
    ,o.bal -- 逾期利息(新增，对接二代征信)
    ,o.migtflag -- 迁移标志
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
from ${iol_schema}.icms_afterloan_creditcondition_bk o
    left join ${iol_schema}.icms_afterloan_creditcondition_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_afterloan_creditcondition_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_afterloan_creditcondition;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_afterloan_creditcondition') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_afterloan_creditcondition drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_afterloan_creditcondition add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_afterloan_creditcondition exchange partition p_${batch_date} with table ${iol_schema}.icms_afterloan_creditcondition_cl;
alter table ${iol_schema}.icms_afterloan_creditcondition exchange partition p_20991231 with table ${iol_schema}.icms_afterloan_creditcondition_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_afterloan_creditcondition to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_creditcondition_op purge;
drop table ${iol_schema}.icms_afterloan_creditcondition_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_afterloan_creditcondition_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_afterloan_creditcondition',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
