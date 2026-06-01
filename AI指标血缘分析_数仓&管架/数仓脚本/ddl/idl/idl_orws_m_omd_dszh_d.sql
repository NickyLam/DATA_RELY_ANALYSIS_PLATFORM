/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_dszh_d
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_dszh_d
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_dszh_d purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_dszh_d(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 会计日期
    ,branch_code varchar2(16) -- 机构
    ,branch_name varchar2(50) -- 机构名称
    ,custno varchar2(20) -- 客户号
    ,acctno varchar2(40) -- 账户
    ,acctna varchar2(40) -- 客户名称
    ,certtp varchar2(40) -- 证件类型
    ,certno varchar2(40) -- 证件号码
    ,tel varchar2(20) -- 手机
    ,opendate varchar2(8) -- 开户日期
    ,processor varchar2(400) -- 监控情况
    ,openti varchar2(30) -- 交易时间
    ,transq varchar2(50) -- 交易流水
    ,tran_user varchar2(30) -- 经办柜员
    ,usernam varchar2(30) -- 经办柜员名
    ,branch_code_ex varchar2(16) -- 最近开户机构
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
grant select on ${idl_schema}.orws_m_omd_dszh_d to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_dszh_d is '对私账户监控统计表';
comment on column ${idl_schema}.orws_m_omd_dszh_d.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_dszh_d.date_id is '会计日期';
comment on column ${idl_schema}.orws_m_omd_dszh_d.branch_code is '机构';
comment on column ${idl_schema}.orws_m_omd_dszh_d.branch_name is '机构名称';
comment on column ${idl_schema}.orws_m_omd_dszh_d.custno is '客户号';
comment on column ${idl_schema}.orws_m_omd_dszh_d.acctno is '账户';
comment on column ${idl_schema}.orws_m_omd_dszh_d.acctna is '客户名称';
comment on column ${idl_schema}.orws_m_omd_dszh_d.certtp is '证件类型';
comment on column ${idl_schema}.orws_m_omd_dszh_d.certno is '证件号码';
comment on column ${idl_schema}.orws_m_omd_dszh_d.tel is '手机';
comment on column ${idl_schema}.orws_m_omd_dszh_d.opendate is '开户日期';
comment on column ${idl_schema}.orws_m_omd_dszh_d.processor is '监控情况';
comment on column ${idl_schema}.orws_m_omd_dszh_d.openti is '交易时间';
comment on column ${idl_schema}.orws_m_omd_dszh_d.transq is '交易流水';
comment on column ${idl_schema}.orws_m_omd_dszh_d.tran_user is '经办柜员';
comment on column ${idl_schema}.orws_m_omd_dszh_d.usernam is '经办柜员名';
comment on column ${idl_schema}.orws_m_omd_dszh_d.branch_code_ex is '最近开户机构';
comment on column ${idl_schema}.orws_m_omd_dszh_d.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_dszh_d.etl_timestamp is 'ETL处理时间戳';
