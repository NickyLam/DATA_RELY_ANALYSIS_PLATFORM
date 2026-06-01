/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_business_putout
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
create table ${iol_schema}.icms_zjbk_business_putout_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zjbk_business_putout
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_business_putout_op purge;
drop table ${iol_schema}.icms_zjbk_business_putout_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_business_putout_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_business_putout where 0=1;

create table ${iol_schema}.icms_zjbk_business_putout_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_business_putout where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_business_putout_cl(
            serialno -- 流水号
            ,loanid -- 借款流水号
            ,accountid -- 授信ID
            ,mchid -- 商户号
            ,appid -- 商户应用ID
            ,orderno -- 放款支付订单号
            ,tradetime -- 放款发起时间
            ,finishtime -- 放款完成时间
            ,status -- 状态
            ,amount -- 放款总金额
            ,currency -- 字节币种
            ,cardid -- 银行卡号
            ,accountname -- 账户名称
            ,accounttype -- 银行卡类型
            ,cnapscode -- 联行号
            ,extinfo -- 其他信息
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,tradeno -- 抖音放款订单号
            ,contractserialno -- 关联合同流水号
            ,currdate -- 账务日期
            ,leader -- 牵头方
            ,partner -- 合作方
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,applydate -- 申请日期
            ,startdate -- 确认日期
            ,enddate -- 到期日
            ,productid -- 产品编号
            ,intrate -- 利率
            ,termmonth -- 期限月
            ,usage -- 用途
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期
            ,periods -- 总期数
            ,graceperiod -- 宽限期
            ,putoutstatus -- 放款状态
            ,outloanchannelno -- 平台订单号
            ,loanresptime -- 支付返回成功时间
            ,counterpartyaccounttype -- 交易对象账户类型
            ,counterpartyname -- 交易对象开户机构
            ,counterpartyaccountno -- 交易对象账号
            ,bankaccounttype -- 银行卡类型
            ,bankphone -- 放款账户手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_business_putout_op(
            serialno -- 流水号
            ,loanid -- 借款流水号
            ,accountid -- 授信ID
            ,mchid -- 商户号
            ,appid -- 商户应用ID
            ,orderno -- 放款支付订单号
            ,tradetime -- 放款发起时间
            ,finishtime -- 放款完成时间
            ,status -- 状态
            ,amount -- 放款总金额
            ,currency -- 字节币种
            ,cardid -- 银行卡号
            ,accountname -- 账户名称
            ,accounttype -- 银行卡类型
            ,cnapscode -- 联行号
            ,extinfo -- 其他信息
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,tradeno -- 抖音放款订单号
            ,contractserialno -- 关联合同流水号
            ,currdate -- 账务日期
            ,leader -- 牵头方
            ,partner -- 合作方
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,applydate -- 申请日期
            ,startdate -- 确认日期
            ,enddate -- 到期日
            ,productid -- 产品编号
            ,intrate -- 利率
            ,termmonth -- 期限月
            ,usage -- 用途
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期
            ,periods -- 总期数
            ,graceperiod -- 宽限期
            ,putoutstatus -- 放款状态
            ,outloanchannelno -- 平台订单号
            ,loanresptime -- 支付返回成功时间
            ,counterpartyaccounttype -- 交易对象账户类型
            ,counterpartyname -- 交易对象开户机构
            ,counterpartyaccountno -- 交易对象账号
            ,bankaccounttype -- 银行卡类型
            ,bankphone -- 放款账户手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.loanid, o.loanid) as loanid -- 借款流水号
    ,nvl(n.accountid, o.accountid) as accountid -- 授信ID
    ,nvl(n.mchid, o.mchid) as mchid -- 商户号
    ,nvl(n.appid, o.appid) as appid -- 商户应用ID
    ,nvl(n.orderno, o.orderno) as orderno -- 放款支付订单号
    ,nvl(n.tradetime, o.tradetime) as tradetime -- 放款发起时间
    ,nvl(n.finishtime, o.finishtime) as finishtime -- 放款完成时间
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.amount, o.amount) as amount -- 放款总金额
    ,nvl(n.currency, o.currency) as currency -- 字节币种
    ,nvl(n.cardid, o.cardid) as cardid -- 银行卡号
    ,nvl(n.accountname, o.accountname) as accountname -- 账户名称
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 银行卡类型
    ,nvl(n.cnapscode, o.cnapscode) as cnapscode -- 联行号
    ,nvl(n.extinfo, o.extinfo) as extinfo -- 其他信息
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.tradeno, o.tradeno) as tradeno -- 抖音放款订单号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 关联合同流水号
    ,nvl(n.currdate, o.currdate) as currdate -- 账务日期
    ,nvl(n.leader, o.leader) as leader -- 牵头方
    ,nvl(n.partner, o.partner) as partner -- 合作方
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.startdate, o.startdate) as startdate -- 确认日期
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.intrate, o.intrate) as intrate -- 利率
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限月
    ,nvl(n.usage, o.usage) as usage -- 用途
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期
    ,nvl(n.periods, o.periods) as periods -- 总期数
    ,nvl(n.graceperiod, o.graceperiod) as graceperiod -- 宽限期
    ,nvl(n.putoutstatus, o.putoutstatus) as putoutstatus -- 放款状态
    ,nvl(n.outloanchannelno, o.outloanchannelno) as outloanchannelno -- 平台订单号
    ,nvl(n.loanresptime, o.loanresptime) as loanresptime -- 支付返回成功时间
    ,nvl(n.counterpartyaccounttype, o.counterpartyaccounttype) as counterpartyaccounttype -- 交易对象账户类型
    ,nvl(n.counterpartyname, o.counterpartyname) as counterpartyname -- 交易对象开户机构
    ,nvl(n.counterpartyaccountno, o.counterpartyaccountno) as counterpartyaccountno -- 交易对象账号
    ,nvl(n.bankaccounttype, o.bankaccounttype) as bankaccounttype -- 银行卡类型
    ,nvl(n.bankphone, o.bankphone) as bankphone -- 放款账户手机号
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
from (select * from ${iol_schema}.icms_zjbk_business_putout_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zjbk_business_putout where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.loanid <> n.loanid
        or o.accountid <> n.accountid
        or o.mchid <> n.mchid
        or o.appid <> n.appid
        or o.orderno <> n.orderno
        or o.tradetime <> n.tradetime
        or o.finishtime <> n.finishtime
        or o.status <> n.status
        or o.amount <> n.amount
        or o.currency <> n.currency
        or o.cardid <> n.cardid
        or o.accountname <> n.accountname
        or o.accounttype <> n.accounttype
        or o.cnapscode <> n.cnapscode
        or o.extinfo <> n.extinfo
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.tradeno <> n.tradeno
        or o.contractserialno <> n.contractserialno
        or o.currdate <> n.currdate
        or o.leader <> n.leader
        or o.partner <> n.partner
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.applydate <> n.applydate
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.productid <> n.productid
        or o.intrate <> n.intrate
        or o.termmonth <> n.termmonth
        or o.usage <> n.usage
        or o.repaytype <> n.repaytype
        or o.repaycycle <> n.repaycycle
        or o.periods <> n.periods
        or o.graceperiod <> n.graceperiod
        or o.putoutstatus <> n.putoutstatus
        or o.outloanchannelno <> n.outloanchannelno
        or o.loanresptime <> n.loanresptime
        or o.counterpartyaccounttype <> n.counterpartyaccounttype
        or o.counterpartyname <> n.counterpartyname
        or o.counterpartyaccountno <> n.counterpartyaccountno
        or o.bankaccounttype <> n.bankaccounttype
        or o.bankphone <> n.bankphone
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_business_putout_cl(
            serialno -- 流水号
            ,loanid -- 借款流水号
            ,accountid -- 授信ID
            ,mchid -- 商户号
            ,appid -- 商户应用ID
            ,orderno -- 放款支付订单号
            ,tradetime -- 放款发起时间
            ,finishtime -- 放款完成时间
            ,status -- 状态
            ,amount -- 放款总金额
            ,currency -- 字节币种
            ,cardid -- 银行卡号
            ,accountname -- 账户名称
            ,accounttype -- 银行卡类型
            ,cnapscode -- 联行号
            ,extinfo -- 其他信息
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,tradeno -- 抖音放款订单号
            ,contractserialno -- 关联合同流水号
            ,currdate -- 账务日期
            ,leader -- 牵头方
            ,partner -- 合作方
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,applydate -- 申请日期
            ,startdate -- 确认日期
            ,enddate -- 到期日
            ,productid -- 产品编号
            ,intrate -- 利率
            ,termmonth -- 期限月
            ,usage -- 用途
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期
            ,periods -- 总期数
            ,graceperiod -- 宽限期
            ,putoutstatus -- 放款状态
            ,outloanchannelno -- 平台订单号
            ,loanresptime -- 支付返回成功时间
            ,counterpartyaccounttype -- 交易对象账户类型
            ,counterpartyname -- 交易对象开户机构
            ,counterpartyaccountno -- 交易对象账号
            ,bankaccounttype -- 银行卡类型
            ,bankphone -- 放款账户手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_business_putout_op(
            serialno -- 流水号
            ,loanid -- 借款流水号
            ,accountid -- 授信ID
            ,mchid -- 商户号
            ,appid -- 商户应用ID
            ,orderno -- 放款支付订单号
            ,tradetime -- 放款发起时间
            ,finishtime -- 放款完成时间
            ,status -- 状态
            ,amount -- 放款总金额
            ,currency -- 字节币种
            ,cardid -- 银行卡号
            ,accountname -- 账户名称
            ,accounttype -- 银行卡类型
            ,cnapscode -- 联行号
            ,extinfo -- 其他信息
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,tradeno -- 抖音放款订单号
            ,contractserialno -- 关联合同流水号
            ,currdate -- 账务日期
            ,leader -- 牵头方
            ,partner -- 合作方
            ,customerid -- 客户号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,applydate -- 申请日期
            ,startdate -- 确认日期
            ,enddate -- 到期日
            ,productid -- 产品编号
            ,intrate -- 利率
            ,termmonth -- 期限月
            ,usage -- 用途
            ,repaytype -- 还款方式
            ,repaycycle -- 还款周期
            ,periods -- 总期数
            ,graceperiod -- 宽限期
            ,putoutstatus -- 放款状态
            ,outloanchannelno -- 平台订单号
            ,loanresptime -- 支付返回成功时间
            ,counterpartyaccounttype -- 交易对象账户类型
            ,counterpartyname -- 交易对象开户机构
            ,counterpartyaccountno -- 交易对象账号
            ,bankaccounttype -- 银行卡类型
            ,bankphone -- 放款账户手机号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.loanid -- 借款流水号
    ,o.accountid -- 授信ID
    ,o.mchid -- 商户号
    ,o.appid -- 商户应用ID
    ,o.orderno -- 放款支付订单号
    ,o.tradetime -- 放款发起时间
    ,o.finishtime -- 放款完成时间
    ,o.status -- 状态
    ,o.amount -- 放款总金额
    ,o.currency -- 字节币种
    ,o.cardid -- 银行卡号
    ,o.accountname -- 账户名称
    ,o.accounttype -- 银行卡类型
    ,o.cnapscode -- 联行号
    ,o.extinfo -- 其他信息
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.tradeno -- 抖音放款订单号
    ,o.contractserialno -- 关联合同流水号
    ,o.currdate -- 账务日期
    ,o.leader -- 牵头方
    ,o.partner -- 合作方
    ,o.customerid -- 客户号
    ,o.customername -- 客户名称
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.applydate -- 申请日期
    ,o.startdate -- 确认日期
    ,o.enddate -- 到期日
    ,o.productid -- 产品编号
    ,o.intrate -- 利率
    ,o.termmonth -- 期限月
    ,o.usage -- 用途
    ,o.repaytype -- 还款方式
    ,o.repaycycle -- 还款周期
    ,o.periods -- 总期数
    ,o.graceperiod -- 宽限期
    ,o.putoutstatus -- 放款状态
    ,o.outloanchannelno -- 平台订单号
    ,o.loanresptime -- 支付返回成功时间
    ,o.counterpartyaccounttype -- 交易对象账户类型
    ,o.counterpartyname -- 交易对象开户机构
    ,o.counterpartyaccountno -- 交易对象账号
    ,o.bankaccounttype -- 银行卡类型
    ,o.bankphone -- 放款账户手机号
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
from ${iol_schema}.icms_zjbk_business_putout_bk o
    left join ${iol_schema}.icms_zjbk_business_putout_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zjbk_business_putout_cl d
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
--truncate table ${iol_schema}.icms_zjbk_business_putout;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zjbk_business_putout') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zjbk_business_putout drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zjbk_business_putout add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zjbk_business_putout exchange partition p_${batch_date} with table ${iol_schema}.icms_zjbk_business_putout_cl;
alter table ${iol_schema}.icms_zjbk_business_putout exchange partition p_20991231 with table ${iol_schema}.icms_zjbk_business_putout_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zjbk_business_putout to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_business_putout_op purge;
drop table ${iol_schema}.icms_zjbk_business_putout_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zjbk_business_putout_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zjbk_business_putout',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
