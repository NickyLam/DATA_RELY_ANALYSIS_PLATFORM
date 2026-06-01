/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_credittradecue
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_credittradecue
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_credittradecue purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_credittradecue(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,crln_txn_btp varchar2(9) -- 信贷交易业务类型:pc02ad01
    ,crln_txn_bsn_lrgclss varchar2(9) -- 信贷交易业务大类:pc02ad02
    ,acc_num number(22) -- 账户数量:pc02as03
    ,cr_int_ln_dstr_yrmo varchar2(11) -- 征信首笔贷款发放年月:pc02ar01
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
grant select on ${iol_schema}.cqss_i_r_credittradecue to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_credittradecue to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_credittradecue to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_credittradecue to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_credittradecue is '二代信贷交易提示信息';
comment on column ${iol_schema}.cqss_i_r_credittradecue.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_credittradecue.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_credittradecue.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_credittradecue.crln_txn_btp is '信贷交易业务类型:pc02ad01';
comment on column ${iol_schema}.cqss_i_r_credittradecue.crln_txn_bsn_lrgclss is '信贷交易业务大类:pc02ad02';
comment on column ${iol_schema}.cqss_i_r_credittradecue.acc_num is '账户数量:pc02as03';
comment on column ${iol_schema}.cqss_i_r_credittradecue.cr_int_ln_dstr_yrmo is '征信首笔贷款发放年月:pc02ar01';
comment on column ${iol_schema}.cqss_i_r_credittradecue.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_credittradecue.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_credittradecue.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_credittradecue.etl_timestamp is 'ETL处理时间戳';
