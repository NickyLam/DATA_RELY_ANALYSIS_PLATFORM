/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_refac_loan_batch_pkg_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_refac_loan_batch_pkg_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_refac_loan_batch_pkg_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_refac_loan_batch_pkg_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_pkg_id varchar2(100) -- 批次包编号
    ,batch_pkg_name varchar2(500) -- 批次包名称
    ,batch_pkg_idf_cd varchar2(30) -- 批次包标识代码
    ,rela_batch_pkg_name varchar2(500) -- 关联批次包名称
    ,rela_batch_pkg_id varchar2(100) -- 关联批次包编号
    ,use_request_descb varchar2(4000) -- 使用要求描述
    ,valid_flg varchar2(60) -- 有效标志
    ,use_int_rat number(18,9) -- 使用利率
    ,int_accr_way_descb varchar2(500) -- 计息方式描述
    ,pmo_amt_evltion_tot number(30,6) -- 抵质押物金额估值汇总
    ,surp_lmt number(30,2) -- 剩余额度
    ,cred_rht_bal number(30,6) -- 债权余额
    ,refac_amt number(30,2) -- 再贷款金额
    ,refac_distr_mode_cd varchar2(30) -- 再贷款发放模式代码
    ,refac_kind_descb varchar2(500) -- 专项再贷款种类代码
    ,refac_cont_id varchar2(100) -- 再贷款合同编号
    ,refac_distr_dt date -- 再贷款发放日期
    ,refac_exp_dt date -- 再贷款到期日期
    ,cap_enter_acct_id varchar2(100) -- 资金划入账户编号
    ,cap_out_acct_id varchar2(100) -- 资金划出账户编号
    ,pbc_doc_name varchar2(500) -- 人行文件名称
    ,pbc_lmt number(30,6) -- 人行额度
    ,pbc_doc_id varchar2(100) -- 人行文件编号
    ,pbc_doc_doc_dt date -- 人行文件发文日期
    ,bl_pbc_corp_princ_name varchar2(500) -- 所属地人民银行单位负责人姓名
    ,bl_pbc_name varchar2(500) -- 所属地人民银行名称
    ,bl_pbc_fin_inst_code varchar2(100) -- 所属地人民银行金融机构编码
    ,bl_pbc_bond_type_descb varchar2(500) -- 所属地人民银行债券类型描述
    ,corp_phone_num varchar2(60) -- 单位联系电话号码
    ,corp_addr varchar2(500) -- 单位地址
    ,move_remark varchar2(500) -- 迁移备注
    ,remark varchar2(1000) -- 备注
    ,rgst_teller_id varchar2(500) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_refac_loan_batch_pkg_h to ${icl_schema};
grant select on ${iml_schema}.agt_refac_loan_batch_pkg_h to ${idl_schema};
grant select on ${iml_schema}.agt_refac_loan_batch_pkg_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_refac_loan_batch_pkg_h is '支小再贷款批次包历史';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.batch_pkg_id is '批次包编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.batch_pkg_name is '批次包名称';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.batch_pkg_idf_cd is '批次包标识代码';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.rela_batch_pkg_name is '关联批次包名称';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.rela_batch_pkg_id is '关联批次包编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.use_request_descb is '使用要求描述';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.valid_flg is '有效标志';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.use_int_rat is '使用利率';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.int_accr_way_descb is '计息方式描述';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.pmo_amt_evltion_tot is '抵质押物金额估值汇总';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.surp_lmt is '剩余额度';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.cred_rht_bal is '债权余额';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.refac_amt is '再贷款金额';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.refac_distr_mode_cd is '再贷款发放模式代码';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.refac_kind_descb is '专项再贷款种类代码';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.refac_cont_id is '再贷款合同编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.refac_distr_dt is '再贷款发放日期';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.refac_exp_dt is '再贷款到期日期';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.cap_enter_acct_id is '资金划入账户编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.cap_out_acct_id is '资金划出账户编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.pbc_doc_name is '人行文件名称';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.pbc_lmt is '人行额度';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.pbc_doc_id is '人行文件编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.pbc_doc_doc_dt is '人行文件发文日期';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.bl_pbc_corp_princ_name is '所属地人民银行单位负责人姓名';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.bl_pbc_name is '所属地人民银行名称';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.bl_pbc_fin_inst_code is '所属地人民银行金融机构编码';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.bl_pbc_bond_type_descb is '所属地人民银行债券类型描述';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.corp_phone_num is '单位联系电话号码';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.corp_addr is '单位地址';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.move_remark is '迁移备注';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.remark is '备注';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_refac_loan_batch_pkg_h.etl_timestamp is 'ETL处理时间戳';
