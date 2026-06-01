/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_busiform_nonwarn_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_busiform_nonwarn_tb
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_busiform_nonwarn_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_busiform_nonwarn_tb(
    form_id varchar2(57) -- 处理单编号
    ,warn_id varchar2(150) -- ID
    ,order_mainstay_no varchar2(270) -- 账户号
    ,is_accno_deal varchar2(60) -- 是否处置账户
    ,deal_date varchar2(150) -- 处置日期
    ,deal_status varchar2(30) -- 处置方式（1、合理 2、预警）
    ,deal_type varchar2(30) -- 下发方式（1、手动）
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.alss_am_busiform_nonwarn_tb to ${iml_schema};
grant select on ${iol_schema}.alss_am_busiform_nonwarn_tb to ${icl_schema};
grant select on ${iol_schema}.alss_am_busiform_nonwarn_tb to ${idl_schema};
grant select on ${iol_schema}.alss_am_busiform_nonwarn_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_busiform_nonwarn_tb is '风险单号联系表';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.form_id is '处理单编号';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.warn_id is 'ID';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.order_mainstay_no is '账户号';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.is_accno_deal is '是否处置账户';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.deal_date is '处置日期';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.deal_status is '处置方式（1、合理 2、预警）';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.deal_type is '下发方式（1、手动）';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_am_busiform_nonwarn_tb.etl_timestamp is 'ETL处理时间戳';
