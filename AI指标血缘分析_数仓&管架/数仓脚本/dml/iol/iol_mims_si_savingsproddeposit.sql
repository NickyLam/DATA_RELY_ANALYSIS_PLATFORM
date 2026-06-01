/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_savingsproddeposit
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
create table ${iol_schema}.mims_si_savingsproddeposit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_savingsproddeposit;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_savingsproddeposit_op purge;
drop table ${iol_schema}.mims_si_savingsproddeposit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_savingsproddeposit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_savingsproddeposit where 0=1;

create table ${iol_schema}.mims_si_savingsproddeposit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_savingsproddeposit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_savingsproddeposit_cl(
            sccode -- 押品编号
            ,protocolcode -- 协议编号
            ,prodcode -- 产品编号
            ,buyaccount -- 购买账号
            ,buyamt -- 购买金额
            ,custid -- 客户号
            ,rate -- 利率
            ,protocolstatus -- 协议状态
            ,startdate -- 起始日期
            ,enddate -- 到期日期
            ,remark -- 其他说明
            ,type -- 类型
            ,parentaccount -- 保证金母户号
            ,childaccount -- 子户号
            ,prodname -- 产品名称
            ,deposit -- 存期
            ,balanceamt -- 可用余额
            ,accountamt -- 账户余额
            ,tdcurrency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_savingsproddeposit_op(
            sccode -- 押品编号
            ,protocolcode -- 协议编号
            ,prodcode -- 产品编号
            ,buyaccount -- 购买账号
            ,buyamt -- 购买金额
            ,custid -- 客户号
            ,rate -- 利率
            ,protocolstatus -- 协议状态
            ,startdate -- 起始日期
            ,enddate -- 到期日期
            ,remark -- 其他说明
            ,type -- 类型
            ,parentaccount -- 保证金母户号
            ,childaccount -- 子户号
            ,prodname -- 产品名称
            ,deposit -- 存期
            ,balanceamt -- 可用余额
            ,accountamt -- 账户余额
            ,tdcurrency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.protocolcode, o.protocolcode) as protocolcode -- 协议编号
    ,nvl(n.prodcode, o.prodcode) as prodcode -- 产品编号
    ,nvl(n.buyaccount, o.buyaccount) as buyaccount -- 购买账号
    ,nvl(n.buyamt, o.buyamt) as buyamt -- 购买金额
    ,nvl(n.custid, o.custid) as custid -- 客户号
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.protocolstatus, o.protocolstatus) as protocolstatus -- 协议状态
    ,nvl(n.startdate, o.startdate) as startdate -- 起始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日期
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.type, o.type) as type -- 类型
    ,nvl(n.parentaccount, o.parentaccount) as parentaccount -- 保证金母户号
    ,nvl(n.childaccount, o.childaccount) as childaccount -- 子户号
    ,nvl(n.prodname, o.prodname) as prodname -- 产品名称
    ,nvl(n.deposit, o.deposit) as deposit -- 存期
    ,nvl(n.balanceamt, o.balanceamt) as balanceamt -- 可用余额
    ,nvl(n.accountamt, o.accountamt) as accountamt -- 账户余额
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_savingsproddeposit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_savingsproddeposit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.protocolcode <> n.protocolcode
        or o.prodcode <> n.prodcode
        or o.buyaccount <> n.buyaccount
        or o.buyamt <> n.buyamt
        or o.custid <> n.custid
        or o.rate <> n.rate
        or o.protocolstatus <> n.protocolstatus
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.remark <> n.remark
        or o.type <> n.type
        or o.parentaccount <> n.parentaccount
        or o.childaccount <> n.childaccount
        or o.prodname <> n.prodname
        or o.deposit <> n.deposit
        or o.balanceamt <> n.balanceamt
        or o.accountamt <> n.accountamt
        or o.tdcurrency <> n.tdcurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_savingsproddeposit_cl(
            sccode -- 押品编号
            ,protocolcode -- 协议编号
            ,prodcode -- 产品编号
            ,buyaccount -- 购买账号
            ,buyamt -- 购买金额
            ,custid -- 客户号
            ,rate -- 利率
            ,protocolstatus -- 协议状态
            ,startdate -- 起始日期
            ,enddate -- 到期日期
            ,remark -- 其他说明
            ,type -- 类型
            ,parentaccount -- 保证金母户号
            ,childaccount -- 子户号
            ,prodname -- 产品名称
            ,deposit -- 存期
            ,balanceamt -- 可用余额
            ,accountamt -- 账户余额
            ,tdcurrency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_savingsproddeposit_op(
            sccode -- 押品编号
            ,protocolcode -- 协议编号
            ,prodcode -- 产品编号
            ,buyaccount -- 购买账号
            ,buyamt -- 购买金额
            ,custid -- 客户号
            ,rate -- 利率
            ,protocolstatus -- 协议状态
            ,startdate -- 起始日期
            ,enddate -- 到期日期
            ,remark -- 其他说明
            ,type -- 类型
            ,parentaccount -- 保证金母户号
            ,childaccount -- 子户号
            ,prodname -- 产品名称
            ,deposit -- 存期
            ,balanceamt -- 可用余额
            ,accountamt -- 账户余额
            ,tdcurrency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.protocolcode -- 协议编号
    ,o.prodcode -- 产品编号
    ,o.buyaccount -- 购买账号
    ,o.buyamt -- 购买金额
    ,o.custid -- 客户号
    ,o.rate -- 利率
    ,o.protocolstatus -- 协议状态
    ,o.startdate -- 起始日期
    ,o.enddate -- 到期日期
    ,o.remark -- 其他说明
    ,o.type -- 类型
    ,o.parentaccount -- 保证金母户号
    ,o.childaccount -- 子户号
    ,o.prodname -- 产品名称
    ,o.deposit -- 存期
    ,o.balanceamt -- 可用余额
    ,o.accountamt -- 账户余额
    ,o.tdcurrency -- 币种
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_savingsproddeposit_bk o
    left join ${iol_schema}.mims_si_savingsproddeposit_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_savingsproddeposit_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_savingsproddeposit;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_savingsproddeposit exchange partition p_19000101 with table ${iol_schema}.mims_si_savingsproddeposit_cl;
alter table ${iol_schema}.mims_si_savingsproddeposit exchange partition p_20991231 with table ${iol_schema}.mims_si_savingsproddeposit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_savingsproddeposit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_savingsproddeposit_op purge;
drop table ${iol_schema}.mims_si_savingsproddeposit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_savingsproddeposit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_savingsproddeposit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
