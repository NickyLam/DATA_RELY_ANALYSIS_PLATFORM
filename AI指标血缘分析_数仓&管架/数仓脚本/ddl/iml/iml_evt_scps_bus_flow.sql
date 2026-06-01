/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_scps_bus_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_scps_bus_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_scps_bus_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_scps_bus_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,task_no varchar2(100) -- 任务号
    ,bank_no varchar2(60) -- 银行行号
    ,sys_id varchar2(100) -- 系统编号
    ,sub_task_no varchar2(100) -- 子任务号
    ,init_task_no varchar2(100) -- 原任务号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,blip_flow_num varchar2(100) -- 影像流水号
    ,tran_code varchar2(30) -- 交易码
    ,chn_id varchar2(100) -- 渠道编号
    ,bus_scene_id varchar2(100) -- 业务场景编号
    ,bus_proc_prior_level varchar2(30) -- 业务处理优先级
    ,prior_level_descb varchar2(500) -- 优先级描述
    ,opera_mode_cd varchar2(30) -- 作业模式代码
    ,init_teller_id varchar2(100) -- 发起柜员编号
    ,init_org_id varchar2(100) -- 发起机构编号
    ,bus_proc_org_id varchar2(100) -- 业务处理机构编号
    ,tran_amt number(30,4) -- 交易金额
    ,tran_tm timestamp -- 交易时间
    ,tran_dt date -- 交易日期
    ,task_status_cd varchar2(30) -- 任务状态代码
    ,cust_id varchar2(250) -- 客户编号
    ,payer_acct_id varchar2(100) -- 付款人账户编号
    ,payer_acct_name varchar2(500) -- 付款人账户名称
    ,recver_acct_id varchar2(100) -- 收款人账户编号
    ,recver_acct_name varchar2(500) -- 收款人账户名称
    ,ghb_acct_id varchar2(100) -- 本行账户编号
    ,ghb_acct_name varchar2(500) -- 本行账户名称
    ,authoriz_diret_teller_id varchar2(100) -- 授权主管柜员编号
    ,refuse_rs_descb varchar2(500) -- 拒绝原因描述
    ,invalid_tm timestamp -- 失效时间
    ,invalid_dt date -- 失效日期
    ,termnt_rs_descb varchar2(1024) -- 终止原因描述
    ,blip_model_id varchar2(100) -- 影像模型编号
    ,blip_upload_tm date -- 影像上传日期
    ,entry_flow_num varchar2(100) -- 记账流水号
    ,entry_dt date -- 记账日期
    ,entry_tm timestamp -- 记账时间
    ,prob_initor_cd varchar2(30) -- 问题发起端代码
    ,remark varchar2(1024) -- 备注
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
grant select on ${iml_schema}.evt_scps_bus_flow to ${icl_schema};
grant select on ${iml_schema}.evt_scps_bus_flow to ${idl_schema};
grant select on ${iml_schema}.evt_scps_bus_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_scps_bus_flow is '后援中心业务流水';
comment on column ${iml_schema}.evt_scps_bus_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_scps_bus_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_scps_bus_flow.task_no is '任务号';
comment on column ${iml_schema}.evt_scps_bus_flow.bank_no is '银行行号';
comment on column ${iml_schema}.evt_scps_bus_flow.sys_id is '系统编号';
comment on column ${iml_schema}.evt_scps_bus_flow.sub_task_no is '子任务号';
comment on column ${iml_schema}.evt_scps_bus_flow.init_task_no is '原任务号';
comment on column ${iml_schema}.evt_scps_bus_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_scps_bus_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_scps_bus_flow.blip_flow_num is '影像流水号';
comment on column ${iml_schema}.evt_scps_bus_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_scps_bus_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_scps_bus_flow.bus_scene_id is '业务场景编号';
comment on column ${iml_schema}.evt_scps_bus_flow.bus_proc_prior_level is '业务处理优先级';
comment on column ${iml_schema}.evt_scps_bus_flow.prior_level_descb is '优先级描述';
comment on column ${iml_schema}.evt_scps_bus_flow.opera_mode_cd is '作业模式代码';
comment on column ${iml_schema}.evt_scps_bus_flow.init_teller_id is '发起柜员编号';
comment on column ${iml_schema}.evt_scps_bus_flow.init_org_id is '发起机构编号';
comment on column ${iml_schema}.evt_scps_bus_flow.bus_proc_org_id is '业务处理机构编号';
comment on column ${iml_schema}.evt_scps_bus_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_scps_bus_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_scps_bus_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_scps_bus_flow.task_status_cd is '任务状态代码';
comment on column ${iml_schema}.evt_scps_bus_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_scps_bus_flow.payer_acct_id is '付款人账户编号';
comment on column ${iml_schema}.evt_scps_bus_flow.payer_acct_name is '付款人账户名称';
comment on column ${iml_schema}.evt_scps_bus_flow.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.evt_scps_bus_flow.recver_acct_name is '收款人账户名称';
comment on column ${iml_schema}.evt_scps_bus_flow.ghb_acct_id is '本行账户编号';
comment on column ${iml_schema}.evt_scps_bus_flow.ghb_acct_name is '本行账户名称';
comment on column ${iml_schema}.evt_scps_bus_flow.authoriz_diret_teller_id is '授权主管柜员编号';
comment on column ${iml_schema}.evt_scps_bus_flow.refuse_rs_descb is '拒绝原因描述';
comment on column ${iml_schema}.evt_scps_bus_flow.invalid_tm is '失效时间';
comment on column ${iml_schema}.evt_scps_bus_flow.invalid_dt is '失效日期';
comment on column ${iml_schema}.evt_scps_bus_flow.termnt_rs_descb is '终止原因描述';
comment on column ${iml_schema}.evt_scps_bus_flow.blip_model_id is '影像模型编号';
comment on column ${iml_schema}.evt_scps_bus_flow.blip_upload_tm is '影像上传日期';
comment on column ${iml_schema}.evt_scps_bus_flow.entry_flow_num is '记账流水号';
comment on column ${iml_schema}.evt_scps_bus_flow.entry_dt is '记账日期';
comment on column ${iml_schema}.evt_scps_bus_flow.entry_tm is '记账时间';
comment on column ${iml_schema}.evt_scps_bus_flow.prob_initor_cd is '问题发起端代码';
comment on column ${iml_schema}.evt_scps_bus_flow.remark is '备注';
comment on column ${iml_schema}.evt_scps_bus_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_scps_bus_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_scps_bus_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_scps_bus_flow.etl_timestamp is 'ETL处理时间戳';
