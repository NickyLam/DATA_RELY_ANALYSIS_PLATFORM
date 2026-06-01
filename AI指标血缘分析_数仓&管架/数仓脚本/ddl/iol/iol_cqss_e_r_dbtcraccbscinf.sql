/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_dbtcraccbscinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_dbtcraccbscinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_dbtcraccbscinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_dbtcraccbscinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,dbtcr_acc_id varchar2(11) -- 借贷账户编号:ed01ai01
    ,acc_avy_st varchar2(3) -- 账户活动状态:ed01ad01
    ,dbtcr_acc_tp varchar2(3) -- 借贷账户类型:ed01ad02
    ,lnd_ddln varchar2(3) -- 借款期限:ed01ad03
    ,inst_tp varchar2(45) -- 机构类型(业务管理机构类型):ed01ad04
    ,mtit_ecd varchar2(192) -- 管理机构编码(业务管理机构代码):ed01ai02
    ,crg_agrm_id varchar2(9) -- 授信协议编号:ed01ai03
    ,dbtcr_bnctg_lrgclss varchar2(3) -- 借贷业务种类大类:ed01ad05
    ,dbtcr_bnctg_sbdvsn varchar2(6) -- 借贷业务种类细分:ed01ad06
    ,opnacc_dt date -- 开户日期:ed01ar01
    ,ccycd varchar2(5) -- 币种代码(币种):ed01ad07
    ,pbc_cr_lnd_amt number(38,0) -- 人行征信借款金额:ed01aj01
    ,crgln number(38,0) -- 授信额度:ed01aj02
    ,exdat date -- 到期日期:ed01ar02
    ,entp_cr_grtstl varchar2(2) -- 企业征信担保方式(担保方式):ed01ad08
    ,dbtcraccorrepygrntmod varchar2(2) -- 借贷账户其他还款保证方式(其它还款保证方式):ed01ad09
    ,ln_dstr_form varchar2(2) -- 贷款发放形式(发放形式):ed01ad10
    ,jnt_lnd_idr varchar2(2) -- 共同借款标识:ed01ad11
    ,cls_dt date -- 关闭日期:ed01ar03
    ,infrpt_dt date -- 信息报告日期:ed01ar04
    ,repy_prfmn_rcrd_num number(22) -- 还款表现记录数:ed01bs01
    ,sptxn_num number(22) -- 特定交易个数:ed01cs01
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
grant select on ${iol_schema}.cqss_e_r_dbtcraccbscinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccbscinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccbscinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccbscinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_dbtcraccbscinf is '借贷账户基本信息';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.dbtcr_acc_id is '借贷账户编号:ed01ai01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.acc_avy_st is '账户活动状态:ed01ad01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.dbtcr_acc_tp is '借贷账户类型:ed01ad02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.lnd_ddln is '借款期限:ed01ad03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.inst_tp is '机构类型(业务管理机构类型):ed01ad04';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.mtit_ecd is '管理机构编码(业务管理机构代码):ed01ai02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.crg_agrm_id is '授信协议编号:ed01ai03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.dbtcr_bnctg_lrgclss is '借贷业务种类大类:ed01ad05';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.dbtcr_bnctg_sbdvsn is '借贷业务种类细分:ed01ad06';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.opnacc_dt is '开户日期:ed01ar01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.ccycd is '币种代码(币种):ed01ad07';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.pbc_cr_lnd_amt is '人行征信借款金额:ed01aj01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.crgln is '授信额度:ed01aj02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.exdat is '到期日期:ed01ar02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.entp_cr_grtstl is '企业征信担保方式(担保方式):ed01ad08';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.dbtcraccorrepygrntmod is '借贷账户其他还款保证方式(其它还款保证方式):ed01ad09';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.ln_dstr_form is '贷款发放形式(发放形式):ed01ad10';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.jnt_lnd_idr is '共同借款标识:ed01ad11';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.cls_dt is '关闭日期:ed01ar03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.infrpt_dt is '信息报告日期:ed01ar04';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.repy_prfmn_rcrd_num is '还款表现记录数:ed01bs01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.sptxn_num is '特定交易个数:ed01cs01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_dbtcraccbscinf.etl_timestamp is 'ETL处理时间戳';
