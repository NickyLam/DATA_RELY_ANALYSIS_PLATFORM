/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_loanaccountinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_loanaccountinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_loanaccountinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_loanaccountinfo(
    id varchar2(96) -- 代码主键:
    ,msgidno varchar2(53) -- 报文标识号:
    ,acc_id varchar2(60) -- 账户编号:
    ,dbtcr_acc_tp varchar2(3) -- 借贷账户类型:
    ,inst_tp varchar2(45) -- 机构类型:
    ,mtit_ecd varchar2(96) -- 业务管理机构代码:
    ,acc_idr varchar2(90) -- 账户标识:
    ,crg_agrm_id number(22) -- 授信协议编号:
    ,idvdbtcr_bnctg_sbdvsn varchar2(3) -- 个人借贷业务种类细分:
    ,ftm_estb_dt date -- 开立日期:
    ,ccycd varchar2(5) -- 币种代码:
    ,bnk_lnd_amt number(38,0) -- 贷款金额:
    ,acc_crgln number(38,0) -- 账户授信额度:
    ,shr_crgln number(38,0) -- 共享授信额度:
    ,exdat date -- 到期日期:
    ,rpmd varchar2(3) -- 还款方式:
    ,idv_cr_repy_frq varchar2(3) -- 个人征信还款频率:
    ,repy_prd_num number(22) -- 还款期数:
    ,idv_cr_grtstl varchar2(2) -- 个人征信担保方式:
    ,ln_dstr_form varchar2(2) -- 贷款发放形式:
    ,jnt_ln_indcd varchar2(9) -- 共同贷款标志代码:
    ,clm_sft_hr_s_repy_st varchar2(2) -- 债权转移时的还款状态:
    ,dbtcraccbaspinstmdnum number(22) -- 借贷账户大额专项分期笔数:
    ,fyrs_prfmn_strt_yrmo varchar2(11) -- 五年表现开始年月:
    ,fyrs_prfmn_ctof_yrmo varchar2(11) -- 五年表现截止年月:
    ,odue_monum number(22) -- 逾期月数:
    ,sptxn_num number(22) -- 特殊交易个数:
    ,spcl_ev_num number(22) -- 特殊事件个数:
    ,rctly24etrsmrstrtyrmo varchar2(11) -- 最近24个月还款开始年月:
    ,rctly24etrsmorcofyrmo varchar2(11) -- 最近24个月还款截止年月:
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:
    ,multi_tenancy_id varchar2(30) -- 多实体标识:
    ,crt_dt_tm date -- 创建日期时间:
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
grant select on ${iol_schema}.cqss_i_r_loanaccountinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_loanaccountinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_loanaccountinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_loanaccountinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_loanaccountinfo is '二代借贷账户基本信息';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.id is '代码主键:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.msgidno is '报文标识号:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.acc_id is '账户编号:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.dbtcr_acc_tp is '借贷账户类型:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.inst_tp is '机构类型:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.mtit_ecd is '业务管理机构代码:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.acc_idr is '账户标识:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.crg_agrm_id is '授信协议编号:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.idvdbtcr_bnctg_sbdvsn is '个人借贷业务种类细分:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.ftm_estb_dt is '开立日期:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.ccycd is '币种代码:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.bnk_lnd_amt is '贷款金额:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.acc_crgln is '账户授信额度:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.shr_crgln is '共享授信额度:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.exdat is '到期日期:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.rpmd is '还款方式:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.idv_cr_repy_frq is '个人征信还款频率:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.repy_prd_num is '还款期数:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.idv_cr_grtstl is '个人征信担保方式:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.ln_dstr_form is '贷款发放形式:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.jnt_ln_indcd is '共同贷款标志代码:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.clm_sft_hr_s_repy_st is '债权转移时的还款状态:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.dbtcraccbaspinstmdnum is '借贷账户大额专项分期笔数:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.fyrs_prfmn_strt_yrmo is '五年表现开始年月:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.fyrs_prfmn_ctof_yrmo is '五年表现截止年月:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.odue_monum is '逾期月数:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.sptxn_num is '特殊交易个数:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.spcl_ev_num is '特殊事件个数:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.rctly24etrsmrstrtyrmo is '最近24个月还款开始年月:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.rctly24etrsmorcofyrmo is '最近24个月还款截止年月:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.annttn_and_sttmnt_num is '标注及声明个数:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.multi_tenancy_id is '多实体标识:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.crt_dt_tm is '创建日期时间:';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_loanaccountinfo.etl_timestamp is 'ETL处理时间戳';
