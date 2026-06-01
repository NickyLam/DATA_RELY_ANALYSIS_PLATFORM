/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_afterpayarrearinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_afterpayarrearinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_afterpayarrearinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_afterpayarrearinfo(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,af_py_btp varchar2(9) -- 后付费业务类型:pc030d01
    ,acc_num number(22) -- 账户数量:pc030s02
    ,inarr_cost_amt number(38,0) -- 拖欠费用金额:pc030j01
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_i_r_afterpayarrearinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_afterpayarrearinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_afterpayarrearinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_afterpayarrearinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_afterpayarrearinfo is '二代后付费业务欠费信息';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.af_py_btp is '后付费业务类型:pc030d01';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.acc_num is '账户数量:pc030s02';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.inarr_cost_amt is '拖欠费用金额:pc030j01';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_afterpayarrearinfo.etl_timestamp is 'ETL处理时间戳';
