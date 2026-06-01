/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bcdl_tran_msg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bcdl_tran_msg
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bcdl_tran_msg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bcdl_tran_msg(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 交易客户编号
    ,corp_work_dt date -- 企业工作日期
    ,corp_flow_num varchar2(60) -- 企业流水号
    ,sign_id varchar2(60) -- 签约编号
    ,acct_num varchar2(60) -- 账号
    ,tran_cd varchar2(10) -- 交易代码
    ,sorc_sys_tran_timestamp timestamp -- 源系统交易时间戳
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
grant select on ${iml_schema}.evt_bcdl_tran_msg to ${icl_schema};
grant select on ${iml_schema}.evt_bcdl_tran_msg to ${idl_schema};
grant select on ${iml_schema}.evt_bcdl_tran_msg to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bcdl_tran_msg is '银企直联交易报文';
comment on column ${iml_schema}.evt_bcdl_tran_msg.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bcdl_tran_msg.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bcdl_tran_msg.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_bcdl_tran_msg.corp_work_dt is '企业工作日期';
comment on column ${iml_schema}.evt_bcdl_tran_msg.corp_flow_num is '企业流水号';
comment on column ${iml_schema}.evt_bcdl_tran_msg.sign_id is '签约编号';
comment on column ${iml_schema}.evt_bcdl_tran_msg.acct_num is '账号';
comment on column ${iml_schema}.evt_bcdl_tran_msg.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_bcdl_tran_msg.sorc_sys_tran_timestamp is '源系统交易时间戳';
comment on column ${iml_schema}.evt_bcdl_tran_msg.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bcdl_tran_msg.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bcdl_tran_msg.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bcdl_tran_msg.etl_timestamp is 'ETL处理时间戳';
