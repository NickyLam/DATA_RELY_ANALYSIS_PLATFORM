/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_prod_and_subj_map_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_prod_and_subj_map_rela
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_prod_and_subj_map_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_prod_and_subj_map_rela(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,sellbl_prod_id varchar2(20) -- 可售产品编号
    ,sellbl_prod_name varchar2(500) -- 可售产品名称
    ,accti_prod_attr_cd1 varchar2(60) -- 核算产品属性代码1
    ,accti_prod_id varchar2(60) -- 核算产品编号
    ,accti_prod_name varchar2(500) -- 核算产品名称
    ,accti_prod_hibchy varchar2(10) -- 核算产品层级
    ,base_prod_flg varchar2(10) -- 基础产品标志
    ,bus_type_cd varchar2(20) -- 业务类型代码
    ,pric_subj_id varchar2(60) -- 本金科目编号
    ,intnal_acct_pric_subj_id varchar2(60) -- 内部账户本金科目编号
    ,recvbl_int_paybl_subj_id varchar2(60) -- 应收应付利息科目编号
    ,recvbl_int_paybl_adj_subj_id varchar2(60) -- 应收应付利息调整科目编号
    ,recvbl_uncol_int_subj_id varchar2(60) -- 应收未收利息科目编号
    ,int_bal_pay_subj_id varchar2(60) -- 利息收支科目编号
    ,spd_pl_subj_id varchar2(60) -- 价差损益科目编号
    ,acru_aldy_impam_int_subj_id varchar2(60) -- 应计已减值利息科目编号
    ,non_acru_int_recvbl_subj_id varchar2(60) -- 非应计应收利息科目编号
    ,wrtn_off_pric_subj_id varchar2(60) -- 已核销本金科目编号
    ,wrtn_off_int_subj_id varchar2(60) -- 已核销利息科目编号
    ,impam_loss_subj_id varchar2(60) -- 减值损失科目编号
    ,impam_prep_subj_id varchar2(60) -- 减值准备科目编号
    ,other_acct_recvbl_impam_prep_subj_id varchar2(60) -- 其他应收款减值准备科目编号
    ,output_tax_lmt_subj_id varchar2(60) -- 销项税额科目编号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_prod_and_subj_map_rela to ${idl_schema};
grant select on ${icl_schema}.cmm_prod_and_subj_map_rela to ${iel_schema};
grant select on ${icl_schema}.cmm_prod_and_subj_map_rela to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_prod_and_subj_map_rela is '产品与科目映射关系';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.sellbl_prod_id is '可售产品编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.sellbl_prod_name is '可售产品名称';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.accti_prod_attr_cd1 is '核算产品属性代码1';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.accti_prod_id is '核算产品编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.accti_prod_name is '核算产品名称';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.accti_prod_hibchy is '核算产品层级';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.base_prod_flg is '基础产品标志';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.bus_type_cd is '业务类型代码';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.pric_subj_id is '本金科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.intnal_acct_pric_subj_id is '内部账户本金科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.recvbl_int_paybl_subj_id is '应收应付利息科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.recvbl_int_paybl_adj_subj_id is '应收应付利息调整科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.recvbl_uncol_int_subj_id is '应收未收利息科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.int_bal_pay_subj_id is '利息收支科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.spd_pl_subj_id is '价差损益科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.acru_aldy_impam_int_subj_id is '应计已减值利息科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.non_acru_int_recvbl_subj_id is '非应计应收利息科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.wrtn_off_pric_subj_id is '已核销本金科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.wrtn_off_int_subj_id is '已核销利息科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.impam_loss_subj_id is '减值损失科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.impam_prep_subj_id is '减值准备科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.other_acct_recvbl_impam_prep_subj_id is '其他应收款减值准备科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.output_tax_lmt_subj_id is '销项税额科目编号';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_prod_and_subj_map_rela.etl_timestamp is 'ETL处理时间戳';
