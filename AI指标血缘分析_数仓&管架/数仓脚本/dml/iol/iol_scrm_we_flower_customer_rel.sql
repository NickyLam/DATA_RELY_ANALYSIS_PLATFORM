/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scrm_we_flower_customer_rel
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
create table ${iol_schema}.scrm_we_flower_customer_rel_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scrm_we_flower_customer_rel
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scrm_we_flower_customer_rel_op purge;
drop table ${iol_schema}.scrm_we_flower_customer_rel_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_we_flower_customer_rel_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scrm_we_flower_customer_rel where 0=1;

create table ${iol_schema}.scrm_we_flower_customer_rel_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scrm_we_flower_customer_rel where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scrm_we_flower_customer_rel_cl(
            id -- 
            ,user_id -- 客户经理id
            ,qw_user_id -- 客户经理企微userId
            ,external_userid -- 客户id
            ,oper_userid -- 发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid
            ,remark -- 客户备注（该成员对此外部联系人的备注）
            ,descript -- 描述（该成员对此外部联系人的描述）
            ,remark_corp_name -- 该成员对此客户备注的企业名称
            ,remark_mobiles -- 客户手机号（该成员对此客户备注的手机号码）
            ,add_way -- 客户来源（该成员添加此客户的来源）
            ,state -- 企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定
            ,is_open_chat -- 是否开启会话存档0：关闭1：开启
            ,crm_contr_id -- 行内联系人id（crm）
            ,crm_contr_nm -- 行内联系人姓名（crm）
            ,corp_id -- 
            ,status -- 状态（1正常 0停用）
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,last_modi_by -- 最后修改人
            ,last_modi_time -- 最后修改时间
            ,is_have_xing -- 是否有星标
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scrm_we_flower_customer_rel_op(
            id -- 
            ,user_id -- 客户经理id
            ,qw_user_id -- 客户经理企微userId
            ,external_userid -- 客户id
            ,oper_userid -- 发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid
            ,remark -- 客户备注（该成员对此外部联系人的备注）
            ,descript -- 描述（该成员对此外部联系人的描述）
            ,remark_corp_name -- 该成员对此客户备注的企业名称
            ,remark_mobiles -- 客户手机号（该成员对此客户备注的手机号码）
            ,add_way -- 客户来源（该成员添加此客户的来源）
            ,state -- 企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定
            ,is_open_chat -- 是否开启会话存档0：关闭1：开启
            ,crm_contr_id -- 行内联系人id（crm）
            ,crm_contr_nm -- 行内联系人姓名（crm）
            ,corp_id -- 
            ,status -- 状态（1正常 0停用）
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,last_modi_by -- 最后修改人
            ,last_modi_time -- 最后修改时间
            ,is_have_xing -- 是否有星标
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.user_id, o.user_id) as user_id -- 客户经理id
    ,nvl(n.qw_user_id, o.qw_user_id) as qw_user_id -- 客户经理企微userId
    ,nvl(n.external_userid, o.external_userid) as external_userid -- 客户id
    ,nvl(n.oper_userid, o.oper_userid) as oper_userid -- 发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid
    ,nvl(n.remark, o.remark) as remark -- 客户备注（该成员对此外部联系人的备注）
    ,nvl(n.descript, o.descript) as descript -- 描述（该成员对此外部联系人的描述）
    ,nvl(n.remark_corp_name, o.remark_corp_name) as remark_corp_name -- 该成员对此客户备注的企业名称
    ,nvl(n.remark_mobiles, o.remark_mobiles) as remark_mobiles -- 客户手机号（该成员对此客户备注的手机号码）
    ,nvl(n.add_way, o.add_way) as add_way -- 客户来源（该成员添加此客户的来源）
    ,nvl(n.state, o.state) as state -- 企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定
    ,nvl(n.is_open_chat, o.is_open_chat) as is_open_chat -- 是否开启会话存档0：关闭1：开启
    ,nvl(n.crm_contr_id, o.crm_contr_id) as crm_contr_id -- 行内联系人id（crm）
    ,nvl(n.crm_contr_nm, o.crm_contr_nm) as crm_contr_nm -- 行内联系人姓名（crm）
    ,nvl(n.corp_id, o.corp_id) as corp_id -- 
    ,nvl(n.status, o.status) as status -- 状态（1正常 0停用）
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.last_modi_by, o.last_modi_by) as last_modi_by -- 最后修改人
    ,nvl(n.last_modi_time, o.last_modi_time) as last_modi_time -- 最后修改时间
    ,nvl(n.is_have_xing, o.is_have_xing) as is_have_xing -- 是否有星标
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
from (select * from ${iol_schema}.scrm_we_flower_customer_rel_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scrm_we_flower_customer_rel where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.user_id <> n.user_id
        or o.qw_user_id <> n.qw_user_id
        or o.external_userid <> n.external_userid
        or o.oper_userid <> n.oper_userid
        or o.remark <> n.remark
        or o.descript <> n.descript
        or o.remark_corp_name <> n.remark_corp_name
        or o.remark_mobiles <> n.remark_mobiles
        or o.add_way <> n.add_way
        or o.state <> n.state
        or o.is_open_chat <> n.is_open_chat
        or o.crm_contr_id <> n.crm_contr_id
        or o.crm_contr_nm <> n.crm_contr_nm
        or o.corp_id <> n.corp_id
        or o.status <> n.status
        or o.create_by <> n.create_by
        or o.create_time <> n.create_time
        or o.last_modi_by <> n.last_modi_by
        or o.last_modi_time <> n.last_modi_time
        or o.is_have_xing <> n.is_have_xing
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scrm_we_flower_customer_rel_cl(
            id -- 
            ,user_id -- 客户经理id
            ,qw_user_id -- 客户经理企微userId
            ,external_userid -- 客户id
            ,oper_userid -- 发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid
            ,remark -- 客户备注（该成员对此外部联系人的备注）
            ,descript -- 描述（该成员对此外部联系人的描述）
            ,remark_corp_name -- 该成员对此客户备注的企业名称
            ,remark_mobiles -- 客户手机号（该成员对此客户备注的手机号码）
            ,add_way -- 客户来源（该成员添加此客户的来源）
            ,state -- 企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定
            ,is_open_chat -- 是否开启会话存档0：关闭1：开启
            ,crm_contr_id -- 行内联系人id（crm）
            ,crm_contr_nm -- 行内联系人姓名（crm）
            ,corp_id -- 
            ,status -- 状态（1正常 0停用）
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,last_modi_by -- 最后修改人
            ,last_modi_time -- 最后修改时间
            ,is_have_xing -- 是否有星标
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scrm_we_flower_customer_rel_op(
            id -- 
            ,user_id -- 客户经理id
            ,qw_user_id -- 客户经理企微userId
            ,external_userid -- 客户id
            ,oper_userid -- 发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid
            ,remark -- 客户备注（该成员对此外部联系人的备注）
            ,descript -- 描述（该成员对此外部联系人的描述）
            ,remark_corp_name -- 该成员对此客户备注的企业名称
            ,remark_mobiles -- 客户手机号（该成员对此客户备注的手机号码）
            ,add_way -- 客户来源（该成员添加此客户的来源）
            ,state -- 企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定
            ,is_open_chat -- 是否开启会话存档0：关闭1：开启
            ,crm_contr_id -- 行内联系人id（crm）
            ,crm_contr_nm -- 行内联系人姓名（crm）
            ,corp_id -- 
            ,status -- 状态（1正常 0停用）
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,last_modi_by -- 最后修改人
            ,last_modi_time -- 最后修改时间
            ,is_have_xing -- 是否有星标
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.user_id -- 客户经理id
    ,o.qw_user_id -- 客户经理企微userId
    ,o.external_userid -- 客户id
    ,o.oper_userid -- 发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid
    ,o.remark -- 客户备注（该成员对此外部联系人的备注）
    ,o.descript -- 描述（该成员对此外部联系人的描述）
    ,o.remark_corp_name -- 该成员对此客户备注的企业名称
    ,o.remark_mobiles -- 客户手机号（该成员对此客户备注的手机号码）
    ,o.add_way -- 客户来源（该成员添加此客户的来源）
    ,o.state -- 企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定
    ,o.is_open_chat -- 是否开启会话存档0：关闭1：开启
    ,o.crm_contr_id -- 行内联系人id（crm）
    ,o.crm_contr_nm -- 行内联系人姓名（crm）
    ,o.corp_id -- 
    ,o.status -- 状态（1正常 0停用）
    ,o.create_by -- 创建人
    ,o.create_time -- 创建时间
    ,o.last_modi_by -- 最后修改人
    ,o.last_modi_time -- 最后修改时间
    ,o.is_have_xing -- 是否有星标
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
from ${iol_schema}.scrm_we_flower_customer_rel_bk o
    left join ${iol_schema}.scrm_we_flower_customer_rel_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scrm_we_flower_customer_rel_cl d
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
--truncate table ${iol_schema}.scrm_we_flower_customer_rel;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scrm_we_flower_customer_rel') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scrm_we_flower_customer_rel drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scrm_we_flower_customer_rel add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scrm_we_flower_customer_rel exchange partition p_${batch_date} with table ${iol_schema}.scrm_we_flower_customer_rel_cl;
alter table ${iol_schema}.scrm_we_flower_customer_rel exchange partition p_20991231 with table ${iol_schema}.scrm_we_flower_customer_rel_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scrm_we_flower_customer_rel to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scrm_we_flower_customer_rel_op purge;
drop table ${iol_schema}.scrm_we_flower_customer_rel_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scrm_we_flower_customer_rel_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scrm_we_flower_customer_rel',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
