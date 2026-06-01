/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_overduesum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_overduesum
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_overduesum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_overduesum(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,odst_btp varchar2(9) -- 逾期状态业务类型:pc02dd01
    ,acc_num number(22) -- 账户数量:pc02ds02
    ,cr_ln_odue_mo_num number(22) -- 征信贷款逾期月份数:pc02ds03
    ,crlnodueblmhtoduetamt number(38,0) -- 征信贷款逾期单月最高逾期总额:pc02dj01
    ,cr_lgst_odue_monum number(22) -- 征信最长逾期月数:pc02ds04
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
grant select on ${iol_schema}.cqss_i_r_overduesum to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_overduesum to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_overduesum to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_overduesum to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_overduesum is '二代逾期（透支)信息汇总';
comment on column ${iol_schema}.cqss_i_r_overduesum.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_overduesum.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_overduesum.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_overduesum.odst_btp is '逾期状态业务类型:pc02dd01';
comment on column ${iol_schema}.cqss_i_r_overduesum.acc_num is '账户数量:pc02ds02';
comment on column ${iol_schema}.cqss_i_r_overduesum.cr_ln_odue_mo_num is '征信贷款逾期月份数:pc02ds03';
comment on column ${iol_schema}.cqss_i_r_overduesum.crlnodueblmhtoduetamt is '征信贷款逾期单月最高逾期总额:pc02dj01';
comment on column ${iol_schema}.cqss_i_r_overduesum.cr_lgst_odue_monum is '征信最长逾期月数:pc02ds04';
comment on column ${iol_schema}.cqss_i_r_overduesum.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_overduesum.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_overduesum.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_overduesum.etl_timestamp is 'ETL处理时间戳';
