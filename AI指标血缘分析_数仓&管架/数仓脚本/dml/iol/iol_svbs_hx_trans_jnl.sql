/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_svbs_hx_trans_jnl
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
create table ${iol_schema}.svbs_hx_trans_jnl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.svbs_hx_trans_jnl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svbs_hx_trans_jnl_op purge;
drop table ${iol_schema}.svbs_hx_trans_jnl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svbs_hx_trans_jnl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svbs_hx_trans_jnl where 0=1;

create table ${iol_schema}.svbs_hx_trans_jnl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svbs_hx_trans_jnl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svbs_hx_trans_jnl_cl(
            access_jnl_no -- 流水号
            ,trans_code -- 交码
            ,trans_channel -- 交易渠道
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,id_type -- 证件类型
            ,id_no -- 证件号码
            ,card_type -- 卡类型
            ,card_no -- 卡号
            ,client_id -- 坐席编号
            ,branch_id -- 机构编号
            ,auth_flag -- 是否授权
            ,auth_result -- 授权结果
            ,author_id -- 授权用户编号
            ,cur_step -- 当前步骤
            ,trans_time -- 交易时间
            ,update_time -- 更新时间
            ,trans_status -- 交易状态
            ,trans_msg -- 交易结果
            ,create_user -- 创建用户
            ,update_user -- 更新用户
            ,session_id -- 会话Id
            ,session_id2 -- 会话Id2
            ,session_id3 -- 会话Id3
            ,session_id4 -- 会话Id4
            ,session_id5 -- 会话Id5
            ,session_id6 -- 会话Id6
            ,session_id7 -- 会话Id7
            ,session_id8 -- 会话Id8
            ,session_id9 -- 会话Id9
            ,trans_address -- 交易地址
            ,task_state -- 是否质检  否-0;是-1
            ,longitude -- 经度
            ,latitude -- 维度
            ,trans_city -- 交易城市
            ,trans_city_code -- 城市编码
            ,connect_type -- 流水接通类型，0-未接通，1-已接通
            ,refuse_info -- 未接通的拒绝类型，如黑名单、未满18周岁等
            ,refuse_detail -- 拒绝内容明细
            ,trans_node_status -- 交易节点状态
            ,is_risk_record -- 是否是风险记录
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svbs_hx_trans_jnl_op(
            access_jnl_no -- 流水号
            ,trans_code -- 交码
            ,trans_channel -- 交易渠道
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,id_type -- 证件类型
            ,id_no -- 证件号码
            ,card_type -- 卡类型
            ,card_no -- 卡号
            ,client_id -- 坐席编号
            ,branch_id -- 机构编号
            ,auth_flag -- 是否授权
            ,auth_result -- 授权结果
            ,author_id -- 授权用户编号
            ,cur_step -- 当前步骤
            ,trans_time -- 交易时间
            ,update_time -- 更新时间
            ,trans_status -- 交易状态
            ,trans_msg -- 交易结果
            ,create_user -- 创建用户
            ,update_user -- 更新用户
            ,session_id -- 会话Id
            ,session_id2 -- 会话Id2
            ,session_id3 -- 会话Id3
            ,session_id4 -- 会话Id4
            ,session_id5 -- 会话Id5
            ,session_id6 -- 会话Id6
            ,session_id7 -- 会话Id7
            ,session_id8 -- 会话Id8
            ,session_id9 -- 会话Id9
            ,trans_address -- 交易地址
            ,task_state -- 是否质检  否-0;是-1
            ,longitude -- 经度
            ,latitude -- 维度
            ,trans_city -- 交易城市
            ,trans_city_code -- 城市编码
            ,connect_type -- 流水接通类型，0-未接通，1-已接通
            ,refuse_info -- 未接通的拒绝类型，如黑名单、未满18周岁等
            ,refuse_detail -- 拒绝内容明细
            ,trans_node_status -- 交易节点状态
            ,is_risk_record -- 是否是风险记录
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.access_jnl_no, o.access_jnl_no) as access_jnl_no -- 流水号
    ,nvl(n.trans_code, o.trans_code) as trans_code -- 交码
    ,nvl(n.trans_channel, o.trans_channel) as trans_channel -- 交易渠道
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.id_type, o.id_type) as id_type -- 证件类型
    ,nvl(n.id_no, o.id_no) as id_no -- 证件号码
    ,nvl(n.card_type, o.card_type) as card_type -- 卡类型
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_id, o.client_id) as client_id -- 坐席编号
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 机构编号
    ,nvl(n.auth_flag, o.auth_flag) as auth_flag -- 是否授权
    ,nvl(n.auth_result, o.auth_result) as auth_result -- 授权结果
    ,nvl(n.author_id, o.author_id) as author_id -- 授权用户编号
    ,nvl(n.cur_step, o.cur_step) as cur_step -- 当前步骤
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.trans_status, o.trans_status) as trans_status -- 交易状态
    ,nvl(n.trans_msg, o.trans_msg) as trans_msg -- 交易结果
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户
    ,nvl(n.update_user, o.update_user) as update_user -- 更新用户
    ,nvl(n.session_id, o.session_id) as session_id -- 会话Id
    ,nvl(n.session_id2, o.session_id2) as session_id2 -- 会话Id2
    ,nvl(n.session_id3, o.session_id3) as session_id3 -- 会话Id3
    ,nvl(n.session_id4, o.session_id4) as session_id4 -- 会话Id4
    ,nvl(n.session_id5, o.session_id5) as session_id5 -- 会话Id5
    ,nvl(n.session_id6, o.session_id6) as session_id6 -- 会话Id6
    ,nvl(n.session_id7, o.session_id7) as session_id7 -- 会话Id7
    ,nvl(n.session_id8, o.session_id8) as session_id8 -- 会话Id8
    ,nvl(n.session_id9, o.session_id9) as session_id9 -- 会话Id9
    ,nvl(n.trans_address, o.trans_address) as trans_address -- 交易地址
    ,nvl(n.task_state, o.task_state) as task_state -- 是否质检  否-0;是-1
    ,nvl(n.longitude, o.longitude) as longitude -- 经度
    ,nvl(n.latitude, o.latitude) as latitude -- 维度
    ,nvl(n.trans_city, o.trans_city) as trans_city -- 交易城市
    ,nvl(n.trans_city_code, o.trans_city_code) as trans_city_code -- 城市编码
    ,nvl(n.connect_type, o.connect_type) as connect_type -- 流水接通类型，0-未接通，1-已接通
    ,nvl(n.refuse_info, o.refuse_info) as refuse_info -- 未接通的拒绝类型，如黑名单、未满18周岁等
    ,nvl(n.refuse_detail, o.refuse_detail) as refuse_detail -- 拒绝内容明细
    ,nvl(n.trans_node_status, o.trans_node_status) as trans_node_status -- 交易节点状态
    ,nvl(n.is_risk_record, o.is_risk_record) as is_risk_record -- 是否是风险记录
    ,case when
            n.access_jnl_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.access_jnl_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.access_jnl_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.svbs_hx_trans_jnl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.svbs_hx_trans_jnl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.access_jnl_no = n.access_jnl_no
where (
        o.access_jnl_no is null
    )
    or (
        n.access_jnl_no is null
    )
    or (
        o.trans_code <> n.trans_code
        or o.trans_channel <> n.trans_channel
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.id_type <> n.id_type
        or o.id_no <> n.id_no
        or o.card_type <> n.card_type
        or o.card_no <> n.card_no
        or o.client_id <> n.client_id
        or o.branch_id <> n.branch_id
        or o.auth_flag <> n.auth_flag
        or o.auth_result <> n.auth_result
        or o.author_id <> n.author_id
        or o.cur_step <> n.cur_step
        or o.trans_time <> n.trans_time
        or o.update_time <> n.update_time
        or o.trans_status <> n.trans_status
        or o.trans_msg <> n.trans_msg
        or o.create_user <> n.create_user
        or o.update_user <> n.update_user
        or o.session_id <> n.session_id
        or o.session_id2 <> n.session_id2
        or o.session_id3 <> n.session_id3
        or o.session_id4 <> n.session_id4
        or o.session_id5 <> n.session_id5
        or o.session_id6 <> n.session_id6
        or o.session_id7 <> n.session_id7
        or o.session_id8 <> n.session_id8
        or o.session_id9 <> n.session_id9
        or o.trans_address <> n.trans_address
        or o.task_state <> n.task_state
        or o.longitude <> n.longitude
        or o.latitude <> n.latitude
        or o.trans_city <> n.trans_city
        or o.trans_city_code <> n.trans_city_code
        or o.connect_type <> n.connect_type
        or o.refuse_info <> n.refuse_info
        or o.refuse_detail <> n.refuse_detail
        or o.trans_node_status <> n.trans_node_status
        or o.is_risk_record <> n.is_risk_record
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svbs_hx_trans_jnl_cl(
            access_jnl_no -- 流水号
            ,trans_code -- 交码
            ,trans_channel -- 交易渠道
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,id_type -- 证件类型
            ,id_no -- 证件号码
            ,card_type -- 卡类型
            ,card_no -- 卡号
            ,client_id -- 坐席编号
            ,branch_id -- 机构编号
            ,auth_flag -- 是否授权
            ,auth_result -- 授权结果
            ,author_id -- 授权用户编号
            ,cur_step -- 当前步骤
            ,trans_time -- 交易时间
            ,update_time -- 更新时间
            ,trans_status -- 交易状态
            ,trans_msg -- 交易结果
            ,create_user -- 创建用户
            ,update_user -- 更新用户
            ,session_id -- 会话Id
            ,session_id2 -- 会话Id2
            ,session_id3 -- 会话Id3
            ,session_id4 -- 会话Id4
            ,session_id5 -- 会话Id5
            ,session_id6 -- 会话Id6
            ,session_id7 -- 会话Id7
            ,session_id8 -- 会话Id8
            ,session_id9 -- 会话Id9
            ,trans_address -- 交易地址
            ,task_state -- 是否质检  否-0;是-1
            ,longitude -- 经度
            ,latitude -- 维度
            ,trans_city -- 交易城市
            ,trans_city_code -- 城市编码
            ,connect_type -- 流水接通类型，0-未接通，1-已接通
            ,refuse_info -- 未接通的拒绝类型，如黑名单、未满18周岁等
            ,refuse_detail -- 拒绝内容明细
            ,trans_node_status -- 交易节点状态
            ,is_risk_record -- 是否是风险记录
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svbs_hx_trans_jnl_op(
            access_jnl_no -- 流水号
            ,trans_code -- 交码
            ,trans_channel -- 交易渠道
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,id_type -- 证件类型
            ,id_no -- 证件号码
            ,card_type -- 卡类型
            ,card_no -- 卡号
            ,client_id -- 坐席编号
            ,branch_id -- 机构编号
            ,auth_flag -- 是否授权
            ,auth_result -- 授权结果
            ,author_id -- 授权用户编号
            ,cur_step -- 当前步骤
            ,trans_time -- 交易时间
            ,update_time -- 更新时间
            ,trans_status -- 交易状态
            ,trans_msg -- 交易结果
            ,create_user -- 创建用户
            ,update_user -- 更新用户
            ,session_id -- 会话Id
            ,session_id2 -- 会话Id2
            ,session_id3 -- 会话Id3
            ,session_id4 -- 会话Id4
            ,session_id5 -- 会话Id5
            ,session_id6 -- 会话Id6
            ,session_id7 -- 会话Id7
            ,session_id8 -- 会话Id8
            ,session_id9 -- 会话Id9
            ,trans_address -- 交易地址
            ,task_state -- 是否质检  否-0;是-1
            ,longitude -- 经度
            ,latitude -- 维度
            ,trans_city -- 交易城市
            ,trans_city_code -- 城市编码
            ,connect_type -- 流水接通类型，0-未接通，1-已接通
            ,refuse_info -- 未接通的拒绝类型，如黑名单、未满18周岁等
            ,refuse_detail -- 拒绝内容明细
            ,trans_node_status -- 交易节点状态
            ,is_risk_record -- 是否是风险记录
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.access_jnl_no -- 流水号
    ,o.trans_code -- 交码
    ,o.trans_channel -- 交易渠道
    ,o.cust_no -- 客户号
    ,o.cust_name -- 客户名称
    ,o.id_type -- 证件类型
    ,o.id_no -- 证件号码
    ,o.card_type -- 卡类型
    ,o.card_no -- 卡号
    ,o.client_id -- 坐席编号
    ,o.branch_id -- 机构编号
    ,o.auth_flag -- 是否授权
    ,o.auth_result -- 授权结果
    ,o.author_id -- 授权用户编号
    ,o.cur_step -- 当前步骤
    ,o.trans_time -- 交易时间
    ,o.update_time -- 更新时间
    ,o.trans_status -- 交易状态
    ,o.trans_msg -- 交易结果
    ,o.create_user -- 创建用户
    ,o.update_user -- 更新用户
    ,o.session_id -- 会话Id
    ,o.session_id2 -- 会话Id2
    ,o.session_id3 -- 会话Id3
    ,o.session_id4 -- 会话Id4
    ,o.session_id5 -- 会话Id5
    ,o.session_id6 -- 会话Id6
    ,o.session_id7 -- 会话Id7
    ,o.session_id8 -- 会话Id8
    ,o.session_id9 -- 会话Id9
    ,o.trans_address -- 交易地址
    ,o.task_state -- 是否质检  否-0;是-1
    ,o.longitude -- 经度
    ,o.latitude -- 维度
    ,o.trans_city -- 交易城市
    ,o.trans_city_code -- 城市编码
    ,o.connect_type -- 流水接通类型，0-未接通，1-已接通
    ,o.refuse_info -- 未接通的拒绝类型，如黑名单、未满18周岁等
    ,o.refuse_detail -- 拒绝内容明细
    ,o.trans_node_status -- 交易节点状态
    ,o.is_risk_record -- 是否是风险记录
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
from ${iol_schema}.svbs_hx_trans_jnl_bk o
    left join ${iol_schema}.svbs_hx_trans_jnl_op n
        on
            o.access_jnl_no = n.access_jnl_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.svbs_hx_trans_jnl_cl d
        on
            o.access_jnl_no = d.access_jnl_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.svbs_hx_trans_jnl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('svbs_hx_trans_jnl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.svbs_hx_trans_jnl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.svbs_hx_trans_jnl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.svbs_hx_trans_jnl exchange partition p_${batch_date} with table ${iol_schema}.svbs_hx_trans_jnl_cl;
alter table ${iol_schema}.svbs_hx_trans_jnl exchange partition p_20991231 with table ${iol_schema}.svbs_hx_trans_jnl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.svbs_hx_trans_jnl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svbs_hx_trans_jnl_op purge;
drop table ${iol_schema}.svbs_hx_trans_jnl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.svbs_hx_trans_jnl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'svbs_hx_trans_jnl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
