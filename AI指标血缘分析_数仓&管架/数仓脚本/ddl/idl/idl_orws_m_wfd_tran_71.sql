/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_wfd_tran_71
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_wfd_tran_71
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_wfd_tran_71 purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_wfd_tran_71(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 业务日期
    ,brchno varchar2(10) -- 交易机构
    ,frozdt varchar2(8) -- 交易日期
    ,acctno varchar2(40) -- 账号
    ,acctna varchar2(80) -- 户名
    ,subsac varchar2(5) -- 子户号
    ,refram number -- 申请金额
    ,cufram number -- 交易金额
    ,matudt varchar2(8) -- 截至日期
    ,frsptp varchar2(20) -- 冻结止付类型
    ,userid varchar2(30) -- 交易柜员 
    ,sqgy_id varchar2(30) -- 授权柜员
    ,exorgn varchar2(40) -- 执行机关
    ,idtftp_na varchar2(8) -- 证明类型
    ,idtfno varchar2(200) -- 证明书号
    ,exusna1 varchar2(20) -- 执行人1
    ,exusna2 varchar2(20) -- 执行人2
    ,exidtp varchar2(20) -- 证件一
    ,exidno varchar2(48) -- 号码一
    ,eidtp2 varchar2(20) -- 证件二
    ,eidno2 varchar2(48) -- 号码二
    ,frozsq varchar2(32) -- 冻结/止付流水号
    ,status varchar2(10) -- 状态
    ,remktx varchar2(100) -- 冻结/止付原因
    ,jysj varchar2(10) -- 
    ,jyls varchar2(40) -- 
    ,jqrq varchar2(20) -- 
    ,jqsj varchar2(20) -- 
    ,jqls varchar2(32) -- 
    ,jqgy varchar2(20) -- 
    ,jqsqgy varchar2(20) -- 
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
grant select on ${idl_schema}.orws_m_wfd_tran_71 to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_wfd_tran_71 is '71_冻结止付登记簿';
comment on column ${idl_schema}.orws_m_wfd_tran_71.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_wfd_tran_71.date_id is '业务日期';
comment on column ${idl_schema}.orws_m_wfd_tran_71.brchno is '交易机构';
comment on column ${idl_schema}.orws_m_wfd_tran_71.frozdt is '交易日期';
comment on column ${idl_schema}.orws_m_wfd_tran_71.acctno is '账号';
comment on column ${idl_schema}.orws_m_wfd_tran_71.acctna is '户名';
comment on column ${idl_schema}.orws_m_wfd_tran_71.subsac is '子户号';
comment on column ${idl_schema}.orws_m_wfd_tran_71.refram is '申请金额';
comment on column ${idl_schema}.orws_m_wfd_tran_71.cufram is '交易金额';
comment on column ${idl_schema}.orws_m_wfd_tran_71.matudt is '截至日期';
comment on column ${idl_schema}.orws_m_wfd_tran_71.frsptp is '冻结止付类型';
comment on column ${idl_schema}.orws_m_wfd_tran_71.userid is '交易柜员 ';
comment on column ${idl_schema}.orws_m_wfd_tran_71.sqgy_id is '授权柜员';
comment on column ${idl_schema}.orws_m_wfd_tran_71.exorgn is '执行机关';
comment on column ${idl_schema}.orws_m_wfd_tran_71.idtftp_na is '证明类型';
comment on column ${idl_schema}.orws_m_wfd_tran_71.idtfno is '证明书号';
comment on column ${idl_schema}.orws_m_wfd_tran_71.exusna1 is '执行人1';
comment on column ${idl_schema}.orws_m_wfd_tran_71.exusna2 is '执行人2';
comment on column ${idl_schema}.orws_m_wfd_tran_71.exidtp is '证件一';
comment on column ${idl_schema}.orws_m_wfd_tran_71.exidno is '号码一';
comment on column ${idl_schema}.orws_m_wfd_tran_71.eidtp2 is '证件二';
comment on column ${idl_schema}.orws_m_wfd_tran_71.eidno2 is '号码二';
comment on column ${idl_schema}.orws_m_wfd_tran_71.frozsq is '冻结/止付流水号';
comment on column ${idl_schema}.orws_m_wfd_tran_71.status is '状态';
comment on column ${idl_schema}.orws_m_wfd_tran_71.remktx is '冻结/止付原因';
comment on column ${idl_schema}.orws_m_wfd_tran_71.jysj is '';
comment on column ${idl_schema}.orws_m_wfd_tran_71.jyls is '';
comment on column ${idl_schema}.orws_m_wfd_tran_71.jqrq is '';
comment on column ${idl_schema}.orws_m_wfd_tran_71.jqsj is '';
comment on column ${idl_schema}.orws_m_wfd_tran_71.jqls is '';
comment on column ${idl_schema}.orws_m_wfd_tran_71.jqgy is '';
comment on column ${idl_schema}.orws_m_wfd_tran_71.jqsqgy is '';
comment on column ${idl_schema}.orws_m_wfd_tran_71.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_wfd_tran_71.etl_timestamp is 'ETL处理时间戳';
