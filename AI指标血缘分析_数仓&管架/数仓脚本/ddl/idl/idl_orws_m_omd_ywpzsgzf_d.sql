/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_ywpzsgzf_d
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_ywpzsgzf_d
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_ywpzsgzf_d purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_ywpzsgzf_d(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 日期
    ,branch_code varchar2(16) -- 机构
    ,branch_name varchar2(50) -- 机构名称
    ,jyrq varchar2(8) -- 交易日期
    ,yg_name varchar2(20) -- 员工名称
    ,acc_code varchar2(16) -- 科目代码
    ,acc_name varchar2(40) -- 科目名称
    ,lsh varchar2(20) -- 流水号
    ,opertordt varchar2(40) -- 操作时间
    ,cnt number -- 作废数量
    ,processor varchar2(400) -- 跟踪处理情况
    ,menuid varchar2(20) -- 交易码
    ,menuname varchar2(80) -- 交易名称
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.orws_m_omd_ywpzsgzf_d to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_ywpzsgzf_d is '业务凭证手工作废监控统计表';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.date_id is '日期';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.branch_code is '机构';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.branch_name is '机构名称';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.jyrq is '交易日期';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.yg_name is '员工名称';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.acc_code is '科目代码';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.acc_name is '科目名称';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.lsh is '流水号';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.opertordt is '操作时间';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.cnt is '作废数量';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.processor is '跟踪处理情况';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.menuid is '交易码';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.menuname is '交易名称';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_ywpzsgzf_d.etl_timestamp is 'ETL处理时间戳';
