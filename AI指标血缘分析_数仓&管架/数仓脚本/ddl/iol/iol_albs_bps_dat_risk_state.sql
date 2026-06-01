/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol albs_bps_dat_risk_state
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.albs_bps_dat_risk_state
whenever sqlerror continue none;
drop table ${iol_schema}.albs_bps_dat_risk_state purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_dat_risk_state(
    id varchar2(48) -- 表主键
    ,log_id varchar2(48) -- 参数日志表id
    ,own_org varchar2(48) -- 归属组织
    ,state_src varchar2(24) -- 高危国家来源，如：ofac
    ,state_code varchar2(24) -- 国家缩写(两位简称)
    ,state_name varchar2(150) -- 国家名称
    ,user_remark varchar2(360) -- 备注
    ,oper_type varchar2(2) -- 操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。
    ,edit_status varchar2(2) -- 编辑状态：1-正常；2-待复核；3-驳回；4-待生效。
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
    ,state_name_en varchar2(180) -- 英文名称
    ,list_id varchar2(48) -- 名单表主键
    ,state_abbreviate varchar2(24) -- 国家缩写(三位简称)
    ,crt_user_code varchar2(96) -- 创建用户编号
    ,crt_branch_code varchar2(96) -- 创建机构编号
    ,last_user_code varchar2(96) -- 上次操作用户编号
    ,risk_level varchar2(3) -- 高风险国家风险等级
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
grant select on ${iol_schema}.albs_bps_dat_risk_state to ${iml_schema};
grant select on ${iol_schema}.albs_bps_dat_risk_state to ${icl_schema};
grant select on ${iol_schema}.albs_bps_dat_risk_state to ${idl_schema};
grant select on ${iol_schema}.albs_bps_dat_risk_state to ${iel_schema};

-- comment
comment on table ${iol_schema}.albs_bps_dat_risk_state is '';
comment on column ${iol_schema}.albs_bps_dat_risk_state.id is '表主键';
comment on column ${iol_schema}.albs_bps_dat_risk_state.log_id is '参数日志表id';
comment on column ${iol_schema}.albs_bps_dat_risk_state.own_org is '归属组织';
comment on column ${iol_schema}.albs_bps_dat_risk_state.state_src is '高危国家来源，如：ofac';
comment on column ${iol_schema}.albs_bps_dat_risk_state.state_code is '国家缩写(两位简称)';
comment on column ${iol_schema}.albs_bps_dat_risk_state.state_name is '国家名称';
comment on column ${iol_schema}.albs_bps_dat_risk_state.user_remark is '备注';
comment on column ${iol_schema}.albs_bps_dat_risk_state.oper_type is '操作类型：0-自动处理；1-新增；2-修改；3-删除；4-查询；5-启用； 6-停用；7-处理；a-经办；b-复核；c-授权。';
comment on column ${iol_schema}.albs_bps_dat_risk_state.edit_status is '编辑状态：1-正常；2-待复核；3-驳回；4-待生效。';
comment on column ${iol_schema}.albs_bps_dat_risk_state.data_enable is '可用标识：a-初始值；y-启用；n-停用；d-删除。';
comment on column ${iol_schema}.albs_bps_dat_risk_state.crt_date is '创建日期(yyyymmdd)';
comment on column ${iol_schema}.albs_bps_dat_risk_state.crt_datetime is '创建时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.albs_bps_dat_risk_state.crt_user_id is '创建用户id（或名称）';
comment on column ${iol_schema}.albs_bps_dat_risk_state.crt_branch_id is '创建机构id';
comment on column ${iol_schema}.albs_bps_dat_risk_state.last_date is '最后操作日期(yyyymmdd)';
comment on column ${iol_schema}.albs_bps_dat_risk_state.last_datetime is '最后操作时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.albs_bps_dat_risk_state.last_user_id is '最后操作用户id';
comment on column ${iol_schema}.albs_bps_dat_risk_state.last_branch_id is '最后操作用户机构id';
comment on column ${iol_schema}.albs_bps_dat_risk_state.last_txn is '最后操作交易码';
comment on column ${iol_schema}.albs_bps_dat_risk_state.state_name_en is '英文名称';
comment on column ${iol_schema}.albs_bps_dat_risk_state.list_id is '名单表主键';
comment on column ${iol_schema}.albs_bps_dat_risk_state.state_abbreviate is '国家缩写(三位简称)';
comment on column ${iol_schema}.albs_bps_dat_risk_state.crt_user_code is '创建用户编号';
comment on column ${iol_schema}.albs_bps_dat_risk_state.crt_branch_code is '创建机构编号';
comment on column ${iol_schema}.albs_bps_dat_risk_state.last_user_code is '上次操作用户编号';
comment on column ${iol_schema}.albs_bps_dat_risk_state.risk_level is '高风险国家风险等级';
comment on column ${iol_schema}.albs_bps_dat_risk_state.start_dt is '开始时间';
comment on column ${iol_schema}.albs_bps_dat_risk_state.end_dt is '结束时间';
comment on column ${iol_schema}.albs_bps_dat_risk_state.id_mark is '增删标志';
comment on column ${iol_schema}.albs_bps_dat_risk_state.etl_timestamp is 'ETL处理时间戳';
