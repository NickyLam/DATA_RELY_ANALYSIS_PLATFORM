/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_albs_bps_dat_risk_state
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
create table ${iol_schema}.albs_bps_dat_risk_state_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.albs_bps_dat_risk_state
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.albs_bps_dat_risk_state_op purge;
drop table ${iol_schema}.albs_bps_dat_risk_state_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_dat_risk_state_op nologging
for exchange with table
${iol_schema}.albs_bps_dat_risk_state;

create table ${iol_schema}.albs_bps_dat_risk_state_cl nologging
for exchange with table
${iol_schema}.albs_bps_dat_risk_state;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.albs_bps_dat_risk_state_cl(
            id -- 表主键
            ,log_id -- 参数日志表ID
            ,own_org -- 归属组织
            ,state_src -- 高危国家来源，如：OFAC
            ,state_code -- 国家缩写(两位简称)
            ,state_name -- 国家名称
            ,user_remark -- 备注
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；A-经办；B-复核；C-授权。
            ,edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
            ,data_enable -- 可用标识：A-初始值；Y-启用；N-停用；D-删除。
            ,crt_date -- 创建日期(YYYYMMDD)
            ,crt_datetime -- 创建时间(YYYYMMDDHHMMSS)
            ,crt_user_id -- 创建用户ID（或名称）
            ,crt_branch_id -- 创建机构ID
            ,last_date -- 最后操作日期(YYYYMMDD)
            ,last_datetime -- 最后操作时间(YYYYMMDDHHMMSS)
            ,last_user_id -- 最后操作用户ID
            ,last_branch_id -- 最后操作用户机构ID
            ,last_txn -- 最后操作交易码
            ,state_name_en -- 英文名称
            ,list_id -- 名单表主键
            ,state_abbreviate -- 国家缩写(三位简称)
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,risk_level -- 高风险国家风险等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.albs_bps_dat_risk_state_op(
            id -- 表主键
            ,log_id -- 参数日志表ID
            ,own_org -- 归属组织
            ,state_src -- 高危国家来源，如：OFAC
            ,state_code -- 国家缩写(两位简称)
            ,state_name -- 国家名称
            ,user_remark -- 备注
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；A-经办；B-复核；C-授权。
            ,edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
            ,data_enable -- 可用标识：A-初始值；Y-启用；N-停用；D-删除。
            ,crt_date -- 创建日期(YYYYMMDD)
            ,crt_datetime -- 创建时间(YYYYMMDDHHMMSS)
            ,crt_user_id -- 创建用户ID（或名称）
            ,crt_branch_id -- 创建机构ID
            ,last_date -- 最后操作日期(YYYYMMDD)
            ,last_datetime -- 最后操作时间(YYYYMMDDHHMMSS)
            ,last_user_id -- 最后操作用户ID
            ,last_branch_id -- 最后操作用户机构ID
            ,last_txn -- 最后操作交易码
            ,state_name_en -- 英文名称
            ,list_id -- 名单表主键
            ,state_abbreviate -- 国家缩写(三位简称)
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,risk_level -- 高风险国家风险等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 表主键
    ,nvl(n.log_id, o.log_id) as log_id -- 参数日志表ID
    ,nvl(n.own_org, o.own_org) as own_org -- 归属组织
    ,nvl(n.state_src, o.state_src) as state_src -- 高危国家来源，如：OFAC
    ,nvl(n.state_code, o.state_code) as state_code -- 国家缩写(两位简称)
    ,nvl(n.state_name, o.state_name) as state_name -- 国家名称
    ,nvl(n.user_remark, o.user_remark) as user_remark -- 备注
    ,nvl(n.oper_type, o.oper_type) as oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；A-经办；B-复核；C-授权。
    ,nvl(n.edit_status, o.edit_status) as edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
    ,nvl(n.data_enable, o.data_enable) as data_enable -- 可用标识：A-初始值；Y-启用；N-停用；D-删除。
    ,nvl(n.crt_date, o.crt_date) as crt_date -- 创建日期(YYYYMMDD)
    ,nvl(n.crt_datetime, o.crt_datetime) as crt_datetime -- 创建时间(YYYYMMDDHHMMSS)
    ,nvl(n.crt_user_id, o.crt_user_id) as crt_user_id -- 创建用户ID（或名称）
    ,nvl(n.crt_branch_id, o.crt_branch_id) as crt_branch_id -- 创建机构ID
    ,nvl(n.last_date, o.last_date) as last_date -- 最后操作日期(YYYYMMDD)
    ,nvl(n.last_datetime, o.last_datetime) as last_datetime -- 最后操作时间(YYYYMMDDHHMMSS)
    ,nvl(n.last_user_id, o.last_user_id) as last_user_id -- 最后操作用户ID
    ,nvl(n.last_branch_id, o.last_branch_id) as last_branch_id -- 最后操作用户机构ID
    ,nvl(n.last_txn, o.last_txn) as last_txn -- 最后操作交易码
    ,nvl(n.state_name_en, o.state_name_en) as state_name_en -- 英文名称
    ,nvl(n.list_id, o.list_id) as list_id -- 名单表主键
    ,nvl(n.state_abbreviate, o.state_abbreviate) as state_abbreviate -- 国家缩写(三位简称)
    ,nvl(n.crt_user_code, o.crt_user_code) as crt_user_code -- 创建用户编号
    ,nvl(n.crt_branch_code, o.crt_branch_code) as crt_branch_code -- 创建机构编号
    ,nvl(n.last_user_code, o.last_user_code) as last_user_code -- 上次操作用户编号
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 高风险国家风险等级
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
from (select * from ${iol_schema}.albs_bps_dat_risk_state_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.albs_bps_dat_risk_state where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.log_id <> n.log_id
        or o.own_org <> n.own_org
        or o.state_src <> n.state_src
        or o.state_code <> n.state_code
        or o.state_name <> n.state_name
        or o.user_remark <> n.user_remark
        or o.oper_type <> n.oper_type
        or o.edit_status <> n.edit_status
        or o.data_enable <> n.data_enable
        or o.crt_date <> n.crt_date
        or o.crt_datetime <> n.crt_datetime
        or o.crt_user_id <> n.crt_user_id
        or o.crt_branch_id <> n.crt_branch_id
        or o.last_date <> n.last_date
        or o.last_datetime <> n.last_datetime
        or o.last_user_id <> n.last_user_id
        or o.last_branch_id <> n.last_branch_id
        or o.last_txn <> n.last_txn
        or o.state_name_en <> n.state_name_en
        or o.list_id <> n.list_id
        or o.state_abbreviate <> n.state_abbreviate
        or o.crt_user_code <> n.crt_user_code
        or o.crt_branch_code <> n.crt_branch_code
        or o.last_user_code <> n.last_user_code
        or o.risk_level <> n.risk_level
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.albs_bps_dat_risk_state_cl(
            id -- 表主键
            ,log_id -- 参数日志表ID
            ,own_org -- 归属组织
            ,state_src -- 高危国家来源，如：OFAC
            ,state_code -- 国家缩写(两位简称)
            ,state_name -- 国家名称
            ,user_remark -- 备注
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；A-经办；B-复核；C-授权。
            ,edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
            ,data_enable -- 可用标识：A-初始值；Y-启用；N-停用；D-删除。
            ,crt_date -- 创建日期(YYYYMMDD)
            ,crt_datetime -- 创建时间(YYYYMMDDHHMMSS)
            ,crt_user_id -- 创建用户ID（或名称）
            ,crt_branch_id -- 创建机构ID
            ,last_date -- 最后操作日期(YYYYMMDD)
            ,last_datetime -- 最后操作时间(YYYYMMDDHHMMSS)
            ,last_user_id -- 最后操作用户ID
            ,last_branch_id -- 最后操作用户机构ID
            ,last_txn -- 最后操作交易码
            ,state_name_en -- 英文名称
            ,list_id -- 名单表主键
            ,state_abbreviate -- 国家缩写(三位简称)
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,risk_level -- 高风险国家风险等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.albs_bps_dat_risk_state_op(
            id -- 表主键
            ,log_id -- 参数日志表ID
            ,own_org -- 归属组织
            ,state_src -- 高危国家来源，如：OFAC
            ,state_code -- 国家缩写(两位简称)
            ,state_name -- 国家名称
            ,user_remark -- 备注
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；A-经办；B-复核；C-授权。
            ,edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
            ,data_enable -- 可用标识：A-初始值；Y-启用；N-停用；D-删除。
            ,crt_date -- 创建日期(YYYYMMDD)
            ,crt_datetime -- 创建时间(YYYYMMDDHHMMSS)
            ,crt_user_id -- 创建用户ID（或名称）
            ,crt_branch_id -- 创建机构ID
            ,last_date -- 最后操作日期(YYYYMMDD)
            ,last_datetime -- 最后操作时间(YYYYMMDDHHMMSS)
            ,last_user_id -- 最后操作用户ID
            ,last_branch_id -- 最后操作用户机构ID
            ,last_txn -- 最后操作交易码
            ,state_name_en -- 英文名称
            ,list_id -- 名单表主键
            ,state_abbreviate -- 国家缩写(三位简称)
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,risk_level -- 高风险国家风险等级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 表主键
    ,o.log_id -- 参数日志表ID
    ,o.own_org -- 归属组织
    ,o.state_src -- 高危国家来源，如：OFAC
    ,o.state_code -- 国家缩写(两位简称)
    ,o.state_name -- 国家名称
    ,o.user_remark -- 备注
    ,o.oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；A-经办；B-复核；C-授权。
    ,o.edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
    ,o.data_enable -- 可用标识：A-初始值；Y-启用；N-停用；D-删除。
    ,o.crt_date -- 创建日期(YYYYMMDD)
    ,o.crt_datetime -- 创建时间(YYYYMMDDHHMMSS)
    ,o.crt_user_id -- 创建用户ID（或名称）
    ,o.crt_branch_id -- 创建机构ID
    ,o.last_date -- 最后操作日期(YYYYMMDD)
    ,o.last_datetime -- 最后操作时间(YYYYMMDDHHMMSS)
    ,o.last_user_id -- 最后操作用户ID
    ,o.last_branch_id -- 最后操作用户机构ID
    ,o.last_txn -- 最后操作交易码
    ,o.state_name_en -- 英文名称
    ,o.list_id -- 名单表主键
    ,o.state_abbreviate -- 国家缩写(三位简称)
    ,o.crt_user_code -- 创建用户编号
    ,o.crt_branch_code -- 创建机构编号
    ,o.last_user_code -- 上次操作用户编号
    ,o.risk_level -- 高风险国家风险等级
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
from ${iol_schema}.albs_bps_dat_risk_state_bk o
    left join ${iol_schema}.albs_bps_dat_risk_state_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.albs_bps_dat_risk_state_cl d
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
--truncate table ${iol_schema}.albs_bps_dat_risk_state;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('albs_bps_dat_risk_state') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.albs_bps_dat_risk_state drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.albs_bps_dat_risk_state add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.albs_bps_dat_risk_state exchange partition p_${batch_date} with table ${iol_schema}.albs_bps_dat_risk_state_cl;
alter table ${iol_schema}.albs_bps_dat_risk_state exchange partition p_20991231 with table ${iol_schema}.albs_bps_dat_risk_state_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.albs_bps_dat_risk_state to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.albs_bps_dat_risk_state_op purge;
drop table ${iol_schema}.albs_bps_dat_risk_state_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.albs_bps_dat_risk_state_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'albs_bps_dat_risk_state',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
