/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_dpc_draft_status
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
create table ${iol_schema}.bdms_dpc_draft_status_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_dpc_draft_status
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_dpc_draft_status_op purge;
drop table ${iol_schema}.bdms_dpc_draft_status_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_dpc_draft_status_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_dpc_draft_status where 0=1;

create table ${iol_schema}.bdms_dpc_draft_status_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_dpc_draft_status where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_dpc_draft_status_cl(
            id -- 
            ,trans_no -- 交易编号
            ,trans_name -- 交易名称
            ,pre_status -- 前置状态：票据来源_票据状态
            ,store_status -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
            ,risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
            ,reserve -- 备注
            ,create_by -- 
            ,create_time -- 
            ,last_upd_opr -- 
            ,last_upd_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_dpc_draft_status_op(
            id -- 
            ,trans_no -- 交易编号
            ,trans_name -- 交易名称
            ,pre_status -- 前置状态：票据来源_票据状态
            ,store_status -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
            ,risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
            ,reserve -- 备注
            ,create_by -- 
            ,create_time -- 
            ,last_upd_opr -- 
            ,last_upd_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.trans_no, o.trans_no) as trans_no -- 交易编号
    ,nvl(n.trans_name, o.trans_name) as trans_name -- 交易名称
    ,nvl(n.pre_status, o.pre_status) as pre_status -- 前置状态：票据来源_票据状态
    ,nvl(n.store_status, o.store_status) as store_status -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
    ,nvl(n.risk_status, o.risk_status) as risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
    ,nvl(n.settle_flag, o.settle_flag) as settle_flag -- 是否结清： 0 否 1 是
    ,nvl(n.recovery_flag, o.recovery_flag) as recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
    ,nvl(n.reserve, o.reserve) as reserve -- 备注
    ,nvl(n.create_by, o.create_by) as create_by -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_dpc_draft_status_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_dpc_draft_status where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.trans_no <> n.trans_no
        or o.trans_name <> n.trans_name
        or o.pre_status <> n.pre_status
        or o.store_status <> n.store_status
        or o.risk_status <> n.risk_status
        or o.settle_flag <> n.settle_flag
        or o.recovery_flag <> n.recovery_flag
        or o.reserve <> n.reserve
        or o.create_by <> n.create_by
        or o.create_time <> n.create_time
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_dpc_draft_status_cl(
            id -- 
            ,trans_no -- 交易编号
            ,trans_name -- 交易名称
            ,pre_status -- 前置状态：票据来源_票据状态
            ,store_status -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
            ,risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
            ,reserve -- 备注
            ,create_by -- 
            ,create_time -- 
            ,last_upd_opr -- 
            ,last_upd_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_dpc_draft_status_op(
            id -- 
            ,trans_no -- 交易编号
            ,trans_name -- 交易名称
            ,pre_status -- 前置状态：票据来源_票据状态
            ,store_status -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
            ,risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
            ,settle_flag -- 是否结清： 0 否 1 是
            ,recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
            ,reserve -- 备注
            ,create_by -- 
            ,create_time -- 
            ,last_upd_opr -- 
            ,last_upd_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.trans_no -- 交易编号
    ,o.trans_name -- 交易名称
    ,o.pre_status -- 前置状态：票据来源_票据状态
    ,o.store_status -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
    ,o.risk_status -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
    ,o.settle_flag -- 是否结清： 0 否 1 是
    ,o.recovery_flag -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
    ,o.reserve -- 备注
    ,o.create_by -- 
    ,o.create_time -- 
    ,o.last_upd_opr -- 
    ,o.last_upd_time -- 
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
from ${iol_schema}.bdms_dpc_draft_status_bk o
    left join ${iol_schema}.bdms_dpc_draft_status_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_dpc_draft_status_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_dpc_draft_status;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_dpc_draft_status') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_dpc_draft_status drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_dpc_draft_status add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_dpc_draft_status exchange partition p_${batch_date} with table ${iol_schema}.bdms_dpc_draft_status_cl;
alter table ${iol_schema}.bdms_dpc_draft_status exchange partition p_20991231 with table ${iol_schema}.bdms_dpc_draft_status_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_dpc_draft_status to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_dpc_draft_status_op purge;
drop table ${iol_schema}.bdms_dpc_draft_status_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_dpc_draft_status_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_dpc_draft_status',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
