/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_remoteauth_inst_tb
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
create table ${iol_schema}.scps_bp_remoteauth_inst_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_remoteauth_inst_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_remoteauth_inst_tb_op purge;
drop table ${iol_schema}.scps_bp_remoteauth_inst_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_remoteauth_inst_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_remoteauth_inst_tb where 0=1;

create table ${iol_schema}.scps_bp_remoteauth_inst_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_remoteauth_inst_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_remoteauth_inst_tb_cl(
            task_id -- 任务号
            ,doc_id -- 影像批次号
            ,bus_id -- 业务流程定义号
            ,bus_ver -- 业务流程版本号
            ,scene_code -- 业务场景号
            ,organ_no -- 发起机构
            ,start_user_id -- 发起柜员号
            ,start_date -- 发起时间
            ,auth_user -- 授权员
            ,auth_date -- 授权时间
            ,auth_type -- 授权类型
            ,state -- 状态
            ,reason -- 拒绝原因
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,sup_scan -- 补扫信息备注
            ,center_no -- 处理中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_remoteauth_inst_tb_op(
            task_id -- 任务号
            ,doc_id -- 影像批次号
            ,bus_id -- 业务流程定义号
            ,bus_ver -- 业务流程版本号
            ,scene_code -- 业务场景号
            ,organ_no -- 发起机构
            ,start_user_id -- 发起柜员号
            ,start_date -- 发起时间
            ,auth_user -- 授权员
            ,auth_date -- 授权时间
            ,auth_type -- 授权类型
            ,state -- 状态
            ,reason -- 拒绝原因
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,sup_scan -- 补扫信息备注
            ,center_no -- 处理中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 影像批次号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务流程定义号
    ,nvl(n.bus_ver, o.bus_ver) as bus_ver -- 业务流程版本号
    ,nvl(n.scene_code, o.scene_code) as scene_code -- 业务场景号
    ,nvl(n.organ_no, o.organ_no) as organ_no -- 发起机构
    ,nvl(n.start_user_id, o.start_user_id) as start_user_id -- 发起柜员号
    ,nvl(n.start_date, o.start_date) as start_date -- 发起时间
    ,nvl(n.auth_user, o.auth_user) as auth_user -- 授权员
    ,nvl(n.auth_date, o.auth_date) as auth_date -- 授权时间
    ,nvl(n.auth_type, o.auth_type) as auth_type -- 授权类型
    ,nvl(n.state, o.state) as state -- 状态
    ,nvl(n.reason, o.reason) as reason -- 拒绝原因
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行号
    ,nvl(n.system_no, o.system_no) as system_no -- 系统号
    ,nvl(n.sup_scan, o.sup_scan) as sup_scan -- 补扫信息备注
    ,nvl(n.center_no, o.center_no) as center_no -- 处理中心
    ,case when
            n.task_id is null
            and n.auth_type is null
            and n.bank_no is null
            and n.system_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.task_id is null
            and n.auth_type is null
            and n.bank_no is null
            and n.system_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.task_id is null
            and n.auth_type is null
            and n.bank_no is null
            and n.system_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_remoteauth_inst_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_remoteauth_inst_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.task_id = n.task_id
            and o.auth_type = n.auth_type
            and o.bank_no = n.bank_no
            and o.system_no = n.system_no
where (
        o.task_id is null
        and o.auth_type is null
        and o.bank_no is null
        and o.system_no is null
    )
    or (
        n.task_id is null
        and n.auth_type is null
        and n.bank_no is null
        and n.system_no is null
    )
    or (
        o.doc_id <> n.doc_id
        or o.bus_id <> n.bus_id
        or o.bus_ver <> n.bus_ver
        or o.scene_code <> n.scene_code
        or o.organ_no <> n.organ_no
        or o.start_user_id <> n.start_user_id
        or o.start_date <> n.start_date
        or o.auth_user <> n.auth_user
        or o.auth_date <> n.auth_date
        or o.state <> n.state
        or o.reason <> n.reason
        or o.sup_scan <> n.sup_scan
        or o.center_no <> n.center_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_remoteauth_inst_tb_cl(
            task_id -- 任务号
            ,doc_id -- 影像批次号
            ,bus_id -- 业务流程定义号
            ,bus_ver -- 业务流程版本号
            ,scene_code -- 业务场景号
            ,organ_no -- 发起机构
            ,start_user_id -- 发起柜员号
            ,start_date -- 发起时间
            ,auth_user -- 授权员
            ,auth_date -- 授权时间
            ,auth_type -- 授权类型
            ,state -- 状态
            ,reason -- 拒绝原因
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,sup_scan -- 补扫信息备注
            ,center_no -- 处理中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_remoteauth_inst_tb_op(
            task_id -- 任务号
            ,doc_id -- 影像批次号
            ,bus_id -- 业务流程定义号
            ,bus_ver -- 业务流程版本号
            ,scene_code -- 业务场景号
            ,organ_no -- 发起机构
            ,start_user_id -- 发起柜员号
            ,start_date -- 发起时间
            ,auth_user -- 授权员
            ,auth_date -- 授权时间
            ,auth_type -- 授权类型
            ,state -- 状态
            ,reason -- 拒绝原因
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,sup_scan -- 补扫信息备注
            ,center_no -- 处理中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_id -- 任务号
    ,o.doc_id -- 影像批次号
    ,o.bus_id -- 业务流程定义号
    ,o.bus_ver -- 业务流程版本号
    ,o.scene_code -- 业务场景号
    ,o.organ_no -- 发起机构
    ,o.start_user_id -- 发起柜员号
    ,o.start_date -- 发起时间
    ,o.auth_user -- 授权员
    ,o.auth_date -- 授权时间
    ,o.auth_type -- 授权类型
    ,o.state -- 状态
    ,o.reason -- 拒绝原因
    ,o.bank_no -- 银行号
    ,o.system_no -- 系统号
    ,o.sup_scan -- 补扫信息备注
    ,o.center_no -- 处理中心
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
from ${iol_schema}.scps_bp_remoteauth_inst_tb_bk o
    left join ${iol_schema}.scps_bp_remoteauth_inst_tb_op n
        on
            o.task_id = n.task_id
            and o.auth_type = n.auth_type
            and o.bank_no = n.bank_no
            and o.system_no = n.system_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_remoteauth_inst_tb_cl d
        on
            o.task_id = d.task_id
            and o.auth_type = d.auth_type
            and o.bank_no = d.bank_no
            and o.system_no = d.system_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_remoteauth_inst_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_remoteauth_inst_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_remoteauth_inst_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_remoteauth_inst_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_remoteauth_inst_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_remoteauth_inst_tb_cl;
alter table ${iol_schema}.scps_bp_remoteauth_inst_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_remoteauth_inst_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_remoteauth_inst_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_remoteauth_inst_tb_op purge;
drop table ${iol_schema}.scps_bp_remoteauth_inst_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_remoteauth_inst_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_remoteauth_inst_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
