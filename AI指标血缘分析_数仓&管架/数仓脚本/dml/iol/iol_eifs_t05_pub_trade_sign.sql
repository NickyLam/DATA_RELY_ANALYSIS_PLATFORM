/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t05_pub_trade_sign
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
create table ${iol_schema}.eifs_t05_pub_trade_sign_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t05_pub_trade_sign
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t05_pub_trade_sign_op purge;
drop table ${iol_schema}.eifs_t05_pub_trade_sign_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_trade_sign_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t05_pub_trade_sign where 0=1;

create table ${iol_schema}.eifs_t05_pub_trade_sign_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t05_pub_trade_sign where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t05_pub_trade_sign_cl(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,txn_chl -- 交易渠道
            ,txn_type -- 交易类型代码
            ,curr_cd -- 币种
            ,time_scale -- 时间单位代码
            ,txn_times_smy -- 累计交易次数
            ,txn_times_limit -- 交易次数上限
            ,txn_credit_smy -- 累计发生额
            ,txn_limit -- 交易限额
            ,last_txn_dt -- 最近交易日期
            ,last_txn_time -- 最近交易时间
            ,sign_control_ind -- 签约服务控制码
            ,third_party_num -- 第三方编号
            ,project_num -- 项目编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t05_pub_trade_sign_op(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,txn_chl -- 交易渠道
            ,txn_type -- 交易类型代码
            ,curr_cd -- 币种
            ,time_scale -- 时间单位代码
            ,txn_times_smy -- 累计交易次数
            ,txn_times_limit -- 交易次数上限
            ,txn_credit_smy -- 累计发生额
            ,txn_limit -- 交易限额
            ,last_txn_dt -- 最近交易日期
            ,last_txn_time -- 最近交易时间
            ,sign_control_ind -- 签约服务控制码
            ,third_party_num -- 第三方编号
            ,project_num -- 项目编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sign_contract_id, o.sign_contract_id) as sign_contract_id -- 签约id
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 签约编号
    ,nvl(n.agreement_item_seq_id, o.agreement_item_seq_id) as agreement_item_seq_id -- 协议项编号
    ,nvl(n.txn_chl, o.txn_chl) as txn_chl -- 交易渠道
    ,nvl(n.txn_type, o.txn_type) as txn_type -- 交易类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种
    ,nvl(n.time_scale, o.time_scale) as time_scale -- 时间单位代码
    ,nvl(n.txn_times_smy, o.txn_times_smy) as txn_times_smy -- 累计交易次数
    ,nvl(n.txn_times_limit, o.txn_times_limit) as txn_times_limit -- 交易次数上限
    ,nvl(n.txn_credit_smy, o.txn_credit_smy) as txn_credit_smy -- 累计发生额
    ,nvl(n.txn_limit, o.txn_limit) as txn_limit -- 交易限额
    ,nvl(n.last_txn_dt, o.last_txn_dt) as last_txn_dt -- 最近交易日期
    ,nvl(n.last_txn_time, o.last_txn_time) as last_txn_time -- 最近交易时间
    ,nvl(n.sign_control_ind, o.sign_control_ind) as sign_control_ind -- 签约服务控制码
    ,nvl(n.third_party_num, o.third_party_num) as third_party_num -- 第三方编号
    ,nvl(n.project_num, o.project_num) as project_num -- 项目编号
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,case when
            n.sign_contract_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sign_contract_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sign_contract_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t05_pub_trade_sign_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t05_pub_trade_sign where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sign_contract_id = n.sign_contract_id
where (
        o.sign_contract_id is null
    )
    or (
        n.sign_contract_id is null
    )
    or (
        o.agreement_id <> n.agreement_id
        or o.agreement_item_seq_id <> n.agreement_item_seq_id
        or o.txn_chl <> n.txn_chl
        or o.txn_type <> n.txn_type
        or o.curr_cd <> n.curr_cd
        or o.time_scale <> n.time_scale
        or o.txn_times_smy <> n.txn_times_smy
        or o.txn_times_limit <> n.txn_times_limit
        or o.txn_credit_smy <> n.txn_credit_smy
        or o.txn_limit <> n.txn_limit
        or o.last_txn_dt <> n.last_txn_dt
        or o.last_txn_time <> n.last_txn_time
        or o.sign_control_ind <> n.sign_control_ind
        or o.third_party_num <> n.third_party_num
        or o.project_num <> n.project_num
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t05_pub_trade_sign_cl(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,txn_chl -- 交易渠道
            ,txn_type -- 交易类型代码
            ,curr_cd -- 币种
            ,time_scale -- 时间单位代码
            ,txn_times_smy -- 累计交易次数
            ,txn_times_limit -- 交易次数上限
            ,txn_credit_smy -- 累计发生额
            ,txn_limit -- 交易限额
            ,last_txn_dt -- 最近交易日期
            ,last_txn_time -- 最近交易时间
            ,sign_control_ind -- 签约服务控制码
            ,third_party_num -- 第三方编号
            ,project_num -- 项目编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t05_pub_trade_sign_op(
            sign_contract_id -- 签约id
            ,agreement_id -- 签约编号
            ,agreement_item_seq_id -- 协议项编号
            ,txn_chl -- 交易渠道
            ,txn_type -- 交易类型代码
            ,curr_cd -- 币种
            ,time_scale -- 时间单位代码
            ,txn_times_smy -- 累计交易次数
            ,txn_times_limit -- 交易次数上限
            ,txn_credit_smy -- 累计发生额
            ,txn_limit -- 交易限额
            ,last_txn_dt -- 最近交易日期
            ,last_txn_time -- 最近交易时间
            ,sign_control_ind -- 签约服务控制码
            ,third_party_num -- 第三方编号
            ,project_num -- 项目编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sign_contract_id -- 签约id
    ,o.agreement_id -- 签约编号
    ,o.agreement_item_seq_id -- 协议项编号
    ,o.txn_chl -- 交易渠道
    ,o.txn_type -- 交易类型代码
    ,o.curr_cd -- 币种
    ,o.time_scale -- 时间单位代码
    ,o.txn_times_smy -- 累计交易次数
    ,o.txn_times_limit -- 交易次数上限
    ,o.txn_credit_smy -- 累计发生额
    ,o.txn_limit -- 交易限额
    ,o.last_txn_dt -- 最近交易日期
    ,o.last_txn_time -- 最近交易时间
    ,o.sign_control_ind -- 签约服务控制码
    ,o.third_party_num -- 第三方编号
    ,o.project_num -- 项目编号
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
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
from ${iol_schema}.eifs_t05_pub_trade_sign_bk o
    left join ${iol_schema}.eifs_t05_pub_trade_sign_op n
        on
            o.sign_contract_id = n.sign_contract_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t05_pub_trade_sign_cl d
        on
            o.sign_contract_id = d.sign_contract_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t05_pub_trade_sign;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t05_pub_trade_sign') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t05_pub_trade_sign drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t05_pub_trade_sign add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t05_pub_trade_sign exchange partition p_${batch_date} with table ${iol_schema}.eifs_t05_pub_trade_sign_cl;
alter table ${iol_schema}.eifs_t05_pub_trade_sign exchange partition p_20991231 with table ${iol_schema}.eifs_t05_pub_trade_sign_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t05_pub_trade_sign to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t05_pub_trade_sign_op purge;
drop table ${iol_schema}.eifs_t05_pub_trade_sign_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t05_pub_trade_sign_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t05_pub_trade_sign',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
