/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_business_putout
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
create table ${iol_schema}.icms_wph_business_putout_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wph_business_putout
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_business_putout_op purge;
drop table ${iol_schema}.icms_wph_business_putout_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_business_putout_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_business_putout where 0=1;

create table ${iol_schema}.icms_wph_business_putout_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_business_putout where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_business_putout_cl(
            serialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,occurdate -- 发生日期
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,productid -- 产品编号
            ,internalkey -- 唯品借据号
            ,creditappno -- 唯品授信申请流水号
            ,loantype -- 贷款类型
            ,isscountry -- 签证国家
            ,loanstatus -- 放款状态
            ,failreason -- 失败原因
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,term -- 贷款期限
            ,gracedays -- 宽限期天数
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,businesssum -- 本次放款金额
            ,settlementaccount -- 结算账号(还款账户)
            ,putoutdate -- 放款日期
            ,maturity -- 到期日
            ,loanaccountno -- 贷款入账账号
            ,repaytype -- 还款方式
            ,vouchtype -- 主担保方式
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,paymenttype -- 放款支付方式
            ,interestrepaycycle -- 结息方式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,overduerate -- 逾期利率
            ,bizdate -- 流程日期
            ,trandate -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_business_putout_op(
            serialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,occurdate -- 发生日期
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,productid -- 产品编号
            ,internalkey -- 唯品借据号
            ,creditappno -- 唯品授信申请流水号
            ,loantype -- 贷款类型
            ,isscountry -- 签证国家
            ,loanstatus -- 放款状态
            ,failreason -- 失败原因
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,term -- 贷款期限
            ,gracedays -- 宽限期天数
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,businesssum -- 本次放款金额
            ,settlementaccount -- 结算账号(还款账户)
            ,putoutdate -- 放款日期
            ,maturity -- 到期日
            ,loanaccountno -- 贷款入账账号
            ,repaytype -- 还款方式
            ,vouchtype -- 主担保方式
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,paymenttype -- 放款支付方式
            ,interestrepaycycle -- 结息方式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,overduerate -- 逾期利率
            ,bizdate -- 流程日期
            ,trandate -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 出账流水号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同流水号
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.internalkey, o.internalkey) as internalkey -- 唯品借据号
    ,nvl(n.creditappno, o.creditappno) as creditappno -- 唯品授信申请流水号
    ,nvl(n.loantype, o.loantype) as loantype -- 贷款类型
    ,nvl(n.isscountry, o.isscountry) as isscountry -- 签证国家
    ,nvl(n.loanstatus, o.loanstatus) as loanstatus -- 放款状态
    ,nvl(n.failreason, o.failreason) as failreason -- 失败原因
    ,nvl(n.cyclefreq, o.cyclefreq) as cyclefreq -- 结息周期
    ,nvl(n.termtype, o.termtype) as termtype -- 贷款期限类型
    ,nvl(n.term, o.term) as term -- 贷款期限
    ,nvl(n.gracedays, o.gracedays) as gracedays -- 宽限期天数
    ,nvl(n.reasoncode, o.reasoncode) as reasoncode -- 贷款用途
    ,nvl(n.remark1, o.remark1) as remark1 -- 备用字段1（行外借据号）
    ,nvl(n.remark2, o.remark2) as remark2 -- 备用字段2
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 本次放款金额
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账号(还款账户)
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 放款日期
    ,nvl(n.maturity, o.maturity) as maturity -- 到期日
    ,nvl(n.loanaccountno, o.loanaccountno) as loanaccountno -- 贷款入账账号
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主担保方式
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 放款支付方式
    ,nvl(n.interestrepaycycle, o.interestrepaycycle) as interestrepaycycle -- 结息方式
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动方式
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 浮动幅度
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.overdueratefloattype, o.overdueratefloattype) as overdueratefloattype -- 逾期利率浮动方式
    ,nvl(n.overdueratefloatvalue, o.overdueratefloatvalue) as overdueratefloatvalue -- 逾期利率浮动值
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 出账机构编号(核心机构)
    ,nvl(n.lendingorgid, o.lendingorgid) as lendingorgid -- 贷款机构编号(核心机构)
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期利率
    ,nvl(n.bizdate, o.bizdate) as bizdate -- 流程日期
    ,nvl(n.trandate, o.trandate) as trandate -- 交易日期
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
from (select * from ${iol_schema}.icms_wph_business_putout_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wph_business_putout where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.contractserialno <> n.contractserialno
        or o.occurdate <> n.occurdate
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.productid <> n.productid
        or o.internalkey <> n.internalkey
        or o.creditappno <> n.creditappno
        or o.loantype <> n.loantype
        or o.isscountry <> n.isscountry
        or o.loanstatus <> n.loanstatus
        or o.failreason <> n.failreason
        or o.cyclefreq <> n.cyclefreq
        or o.termtype <> n.termtype
        or o.term <> n.term
        or o.gracedays <> n.gracedays
        or o.reasoncode <> n.reasoncode
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.businesssum <> n.businesssum
        or o.settlementaccount <> n.settlementaccount
        or o.putoutdate <> n.putoutdate
        or o.maturity <> n.maturity
        or o.loanaccountno <> n.loanaccountno
        or o.repaytype <> n.repaytype
        or o.vouchtype <> n.vouchtype
        or o.currency <> n.currency
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.ratemodel <> n.ratemodel
        or o.paymenttype <> n.paymenttype
        or o.interestrepaycycle <> n.interestrepaycycle
        or o.baseratetype <> n.baseratetype
        or o.baserate <> n.baserate
        or o.ratefloattype <> n.ratefloattype
        or o.rateadjusttype <> n.rateadjusttype
        or o.floatrange <> n.floatrange
        or o.executerate <> n.executerate
        or o.overdueratefloattype <> n.overdueratefloattype
        or o.overdueratefloatvalue <> n.overdueratefloatvalue
        or o.putoutorgid <> n.putoutorgid
        or o.lendingorgid <> n.lendingorgid
        or o.overduerate <> n.overduerate
        or o.bizdate <> n.bizdate
        or o.trandate <> n.trandate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_business_putout_cl(
            serialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,occurdate -- 发生日期
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,productid -- 产品编号
            ,internalkey -- 唯品借据号
            ,creditappno -- 唯品授信申请流水号
            ,loantype -- 贷款类型
            ,isscountry -- 签证国家
            ,loanstatus -- 放款状态
            ,failreason -- 失败原因
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,term -- 贷款期限
            ,gracedays -- 宽限期天数
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,businesssum -- 本次放款金额
            ,settlementaccount -- 结算账号(还款账户)
            ,putoutdate -- 放款日期
            ,maturity -- 到期日
            ,loanaccountno -- 贷款入账账号
            ,repaytype -- 还款方式
            ,vouchtype -- 主担保方式
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,paymenttype -- 放款支付方式
            ,interestrepaycycle -- 结息方式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,overduerate -- 逾期利率
            ,bizdate -- 流程日期
            ,trandate -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_business_putout_op(
            serialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,occurdate -- 发生日期
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,productid -- 产品编号
            ,internalkey -- 唯品借据号
            ,creditappno -- 唯品授信申请流水号
            ,loantype -- 贷款类型
            ,isscountry -- 签证国家
            ,loanstatus -- 放款状态
            ,failreason -- 失败原因
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,term -- 贷款期限
            ,gracedays -- 宽限期天数
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,businesssum -- 本次放款金额
            ,settlementaccount -- 结算账号(还款账户)
            ,putoutdate -- 放款日期
            ,maturity -- 到期日
            ,loanaccountno -- 贷款入账账号
            ,repaytype -- 还款方式
            ,vouchtype -- 主担保方式
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,paymenttype -- 放款支付方式
            ,interestrepaycycle -- 结息方式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,overduerate -- 逾期利率
            ,bizdate -- 流程日期
            ,trandate -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 出账流水号
    ,o.contractserialno -- 合同流水号
    ,o.occurdate -- 发生日期
    ,o.customerid -- 客户号
    ,o.customername -- 客户名称
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.productid -- 产品编号
    ,o.internalkey -- 唯品借据号
    ,o.creditappno -- 唯品授信申请流水号
    ,o.loantype -- 贷款类型
    ,o.isscountry -- 签证国家
    ,o.loanstatus -- 放款状态
    ,o.failreason -- 失败原因
    ,o.cyclefreq -- 结息周期
    ,o.termtype -- 贷款期限类型
    ,o.term -- 贷款期限
    ,o.gracedays -- 宽限期天数
    ,o.reasoncode -- 贷款用途
    ,o.remark1 -- 备用字段1（行外借据号）
    ,o.remark2 -- 备用字段2
    ,o.businesssum -- 本次放款金额
    ,o.settlementaccount -- 结算账号(还款账户)
    ,o.putoutdate -- 放款日期
    ,o.maturity -- 到期日
    ,o.loanaccountno -- 贷款入账账号
    ,o.repaytype -- 还款方式
    ,o.vouchtype -- 主担保方式
    ,o.currency -- 币种
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
    ,o.paymenttype -- 放款支付方式
    ,o.interestrepaycycle -- 结息方式
    ,o.baseratetype -- 基准利率类型
    ,o.baserate -- 基准利率
    ,o.ratefloattype -- 利率浮动方式
    ,o.rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
    ,o.floatrange -- 浮动幅度
    ,o.executerate -- 执行利率
    ,o.overdueratefloattype -- 逾期利率浮动方式
    ,o.overdueratefloatvalue -- 逾期利率浮动值
    ,o.putoutorgid -- 出账机构编号(核心机构)
    ,o.lendingorgid -- 贷款机构编号(核心机构)
    ,o.overduerate -- 逾期利率
    ,o.bizdate -- 流程日期
    ,o.trandate -- 交易日期
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
from ${iol_schema}.icms_wph_business_putout_bk o
    left join ${iol_schema}.icms_wph_business_putout_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wph_business_putout_cl d
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
--truncate table ${iol_schema}.icms_wph_business_putout;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wph_business_putout') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wph_business_putout drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wph_business_putout add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wph_business_putout exchange partition p_${batch_date} with table ${iol_schema}.icms_wph_business_putout_cl;
alter table ${iol_schema}.icms_wph_business_putout exchange partition p_20991231 with table ${iol_schema}.icms_wph_business_putout_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wph_business_putout to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_business_putout_op purge;
drop table ${iol_schema}.icms_wph_business_putout_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wph_business_putout_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wph_business_putout',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
