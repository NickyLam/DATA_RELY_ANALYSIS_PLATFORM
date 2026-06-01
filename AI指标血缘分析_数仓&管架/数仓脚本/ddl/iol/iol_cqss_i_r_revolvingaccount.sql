/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_revolvingaccount
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_revolvingaccount
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_revolvingaccount purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_revolvingaccount(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,crnotclsgllpsninstnum number(22) -- 征信未结清贷款法人机构数:pc02gs01
    ,acc_num number(22) -- 账户数量:pc02gs02
    ,crgln number(38,0) -- 授信总额:pc02gj01
    ,cr_not_clsg_lnbal number(38,0) -- 征信未结清贷款余额:pc02gj02
    ,crnotclr6mashldrepymt number(38,0) -- 征信未结清贷款最近6月平均应还款:pc02gj03
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
    ,rctly6_etrs_mo_avg_bal number(38,0) -- 最近 6 个月平均应还款
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
grant select on ${iol_schema}.cqss_i_r_revolvingaccount to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_revolvingaccount to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_revolvingaccount to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_revolvingaccount to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_revolvingaccount is '二代循环贷账户信息';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.crnotclsgllpsninstnum is '征信未结清贷款法人机构数:pc02gs01';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.acc_num is '账户数量:pc02gs02';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.crgln is '授信总额:pc02gj01';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.cr_not_clsg_lnbal is '征信未结清贷款余额:pc02gj02';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.crnotclr6mashldrepymt is '征信未结清贷款最近6月平均应还款:pc02gj03';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.rctly6_etrs_mo_avg_bal is '最近 6 个月平均应还款';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_revolvingaccount.etl_timestamp is 'ETL处理时间戳';
