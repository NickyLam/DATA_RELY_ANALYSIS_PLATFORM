/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_remoteauth_inst_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_remoteauth_inst_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_remoteauth_inst_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_remoteauth_inst_tb(
    task_id varchar2(50) -- 任务号
    ,doc_id varchar2(50) -- 影像批次号
    ,bus_id varchar2(6) -- 业务流程定义号
    ,bus_ver number(10,0) -- 业务流程版本号
    ,scene_code varchar2(30) -- 业务场景号
    ,organ_no varchar2(10) -- 发起机构
    ,start_user_id varchar2(20) -- 发起柜员号
    ,start_date varchar2(14) -- 发起时间
    ,auth_user varchar2(20) -- 授权员
    ,auth_date varchar2(14) -- 授权时间
    ,auth_type varchar2(1) -- 授权类型
    ,state varchar2(2) -- 状态
    ,reason varchar2(500) -- 拒绝原因
    ,bank_no varchar2(10) -- 银行号
    ,system_no varchar2(10) -- 系统号
    ,sup_scan varchar2(500) -- 补扫信息备注
    ,center_no varchar2(10) -- 处理中心
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
grant select on ${iol_schema}.scps_bp_remoteauth_inst_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_remoteauth_inst_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_remoteauth_inst_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_remoteauth_inst_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_remoteauth_inst_tb is '远程授权实例表';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.doc_id is '影像批次号';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.bus_id is '业务流程定义号';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.bus_ver is '业务流程版本号';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.scene_code is '业务场景号';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.organ_no is '发起机构';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.start_user_id is '发起柜员号';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.start_date is '发起时间';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.auth_user is '授权员';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.auth_date is '授权时间';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.auth_type is '授权类型';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.state is '状态';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.reason is '拒绝原因';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.system_no is '系统号';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.sup_scan is '补扫信息备注';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.center_no is '处理中心';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_remoteauth_inst_tb.etl_timestamp is 'ETL处理时间戳';
