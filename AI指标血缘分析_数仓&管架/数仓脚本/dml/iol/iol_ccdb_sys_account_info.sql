/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_sys_account_info
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
create table ${iol_schema}.ccdb_sys_account_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccdb_sys_account_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_sys_account_info_op purge;
drop table ${iol_schema}.ccdb_sys_account_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_sys_account_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_sys_account_info where 0=1;

create table ${iol_schema}.ccdb_sys_account_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccdb_sys_account_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_sys_account_info_cl(
            status -- 状态
            ,password -- 登录密码
            ,create_date -- 创建日期
            ,update_date -- 修改日期
            ,agent_id -- agentid
            ,business_group_code -- 业务组编号（参数配置）
            ,account_code -- 用户账号
            ,emp_code -- 员工编号
            ,skill_group_code -- 技能组编号（参数配置）
            ,pwd_lapse_date -- 密码过期时间
            ,creater_code -- 创建者工号
            ,update_code -- 更新者工号
            ,operator_type_code -- 用户类型编码（参数配置）
            ,account_lock -- 锁定用户 0:locked  1:unlock
            ,aworksts -- 工作状态
            ,tsworkststime -- 工作状态开始时间
            ,login_num -- 是否首次登录 (新建用户初始值为1)
            ,reset_password_flag -- 是否重置密码 (0:未重置  1:重置)新增用户为1
            ,lock_num -- 登陆失败次数
            ,lock_time -- 登陆时间
            ,login_server -- 签入地址(priserver 代表主中心 bakserver 备中心)
            ,media_type -- 多媒体类型（chat代表在线video视频media多媒体）
            ,media_pic -- 视频客服不开摄像头背景图
            ,tone_switch -- 在线客服铃声提醒开关
            ,pro_bank_tone_switch -- 流程银行提示音提醒开关
            ,softphone_type -- 软电话类型（websocket/applet:接入方式为websocket/applet）
            ,tracking_remind_tone_switch -- 小结继续跟进提示音提醒开关
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_sys_account_info_op(
            status -- 状态
            ,password -- 登录密码
            ,create_date -- 创建日期
            ,update_date -- 修改日期
            ,agent_id -- agentid
            ,business_group_code -- 业务组编号（参数配置）
            ,account_code -- 用户账号
            ,emp_code -- 员工编号
            ,skill_group_code -- 技能组编号（参数配置）
            ,pwd_lapse_date -- 密码过期时间
            ,creater_code -- 创建者工号
            ,update_code -- 更新者工号
            ,operator_type_code -- 用户类型编码（参数配置）
            ,account_lock -- 锁定用户 0:locked  1:unlock
            ,aworksts -- 工作状态
            ,tsworkststime -- 工作状态开始时间
            ,login_num -- 是否首次登录 (新建用户初始值为1)
            ,reset_password_flag -- 是否重置密码 (0:未重置  1:重置)新增用户为1
            ,lock_num -- 登陆失败次数
            ,lock_time -- 登陆时间
            ,login_server -- 签入地址(priserver 代表主中心 bakserver 备中心)
            ,media_type -- 多媒体类型（chat代表在线video视频media多媒体）
            ,media_pic -- 视频客服不开摄像头背景图
            ,tone_switch -- 在线客服铃声提醒开关
            ,pro_bank_tone_switch -- 流程银行提示音提醒开关
            ,softphone_type -- 软电话类型（websocket/applet:接入方式为websocket/applet）
            ,tracking_remind_tone_switch -- 小结继续跟进提示音提醒开关
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.status, o.status) as status -- 状态
    ,nvl(n.password, o.password) as password -- 登录密码
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.update_date, o.update_date) as update_date -- 修改日期
    ,nvl(n.agent_id, o.agent_id) as agent_id -- agentid
    ,nvl(n.business_group_code, o.business_group_code) as business_group_code -- 业务组编号（参数配置）
    ,nvl(n.account_code, o.account_code) as account_code -- 用户账号
    ,nvl(n.emp_code, o.emp_code) as emp_code -- 员工编号
    ,nvl(n.skill_group_code, o.skill_group_code) as skill_group_code -- 技能组编号（参数配置）
    ,nvl(n.pwd_lapse_date, o.pwd_lapse_date) as pwd_lapse_date -- 密码过期时间
    ,nvl(n.creater_code, o.creater_code) as creater_code -- 创建者工号
    ,nvl(n.update_code, o.update_code) as update_code -- 更新者工号
    ,nvl(n.operator_type_code, o.operator_type_code) as operator_type_code -- 用户类型编码（参数配置）
    ,nvl(n.account_lock, o.account_lock) as account_lock -- 锁定用户 0:locked  1:unlock
    ,nvl(n.aworksts, o.aworksts) as aworksts -- 工作状态
    ,nvl(n.tsworkststime, o.tsworkststime) as tsworkststime -- 工作状态开始时间
    ,nvl(n.login_num, o.login_num) as login_num -- 是否首次登录 (新建用户初始值为1)
    ,nvl(n.reset_password_flag, o.reset_password_flag) as reset_password_flag -- 是否重置密码 (0:未重置  1:重置)新增用户为1
    ,nvl(n.lock_num, o.lock_num) as lock_num -- 登陆失败次数
    ,nvl(n.lock_time, o.lock_time) as lock_time -- 登陆时间
    ,nvl(n.login_server, o.login_server) as login_server -- 签入地址(priserver 代表主中心 bakserver 备中心)
    ,nvl(n.media_type, o.media_type) as media_type -- 多媒体类型（chat代表在线video视频media多媒体）
    ,nvl(n.media_pic, o.media_pic) as media_pic -- 视频客服不开摄像头背景图
    ,nvl(n.tone_switch, o.tone_switch) as tone_switch -- 在线客服铃声提醒开关
    ,nvl(n.pro_bank_tone_switch, o.pro_bank_tone_switch) as pro_bank_tone_switch -- 流程银行提示音提醒开关
    ,nvl(n.softphone_type, o.softphone_type) as softphone_type -- 软电话类型（websocket/applet:接入方式为websocket/applet）
    ,nvl(n.tracking_remind_tone_switch, o.tracking_remind_tone_switch) as tracking_remind_tone_switch -- 小结继续跟进提示音提醒开关
    ,case when
            n.account_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.account_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.account_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccdb_sys_account_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ccdb_sys_account_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.account_code = n.account_code
where (
        o.account_code is null
    )
    or (
        n.account_code is null
    )
    or (
        o.status <> n.status
        or o.password <> n.password
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.agent_id <> n.agent_id
        or o.business_group_code <> n.business_group_code
        or o.emp_code <> n.emp_code
        or o.skill_group_code <> n.skill_group_code
        or o.pwd_lapse_date <> n.pwd_lapse_date
        or o.creater_code <> n.creater_code
        or o.update_code <> n.update_code
        or o.operator_type_code <> n.operator_type_code
        or o.account_lock <> n.account_lock
        or o.aworksts <> n.aworksts
        or o.tsworkststime <> n.tsworkststime
        or o.login_num <> n.login_num
        or o.reset_password_flag <> n.reset_password_flag
        or o.lock_num <> n.lock_num
        or o.lock_time <> n.lock_time
        or o.login_server <> n.login_server
        or o.media_type <> n.media_type
        or o.media_pic <> n.media_pic
        or o.tone_switch <> n.tone_switch
        or o.pro_bank_tone_switch <> n.pro_bank_tone_switch
        or o.softphone_type <> n.softphone_type
        or o.tracking_remind_tone_switch <> n.tracking_remind_tone_switch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_sys_account_info_cl(
            status -- 状态
            ,password -- 登录密码
            ,create_date -- 创建日期
            ,update_date -- 修改日期
            ,agent_id -- agentid
            ,business_group_code -- 业务组编号（参数配置）
            ,account_code -- 用户账号
            ,emp_code -- 员工编号
            ,skill_group_code -- 技能组编号（参数配置）
            ,pwd_lapse_date -- 密码过期时间
            ,creater_code -- 创建者工号
            ,update_code -- 更新者工号
            ,operator_type_code -- 用户类型编码（参数配置）
            ,account_lock -- 锁定用户 0:locked  1:unlock
            ,aworksts -- 工作状态
            ,tsworkststime -- 工作状态开始时间
            ,login_num -- 是否首次登录 (新建用户初始值为1)
            ,reset_password_flag -- 是否重置密码 (0:未重置  1:重置)新增用户为1
            ,lock_num -- 登陆失败次数
            ,lock_time -- 登陆时间
            ,login_server -- 签入地址(priserver 代表主中心 bakserver 备中心)
            ,media_type -- 多媒体类型（chat代表在线video视频media多媒体）
            ,media_pic -- 视频客服不开摄像头背景图
            ,tone_switch -- 在线客服铃声提醒开关
            ,pro_bank_tone_switch -- 流程银行提示音提醒开关
            ,softphone_type -- 软电话类型（websocket/applet:接入方式为websocket/applet）
            ,tracking_remind_tone_switch -- 小结继续跟进提示音提醒开关
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_sys_account_info_op(
            status -- 状态
            ,password -- 登录密码
            ,create_date -- 创建日期
            ,update_date -- 修改日期
            ,agent_id -- agentid
            ,business_group_code -- 业务组编号（参数配置）
            ,account_code -- 用户账号
            ,emp_code -- 员工编号
            ,skill_group_code -- 技能组编号（参数配置）
            ,pwd_lapse_date -- 密码过期时间
            ,creater_code -- 创建者工号
            ,update_code -- 更新者工号
            ,operator_type_code -- 用户类型编码（参数配置）
            ,account_lock -- 锁定用户 0:locked  1:unlock
            ,aworksts -- 工作状态
            ,tsworkststime -- 工作状态开始时间
            ,login_num -- 是否首次登录 (新建用户初始值为1)
            ,reset_password_flag -- 是否重置密码 (0:未重置  1:重置)新增用户为1
            ,lock_num -- 登陆失败次数
            ,lock_time -- 登陆时间
            ,login_server -- 签入地址(priserver 代表主中心 bakserver 备中心)
            ,media_type -- 多媒体类型（chat代表在线video视频media多媒体）
            ,media_pic -- 视频客服不开摄像头背景图
            ,tone_switch -- 在线客服铃声提醒开关
            ,pro_bank_tone_switch -- 流程银行提示音提醒开关
            ,softphone_type -- 软电话类型（websocket/applet:接入方式为websocket/applet）
            ,tracking_remind_tone_switch -- 小结继续跟进提示音提醒开关
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.status -- 状态
    ,o.password -- 登录密码
    ,o.create_date -- 创建日期
    ,o.update_date -- 修改日期
    ,o.agent_id -- agentid
    ,o.business_group_code -- 业务组编号（参数配置）
    ,o.account_code -- 用户账号
    ,o.emp_code -- 员工编号
    ,o.skill_group_code -- 技能组编号（参数配置）
    ,o.pwd_lapse_date -- 密码过期时间
    ,o.creater_code -- 创建者工号
    ,o.update_code -- 更新者工号
    ,o.operator_type_code -- 用户类型编码（参数配置）
    ,o.account_lock -- 锁定用户 0:locked  1:unlock
    ,o.aworksts -- 工作状态
    ,o.tsworkststime -- 工作状态开始时间
    ,o.login_num -- 是否首次登录 (新建用户初始值为1)
    ,o.reset_password_flag -- 是否重置密码 (0:未重置  1:重置)新增用户为1
    ,o.lock_num -- 登陆失败次数
    ,o.lock_time -- 登陆时间
    ,o.login_server -- 签入地址(priserver 代表主中心 bakserver 备中心)
    ,o.media_type -- 多媒体类型（chat代表在线video视频media多媒体）
    ,o.media_pic -- 视频客服不开摄像头背景图
    ,o.tone_switch -- 在线客服铃声提醒开关
    ,o.pro_bank_tone_switch -- 流程银行提示音提醒开关
    ,o.softphone_type -- 软电话类型（websocket/applet:接入方式为websocket/applet）
    ,o.tracking_remind_tone_switch -- 小结继续跟进提示音提醒开关
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
from ${iol_schema}.ccdb_sys_account_info_bk o
    left join ${iol_schema}.ccdb_sys_account_info_op n
        on
            o.account_code = n.account_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ccdb_sys_account_info_cl d
        on
            o.account_code = d.account_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccdb_sys_account_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ccdb_sys_account_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ccdb_sys_account_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ccdb_sys_account_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ccdb_sys_account_info exchange partition p_${batch_date} with table ${iol_schema}.ccdb_sys_account_info_cl;
alter table ${iol_schema}.ccdb_sys_account_info exchange partition p_20991231 with table ${iol_schema}.ccdb_sys_account_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_sys_account_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_sys_account_info_op purge;
drop table ${iol_schema}.ccdb_sys_account_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccdb_sys_account_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_sys_account_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
