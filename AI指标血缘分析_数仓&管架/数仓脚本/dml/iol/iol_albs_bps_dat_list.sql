/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_albs_bps_dat_list
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
create table ${iol_schema}.albs_bps_dat_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.albs_bps_dat_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.albs_bps_dat_list_op purge;
drop table ${iol_schema}.albs_bps_dat_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_dat_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.albs_bps_dat_list where 0=1;

create table ${iol_schema}.albs_bps_dat_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.albs_bps_dat_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.albs_bps_dat_list_cl(
            id -- 表主键
            ,own_org -- 归属组织
            ,list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
            ,chnl_id -- 名单渠道id
            ,list_ori_id -- 名单原始编号
            ,list_version -- 名单版本号
            ,list_type -- 名单类型：1-个人；2-实体；3-其他。
            ,active_flag -- 激活标识：0-不可用；1-可用；
            ,active_date -- 启用时间
            ,expiry_date -- 停用时间
            ,gender -- （个人）性别：1-男；2-女。
            ,deceased -- （个人）是否已故：yes/no
            ,list_crt_date -- 名单收录时间
            ,list_update_date -- 名单修改时间
            ,ref_codes -- 名单数据引用来源代码，多来源半角逗号隔开。
            ,desc_codes -- 名单描述代码，如登记djs的"3#1,3#2"，多个用半角逗号分隔。
            ,desc_icons -- 风险标签（黑名单风险图标归类）多风险标签逗号隔开
            ,risk_level -- 风险等级（预留，用法待定）
            ,is_china_list -- 是否国内名单：0-否；1-是。
            ,sys_remark -- 备注
            ,deal_status -- 处理状态：0-待处理；1-处理中；2-已处理。
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
            ,data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
            ,crt_date -- 创建日期(yyyymmdd)
            ,crt_datetime -- 创建时间(yyyymmddhhmmss)
            ,crt_user_id -- 创建用户id（或名称）
            ,crt_branch_id -- 创建机构id
            ,last_date -- 最后操作日期(yyyymmdd)
            ,last_datetime -- 最后操作时间(yyyymmddhhmmss)
            ,last_user_id -- 最后操作用户id
            ,last_branch_id -- 最后操作用户机构id
            ,last_txn -- 最后操作交易码
            ,action_type -- 名单数据操作类型：1-新增；2-修改；3-删除
            ,edit_status -- 编辑状态
            ,log_id -- 日志表主键
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,file_seq -- 文件序列
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.albs_bps_dat_list_op(
            id -- 表主键
            ,own_org -- 归属组织
            ,list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
            ,chnl_id -- 名单渠道id
            ,list_ori_id -- 名单原始编号
            ,list_version -- 名单版本号
            ,list_type -- 名单类型：1-个人；2-实体；3-其他。
            ,active_flag -- 激活标识：0-不可用；1-可用；
            ,active_date -- 启用时间
            ,expiry_date -- 停用时间
            ,gender -- （个人）性别：1-男；2-女。
            ,deceased -- （个人）是否已故：yes/no
            ,list_crt_date -- 名单收录时间
            ,list_update_date -- 名单修改时间
            ,ref_codes -- 名单数据引用来源代码，多来源半角逗号隔开。
            ,desc_codes -- 名单描述代码，如登记djs的"3#1,3#2"，多个用半角逗号分隔。
            ,desc_icons -- 风险标签（黑名单风险图标归类）多风险标签逗号隔开
            ,risk_level -- 风险等级（预留，用法待定）
            ,is_china_list -- 是否国内名单：0-否；1-是。
            ,sys_remark -- 备注
            ,deal_status -- 处理状态：0-待处理；1-处理中；2-已处理。
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
            ,data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
            ,crt_date -- 创建日期(yyyymmdd)
            ,crt_datetime -- 创建时间(yyyymmddhhmmss)
            ,crt_user_id -- 创建用户id（或名称）
            ,crt_branch_id -- 创建机构id
            ,last_date -- 最后操作日期(yyyymmdd)
            ,last_datetime -- 最后操作时间(yyyymmddhhmmss)
            ,last_user_id -- 最后操作用户id
            ,last_branch_id -- 最后操作用户机构id
            ,last_txn -- 最后操作交易码
            ,action_type -- 名单数据操作类型：1-新增；2-修改；3-删除
            ,edit_status -- 编辑状态
            ,log_id -- 日志表主键
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,file_seq -- 文件序列
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 表主键
    ,nvl(n.own_org, o.own_org) as own_org -- 归属组织
    ,nvl(n.list_kind, o.list_kind) as list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
    ,nvl(n.chnl_id, o.chnl_id) as chnl_id -- 名单渠道id
    ,nvl(n.list_ori_id, o.list_ori_id) as list_ori_id -- 名单原始编号
    ,nvl(n.list_version, o.list_version) as list_version -- 名单版本号
    ,nvl(n.list_type, o.list_type) as list_type -- 名单类型：1-个人；2-实体；3-其他。
    ,nvl(n.active_flag, o.active_flag) as active_flag -- 激活标识：0-不可用；1-可用；
    ,nvl(n.active_date, o.active_date) as active_date -- 启用时间
    ,nvl(n.expiry_date, o.expiry_date) as expiry_date -- 停用时间
    ,nvl(n.gender, o.gender) as gender -- （个人）性别：1-男；2-女。
    ,nvl(n.deceased, o.deceased) as deceased -- （个人）是否已故：yes/no
    ,nvl(n.list_crt_date, o.list_crt_date) as list_crt_date -- 名单收录时间
    ,nvl(n.list_update_date, o.list_update_date) as list_update_date -- 名单修改时间
    ,nvl(n.ref_codes, o.ref_codes) as ref_codes -- 名单数据引用来源代码，多来源半角逗号隔开。
    ,nvl(n.desc_codes, o.desc_codes) as desc_codes -- 名单描述代码，如登记djs的"3#1,3#2"，多个用半角逗号分隔。
    ,nvl(n.desc_icons, o.desc_icons) as desc_icons -- 风险标签（黑名单风险图标归类）多风险标签逗号隔开
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险等级（预留，用法待定）
    ,nvl(n.is_china_list, o.is_china_list) as is_china_list -- 是否国内名单：0-否；1-是。
    ,nvl(n.sys_remark, o.sys_remark) as sys_remark -- 备注
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 处理状态：0-待处理；1-处理中；2-已处理。
    ,nvl(n.oper_type, o.oper_type) as oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
    ,nvl(n.data_enable, o.data_enable) as data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
    ,nvl(n.crt_date, o.crt_date) as crt_date -- 创建日期(yyyymmdd)
    ,nvl(n.crt_datetime, o.crt_datetime) as crt_datetime -- 创建时间(yyyymmddhhmmss)
    ,nvl(n.crt_user_id, o.crt_user_id) as crt_user_id -- 创建用户id（或名称）
    ,nvl(n.crt_branch_id, o.crt_branch_id) as crt_branch_id -- 创建机构id
    ,nvl(n.last_date, o.last_date) as last_date -- 最后操作日期(yyyymmdd)
    ,nvl(n.last_datetime, o.last_datetime) as last_datetime -- 最后操作时间(yyyymmddhhmmss)
    ,nvl(n.last_user_id, o.last_user_id) as last_user_id -- 最后操作用户id
    ,nvl(n.last_branch_id, o.last_branch_id) as last_branch_id -- 最后操作用户机构id
    ,nvl(n.last_txn, o.last_txn) as last_txn -- 最后操作交易码
    ,nvl(n.action_type, o.action_type) as action_type -- 名单数据操作类型：1-新增；2-修改；3-删除
    ,nvl(n.edit_status, o.edit_status) as edit_status -- 编辑状态
    ,nvl(n.log_id, o.log_id) as log_id -- 日志表主键
    ,nvl(n.crt_user_code, o.crt_user_code) as crt_user_code -- 创建用户编号
    ,nvl(n.crt_branch_code, o.crt_branch_code) as crt_branch_code -- 创建机构编号
    ,nvl(n.last_user_code, o.last_user_code) as last_user_code -- 上次操作用户编号
    ,nvl(n.file_seq, o.file_seq) as file_seq -- 文件序列
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
from (select * from ${iol_schema}.albs_bps_dat_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.albs_bps_dat_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.chnl_id <> n.chnl_id
        or o.list_ori_id <> n.list_ori_id
        or o.list_version <> n.list_version
        or o.list_type <> n.list_type
        or o.active_flag <> n.active_flag
        or o.active_date <> n.active_date
        or o.expiry_date <> n.expiry_date
        or o.gender <> n.gender
        or o.deceased <> n.deceased
        or o.list_crt_date <> n.list_crt_date
        or o.list_update_date <> n.list_update_date
        or o.ref_codes <> n.ref_codes
        or o.desc_codes <> n.desc_codes
        or o.desc_icons <> n.desc_icons
        or o.risk_level <> n.risk_level
        or o.is_china_list <> n.is_china_list
        or o.sys_remark <> n.sys_remark
        or o.deal_status <> n.deal_status
        or o.oper_type <> n.oper_type
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
        or o.action_type <> n.action_type
        or o.edit_status <> n.edit_status
        or o.log_id <> n.log_id
        or o.crt_user_code <> n.crt_user_code
        or o.crt_branch_code <> n.crt_branch_code
        or o.last_user_code <> n.last_user_code
        or o.file_seq <> n.file_seq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.albs_bps_dat_list_cl(
            id -- 表主键
            ,own_org -- 归属组织
            ,list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
            ,chnl_id -- 名单渠道id
            ,list_ori_id -- 名单原始编号
            ,list_version -- 名单版本号
            ,list_type -- 名单类型：1-个人；2-实体；3-其他。
            ,active_flag -- 激活标识：0-不可用；1-可用；
            ,active_date -- 启用时间
            ,expiry_date -- 停用时间
            ,gender -- （个人）性别：1-男；2-女。
            ,deceased -- （个人）是否已故：yes/no
            ,list_crt_date -- 名单收录时间
            ,list_update_date -- 名单修改时间
            ,ref_codes -- 名单数据引用来源代码，多来源半角逗号隔开。
            ,desc_codes -- 名单描述代码，如登记djs的"3#1,3#2"，多个用半角逗号分隔。
            ,desc_icons -- 风险标签（黑名单风险图标归类）多风险标签逗号隔开
            ,risk_level -- 风险等级（预留，用法待定）
            ,is_china_list -- 是否国内名单：0-否；1-是。
            ,sys_remark -- 备注
            ,deal_status -- 处理状态：0-待处理；1-处理中；2-已处理。
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
            ,data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
            ,crt_date -- 创建日期(yyyymmdd)
            ,crt_datetime -- 创建时间(yyyymmddhhmmss)
            ,crt_user_id -- 创建用户id（或名称）
            ,crt_branch_id -- 创建机构id
            ,last_date -- 最后操作日期(yyyymmdd)
            ,last_datetime -- 最后操作时间(yyyymmddhhmmss)
            ,last_user_id -- 最后操作用户id
            ,last_branch_id -- 最后操作用户机构id
            ,last_txn -- 最后操作交易码
            ,action_type -- 名单数据操作类型：1-新增；2-修改；3-删除
            ,edit_status -- 编辑状态
            ,log_id -- 日志表主键
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,file_seq -- 文件序列
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.albs_bps_dat_list_op(
            id -- 表主键
            ,own_org -- 归属组织
            ,list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
            ,chnl_id -- 名单渠道id
            ,list_ori_id -- 名单原始编号
            ,list_version -- 名单版本号
            ,list_type -- 名单类型：1-个人；2-实体；3-其他。
            ,active_flag -- 激活标识：0-不可用；1-可用；
            ,active_date -- 启用时间
            ,expiry_date -- 停用时间
            ,gender -- （个人）性别：1-男；2-女。
            ,deceased -- （个人）是否已故：yes/no
            ,list_crt_date -- 名单收录时间
            ,list_update_date -- 名单修改时间
            ,ref_codes -- 名单数据引用来源代码，多来源半角逗号隔开。
            ,desc_codes -- 名单描述代码，如登记djs的"3#1,3#2"，多个用半角逗号分隔。
            ,desc_icons -- 风险标签（黑名单风险图标归类）多风险标签逗号隔开
            ,risk_level -- 风险等级（预留，用法待定）
            ,is_china_list -- 是否国内名单：0-否；1-是。
            ,sys_remark -- 备注
            ,deal_status -- 处理状态：0-待处理；1-处理中；2-已处理。
            ,oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
            ,data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
            ,crt_date -- 创建日期(yyyymmdd)
            ,crt_datetime -- 创建时间(yyyymmddhhmmss)
            ,crt_user_id -- 创建用户id（或名称）
            ,crt_branch_id -- 创建机构id
            ,last_date -- 最后操作日期(yyyymmdd)
            ,last_datetime -- 最后操作时间(yyyymmddhhmmss)
            ,last_user_id -- 最后操作用户id
            ,last_branch_id -- 最后操作用户机构id
            ,last_txn -- 最后操作交易码
            ,action_type -- 名单数据操作类型：1-新增；2-修改；3-删除
            ,edit_status -- 编辑状态
            ,log_id -- 日志表主键
            ,crt_user_code -- 创建用户编号
            ,crt_branch_code -- 创建机构编号
            ,last_user_code -- 上次操作用户编号
            ,file_seq -- 文件序列
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 表主键
    ,o.own_org -- 归属组织
    ,o.list_kind -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
    ,o.chnl_id -- 名单渠道id
    ,o.list_ori_id -- 名单原始编号
    ,o.list_version -- 名单版本号
    ,o.list_type -- 名单类型：1-个人；2-实体；3-其他。
    ,o.active_flag -- 激活标识：0-不可用；1-可用；
    ,o.active_date -- 启用时间
    ,o.expiry_date -- 停用时间
    ,o.gender -- （个人）性别：1-男；2-女。
    ,o.deceased -- （个人）是否已故：yes/no
    ,o.list_crt_date -- 名单收录时间
    ,o.list_update_date -- 名单修改时间
    ,o.ref_codes -- 名单数据引用来源代码，多来源半角逗号隔开。
    ,o.desc_codes -- 名单描述代码，如登记djs的"3#1,3#2"，多个用半角逗号分隔。
    ,o.desc_icons -- 风险标签（黑名单风险图标归类）多风险标签逗号隔开
    ,o.risk_level -- 风险等级（预留，用法待定）
    ,o.is_china_list -- 是否国内名单：0-否；1-是。
    ,o.sys_remark -- 备注
    ,o.deal_status -- 处理状态：0-待处理；1-处理中；2-已处理。
    ,o.oper_type -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
    ,o.data_enable -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
    ,o.crt_date -- 创建日期(yyyymmdd)
    ,o.crt_datetime -- 创建时间(yyyymmddhhmmss)
    ,o.crt_user_id -- 创建用户id（或名称）
    ,o.crt_branch_id -- 创建机构id
    ,o.last_date -- 最后操作日期(yyyymmdd)
    ,o.last_datetime -- 最后操作时间(yyyymmddhhmmss)
    ,o.last_user_id -- 最后操作用户id
    ,o.last_branch_id -- 最后操作用户机构id
    ,o.last_txn -- 最后操作交易码
    ,o.action_type -- 名单数据操作类型：1-新增；2-修改；3-删除
    ,o.edit_status -- 编辑状态
    ,o.log_id -- 日志表主键
    ,o.crt_user_code -- 创建用户编号
    ,o.crt_branch_code -- 创建机构编号
    ,o.last_user_code -- 上次操作用户编号
    ,o.file_seq -- 文件序列
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
from ${iol_schema}.albs_bps_dat_list_bk o
    left join ${iol_schema}.albs_bps_dat_list_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.albs_bps_dat_list_cl d
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
--truncate table ${iol_schema}.albs_bps_dat_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('albs_bps_dat_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.albs_bps_dat_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.albs_bps_dat_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.albs_bps_dat_list exchange partition p_${batch_date} with table ${iol_schema}.albs_bps_dat_list_cl;
alter table ${iol_schema}.albs_bps_dat_list exchange partition p_20991231 with table ${iol_schema}.albs_bps_dat_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.albs_bps_dat_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.albs_bps_dat_list_op purge;
drop table ${iol_schema}.albs_bps_dat_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.albs_bps_dat_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'albs_bps_dat_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
