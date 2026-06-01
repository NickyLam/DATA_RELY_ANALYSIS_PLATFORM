/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_supv_acct_req_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_supv_acct_req_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_supv_acct_req_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_supv_acct_req_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,midgrod_tran_dt date -- 中台交易日期
    ,sys_id varchar2(100) -- 系统编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,tran_dir_cd varchar2(30) -- 交易方向代码
    ,tran_cnt number(10) -- 交易次数
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,supv_acct_id varchar2(100) -- 监管账户编号
    ,bus_msg_id varchar2(100) -- 业务报文编号
    ,intfc_name varchar2(750) -- 接口名称
    ,proc_tm timestamp -- 处理时间
    ,rest_cd varchar2(30) -- 处理结果代码
    ,que_start_tm timestamp -- 查询开始时间
    ,que_end_tm timestamp -- 查询结束时间
    ,return_code varchar2(150) -- 返回码
    ,return_info_desc varchar2(750) -- 返回信息描述
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,proc_org_id varchar2(100) -- 处理机构编号
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,prpery_flow_num varchar2(100) -- 外围流水号
    ,sys_in_flow_num varchar2(100) -- 系统内流水号
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
grant select on ${iml_schema}.evt_supv_acct_req_flow to ${icl_schema};
grant select on ${iml_schema}.evt_supv_acct_req_flow to ${idl_schema};
grant select on ${iml_schema}.evt_supv_acct_req_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_supv_acct_req_flow is '监管账户请求流水';
comment on column ${iml_schema}.evt_supv_acct_req_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.midgrod_tran_dt is '中台交易日期';
comment on column ${iml_schema}.evt_supv_acct_req_flow.sys_id is '系统编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_supv_acct_req_flow.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.evt_supv_acct_req_flow.tran_cnt is '交易次数';
comment on column ${iml_schema}.evt_supv_acct_req_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_supv_acct_req_flow.supv_acct_id is '监管账户编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.bus_msg_id is '业务报文编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.intfc_name is '接口名称';
comment on column ${iml_schema}.evt_supv_acct_req_flow.proc_tm is '处理时间';
comment on column ${iml_schema}.evt_supv_acct_req_flow.rest_cd is '处理结果代码';
comment on column ${iml_schema}.evt_supv_acct_req_flow.que_start_tm is '查询开始时间';
comment on column ${iml_schema}.evt_supv_acct_req_flow.que_end_tm is '查询结束时间';
comment on column ${iml_schema}.evt_supv_acct_req_flow.return_code is '返回码';
comment on column ${iml_schema}.evt_supv_acct_req_flow.return_info_desc is '返回信息描述';
comment on column ${iml_schema}.evt_supv_acct_req_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.proc_org_id is '处理机构编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.prpery_flow_num is '外围流水号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.sys_in_flow_num is '系统内流水号';
comment on column ${iml_schema}.evt_supv_acct_req_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_supv_acct_req_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_supv_acct_req_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_supv_acct_req_flow.etl_timestamp is 'ETL处理时间戳';
