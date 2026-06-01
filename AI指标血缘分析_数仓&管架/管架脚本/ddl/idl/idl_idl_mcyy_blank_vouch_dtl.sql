/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl idl_mcyy_blank_vouch_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_blank_vouch_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_blank_vouch_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_blank_vouch_dtl(
   etl_dt        DATE,
  index_no      VARCHAR2(30),
  index_name    VARCHAR2(200),
  org_no        VARCHAR2(60),
  org_name      VARCHAR2(80),
  super_org_no  VARCHAR2(6),
  blank_num     NUMBER(38,8),
  dev_no        VARCHAR2(20),
  card_no       VARCHAR2(20),
  reason        VARCHAR2(200),
  take_org      VARCHAR2(200),
  rgstrat       VARCHAR2(20),
  rgst_time     VARCHAR2(20),
  proc_ps       VARCHAR2(20),
  proc_time     VARCHAR2(20),
  proc_site     VARCHAR2(200),
  cust_name     VARCHAR2(20),
  card_status   VARCHAR2(20),
  etl_timestamp TIMESTAMP(6),
  source_sys    VARCHAR2(60)
)

partition by list(etl_dt)
subpartition by list(source_sys)
(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
    (
        subpartition p_19000101_d values ('CARD_DTL')
    )
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_blank_vouch_dtl to ${idl_schema};


-- comment  
comment on table MCYY_BLANK_VOUCH_DTL
  is '营运重空明细事实表';
-- Add comments to the columns 
comment on column MCYY_BLANK_VOUCH_DTL.etl_dt
  is 'ETL日期';
comment on column MCYY_BLANK_VOUCH_DTL.index_no
  is '指标编号';
comment on column MCYY_BLANK_VOUCH_DTL.index_name
  is '指标名称';
comment on column MCYY_BLANK_VOUCH_DTL.org_no
  is '机构编号';
comment on column MCYY_BLANK_VOUCH_DTL.org_name
  is '机构名称';
comment on column MCYY_BLANK_VOUCH_DTL.super_org_no
  is '上级机构代码';
comment on column MCYY_BLANK_VOUCH_DTL.blank_num
  is '重空数量';
comment on column MCYY_BLANK_VOUCH_DTL.dev_no
  is '设备编号';
comment on column MCYY_BLANK_VOUCH_DTL.card_no
  is '卡号';
comment on column MCYY_BLANK_VOUCH_DTL.reason
  is '原因';
comment on column MCYY_BLANK_VOUCH_DTL.take_org
  is '处理机构';
comment on column MCYY_BLANK_VOUCH_DTL.rgstrat
  is '登记人';
comment on column MCYY_BLANK_VOUCH_DTL.rgst_time
  is '登记时间';
comment on column MCYY_BLANK_VOUCH_DTL.proc_ps
  is '处理人';
comment on column MCYY_BLANK_VOUCH_DTL.proc_time
  is '处理时间';
comment on column MCYY_BLANK_VOUCH_DTL.proc_site
  is '处理地点';
comment on column MCYY_BLANK_VOUCH_DTL.cust_name
  is '客户姓名';
comment on column MCYY_BLANK_VOUCH_DTL.card_status
  is '吞卡状态';