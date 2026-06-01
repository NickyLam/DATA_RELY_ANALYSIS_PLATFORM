/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bus_rela_msg_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bus_rela_msg_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bus_rela_msg_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bus_rela_msg_flow(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_msg_flow_num varchar2(60) -- 业务报文流水号
    ,msg_analy_id varchar2(60) -- 报文解析编号
    ,tran_sender varchar2(90) -- 交易发送方
    ,tran_recver varchar2(90) -- 交易接收方
    ,msg_ind_no varchar2(60) -- 报文标识号
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,msg_id varchar2(60) -- 报文编号
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,msg_dir_cd varchar2(10) -- 报文方向代码
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
grant select on ${iml_schema}.evt_bus_rela_msg_flow to ${icl_schema};
grant select on ${iml_schema}.evt_bus_rela_msg_flow to ${idl_schema};
grant select on ${iml_schema}.evt_bus_rela_msg_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bus_rela_msg_flow is '业务相关报文流水事件';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.bus_msg_flow_num is '业务报文流水号';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.msg_analy_id is '报文解析编号';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.tran_sender is '交易发送方';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.tran_recver is '交易接收方';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.msg_ind_no is '报文标识号';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.msg_id is '报文编号';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.msg_dir_cd is '报文方向代码';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bus_rela_msg_flow.etl_timestamp is 'ETL处理时间戳';
