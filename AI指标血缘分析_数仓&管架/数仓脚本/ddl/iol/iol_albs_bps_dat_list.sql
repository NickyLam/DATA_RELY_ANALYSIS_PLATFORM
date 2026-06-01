/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol albs_bps_dat_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.albs_bps_dat_list
whenever sqlerror continue none;
drop table ${iol_schema}.albs_bps_dat_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_dat_list(
    id varchar2(48) -- 表主键
    ,own_org varchar2(48) -- 归属组织
    ,list_kind varchar2(2) -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
    ,chnl_id varchar2(48) -- 名单渠道id
    ,list_ori_id varchar2(48) -- 名单原始编号
    ,list_version varchar2(48) -- 名单版本号
    ,list_type varchar2(2) -- 名单类型：1-个人；2-实体；3-其他。
    ,active_flag varchar2(2) -- 激活标识：0-不可用；1-可用；
    ,active_date varchar2(12) -- 启用时间
    ,expiry_date varchar2(12) -- 停用时间
    ,gender varchar2(2) -- （个人）性别：1-男；2-女。
    ,deceased varchar2(24) -- （个人）是否已故：yes/no
    ,list_crt_date varchar2(24) -- 名单收录时间
    ,list_update_date varchar2(24) -- 名单修改时间
    ,ref_codes varchar2(1536) -- 名单数据引用来源代码，多来源半角逗号隔开。
    ,desc_codes varchar2(300) -- 名单描述代码，如登记djs的"3#1,3#2"，多个用半角逗号分隔。
    ,desc_icons varchar2(180) -- 风险标签（黑名单风险图标归类）多风险标签逗号隔开
    ,risk_level varchar2(72) -- 风险等级（预留，用法待定）
    ,is_china_list varchar2(2) -- 是否国内名单：0-否；1-是。
    ,sys_remark varchar2(450) -- 备注
    ,deal_status varchar2(2) -- 处理状态：0-待处理；1-处理中；2-已处理。
    ,oper_type varchar2(2) -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
    ,data_enable varchar2(2) -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
    ,crt_date varchar2(12) -- 创建日期(yyyymmdd)
    ,crt_datetime varchar2(21) -- 创建时间(yyyymmddhhmmss)
    ,crt_user_id varchar2(48) -- 创建用户id（或名称）
    ,crt_branch_id varchar2(48) -- 创建机构id
    ,last_date varchar2(12) -- 最后操作日期(yyyymmdd)
    ,last_datetime varchar2(21) -- 最后操作时间(yyyymmddhhmmss)
    ,last_user_id varchar2(48) -- 最后操作用户id
    ,last_branch_id varchar2(48) -- 最后操作用户机构id
    ,last_txn varchar2(24) -- 最后操作交易码
    ,action_type varchar2(2) -- 名单数据操作类型：1-新增；2-修改；3-删除
    ,edit_status varchar2(2) -- 编辑状态
    ,log_id varchar2(48) -- 日志表主键
    ,crt_user_code varchar2(96) -- 创建用户编号
    ,crt_branch_code varchar2(96) -- 创建机构编号
    ,last_user_code varchar2(96) -- 上次操作用户编号
    ,file_seq varchar2(24) -- 文件序列
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.albs_bps_dat_list to ${iml_schema};
grant select on ${iol_schema}.albs_bps_dat_list to ${icl_schema};
grant select on ${iol_schema}.albs_bps_dat_list to ${idl_schema};
grant select on ${iol_schema}.albs_bps_dat_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.albs_bps_dat_list is '名单主表';
comment on column ${iol_schema}.albs_bps_dat_list.id is '表主键';
comment on column ${iol_schema}.albs_bps_dat_list.own_org is '归属组织';
comment on column ${iol_schema}.albs_bps_dat_list.list_kind is '名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。';
comment on column ${iol_schema}.albs_bps_dat_list.chnl_id is '名单渠道id';
comment on column ${iol_schema}.albs_bps_dat_list.list_ori_id is '名单原始编号';
comment on column ${iol_schema}.albs_bps_dat_list.list_version is '名单版本号';
comment on column ${iol_schema}.albs_bps_dat_list.list_type is '名单类型：1-个人；2-实体；3-其他。';
comment on column ${iol_schema}.albs_bps_dat_list.active_flag is '激活标识：0-不可用；1-可用；';
comment on column ${iol_schema}.albs_bps_dat_list.active_date is '启用时间';
comment on column ${iol_schema}.albs_bps_dat_list.expiry_date is '停用时间';
comment on column ${iol_schema}.albs_bps_dat_list.gender is '（个人）性别：1-男；2-女。';
comment on column ${iol_schema}.albs_bps_dat_list.deceased is '（个人）是否已故：yes/no';
comment on column ${iol_schema}.albs_bps_dat_list.list_crt_date is '名单收录时间';
comment on column ${iol_schema}.albs_bps_dat_list.list_update_date is '名单修改时间';
comment on column ${iol_schema}.albs_bps_dat_list.ref_codes is '名单数据引用来源代码，多来源半角逗号隔开。';
comment on column ${iol_schema}.albs_bps_dat_list.desc_codes is '名单描述代码，如登记djs的"3#1,3#2"，多个用半角逗号分隔。';
comment on column ${iol_schema}.albs_bps_dat_list.desc_icons is '风险标签（黑名单风险图标归类）多风险标签逗号隔开';
comment on column ${iol_schema}.albs_bps_dat_list.risk_level is '风险等级（预留，用法待定）';
comment on column ${iol_schema}.albs_bps_dat_list.is_china_list is '是否国内名单：0-否；1-是。';
comment on column ${iol_schema}.albs_bps_dat_list.sys_remark is '备注';
comment on column ${iol_schema}.albs_bps_dat_list.deal_status is '处理状态：0-待处理；1-处理中；2-已处理。';
comment on column ${iol_schema}.albs_bps_dat_list.oper_type is '操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。';
comment on column ${iol_schema}.albs_bps_dat_list.data_enable is '可用标识：a-初始值；y-启用；n-停用；d-删除。';
comment on column ${iol_schema}.albs_bps_dat_list.crt_date is '创建日期(yyyymmdd)';
comment on column ${iol_schema}.albs_bps_dat_list.crt_datetime is '创建时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.albs_bps_dat_list.crt_user_id is '创建用户id（或名称）';
comment on column ${iol_schema}.albs_bps_dat_list.crt_branch_id is '创建机构id';
comment on column ${iol_schema}.albs_bps_dat_list.last_date is '最后操作日期(yyyymmdd)';
comment on column ${iol_schema}.albs_bps_dat_list.last_datetime is '最后操作时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.albs_bps_dat_list.last_user_id is '最后操作用户id';
comment on column ${iol_schema}.albs_bps_dat_list.last_branch_id is '最后操作用户机构id';
comment on column ${iol_schema}.albs_bps_dat_list.last_txn is '最后操作交易码';
comment on column ${iol_schema}.albs_bps_dat_list.action_type is '名单数据操作类型：1-新增；2-修改；3-删除';
comment on column ${iol_schema}.albs_bps_dat_list.edit_status is '编辑状态';
comment on column ${iol_schema}.albs_bps_dat_list.log_id is '日志表主键';
comment on column ${iol_schema}.albs_bps_dat_list.crt_user_code is '创建用户编号';
comment on column ${iol_schema}.albs_bps_dat_list.crt_branch_code is '创建机构编号';
comment on column ${iol_schema}.albs_bps_dat_list.last_user_code is '上次操作用户编号';
comment on column ${iol_schema}.albs_bps_dat_list.file_seq is '文件序列';
comment on column ${iol_schema}.albs_bps_dat_list.start_dt is '开始时间';
comment on column ${iol_schema}.albs_bps_dat_list.end_dt is '结束时间';
comment on column ${iol_schema}.albs_bps_dat_list.id_mark is '增删标志';
comment on column ${iol_schema}.albs_bps_dat_list.etl_timestamp is 'ETL处理时间戳';
