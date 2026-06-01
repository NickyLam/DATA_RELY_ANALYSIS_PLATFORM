/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_creditrecovery
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_creditrecovery
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_creditrecovery purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_creditrecovery(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,pbc_be_rec_btp varchar2(9) -- 人行被追偿业务类型:pc02bd01
    ,acc_num number(22) -- 账户数量:pc02bs03
    ,cr_not_clsg_lnbal number(38,0) -- 征信未结清贷款余额:pc02bj02
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
grant select on ${iol_schema}.cqss_i_r_creditrecovery to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_creditrecovery to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_creditrecovery to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_creditrecovery to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_creditrecovery is '二代被追偿汇总信息';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.pbc_be_rec_btp is '人行被追偿业务类型:pc02bd01';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.acc_num is '账户数量:pc02bs03';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.cr_not_clsg_lnbal is '征信未结清贷款余额:pc02bj02';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_creditrecovery.etl_timestamp is 'ETL处理时间戳';
