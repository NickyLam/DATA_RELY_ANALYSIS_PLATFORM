/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_trd_trade_fee_detail
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
create table ${iol_schema}.fams_trd_trade_fee_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_trd_trade_fee_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_trd_trade_fee_detail_op purge;
drop table ${iol_schema}.fams_trd_trade_fee_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_trd_trade_fee_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_trd_trade_fee_detail where 0=1;

create table ${iol_schema}.fams_trd_trade_fee_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_trd_trade_fee_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_trd_trade_fee_detail_cl(
            trade_id -- 交易编号
            ,fee_type -- 费用类型，结算费、交易手续费、通道费、资产推荐费、增值税、城建税、教育附加税等
            ,is_pay_with_trade -- 是否随交易支付
            ,fee_amt -- 费用金额
            ,chl_finprod_id -- 通道代码，通道费时填该值。
            ,fee_id -- 费用代码，计提式费用存现金流代码，一次性费用存费用类型
            ,fee_rate -- 费率
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,ccy -- 币种
            ,is_prepaid -- 是否作为待摊
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_trd_trade_fee_detail_op(
            trade_id -- 交易编号
            ,fee_type -- 费用类型，结算费、交易手续费、通道费、资产推荐费、增值税、城建税、教育附加税等
            ,is_pay_with_trade -- 是否随交易支付
            ,fee_amt -- 费用金额
            ,chl_finprod_id -- 通道代码，通道费时填该值。
            ,fee_id -- 费用代码，计提式费用存现金流代码，一次性费用存费用类型
            ,fee_rate -- 费率
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,ccy -- 币种
            ,is_prepaid -- 是否作为待摊
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trade_id, o.trade_id) as trade_id -- 交易编号
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费用类型，结算费、交易手续费、通道费、资产推荐费、增值税、城建税、教育附加税等
    ,nvl(n.is_pay_with_trade, o.is_pay_with_trade) as is_pay_with_trade -- 是否随交易支付
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 费用金额
    ,nvl(n.chl_finprod_id, o.chl_finprod_id) as chl_finprod_id -- 通道代码，通道费时填该值。
    ,nvl(n.fee_id, o.fee_id) as fee_id -- 费用代码，计提式费用存现金流代码，一次性费用存费用类型
    ,nvl(n.fee_rate, o.fee_rate) as fee_rate -- 费率
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.is_prepaid, o.is_prepaid) as is_prepaid -- 是否作为待摊
    ,case when
            n.trade_id is null
            and n.fee_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trade_id is null
            and n.fee_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trade_id is null
            and n.fee_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_trd_trade_fee_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_trd_trade_fee_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trade_id = n.trade_id
            and o.fee_type = n.fee_type
where (
        o.trade_id is null
        and o.fee_type is null
    )
    or (
        n.trade_id is null
        and n.fee_type is null
    )
    or (
        o.is_pay_with_trade <> n.is_pay_with_trade
        or o.fee_amt <> n.fee_amt
        or o.chl_finprod_id <> n.chl_finprod_id
        or o.fee_id <> n.fee_id
        or o.fee_rate <> n.fee_rate
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.ccy <> n.ccy
        or o.is_prepaid <> n.is_prepaid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_trd_trade_fee_detail_cl(
            trade_id -- 交易编号
            ,fee_type -- 费用类型，结算费、交易手续费、通道费、资产推荐费、增值税、城建税、教育附加税等
            ,is_pay_with_trade -- 是否随交易支付
            ,fee_amt -- 费用金额
            ,chl_finprod_id -- 通道代码，通道费时填该值。
            ,fee_id -- 费用代码，计提式费用存现金流代码，一次性费用存费用类型
            ,fee_rate -- 费率
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,ccy -- 币种
            ,is_prepaid -- 是否作为待摊
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_trd_trade_fee_detail_op(
            trade_id -- 交易编号
            ,fee_type -- 费用类型，结算费、交易手续费、通道费、资产推荐费、增值税、城建税、教育附加税等
            ,is_pay_with_trade -- 是否随交易支付
            ,fee_amt -- 费用金额
            ,chl_finprod_id -- 通道代码，通道费时填该值。
            ,fee_id -- 费用代码，计提式费用存现金流代码，一次性费用存费用类型
            ,fee_rate -- 费率
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,ccy -- 币种
            ,is_prepaid -- 是否作为待摊
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trade_id -- 交易编号
    ,o.fee_type -- 费用类型，结算费、交易手续费、通道费、资产推荐费、增值税、城建税、教育附加税等
    ,o.is_pay_with_trade -- 是否随交易支付
    ,o.fee_amt -- 费用金额
    ,o.chl_finprod_id -- 通道代码，通道费时填该值。
    ,o.fee_id -- 费用代码，计提式费用存现金流代码，一次性费用存费用类型
    ,o.fee_rate -- 费率
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.ccy -- 币种
    ,o.is_prepaid -- 是否作为待摊
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
from ${iol_schema}.fams_trd_trade_fee_detail_bk o
    left join ${iol_schema}.fams_trd_trade_fee_detail_op n
        on
            o.trade_id = n.trade_id
            and o.fee_type = n.fee_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_trd_trade_fee_detail_cl d
        on
            o.trade_id = d.trade_id
            and o.fee_type = d.fee_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_trd_trade_fee_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_trd_trade_fee_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_trd_trade_fee_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_trd_trade_fee_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_trd_trade_fee_detail exchange partition p_${batch_date} with table ${iol_schema}.fams_trd_trade_fee_detail_cl;
alter table ${iol_schema}.fams_trd_trade_fee_detail exchange partition p_20991231 with table ${iol_schema}.fams_trd_trade_fee_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_trd_trade_fee_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_trd_trade_fee_detail_op purge;
drop table ${iol_schema}.fams_trd_trade_fee_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_trd_trade_fee_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_trd_trade_fee_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
