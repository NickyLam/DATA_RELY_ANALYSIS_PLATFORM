/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_dbtcraccnidrryrsplinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,dbtcr_acc_id varchar2(9) -- 借贷账户编号:ed070i01
    ,idnt_inf_cgycd varchar2(2) -- 身份信息类别代码(主借款人身份类别):ed070d01
    ,dbtcr_acc_tp varchar2(3) -- 借贷账户类型(账户类型):ed070d02
    ,rel_repy_rspl_tp varchar2(9) -- 相关还款责任类型:ed070d03
    ,rel_repy_rspl_amt_ccy varchar2(5) -- 相关还款责任金额币种:ed070d10
    ,rel_repy_rspl_qot number(15,0) -- 相关还款责任限额:ed070j01
    ,inst_tp varchar2(45) -- 机构类型(业务管理机构类型):ed070d04
    ,mtit_ecd varchar2(192) -- 管理机构编码(业务管理机构代码):ed070i02
    ,repy_rspl_bnctg varchar2(9) -- 还款责任业务种类(业务种类):ed070d05
    ,dbtcrbnctg_sbdvsn varchar2(3) -- 企业借贷业务种类细分(业务种类细分):ed070d06
    ,ftm_estb_dt date -- 首次开立日期(开立日期):ed070r01
    ,exdat date -- 到期日期:ed070r02
    ,ccycd varchar2(5) -- 币种代码(币种):ed070d07
    ,bal number(38,0) -- 余额:ed070j02
    ,pbc_lv5cl_cd varchar2(2) -- 人行征信五级分类(五级分类):ed070d08
    ,cur_odue_tamt number(38,0) -- 当前逾期总额(逾期总额):ed070j03
    ,cur_odue_pnp number(38,0) -- 当前逾期本金(逾期本金):ed070j04
    ,dbtcr_acc_odue_monum number(22) -- 借贷账户逾期月数(逾期月数):ed070s01
    ,cr_ln_repy_st varchar2(90) -- 征信贷款还款状态(还款状态):ed070d09
    ,srpls_repy_monum number(22) -- 剩余还款月数:ed070s02
    ,infrpt_dt date -- 信息报告日期:ed070r03
    ,pbc_cr_lnd_amt number(38,0) -- 人行征信借款金额:ed070j05
    ,pbc_cr_crline number(38,0) -- 信用额度:ed070j06
    ,grnt_ctr_id varchar2(9) -- 保证合同编号:ed070i03
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
grant select on ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf is '借贷账户（不含贴现）相关还款责任信息';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.dbtcr_acc_id is '借贷账户编号:ed070i01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.idnt_inf_cgycd is '身份信息类别代码(主借款人身份类别):ed070d01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.dbtcr_acc_tp is '借贷账户类型(账户类型):ed070d02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.rel_repy_rspl_tp is '相关还款责任类型:ed070d03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.rel_repy_rspl_amt_ccy is '相关还款责任金额币种:ed070d10';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.rel_repy_rspl_qot is '相关还款责任限额:ed070j01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.inst_tp is '机构类型(业务管理机构类型):ed070d04';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.mtit_ecd is '管理机构编码(业务管理机构代码):ed070i02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.repy_rspl_bnctg is '还款责任业务种类(业务种类):ed070d05';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.dbtcrbnctg_sbdvsn is '企业借贷业务种类细分(业务种类细分):ed070d06';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.ftm_estb_dt is '首次开立日期(开立日期):ed070r01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.exdat is '到期日期:ed070r02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.ccycd is '币种代码(币种):ed070d07';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.bal is '余额:ed070j02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.pbc_lv5cl_cd is '人行征信五级分类(五级分类):ed070d08';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.cur_odue_tamt is '当前逾期总额(逾期总额):ed070j03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.cur_odue_pnp is '当前逾期本金(逾期本金):ed070j04';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.dbtcr_acc_odue_monum is '借贷账户逾期月数(逾期月数):ed070s01';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.cr_ln_repy_st is '征信贷款还款状态(还款状态):ed070d09';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.srpls_repy_monum is '剩余还款月数:ed070s02';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.infrpt_dt is '信息报告日期:ed070r03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.pbc_cr_lnd_amt is '人行征信借款金额:ed070j05';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.pbc_cr_crline is '信用额度:ed070j06';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.grnt_ctr_id is '保证合同编号:ed070i03';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_dbtcraccnidrryrsplinf.etl_timestamp is 'ETL处理时间戳';
