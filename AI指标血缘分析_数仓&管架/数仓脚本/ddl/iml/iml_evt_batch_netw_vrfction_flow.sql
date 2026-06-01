/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_batch_netw_vrfction_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_batch_netw_vrfction_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_batch_netw_vrfction_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_netw_vrfction_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_dt date -- 批次日期
    ,batch_id varchar2(100) -- 批次编号
    ,batch_seq_num varchar2(60) -- 批次序号
    ,netw_vrfction_ser_num varchar2(100) -- 联网核查序列号
    ,netw_vrfction_dt date -- 联网核查日期
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_num varchar2(60) -- 证件号码
    ,cert_name varchar2(500) -- 证件姓名
    ,msg_id varchar2(100) -- 报文编号
    ,sys_cd varchar2(30) -- 系统代码
    ,ibank_no varchar2(60) -- 联行号
    ,org_id varchar2(100) -- 机构编号
    ,vrfction_pass_cd varchar2(30) -- 核查通道代码
    ,vrfction_dept_cd varchar2(30) -- 核查部门代码
    ,vrfction_type_cd varchar2(30) -- 核查类型代码
    ,bus_kind_cd varchar2(30) -- 业务种类代码
    ,midgrod_flow_num varchar2(250) -- 中台流水号
    ,check_rest_cd varchar2(30) -- 验证结果代码
    ,check_status_cd varchar2(30) -- 验证状态代码
    ,valid_rec_flg varchar2(10) -- 有效记录标志
    ,export_status_cd varchar2(30) -- 导出状态代码
    ,vrfction_status_cd varchar2(30) -- 核查状态代码
    ,aldy_stat_flg varchar2(10) -- 已统计标志
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
grant select on ${iml_schema}.evt_batch_netw_vrfction_flow to ${icl_schema};
grant select on ${iml_schema}.evt_batch_netw_vrfction_flow to ${idl_schema};
grant select on ${iml_schema}.evt_batch_netw_vrfction_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_batch_netw_vrfction_flow is '批量联网核查流水';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.batch_dt is '批次日期';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.batch_id is '批次编号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.batch_seq_num is '批次序号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.netw_vrfction_ser_num is '联网核查序列号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.netw_vrfction_dt is '联网核查日期';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.cert_num is '证件号码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.cert_name is '证件姓名';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.msg_id is '报文编号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.sys_cd is '系统代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.ibank_no is '联行号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.vrfction_pass_cd is '核查通道代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.vrfction_dept_cd is '核查部门代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.vrfction_type_cd is '核查类型代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.bus_kind_cd is '业务种类代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.check_rest_cd is '验证结果代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.check_status_cd is '验证状态代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.valid_rec_flg is '有效记录标志';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.export_status_cd is '导出状态代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.vrfction_status_cd is '核查状态代码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.aldy_stat_flg is '已统计标志';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_batch_netw_vrfction_flow.etl_timestamp is 'ETL处理时间戳';
