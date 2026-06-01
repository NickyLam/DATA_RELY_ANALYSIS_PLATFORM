/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_arrearage_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_arrearage_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_arrearage_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_arrearage_hist(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,company varchar2(20) -- 法人
    ,osd_status varchar2(1) -- 欠费状态
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,seq_no varchar2(50) -- 序号
    ,osd_date date -- 欠费日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,oth_internal_key number(15) -- 对手账户内部键
    ,total_arre_expense number(17,2) -- 欠付
    ,total_arre_income number(17,2) -- 欠收
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
grant select on ${iol_schema}.ncbs_rb_pcp_arrearage_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_arrearage_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_arrearage_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_arrearage_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_arrearage_hist is '资金池周期扣划欠费明细表';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.osd_status is '欠费状态';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.osd_date is '欠费日期';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.total_arre_expense is '欠付';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.total_arre_income is '欠收';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_pcp_arrearage_hist.etl_timestamp is 'ETL处理时间戳';
