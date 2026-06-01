/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_gsdjb_d
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_gsdjb_d
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_gsdjb_d purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_gsdjb_d(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 业务日期
    ,indexno number -- 序号
    ,brchno varchar2(10) -- 开户机构
    ,rplssq varchar2(20) -- 挂失登记号
    ,rplsdt varchar2(8) -- 挂失日期
    ,acctno varchar2(40) -- 账号
    ,acctna varchar2(80) -- 户名
    ,rplsfs varchar2(30) -- 挂失方式
    ,dcmttp varchar2(30) -- 凭证类型
    ,dcmtno varchar2(20) -- 凭证号
    ,rplstp varchar2(30) -- 挂失种类  
    ,idtftp varchar2(30) -- 证件类型
    ,idtfno varchar2(20) -- 证件号码
    ,agcuna varchar2(20) -- 代理人
    ,agidtp varchar2(30) -- 代理证件类型
    ,agidno varchar2(20) -- 代理证件号码
    ,rplsus varchar2(20) -- 挂失柜员
    ,authus varchar2(20) -- 挂失授权人
    ,unlsus varchar2(10) -- 解挂柜员
    ,ckbkus varchar2(10) -- 解挂授权人
    ,unlsdt varchar2(8) -- 处理日期
    ,unchtg varchar2(20) -- 处理结果
    ,ugcuna varchar2(16) -- 代理人
    ,ugidtp varchar2(20) -- 代理证件类型
    ,ugidno varchar2(20) -- 代理证件号码
    ,tranbr varchar2(10) -- 
    ,gstranti varchar2(25) -- 
    ,gsrplssq varchar2(20) -- 
    ,gsservtp varchar2(8) -- 
    ,jgtranti varchar2(25) -- 
    ,unlssq varchar2(20) -- 
    ,jgservtp varchar2(8) -- 
    ,transq varchar2(20) -- 
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
grant select on ${idl_schema}.orws_m_omd_gsdjb_d to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_gsdjb_d is '凭证、现金调配登记簿';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.date_id is '业务日期';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.indexno is '序号';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.brchno is '开户机构';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.rplssq is '挂失登记号';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.rplsdt is '挂失日期';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.acctno is '账号';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.acctna is '户名';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.rplsfs is '挂失方式';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.dcmttp is '凭证类型';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.dcmtno is '凭证号';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.rplstp is '挂失种类  ';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.idtftp is '证件类型';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.idtfno is '证件号码';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.agcuna is '代理人';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.agidtp is '代理证件类型';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.agidno is '代理证件号码';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.rplsus is '挂失柜员';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.authus is '挂失授权人';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.unlsus is '解挂柜员';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.ckbkus is '解挂授权人';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.unlsdt is '处理日期';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.unchtg is '处理结果';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.ugcuna is '代理人';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.ugidtp is '代理证件类型';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.ugidno is '代理证件号码';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.tranbr is '';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.gstranti is '';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.gsrplssq is '';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.gsservtp is '';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.jgtranti is '';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.unlssq is '';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.jgservtp is '';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.transq is '';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_gsdjb_d.etl_timestamp is 'ETL处理时间戳';
