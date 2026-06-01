/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_wrntaccbscinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_wrntaccbscinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_wrntaccbscinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_wrntaccbscinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,wrnt_acc_id varchar2(11) -- 担保账户编号:ed04ai01
    ,wrnt_acc_tp varchar2(3) -- 担保账户编号:ed04ai01
    ,inst_tp varchar2(45) -- 机构类型(业务管理机构类型):ed04ad02
    ,mtit_ecd varchar2(192) -- 管理机构编码(业务管理机构代码):ed04ai02
    ,crg_agrm_id varchar2(9) -- 授信协议编号:ed04ai03
    ,wrnt_txn_bnctg_sbdvsn varchar2(6) -- 担保交易业务种类细分:ed04ad03
    ,ftm_estb_dt date -- 首次开立日期(开立日期):ed04ar01
    ,ccycd varchar2(5) -- 币种代码(币种):ed04ad04
    ,bnk_lnd_amt number(38,0) -- 银行借款金额(金额):ed04aj01
    ,exdat date -- 到期日期:ed04ar02
    ,anti_grtstl varchar2(2) -- 反担保方式:ed04ad05
    ,wrntaccothrreygrntmod varchar2(2) -- 担保账户其它还款保证方式:ed04ad06
    ,mrgn_pct number(20,2) -- 保证金比例:ed04aq01
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
grant select on ${iol_schema}.cqss_e_r_wrntaccbscinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_wrntaccbscinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_wrntaccbscinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_wrntaccbscinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_wrntaccbscinf is '担保账户基本信息';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.wrnt_acc_id is '担保账户编号:ed04ai01';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.wrnt_acc_tp is '担保账户编号:ed04ai01';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.inst_tp is '机构类型(业务管理机构类型):ed04ad02';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.mtit_ecd is '管理机构编码(业务管理机构代码):ed04ai02';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.crg_agrm_id is '授信协议编号:ed04ai03';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.wrnt_txn_bnctg_sbdvsn is '担保交易业务种类细分:ed04ad03';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.ftm_estb_dt is '首次开立日期(开立日期):ed04ar01';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.ccycd is '币种代码(币种):ed04ad04';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.bnk_lnd_amt is '银行借款金额(金额):ed04aj01';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.exdat is '到期日期:ed04ar02';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.anti_grtstl is '反担保方式:ed04ad05';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.wrntaccothrreygrntmod is '担保账户其它还款保证方式:ed04ad06';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.mrgn_pct is '保证金比例:ed04aq01';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_wrntaccbscinf.etl_timestamp is 'ETL处理时间戳';
