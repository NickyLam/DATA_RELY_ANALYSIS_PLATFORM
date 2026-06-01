/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_cdgh_d
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_cdgh_d
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_cdgh_d purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_cdgh_d(
    etl_dt date -- ETL处理日期
    ,ods_src_dt varchar2(8) -- 会计日期
    ,trandt varchar2(8) -- 交易日期
    ,branch_name varchar2(80) -- 上级机构
    ,tranbr varchar2(10) -- 交易机构编码
    ,brchna varchar2(64) -- 交易机构名称
    ,acctno varchar2(40) -- 帐号
    ,acctna varchar2(80) -- 账户名称
    ,accttp varchar2(100) -- 账户性质
    ,bus_type varchar2(100) -- 业务类型
    ,trantime varchar2(16) -- 交易时间
    ,transq varchar2(20) -- 交易流水
    ,tranus varchar2(10) -- 交易柜员号
    ,userna varchar2(16) -- 交易柜员名
    ,tranam number -- 交易金额
    ,processor varchar2(27) -- 异常原因
    ,authnam varchar2(20) -- 授权柜员名称
    ,authus varchar2(16) -- 授权柜员号
    ,dcmttp varchar2(10) -- 凭证类型
    ,menuid varchar2(10) -- 交易码
    ,menunam varchar2(64) -- 交易名称
    ,acct_branchno varchar2(20) -- 开户机构号
    ,acct_branchnam varchar2(60) -- 开户机构名称
    ,dcmtno varchar2(20) -- 凭证号
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
grant select on ${idl_schema}.orws_m_omd_cdgh_d to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_cdgh_d is '存单更换异常表';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.ods_src_dt is '会计日期';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.trandt is '交易日期';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.branch_name is '上级机构';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.tranbr is '交易机构编码';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.brchna is '交易机构名称';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.acctno is '帐号';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.acctna is '账户名称';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.accttp is '账户性质';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.bus_type is '业务类型';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.trantime is '交易时间';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.transq is '交易流水';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.tranus is '交易柜员号';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.userna is '交易柜员名';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.tranam is '交易金额';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.processor is '异常原因';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.authnam is '授权柜员名称';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.authus is '授权柜员号';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.dcmttp is '凭证类型';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.menuid is '交易码';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.menunam is '交易名称';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.acct_branchno is '开户机构号';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.acct_branchnam is '开户机构名称';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.dcmtno is '凭证号';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_cdgh_d.etl_timestamp is 'ETL处理时间戳';
