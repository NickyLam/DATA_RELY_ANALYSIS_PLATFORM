/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_asset_disposal_apply
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
create table ${iol_schema}.icms_asset_disposal_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_asset_disposal_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_asset_disposal_apply_op purge;
drop table ${iol_schema}.icms_asset_disposal_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_asset_disposal_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_asset_disposal_apply where 0=1;

create table ${iol_schema}.icms_asset_disposal_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_asset_disposal_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_asset_disposal_apply_cl(
            serialno -- 流水号
            ,accountno -- 账户
            ,accountname -- 账户名称
            ,subacctnum -- 子账户
            ,accountcurrency -- 账户币种
            ,transactionamt -- 交易价格
            ,accountrodtype -- 账户产品类型
            ,handletype -- 处置方式
            ,handledate -- 处置日期
            ,handlebalancesum -- 回收金额汇总
            ,handledesc -- 处置说明
            ,handlenum -- 处置数量
            ,approvestatus -- 审批状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,operateuserid -- 经办客户经理
            ,operateorgid -- 经办客户经理所属机构
            ,operatedate -- 经办时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,counterpartyzh -- 交易对手账号
            ,counterpartyname -- 受让方（交易对手）
            ,counterpartyzhbank -- 交易对手账号开户行名称
            ,programno -- 方案编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_asset_disposal_apply_op(
            serialno -- 流水号
            ,accountno -- 账户
            ,accountname -- 账户名称
            ,subacctnum -- 子账户
            ,accountcurrency -- 账户币种
            ,transactionamt -- 交易价格
            ,accountrodtype -- 账户产品类型
            ,handletype -- 处置方式
            ,handledate -- 处置日期
            ,handlebalancesum -- 回收金额汇总
            ,handledesc -- 处置说明
            ,handlenum -- 处置数量
            ,approvestatus -- 审批状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,operateuserid -- 经办客户经理
            ,operateorgid -- 经办客户经理所属机构
            ,operatedate -- 经办时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,counterpartyzh -- 交易对手账号
            ,counterpartyname -- 受让方（交易对手）
            ,counterpartyzhbank -- 交易对手账号开户行名称
            ,programno -- 方案编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.accountno, o.accountno) as accountno -- 账户
    ,nvl(n.accountname, o.accountname) as accountname -- 账户名称
    ,nvl(n.subacctnum, o.subacctnum) as subacctnum -- 子账户
    ,nvl(n.accountcurrency, o.accountcurrency) as accountcurrency -- 账户币种
    ,nvl(n.transactionamt, o.transactionamt) as transactionamt -- 交易价格
    ,nvl(n.accountrodtype, o.accountrodtype) as accountrodtype -- 账户产品类型
    ,nvl(n.handletype, o.handletype) as handletype -- 处置方式
    ,nvl(n.handledate, o.handledate) as handledate -- 处置日期
    ,nvl(n.handlebalancesum, o.handlebalancesum) as handlebalancesum -- 回收金额汇总
    ,nvl(n.handledesc, o.handledesc) as handledesc -- 处置说明
    ,nvl(n.handlenum, o.handlenum) as handlenum -- 处置数量
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办客户经理
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办客户经理所属机构
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.counterpartyzh, o.counterpartyzh) as counterpartyzh -- 交易对手账号
    ,nvl(n.counterpartyname, o.counterpartyname) as counterpartyname -- 受让方（交易对手）
    ,nvl(n.counterpartyzhbank, o.counterpartyzhbank) as counterpartyzhbank -- 交易对手账号开户行名称
    ,nvl(n.programno, o.programno) as programno -- 方案编号
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
from (select * from ${iol_schema}.icms_asset_disposal_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_asset_disposal_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.accountno <> n.accountno
        or o.accountname <> n.accountname
        or o.subacctnum <> n.subacctnum
        or o.accountcurrency <> n.accountcurrency
        or o.transactionamt <> n.transactionamt
        or o.accountrodtype <> n.accountrodtype
        or o.handletype <> n.handletype
        or o.handledate <> n.handledate
        or o.handlebalancesum <> n.handlebalancesum
        or o.handledesc <> n.handledesc
        or o.handlenum <> n.handlenum
        or o.approvestatus <> n.approvestatus
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.operatedate <> n.operatedate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.counterpartyzh <> n.counterpartyzh
        or o.counterpartyname <> n.counterpartyname
        or o.counterpartyzhbank <> n.counterpartyzhbank
        or o.programno <> n.programno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_asset_disposal_apply_cl(
            serialno -- 流水号
            ,accountno -- 账户
            ,accountname -- 账户名称
            ,subacctnum -- 子账户
            ,accountcurrency -- 账户币种
            ,transactionamt -- 交易价格
            ,accountrodtype -- 账户产品类型
            ,handletype -- 处置方式
            ,handledate -- 处置日期
            ,handlebalancesum -- 回收金额汇总
            ,handledesc -- 处置说明
            ,handlenum -- 处置数量
            ,approvestatus -- 审批状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,operateuserid -- 经办客户经理
            ,operateorgid -- 经办客户经理所属机构
            ,operatedate -- 经办时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,counterpartyzh -- 交易对手账号
            ,counterpartyname -- 受让方（交易对手）
            ,counterpartyzhbank -- 交易对手账号开户行名称
            ,programno -- 方案编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_asset_disposal_apply_op(
            serialno -- 流水号
            ,accountno -- 账户
            ,accountname -- 账户名称
            ,subacctnum -- 子账户
            ,accountcurrency -- 账户币种
            ,transactionamt -- 交易价格
            ,accountrodtype -- 账户产品类型
            ,handletype -- 处置方式
            ,handledate -- 处置日期
            ,handlebalancesum -- 回收金额汇总
            ,handledesc -- 处置说明
            ,handlenum -- 处置数量
            ,approvestatus -- 审批状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,operateuserid -- 经办客户经理
            ,operateorgid -- 经办客户经理所属机构
            ,operatedate -- 经办时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,counterpartyzh -- 交易对手账号
            ,counterpartyname -- 受让方（交易对手）
            ,counterpartyzhbank -- 交易对手账号开户行名称
            ,programno -- 方案编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.accountno -- 账户
    ,o.accountname -- 账户名称
    ,o.subacctnum -- 子账户
    ,o.accountcurrency -- 账户币种
    ,o.transactionamt -- 交易价格
    ,o.accountrodtype -- 账户产品类型
    ,o.handletype -- 处置方式
    ,o.handledate -- 处置日期
    ,o.handlebalancesum -- 回收金额汇总
    ,o.handledesc -- 处置说明
    ,o.handlenum -- 处置数量
    ,o.approvestatus -- 审批状态
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.operateuserid -- 经办客户经理
    ,o.operateorgid -- 经办客户经理所属机构
    ,o.operatedate -- 经办时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.counterpartyzh -- 交易对手账号
    ,o.counterpartyname -- 受让方（交易对手）
    ,o.counterpartyzhbank -- 交易对手账号开户行名称
    ,o.programno -- 方案编号
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
from ${iol_schema}.icms_asset_disposal_apply_bk o
    left join ${iol_schema}.icms_asset_disposal_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_asset_disposal_apply_cl d
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
--truncate table ${iol_schema}.icms_asset_disposal_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_asset_disposal_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_asset_disposal_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_asset_disposal_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_asset_disposal_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_asset_disposal_apply_cl;
alter table ${iol_schema}.icms_asset_disposal_apply exchange partition p_20991231 with table ${iol_schema}.icms_asset_disposal_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_asset_disposal_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_asset_disposal_apply_op purge;
drop table ${iol_schema}.icms_asset_disposal_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_asset_disposal_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_asset_disposal_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
