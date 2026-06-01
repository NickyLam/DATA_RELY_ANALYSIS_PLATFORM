/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_afterloan_change
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
create table ${iol_schema}.icms_afterloan_change_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_afterloan_change
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_change_op purge;
drop table ${iol_schema}.icms_afterloan_change_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_change_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_change where 0=1;

create table ${iol_schema}.icms_afterloan_change_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_change where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_change_cl(
            serialno -- 流水号
            ,applystatus -- 申请状态
            ,rateunit2 -- 利率单位
            ,ratefloattype2 -- 利率浮动类型
            ,businessrate2 -- 执行利率
            ,paymentaccount -- 还款账号
            ,transno -- 核心交易号
            ,oldrepaydate -- 原还款日
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,oldrepaytype -- 原还款方式
            ,completeflag -- 完成标志
            ,repayaccname -- 还款账户名称
            ,belongdept -- 所属条线
            ,oldrepayaccname -- 原还款账户名称
            ,baserate -- 基准利率
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,loanno -- 关联借据号
            ,customerid -- 客户编号
            ,termid2 -- 利率模式
            ,updatedate -- 更新日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,objecttype -- 关联对象类型
            ,ratefloattype -- 利率浮动类型
            ,ratefloat2 -- 浮动幅度
            ,paymenttype -- 还款方式
            ,gaincyc -- 递变周期
            ,oldrepayaccno -- 原还款账户
            ,termid -- 利率模式
            ,businessrate -- 执行利率
            ,putoutaccount -- 放款账号
            ,payfrequency -- 指定周期
            ,productid -- 产品编号
            ,repricetype2 -- 利率调整方式
            ,accountingorgid -- 入账机构
            ,baseratetype -- 基准利率类型
            ,baserate2 -- 基准利率
            ,transcode -- 交易类型
            ,oldmaturitydate -- 原贷款到期日
            ,baseratetype2 -- 基准利率类型
            ,payfrequencytype -- 还款周期类型
            ,segrptamount -- 尾款金额
            ,transdate -- 生效日期
            ,remark -- 备注
            ,relativeserialno -- 关联流水号
            ,defaultdueday -- 默认还款日
            ,gainamount -- 递变幅度
            ,transstatus -- 交易状态
            ,excutedate -- 交易日期
            ,customername -- 客户名称
            ,newmaturitydate -- 新贷款到期日
            ,rateunit -- 利率单位
            ,ratechangeflag -- 利率变更标志
            ,ratefloat -- 浮动幅度
            ,inputorgid -- 登记机构
            ,repricetype -- 利率调整方式
            ,segterm -- 指定还款计算期限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_change_op(
            serialno -- 流水号
            ,applystatus -- 申请状态
            ,rateunit2 -- 利率单位
            ,ratefloattype2 -- 利率浮动类型
            ,businessrate2 -- 执行利率
            ,paymentaccount -- 还款账号
            ,transno -- 核心交易号
            ,oldrepaydate -- 原还款日
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,oldrepaytype -- 原还款方式
            ,completeflag -- 完成标志
            ,repayaccname -- 还款账户名称
            ,belongdept -- 所属条线
            ,oldrepayaccname -- 原还款账户名称
            ,baserate -- 基准利率
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,loanno -- 关联借据号
            ,customerid -- 客户编号
            ,termid2 -- 利率模式
            ,updatedate -- 更新日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,objecttype -- 关联对象类型
            ,ratefloattype -- 利率浮动类型
            ,ratefloat2 -- 浮动幅度
            ,paymenttype -- 还款方式
            ,gaincyc -- 递变周期
            ,oldrepayaccno -- 原还款账户
            ,termid -- 利率模式
            ,businessrate -- 执行利率
            ,putoutaccount -- 放款账号
            ,payfrequency -- 指定周期
            ,productid -- 产品编号
            ,repricetype2 -- 利率调整方式
            ,accountingorgid -- 入账机构
            ,baseratetype -- 基准利率类型
            ,baserate2 -- 基准利率
            ,transcode -- 交易类型
            ,oldmaturitydate -- 原贷款到期日
            ,baseratetype2 -- 基准利率类型
            ,payfrequencytype -- 还款周期类型
            ,segrptamount -- 尾款金额
            ,transdate -- 生效日期
            ,remark -- 备注
            ,relativeserialno -- 关联流水号
            ,defaultdueday -- 默认还款日
            ,gainamount -- 递变幅度
            ,transstatus -- 交易状态
            ,excutedate -- 交易日期
            ,customername -- 客户名称
            ,newmaturitydate -- 新贷款到期日
            ,rateunit -- 利率单位
            ,ratechangeflag -- 利率变更标志
            ,ratefloat -- 浮动幅度
            ,inputorgid -- 登记机构
            ,repricetype -- 利率调整方式
            ,segterm -- 指定还款计算期限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.applystatus, o.applystatus) as applystatus -- 申请状态
    ,nvl(n.rateunit2, o.rateunit2) as rateunit2 -- 利率单位
    ,nvl(n.ratefloattype2, o.ratefloattype2) as ratefloattype2 -- 利率浮动类型
    ,nvl(n.businessrate2, o.businessrate2) as businessrate2 -- 执行利率
    ,nvl(n.paymentaccount, o.paymentaccount) as paymentaccount -- 还款账号
    ,nvl(n.transno, o.transno) as transno -- 核心交易号
    ,nvl(n.oldrepaydate, o.oldrepaydate) as oldrepaydate -- 原还款日
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.oldrepaytype, o.oldrepaytype) as oldrepaytype -- 原还款方式
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 完成标志
    ,nvl(n.repayaccname, o.repayaccname) as repayaccname -- 还款账户名称
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 所属条线
    ,nvl(n.oldrepayaccname, o.oldrepayaccname) as oldrepayaccname -- 原还款账户名称
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.loanno, o.loanno) as loanno -- 关联借据号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.termid2, o.termid2) as termid2 -- 利率模式
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 关联对象类型
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动类型
    ,nvl(n.ratefloat2, o.ratefloat2) as ratefloat2 -- 浮动幅度
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 还款方式
    ,nvl(n.gaincyc, o.gaincyc) as gaincyc -- 递变周期
    ,nvl(n.oldrepayaccno, o.oldrepayaccno) as oldrepayaccno -- 原还款账户
    ,nvl(n.termid, o.termid) as termid -- 利率模式
    ,nvl(n.businessrate, o.businessrate) as businessrate -- 执行利率
    ,nvl(n.putoutaccount, o.putoutaccount) as putoutaccount -- 放款账号
    ,nvl(n.payfrequency, o.payfrequency) as payfrequency -- 指定周期
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.repricetype2, o.repricetype2) as repricetype2 -- 利率调整方式
    ,nvl(n.accountingorgid, o.accountingorgid) as accountingorgid -- 入账机构
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate2, o.baserate2) as baserate2 -- 基准利率
    ,nvl(n.transcode, o.transcode) as transcode -- 交易类型
    ,nvl(n.oldmaturitydate, o.oldmaturitydate) as oldmaturitydate -- 原贷款到期日
    ,nvl(n.baseratetype2, o.baseratetype2) as baseratetype2 -- 基准利率类型
    ,nvl(n.payfrequencytype, o.payfrequencytype) as payfrequencytype -- 还款周期类型
    ,nvl(n.segrptamount, o.segrptamount) as segrptamount -- 尾款金额
    ,nvl(n.transdate, o.transdate) as transdate -- 生效日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号
    ,nvl(n.defaultdueday, o.defaultdueday) as defaultdueday -- 默认还款日
    ,nvl(n.gainamount, o.gainamount) as gainamount -- 递变幅度
    ,nvl(n.transstatus, o.transstatus) as transstatus -- 交易状态
    ,nvl(n.excutedate, o.excutedate) as excutedate -- 交易日期
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.newmaturitydate, o.newmaturitydate) as newmaturitydate -- 新贷款到期日
    ,nvl(n.rateunit, o.rateunit) as rateunit -- 利率单位
    ,nvl(n.ratechangeflag, o.ratechangeflag) as ratechangeflag -- 利率变更标志
    ,nvl(n.ratefloat, o.ratefloat) as ratefloat -- 浮动幅度
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.repricetype, o.repricetype) as repricetype -- 利率调整方式
    ,nvl(n.segterm, o.segterm) as segterm -- 指定还款计算期限
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
from (select * from ${iol_schema}.icms_afterloan_change_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_afterloan_change where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.applystatus <> n.applystatus
        or o.rateunit2 <> n.rateunit2
        or o.ratefloattype2 <> n.ratefloattype2
        or o.businessrate2 <> n.businessrate2
        or o.paymentaccount <> n.paymentaccount
        or o.transno <> n.transno
        or o.oldrepaydate <> n.oldrepaydate
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.oldrepaytype <> n.oldrepaytype
        or o.completeflag <> n.completeflag
        or o.repayaccname <> n.repayaccname
        or o.belongdept <> n.belongdept
        or o.oldrepayaccname <> n.oldrepayaccname
        or o.baserate <> n.baserate
        or o.inputuserid <> n.inputuserid
        or o.updateorgid <> n.updateorgid
        or o.corporgid <> n.corporgid
        or o.loanno <> n.loanno
        or o.customerid <> n.customerid
        or o.termid2 <> n.termid2
        or o.updatedate <> n.updatedate
        or o.migtflag <> n.migtflag
        or o.objecttype <> n.objecttype
        or o.ratefloattype <> n.ratefloattype
        or o.ratefloat2 <> n.ratefloat2
        or o.paymenttype <> n.paymenttype
        or o.gaincyc <> n.gaincyc
        or o.oldrepayaccno <> n.oldrepayaccno
        or o.termid <> n.termid
        or o.businessrate <> n.businessrate
        or o.putoutaccount <> n.putoutaccount
        or o.payfrequency <> n.payfrequency
        or o.productid <> n.productid
        or o.repricetype2 <> n.repricetype2
        or o.accountingorgid <> n.accountingorgid
        or o.baseratetype <> n.baseratetype
        or o.baserate2 <> n.baserate2
        or o.transcode <> n.transcode
        or o.oldmaturitydate <> n.oldmaturitydate
        or o.baseratetype2 <> n.baseratetype2
        or o.payfrequencytype <> n.payfrequencytype
        or o.segrptamount <> n.segrptamount
        or o.transdate <> n.transdate
        or o.remark <> n.remark
        or o.relativeserialno <> n.relativeserialno
        or o.defaultdueday <> n.defaultdueday
        or o.gainamount <> n.gainamount
        or o.transstatus <> n.transstatus
        or o.excutedate <> n.excutedate
        or o.customername <> n.customername
        or o.newmaturitydate <> n.newmaturitydate
        or o.rateunit <> n.rateunit
        or o.ratechangeflag <> n.ratechangeflag
        or o.ratefloat <> n.ratefloat
        or o.inputorgid <> n.inputorgid
        or o.repricetype <> n.repricetype
        or o.segterm <> n.segterm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_change_cl(
            serialno -- 流水号
            ,applystatus -- 申请状态
            ,rateunit2 -- 利率单位
            ,ratefloattype2 -- 利率浮动类型
            ,businessrate2 -- 执行利率
            ,paymentaccount -- 还款账号
            ,transno -- 核心交易号
            ,oldrepaydate -- 原还款日
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,oldrepaytype -- 原还款方式
            ,completeflag -- 完成标志
            ,repayaccname -- 还款账户名称
            ,belongdept -- 所属条线
            ,oldrepayaccname -- 原还款账户名称
            ,baserate -- 基准利率
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,loanno -- 关联借据号
            ,customerid -- 客户编号
            ,termid2 -- 利率模式
            ,updatedate -- 更新日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,objecttype -- 关联对象类型
            ,ratefloattype -- 利率浮动类型
            ,ratefloat2 -- 浮动幅度
            ,paymenttype -- 还款方式
            ,gaincyc -- 递变周期
            ,oldrepayaccno -- 原还款账户
            ,termid -- 利率模式
            ,businessrate -- 执行利率
            ,putoutaccount -- 放款账号
            ,payfrequency -- 指定周期
            ,productid -- 产品编号
            ,repricetype2 -- 利率调整方式
            ,accountingorgid -- 入账机构
            ,baseratetype -- 基准利率类型
            ,baserate2 -- 基准利率
            ,transcode -- 交易类型
            ,oldmaturitydate -- 原贷款到期日
            ,baseratetype2 -- 基准利率类型
            ,payfrequencytype -- 还款周期类型
            ,segrptamount -- 尾款金额
            ,transdate -- 生效日期
            ,remark -- 备注
            ,relativeserialno -- 关联流水号
            ,defaultdueday -- 默认还款日
            ,gainamount -- 递变幅度
            ,transstatus -- 交易状态
            ,excutedate -- 交易日期
            ,customername -- 客户名称
            ,newmaturitydate -- 新贷款到期日
            ,rateunit -- 利率单位
            ,ratechangeflag -- 利率变更标志
            ,ratefloat -- 浮动幅度
            ,inputorgid -- 登记机构
            ,repricetype -- 利率调整方式
            ,segterm -- 指定还款计算期限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_change_op(
            serialno -- 流水号
            ,applystatus -- 申请状态
            ,rateunit2 -- 利率单位
            ,ratefloattype2 -- 利率浮动类型
            ,businessrate2 -- 执行利率
            ,paymentaccount -- 还款账号
            ,transno -- 核心交易号
            ,oldrepaydate -- 原还款日
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,oldrepaytype -- 原还款方式
            ,completeflag -- 完成标志
            ,repayaccname -- 还款账户名称
            ,belongdept -- 所属条线
            ,oldrepayaccname -- 原还款账户名称
            ,baserate -- 基准利率
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,loanno -- 关联借据号
            ,customerid -- 客户编号
            ,termid2 -- 利率模式
            ,updatedate -- 更新日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,objecttype -- 关联对象类型
            ,ratefloattype -- 利率浮动类型
            ,ratefloat2 -- 浮动幅度
            ,paymenttype -- 还款方式
            ,gaincyc -- 递变周期
            ,oldrepayaccno -- 原还款账户
            ,termid -- 利率模式
            ,businessrate -- 执行利率
            ,putoutaccount -- 放款账号
            ,payfrequency -- 指定周期
            ,productid -- 产品编号
            ,repricetype2 -- 利率调整方式
            ,accountingorgid -- 入账机构
            ,baseratetype -- 基准利率类型
            ,baserate2 -- 基准利率
            ,transcode -- 交易类型
            ,oldmaturitydate -- 原贷款到期日
            ,baseratetype2 -- 基准利率类型
            ,payfrequencytype -- 还款周期类型
            ,segrptamount -- 尾款金额
            ,transdate -- 生效日期
            ,remark -- 备注
            ,relativeserialno -- 关联流水号
            ,defaultdueday -- 默认还款日
            ,gainamount -- 递变幅度
            ,transstatus -- 交易状态
            ,excutedate -- 交易日期
            ,customername -- 客户名称
            ,newmaturitydate -- 新贷款到期日
            ,rateunit -- 利率单位
            ,ratechangeflag -- 利率变更标志
            ,ratefloat -- 浮动幅度
            ,inputorgid -- 登记机构
            ,repricetype -- 利率调整方式
            ,segterm -- 指定还款计算期限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.applystatus -- 申请状态
    ,o.rateunit2 -- 利率单位
    ,o.ratefloattype2 -- 利率浮动类型
    ,o.businessrate2 -- 执行利率
    ,o.paymentaccount -- 还款账号
    ,o.transno -- 核心交易号
    ,o.oldrepaydate -- 原还款日
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.oldrepaytype -- 原还款方式
    ,o.completeflag -- 完成标志
    ,o.repayaccname -- 还款账户名称
    ,o.belongdept -- 所属条线
    ,o.oldrepayaccname -- 原还款账户名称
    ,o.baserate -- 基准利率
    ,o.inputuserid -- 登记人
    ,o.updateorgid -- 更新机构
    ,o.corporgid -- 法人机构编号
    ,o.loanno -- 关联借据号
    ,o.customerid -- 客户编号
    ,o.termid2 -- 利率模式
    ,o.updatedate -- 更新日期
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.objecttype -- 关联对象类型
    ,o.ratefloattype -- 利率浮动类型
    ,o.ratefloat2 -- 浮动幅度
    ,o.paymenttype -- 还款方式
    ,o.gaincyc -- 递变周期
    ,o.oldrepayaccno -- 原还款账户
    ,o.termid -- 利率模式
    ,o.businessrate -- 执行利率
    ,o.putoutaccount -- 放款账号
    ,o.payfrequency -- 指定周期
    ,o.productid -- 产品编号
    ,o.repricetype2 -- 利率调整方式
    ,o.accountingorgid -- 入账机构
    ,o.baseratetype -- 基准利率类型
    ,o.baserate2 -- 基准利率
    ,o.transcode -- 交易类型
    ,o.oldmaturitydate -- 原贷款到期日
    ,o.baseratetype2 -- 基准利率类型
    ,o.payfrequencytype -- 还款周期类型
    ,o.segrptamount -- 尾款金额
    ,o.transdate -- 生效日期
    ,o.remark -- 备注
    ,o.relativeserialno -- 关联流水号
    ,o.defaultdueday -- 默认还款日
    ,o.gainamount -- 递变幅度
    ,o.transstatus -- 交易状态
    ,o.excutedate -- 交易日期
    ,o.customername -- 客户名称
    ,o.newmaturitydate -- 新贷款到期日
    ,o.rateunit -- 利率单位
    ,o.ratechangeflag -- 利率变更标志
    ,o.ratefloat -- 浮动幅度
    ,o.inputorgid -- 登记机构
    ,o.repricetype -- 利率调整方式
    ,o.segterm -- 指定还款计算期限
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
from ${iol_schema}.icms_afterloan_change_bk o
    left join ${iol_schema}.icms_afterloan_change_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_afterloan_change_cl d
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
--truncate table ${iol_schema}.icms_afterloan_change;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_afterloan_change') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_afterloan_change drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_afterloan_change add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_afterloan_change exchange partition p_${batch_date} with table ${iol_schema}.icms_afterloan_change_cl;
alter table ${iol_schema}.icms_afterloan_change exchange partition p_20991231 with table ${iol_schema}.icms_afterloan_change_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_afterloan_change to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_change_op purge;
drop table ${iol_schema}.icms_afterloan_change_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_afterloan_change_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_afterloan_change',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
