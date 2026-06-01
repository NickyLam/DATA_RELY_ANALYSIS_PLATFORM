/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_m_omd_dxezfxtwfh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_m_omd_dxezfxtwfh
whenever sqlerror continue none;
drop table ${idl_schema}.orws_m_omd_dxezfxtwfh purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_m_omd_dxezfxtwfh(
    etl_dt date -- ETL处理日期
    ,date_id varchar2(8) -- 数据日期
    ,jbwd varchar2(8) -- 经办网点
    ,lrrqjsj varchar2(14) -- 录入日期及时间
    ,jbgy varchar2(16) -- 经办柜员
    ,sqgy varchar2(16) -- 授权柜员
    ,zfjyxh varchar2(16) -- 支付交易序号
    ,jyls varchar2(12) -- 交易流水
    ,ywzt varchar2(2) -- 业务状态
    ,sjfkrzh varchar2(35) -- 实际付款人账号
    ,sjfkrmc varchar2(100) -- 实际付款人名称
    ,jyje number -- 交易金额
    ,jbwdmc varchar2(80) -- 机构名称
    ,zfxt varchar2(20) -- 支付系统
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
grant select on ${idl_schema}.orws_m_omd_dxezfxtwfh to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_m_omd_dxezfxtwfh is '大小额支付系统未复核';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.date_id is '数据日期';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.jbwd is '经办网点';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.lrrqjsj is '录入日期及时间';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.jbgy is '经办柜员';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.sqgy is '授权柜员';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.zfjyxh is '支付交易序号';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.jyls is '交易流水';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.ywzt is '业务状态';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.sjfkrzh is '实际付款人账号';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.sjfkrmc is '实际付款人名称';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.jyje is '交易金额';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.jbwdmc is '机构名称';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.zfxt is '支付系统';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.job_cd is '任务代码';
comment on column ${idl_schema}.orws_m_omd_dxezfxtwfh.etl_timestamp is 'ETL处理时间戳';
