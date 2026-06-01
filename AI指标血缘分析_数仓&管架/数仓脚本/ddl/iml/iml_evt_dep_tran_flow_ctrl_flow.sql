/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dep_tran_flow_ctrl_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dep_tran_flow_ctrl_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dep_tran_flow_ctrl_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_tran_flow_ctrl_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,chn_id varchar2(100) -- 渠道编号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,chn_tran_dt date -- 渠道交易日期
    ,cust_id varchar2(100) -- 客户编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,src_module_type_cd varchar2(30) -- 源模块类型代码
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
    ,onl_bus_proc_status_cd varchar2(30) -- 联机业务处理状态代码
    ,intfc_serv_type_cd varchar2(30) -- 接口服务类型代码
    ,intfc_serv_id varchar2(100) -- 接口服务编号
    ,bus_tran_dt date -- 业务交易日期
    ,tran_tm timestamp -- 交易时间
    ,bus_subclass_cd varchar2(30) -- 业务细类代码
    ,sys_init_sub_flow_num varchar2(100) -- 系统原始子流水号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_dep_tran_flow_ctrl_flow to ${icl_schema};
grant select on ${iml_schema}.evt_dep_tran_flow_ctrl_flow to ${idl_schema};
grant select on ${iml_schema}.evt_dep_tran_flow_ctrl_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dep_tran_flow_ctrl_flow is '存款交易流程控制流水';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.chn_tran_dt is '渠道交易日期';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.src_module_type_cd is '源模块类型代码';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.onl_bus_proc_status_cd is '联机业务处理状态代码';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.intfc_serv_type_cd is '接口服务类型代码';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.intfc_serv_id is '接口服务编号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.bus_subclass_cd is '业务细类代码';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.sys_init_sub_flow_num is '系统原始子流水号';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dep_tran_flow_ctrl_flow.etl_timestamp is 'ETL处理时间戳';
