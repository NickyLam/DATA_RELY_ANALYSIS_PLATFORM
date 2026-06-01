/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_wrnttxnclsmyinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_wrnttxnclsmyinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_wrnttxnclsmyinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_wrnttxnclsmyinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,smy_tp varchar2(2) -- 汇总类型
    ,entp_wrnt_txn_btp varchar2(2) -- 企业担保交易业务类型(业务类型):eb03ad01
    ,ast_qly_cl varchar2(2) -- 资产质量分类:eb03ad02
    ,acc_num number(22) -- 账户数:eb03as02
    ,bal number(38,0) -- 余额:eb03aj01
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
grant select on ${iol_schema}.cqss_e_r_wrnttxnclsmyinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_wrnttxnclsmyinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_wrnttxnclsmyinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_wrnttxnclsmyinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_wrnttxnclsmyinf is '担保交易分类汇总信息（未结清）';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.smy_tp is '汇总类型';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.entp_wrnt_txn_btp is '企业担保交易业务类型(业务类型):eb03ad01';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.ast_qly_cl is '资产质量分类:eb03ad02';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.acc_num is '账户数:eb03as02';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.bal is '余额:eb03aj01';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_wrnttxnclsmyinf.etl_timestamp is 'ETL处理时间戳';
