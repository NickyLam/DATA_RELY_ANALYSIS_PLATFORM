/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ponl_batch_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ponl_batch_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ponl_batch_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ponl_batch_tran_flow(
    evt_id varchar(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,onl_tran_flow_num varchar2(100) -- 网银交易流水号
    ,batch_id varchar2(100) -- 批次编号
    ,cust_id varchar2(100) -- cust_id
    ,dept_id varchar2(100) -- 部门编号
    ,save_cert_way_cd varchar2(30) -- 安全认证方式代码
    ,auth_type_cd varchar2(30) -- 授权类型代码
    ,tot number(30) -- 总笔数
    ,tot_amt number(30,8) -- 总金额
    ,sucs_cnt number(30) -- 成功次数
    ,sucs_amt number(30,8) -- 成功金额
    ,fail_cnt number(30) -- 失败次数
    ,fail_amt number(30,8) -- 失败金额
    ,tran_dt varchar2(20) -- 交易日期
    ,tran_timestamp timestamp -- 交易时间戳
    ,tran_code varchar2(60) -- 交易码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,batch_data_src_cd varchar2(30) -- 批量数据来源代码
    ,tran_way_cd varchar2(30) -- 转出方式代码
    ,tran_out_dt date -- 转出日期
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
grant select on ${iml_schema}.evt_ponl_batch_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ponl_batch_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ponl_batch_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ponl_batch_tran_flow is '个人网银批量交易流水';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.onl_tran_flow_num is '网银交易流水号';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.batch_id is '批次编号';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.dept_id is '部门编号';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.save_cert_way_cd is '安全认证方式代码';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.auth_type_cd is '授权类型代码';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.tot is '总笔数';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.tot_amt is '总金额';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.sucs_cnt is '成功次数';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.sucs_amt is '成功金额';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.fail_cnt is '失败次数';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.fail_amt is '失败金额';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.tran_timestamp is '交易时间戳';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.batch_data_src_cd is '批量数据来源代码';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.tran_way_cd is '转出方式代码';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.tran_out_dt is '转出日期';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ponl_batch_tran_flow.etl_timestamp is 'ETL处理时间戳';
