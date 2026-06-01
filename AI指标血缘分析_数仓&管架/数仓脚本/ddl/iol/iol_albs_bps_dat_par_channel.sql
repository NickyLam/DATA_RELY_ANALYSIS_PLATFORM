/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol albs_bps_dat_par_channel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.albs_bps_dat_par_channel
whenever sqlerror continue none;
drop table ${iol_schema}.albs_bps_dat_par_channel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_dat_par_channel(
    id varchar2(48) -- 表主键
    ,own_org varchar2(48) -- 归属组织
    ,list_kind varchar2(2) -- 名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。
    ,chnl_code varchar2(24) -- 渠道代码
    ,chnl_name varchar2(120) -- 渠道名称
    ,file_charset varchar2(12) -- 文件字符集
    ,file_type_code varchar2(12) -- 文件路径类型编码
    ,imp_bean varchar2(96) -- 数据导入bean（在枚举表中定义选择）
    ,user_remark varchar2(360) -- 备注
    ,log_id varchar2(48) -- 参数日志表id
    ,sys_def_flag varchar2(2) -- 系统定义标志：1-系统定义，不可修改；0-用户定义，可修改。
    ,oper_type varchar2(2) -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
    ,edit_status varchar2(2) -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
    ,data_enable varchar2(2) -- 可用标识：a-初始值；y-启用；n-停用；d-删除。
    ,crt_datetime varchar2(21) -- 创建时间(yyyymmddhhmmss)
    ,crt_user_id varchar2(48) -- 创建用户id（或名称）
    ,crt_branch_id varchar2(48) -- 创建机构id
    ,last_datetime varchar2(21) -- 最后操作时间(yyyymmddhhmmss)
    ,last_user_id varchar2(48) -- 最后操作用户id
    ,last_branch_id varchar2(48) -- 最后操作用户机构id
    ,last_txn varchar2(24) -- 最后操作交易码
    ,crt_user_code varchar2(96) -- 创建用户编号
    ,crt_branch_code varchar2(96) -- 创建机构编号
    ,last_user_code varchar2(96) -- 上次操作用户编号
    ,risk_level varchar2(3) -- 风险等级编号
    ,deal_opinion varchar2(1500) -- 处置手段
    ,chnl_src varchar2(120) -- 
    ,chnl_provider varchar2(120) -- 
    ,chnl_manager varchar2(120) -- 
    ,chnl_maintain varchar2(120) -- 
    ,chnl_update_time varchar2(3) -- 
    ,chnl_desc varchar2(1500) -- 
    ,file_path varchar2(300) -- 
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
grant select on ${iol_schema}.albs_bps_dat_par_channel to ${iml_schema};
grant select on ${iol_schema}.albs_bps_dat_par_channel to ${icl_schema};
grant select on ${iol_schema}.albs_bps_dat_par_channel to ${idl_schema};
grant select on ${iol_schema}.albs_bps_dat_par_channel to ${iel_schema};

-- comment
comment on table ${iol_schema}.albs_bps_dat_par_channel is '渠道参数表';
comment on column ${iol_schema}.albs_bps_dat_par_channel.id is '表主键';
comment on column ${iol_schema}.albs_bps_dat_par_channel.own_org is '归属组织';
comment on column ${iol_schema}.albs_bps_dat_par_channel.list_kind is '名单种类：1-黑名单；2-灰名单；3-白名单； 4-命名待定（须命中才能做业务的名单）。';
comment on column ${iol_schema}.albs_bps_dat_par_channel.chnl_code is '渠道代码';
comment on column ${iol_schema}.albs_bps_dat_par_channel.chnl_name is '渠道名称';
comment on column ${iol_schema}.albs_bps_dat_par_channel.file_charset is '文件字符集';
comment on column ${iol_schema}.albs_bps_dat_par_channel.file_type_code is '文件路径类型编码';
comment on column ${iol_schema}.albs_bps_dat_par_channel.imp_bean is '数据导入bean（在枚举表中定义选择）';
comment on column ${iol_schema}.albs_bps_dat_par_channel.user_remark is '备注';
comment on column ${iol_schema}.albs_bps_dat_par_channel.log_id is '参数日志表id';
comment on column ${iol_schema}.albs_bps_dat_par_channel.sys_def_flag is '系统定义标志：1-系统定义，不可修改；0-用户定义，可修改。';
comment on column ${iol_schema}.albs_bps_dat_par_channel.oper_type is '操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。';
comment on column ${iol_schema}.albs_bps_dat_par_channel.edit_status is '编辑状态：1-正常；2-待复核；3-驳回；4-待生效。';
comment on column ${iol_schema}.albs_bps_dat_par_channel.data_enable is '可用标识：a-初始值；y-启用；n-停用；d-删除。';
comment on column ${iol_schema}.albs_bps_dat_par_channel.crt_datetime is '创建时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.albs_bps_dat_par_channel.crt_user_id is '创建用户id（或名称）';
comment on column ${iol_schema}.albs_bps_dat_par_channel.crt_branch_id is '创建机构id';
comment on column ${iol_schema}.albs_bps_dat_par_channel.last_datetime is '最后操作时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.albs_bps_dat_par_channel.last_user_id is '最后操作用户id';
comment on column ${iol_schema}.albs_bps_dat_par_channel.last_branch_id is '最后操作用户机构id';
comment on column ${iol_schema}.albs_bps_dat_par_channel.last_txn is '最后操作交易码';
comment on column ${iol_schema}.albs_bps_dat_par_channel.crt_user_code is '创建用户编号';
comment on column ${iol_schema}.albs_bps_dat_par_channel.crt_branch_code is '创建机构编号';
comment on column ${iol_schema}.albs_bps_dat_par_channel.last_user_code is '上次操作用户编号';
comment on column ${iol_schema}.albs_bps_dat_par_channel.risk_level is '风险等级编号';
comment on column ${iol_schema}.albs_bps_dat_par_channel.deal_opinion is '处置手段';
comment on column ${iol_schema}.albs_bps_dat_par_channel.chnl_src is '';
comment on column ${iol_schema}.albs_bps_dat_par_channel.chnl_provider is '';
comment on column ${iol_schema}.albs_bps_dat_par_channel.chnl_manager is '';
comment on column ${iol_schema}.albs_bps_dat_par_channel.chnl_maintain is '';
comment on column ${iol_schema}.albs_bps_dat_par_channel.chnl_update_time is '';
comment on column ${iol_schema}.albs_bps_dat_par_channel.chnl_desc is '';
comment on column ${iol_schema}.albs_bps_dat_par_channel.file_path is '';
comment on column ${iol_schema}.albs_bps_dat_par_channel.start_dt is '开始时间';
comment on column ${iol_schema}.albs_bps_dat_par_channel.end_dt is '结束时间';
comment on column ${iol_schema}.albs_bps_dat_par_channel.id_mark is '增删标志';
comment on column ${iol_schema}.albs_bps_dat_par_channel.etl_timestamp is 'ETL处理时间戳';
