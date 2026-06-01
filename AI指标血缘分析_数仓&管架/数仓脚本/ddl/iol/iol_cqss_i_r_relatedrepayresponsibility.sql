/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_relatedrepayresponsibility
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_relatedrepayresponsibility
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_relatedrepayresponsibility purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_relatedrepayresponsibility(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,idnt_inf_cgycd varchar2(2) -- 身份信息类别代码:pd03ad08
    ,inst_tp varchar2(45) -- 机构类型:pd03ad01
    ,mtit_ecd varchar2(192) -- 管理机构编码:pd03aq01
    ,repy_rspl_bnctg varchar2(9) -- 还款责任业务种类:pd03ad02
    ,cr_ln_dstr_dt date -- 征信贷款发放日期:pd03ar01
    ,cr_ln_exdat date -- 征信贷款到期日期:pd03ar02
    ,rel_repy_rsplpsn_tp varchar2(9) -- 相关还款责任人类型:pd03ad03
    ,rel_repy_rspl_qot number(38,0) -- 相关还款责任金额:pd03aj01
    ,ccycd varchar2(5) -- 币种代码:pd03ad04
    ,cr_lnpp_bal number(38,0) -- 征信贷款本金余额:pd03aj02
    ,pbc_lv5cl_cd varchar2(2) -- 人行五级分类代码:pd03ad05
    ,dbtcr_acc_tp varchar2(3) -- 借贷账户类型:pd03ad06
    ,cr_ln_repy_st varchar2(90) -- 还款状态:pd03ad07
    ,cr_ln_odue_cnu_monum number(22) -- 征信贷款逾期持续月数:pd03as01
    ,vld_codt date -- 有效截止日期:pd03ar03
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数
    ,multi_tenancy_id varchar2(8) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
    ,grnt_ctr_id varchar2(90) -- 保证合同编号
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
grant select on ${iol_schema}.cqss_i_r_relatedrepayresponsibility to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_relatedrepayresponsibility to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_relatedrepayresponsibility to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_relatedrepayresponsibility to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_relatedrepayresponsibility is '二代相关还款责任信息';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.idnt_inf_cgycd is '身份信息类别代码:pd03ad08';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.inst_tp is '机构类型:pd03ad01';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.mtit_ecd is '管理机构编码:pd03aq01';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.repy_rspl_bnctg is '还款责任业务种类:pd03ad02';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.cr_ln_dstr_dt is '征信贷款发放日期:pd03ar01';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.cr_ln_exdat is '征信贷款到期日期:pd03ar02';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.rel_repy_rsplpsn_tp is '相关还款责任人类型:pd03ad03';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.rel_repy_rspl_qot is '相关还款责任金额:pd03aj01';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.ccycd is '币种代码:pd03ad04';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.cr_lnpp_bal is '征信贷款本金余额:pd03aj02';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.pbc_lv5cl_cd is '人行五级分类代码:pd03ad05';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.dbtcr_acc_tp is '借贷账户类型:pd03ad06';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.cr_ln_repy_st is '还款状态:pd03ad07';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.cr_ln_odue_cnu_monum is '征信贷款逾期持续月数:pd03as01';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.vld_codt is '有效截止日期:pd03ar03';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.annttn_and_sttmnt_num is '标注及声明个数';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.grnt_ctr_id is '保证合同编号';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_relatedrepayresponsibility.etl_timestamp is 'ETL处理时间戳';
