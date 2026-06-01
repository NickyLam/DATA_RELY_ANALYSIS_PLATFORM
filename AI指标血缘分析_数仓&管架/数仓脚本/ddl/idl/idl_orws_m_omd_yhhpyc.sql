/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_yhhpyc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_yhhpyc
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_yhhpyc purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_yhhpyc(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 数据日期
    ,gs_no number -- 序号
    ,cshpbillnb varchar2(20) -- 汇票号码
    ,cshpbilltype varchar2(4) -- 汇票类型
    ,hpstatus varchar2(1) -- 记账状态
    ,billst varchar2(2) -- 汇票状态
    ,cshpbillamt number -- 出票金额
    ,paybrnno varchar2(14) -- 签发行行号 
    ,cshpbilldate varchar2(8) -- 签发日期
    ,payacct varchar2(35) -- 申请人账号
    ,payname varchar2(120) -- 申请人名称
    ,tranus varchar2(10) -- 交易柜员
    ,ckbkus varchar2(10) -- 复核柜员
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
grant select on ${idl_schema}.orws_m_omd_yhhpyc to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_yhhpyc is '376_银行汇票状态异常报表';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.date_id is '数据日期';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.gs_no is '序号';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.cshpbillnb is '汇票号码';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.cshpbilltype is '汇票类型';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.hpstatus is '记账状态';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.billst is '汇票状态';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.cshpbillamt is '出票金额';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.paybrnno is '签发行行号 ';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.cshpbilldate is '签发日期';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.payacct is '申请人账号';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.payname is '申请人名称';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.tranus is '交易柜员';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.ckbkus is '复核柜员';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_yhhpyc.etl_timestamp is 'ETL处理时间戳';
