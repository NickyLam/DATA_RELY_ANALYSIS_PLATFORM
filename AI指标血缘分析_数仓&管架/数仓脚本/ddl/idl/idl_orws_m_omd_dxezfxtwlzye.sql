/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_dxezfxtwlzye
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_dxezfxtwlzye
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_dxezfxtwlzye purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_dxezfxtwlzye(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 数据日期
    ,jg varchar2(10) -- 机构
    ,khwd varchar2(80) -- 开户网点
    ,gzzh varchar2(40) -- 挂账账号
    ,zhmc varchar2(80) -- 账户名称
    ,ye number -- 余额
    ,km varchar2(20) -- 科目
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
grant select on ${idl_schema}.orws_m_omd_dxezfxtwlzye to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_dxezfxtwlzye is '大小额支付系统往来账余额';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.date_id is '数据日期';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.jg is '机构';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.khwd is '开户网点';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.gzzh is '挂账账号';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.zhmc is '账户名称';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.ye is '余额';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.km is '科目';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwlzye.etl_timestamp is 'ETL处理时间戳';
