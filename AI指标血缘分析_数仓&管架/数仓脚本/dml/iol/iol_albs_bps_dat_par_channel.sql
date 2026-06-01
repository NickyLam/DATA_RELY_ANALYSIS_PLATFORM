/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_albs_bps_dat_par_channel
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
create table ${iol_schema}.albs_bps_dat_par_channel_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.albs_bps_dat_par_channel
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.albs_bps_dat_par_channel_op purge;
drop table ${iol_schema}.albs_bps_dat_par_channel_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_dat_par_channel_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.albs_bps_dat_par_channel where 0=1;

create table ${iol_schema}.albs_bps_dat_par_channel_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.albs_bps_dat_par_channel where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.albs_bps_dat_par_channel_cl(
            id -- 表主键
            ,own_org -- 归属组织
            ,list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
            ,chnl_code -- 渠道代码
            ,chnl_name -- 渠道名称
            ,file_charset -- 文件字符集
            ,file_type_code -- 文件路径类型编码
            ,imp_bean -- 数据导入bean（在枚举表中定义选择）
            ,user_remark -- 备注
            ,log_id -- 参数日志表id
            ,sys_def_flag -- 系统定义标志：1-系统定义，不可修改；0-用户定义，可修改。
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
            ,edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
            ,data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
            ,crt_datetime -- 创建时间(yyyymmddhhmmss)
            ,crt_user_id -- 创建用户id（或名称）
            ,crt_branch_id -- 创建机构id
            ,last_datetime -- 最后操作时间(yyyymmddhhmmss)
            ,last_user_id -- 最后操作用户id
            ,last_branch_id -- 最后操作用户机构id
            ,last_txn -- 最后操作交易码
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,risk_level -- 风险等级编号
            ,deal_opinion -- 处置手段
            ,chnl_src -- 
            ,chnl_provider -- 
            ,chnl_manager -- 
            ,chnl_maintain -- 
            ,chnl_update_time -- 
            ,chnl_desc -- 
            ,file_path -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.albs_bps_dat_par_channel_op(
            id -- 表主键
            ,own_org -- 归属组织
            ,list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
            ,chnl_code -- 渠道代码
            ,chnl_name -- 渠道名称
            ,file_charset -- 文件字符集
            ,file_type_code -- 文件路径类型编码
            ,imp_bean -- 数据导入bean（在枚举表中定义选择）
            ,user_remark -- 备注
            ,log_id -- 参数日志表id
            ,sys_def_flag -- 系统定义标志：1-系统定义，不可修改；0-用户定义，可修改。
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
            ,edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
            ,data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
            ,crt_datetime -- 创建时间(yyyymmddhhmmss)
            ,crt_user_id -- 创建用户id（或名称）
            ,crt_branch_id -- 创建机构id
            ,last_datetime -- 最后操作时间(yyyymmddhhmmss)
            ,last_user_id -- 最后操作用户id
            ,last_branch_id -- 最后操作用户机构id
            ,last_txn -- 最后操作交易码
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,risk_level -- 风险等级编号
            ,deal_opinion -- 处置手段
            ,chnl_src -- 
            ,chnl_provider -- 
            ,chnl_manager -- 
            ,chnl_maintain -- 
            ,chnl_update_time -- 
            ,chnl_desc -- 
            ,file_path -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 表主键
    ,nvl(n.own_org, o.own_org) as own_org -- 归属组织
    ,nvl(n.list_kind, o.list_kind) as list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
    ,nvl(n.chnl_code, o.chnl_code) as chnl_code -- 渠道代码
    ,nvl(n.chnl_name, o.chnl_name) as chnl_name -- 渠道名称
    ,nvl(n.file_charset, o.file_charset) as file_charset -- 文件字符集
    ,nvl(n.file_type_code, o.file_type_code) as file_type_code -- 文件路径类型编码
    ,nvl(n.imp_bean, o.imp_bean) as imp_bean -- 数据导入bean（在枚举表中定义选择）
    ,nvl(n.user_remark, o.user_remark) as user_remark -- 备注
    ,nvl(n.log_id, o.log_id) as log_id -- 参数日志表id
    ,nvl(n.sys_def_flag, o.sys_def_flag) as sys_def_flag -- 系统定义标志：1-系统定义，不可修改；0-用户定义，可修改。
    ,nvl(n.oper_type, o.oper_type) as oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
    ,nvl(n.edit_status, o.edit_status) as edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
    ,nvl(n.data_enable, o.data_enable) as data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
    ,nvl(n.crt_datetime, o.crt_datetime) as crt_datetime -- 创建时间(yyyymmddhhmmss)
    ,nvl(n.crt_user_id, o.crt_user_id) as crt_user_id -- 创建用户id（或名称）
    ,nvl(n.crt_branch_id, o.crt_branch_id) as crt_branch_id -- 创建机构id
    ,nvl(n.last_datetime, o.last_datetime) as last_datetime -- 最后操作时间(yyyymmddhhmmss)
    ,nvl(n.last_user_id, o.last_user_id) as last_user_id -- 最后操作用户id
    ,nvl(n.last_branch_id, o.last_branch_id) as last_branch_id -- 最后操作用户机构id
    ,nvl(n.last_txn, o.last_txn) as last_txn -- 最后操作交易码
    ,nvl(n.crt_user_code, o.crt_user_code) as crt_user_code -- 创建用户编号
    ,nvl(n.crt_branch_code, o.crt_branch_code) as crt_branch_code -- 创建机构编号
    ,nvl(n.last_user_code, o.last_user_code) as last_user_code -- 上次操作用户编号
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险等级编号
    ,nvl(n.deal_opinion, o.deal_opinion) as deal_opinion -- 处置手段
    ,nvl(n.chnl_src, o.chnl_src) as chnl_src -- 
    ,nvl(n.chnl_provider, o.chnl_provider) as chnl_provider -- 
    ,nvl(n.chnl_manager, o.chnl_manager) as chnl_manager -- 
    ,nvl(n.chnl_maintain, o.chnl_maintain) as chnl_maintain -- 
    ,nvl(n.chnl_update_time, o.chnl_update_time) as chnl_update_time -- 
    ,nvl(n.chnl_desc, o.chnl_desc) as chnl_desc -- 
    ,nvl(n.file_path, o.file_path) as file_path -- 
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
from (select * from ${iol_schema}.albs_bps_dat_par_channel_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.albs_bps_dat_par_channel where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.own_org <> n.own_org
        or o.list_kind <> n.list_kind
        or o.chnl_code <> n.chnl_code
        or o.chnl_name <> n.chnl_name
        or o.file_charset <> n.file_charset
        or o.file_type_code <> n.file_type_code
        or o.imp_bean <> n.imp_bean
        or o.user_remark <> n.user_remark
        or o.log_id <> n.log_id
        or o.sys_def_flag <> n.sys_def_flag
        or o.oper_type <> n.oper_type
        or o.edit_status <> n.edit_status
        or o.data_enable <> n.data_enable
        or o.crt_datetime <> n.crt_datetime
        or o.crt_user_id <> n.crt_user_id
        or o.crt_branch_id <> n.crt_branch_id
        or o.last_datetime <> n.last_datetime
        or o.last_user_id <> n.last_user_id
        or o.last_branch_id <> n.last_branch_id
        or o.last_txn <> n.last_txn
        or o.crt_user_code <> n.crt_user_code
        or o.crt_branch_code <> n.crt_branch_code
        or o.last_user_code <> n.last_user_code
        or o.risk_level <> n.risk_level
        or o.deal_opinion <> n.deal_opinion
        or o.chnl_src <> n.chnl_src
        or o.chnl_provider <> n.chnl_provider
        or o.chnl_manager <> n.chnl_manager
        or o.chnl_maintain <> n.chnl_maintain
        or o.chnl_update_time <> n.chnl_update_time
        or o.chnl_desc <> n.chnl_desc
        or o.file_path <> n.file_path
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.albs_bps_dat_par_channel_cl(
            id -- 表主键
            ,own_org -- 归属组织
            ,list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
            ,chnl_code -- 渠道代码
            ,chnl_name -- 渠道名称
            ,file_charset -- 文件字符集
            ,file_type_code -- 文件路径类型编码
            ,imp_bean -- 数据导入bean（在枚举表中定义选择）
            ,user_remark -- 备注
            ,log_id -- 参数日志表id
            ,sys_def_flag -- 系统定义标志：1-系统定义，不可修改；0-用户定义，可修改。
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
            ,edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
            ,data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
            ,crt_datetime -- 创建时间(yyyymmddhhmmss)
            ,crt_user_id -- 创建用户id（或名称）
            ,crt_branch_id -- 创建机构id
            ,last_datetime -- 最后操作时间(yyyymmddhhmmss)
            ,last_user_id -- 最后操作用户id
            ,last_branch_id -- 最后操作用户机构id
            ,last_txn -- 最后操作交易码
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,risk_level -- 风险等级编号
            ,deal_opinion -- 处置手段
            ,chnl_src -- 
            ,chnl_provider -- 
            ,chnl_manager -- 
            ,chnl_maintain -- 
            ,chnl_update_time -- 
            ,chnl_desc -- 
            ,file_path -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.albs_bps_dat_par_channel_op(
            id -- 表主键
            ,own_org -- 归属组织
            ,list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
            ,chnl_code -- 渠道代码
            ,chnl_name -- 渠道名称
            ,file_charset -- 文件字符集
            ,file_type_code -- 文件路径类型编码
            ,imp_bean -- 数据导入bean（在枚举表中定义选择）
            ,user_remark -- 备注
            ,log_id -- 参数日志表id
            ,sys_def_flag -- 系统定义标志：1-系统定义，不可修改；0-用户定义，可修改。
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
            ,edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
            ,data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
            ,crt_datetime -- 创建时间(yyyymmddhhmmss)
            ,crt_user_id -- 创建用户id（或名称）
            ,crt_branch_id -- 创建机构id
            ,last_datetime -- 最后操作时间(yyyymmddhhmmss)
            ,last_user_id -- 最后操作用户id
            ,last_branch_id -- 最后操作用户机构id
            ,last_txn -- 最后操作交易码
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,risk_level -- 风险等级编号
            ,deal_opinion -- 处置手段
            ,chnl_src -- 
            ,chnl_provider -- 
            ,chnl_manager -- 
            ,chnl_maintain -- 
            ,chnl_update_time -- 
            ,chnl_desc -- 
            ,file_path -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 表主键
    ,o.own_org -- 归属组织
    ,o.list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
    ,o.chnl_code -- 渠道代码
    ,o.chnl_name -- 渠道名称
    ,o.file_charset -- 文件字符集
    ,o.file_type_code -- 文件路径类型编码
    ,o.imp_bean -- 数据导入bean（在枚举表中定义选择）
    ,o.user_remark -- 备注
    ,o.log_id -- 参数日志表id
    ,o.sys_def_flag -- 系统定义标志：1-系统定义，不可修改；0-用户定义，可修改。
    ,o.oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
    ,o.edit_status -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
    ,o.data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
    ,o.crt_datetime -- 创建时间(yyyymmddhhmmss)
    ,o.crt_user_id -- 创建用户id（或名称）
    ,o.crt_branch_id -- 创建机构id
    ,o.last_datetime -- 最后操作时间(yyyymmddhhmmss)
    ,o.last_user_id -- 最后操作用户id
    ,o.last_branch_id -- 最后操作用户机构id
    ,o.last_txn -- 最后操作交易码
    ,o.crt_user_code -- 创建用户编号
    ,o.crt_branch_code -- 创建机构编号
    ,o.last_user_code -- 上次操作用户编号
    ,o.risk_level -- 风险等级编号
    ,o.deal_opinion -- 处置手段
    ,o.chnl_src -- 
    ,o.chnl_provider -- 
    ,o.chnl_manager -- 
    ,o.chnl_maintain -- 
    ,o.chnl_update_time -- 
    ,o.chnl_desc -- 
    ,o.file_path -- 
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
from ${iol_schema}.albs_bps_dat_par_channel_bk o
    left join ${iol_schema}.albs_bps_dat_par_channel_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.albs_bps_dat_par_channel_cl d
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
--truncate table ${iol_schema}.albs_bps_dat_par_channel;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('albs_bps_dat_par_channel') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.albs_bps_dat_par_channel drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.albs_bps_dat_par_channel add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.albs_bps_dat_par_channel exchange partition p_${batch_date} with table ${iol_schema}.albs_bps_dat_par_channel_cl;
alter table ${iol_schema}.albs_bps_dat_par_channel exchange partition p_20991231 with table ${iol_schema}.albs_bps_dat_par_channel_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.albs_bps_dat_par_channel to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.albs_bps_dat_par_channel_op purge;
drop table ${iol_schema}.albs_bps_dat_par_channel_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.albs_bps_dat_par_channel_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'albs_bps_dat_par_channel',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
