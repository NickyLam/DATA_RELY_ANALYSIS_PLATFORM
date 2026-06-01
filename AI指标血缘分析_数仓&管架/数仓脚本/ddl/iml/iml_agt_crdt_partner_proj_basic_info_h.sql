/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_crdt_partner_proj_basic_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_crdt_partner_proj_basic_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_crdt_partner_proj_basic_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_partner_proj_basic_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,co_proj_id varchar2(100) -- 合作项目编号
    ,co_proj_name varchar2(500) -- 合作项目名称
    ,co_proj_type_cd varchar2(30) -- 合作项目类型代码
    ,partner_id varchar2(100) -- 合作方编号
    ,partner_type_cd varchar2(60) -- 合作方类型代码
    ,coprator_type_cd varchar2(30) -- 合作商类型代码
    ,partner_capital_ratio number(24,8) -- 合作方资本金比例
    ,co_agt_id varchar2(100) -- 合作协议编号
    ,have_proj_lmt_flg varchar2(12) -- 有项目额度标志
    ,proj_begin_dt date -- 项目起始日期
    ,proj_exp_dt date -- 项目到期日期
    ,co_tenor number(10) -- 合作期限
    ,fee_rat number(18,6) -- 费率
    ,comm_ratio number(24,8) -- 佣金比例
    ,proj_status_cd varchar2(60) -- 项目状态代码
    ,proj_descb varchar2(4000) -- 项目描述
    ,cont_circl_flg varchar2(10) -- 合同可循环标志
    ,org_id varchar2(100) -- 机构编号
    ,cap_supv_acct_id varchar2(100) -- 资金监管账户编号
    ,cap_supv_acct_name varchar2(500) -- 资金监管账户名称
    ,proj_stl_acct_id varchar2(100) -- 项目结算账户编号
    ,proj_stl_acct_name varchar2(500) -- 项目结算账户名称
    ,proj_stl_open_acct_bank_org_id varchar2(250) -- 项目结算开户银行机构编号
    ,proj_stl_open_acct_org_id varchar2(100) -- 项目结算开户机构编号
    ,appl_type_cd varchar2(30) -- 申请类型代码
    ,hxb_rela_ps_flg varchar2(10) -- 我行关联人标志
    ,move_remark varchar2(500) -- 迁移备注
    ,cmplt_flg varchar2(10) -- 完成标志
    ,final_update_dt date -- 最后更新日期
    ,proj_intror_name varchar2(500) -- 项目介绍人名称
    ,fit_org_range_cd varchar2(4000) -- 适用机构范围代码
    ,expt_lmt_flg varchar2(10) -- 例外额度标志
    ,paid_in_capital number(30,8) -- 实收资本
    ,co_mode_cd varchar2(60) -- 合作模式代码
    ,init_agt_id varchar2(100) -- 原协议编号
    ,bus_max_open_amt number(30,8) -- 业务最大敞口金额
    ,rgst_cap number(30,8) -- 注册资本
    ,early_days_start_use_lmt number(30,8) -- 前期启用额度
    ,lmt_nmal_amt number(30,8) -- 额度名义金额
    ,circl_flg varchar2(10) -- 循环标志
    ,invo_syn_crdt_apv_reply_modif_flg varchar2(10) -- 涉及综合信贷审批批复变更标志
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
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
grant select on ${iml_schema}.agt_crdt_partner_proj_basic_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_crdt_partner_proj_basic_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_crdt_partner_proj_basic_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_crdt_partner_proj_basic_info_h is '信贷合作方项目基本信息历史';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.co_proj_id is '合作项目编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.co_proj_name is '合作项目名称';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.co_proj_type_cd is '合作项目类型代码';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.partner_id is '合作方编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.partner_type_cd is '合作方类型代码';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.coprator_type_cd is '合作商类型代码';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.partner_capital_ratio is '合作方资本金比例';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.co_agt_id is '合作协议编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.have_proj_lmt_flg is '有项目额度标志';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_begin_dt is '项目起始日期';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_exp_dt is '项目到期日期';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.co_tenor is '合作期限';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.fee_rat is '费率';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.comm_ratio is '佣金比例';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_status_cd is '项目状态代码';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_descb is '项目描述';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.cont_circl_flg is '合同可循环标志';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.cap_supv_acct_id is '资金监管账户编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.cap_supv_acct_name is '资金监管账户名称';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_stl_acct_id is '项目结算账户编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_stl_acct_name is '项目结算账户名称';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_stl_open_acct_bank_org_id is '项目结算开户银行机构编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_stl_open_acct_org_id is '项目结算开户机构编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.appl_type_cd is '申请类型代码';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.hxb_rela_ps_flg is '我行关联人标志';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.move_remark is '迁移备注';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.cmplt_flg is '完成标志';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.proj_intror_name is '项目介绍人名称';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.fit_org_range_cd is '适用机构范围代码';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.expt_lmt_flg is '例外额度标志';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.paid_in_capital is '实收资本';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.co_mode_cd is '合作模式代码';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.init_agt_id is '原协议编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.bus_max_open_amt is '业务最大敞口金额';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.rgst_cap is '注册资本';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.early_days_start_use_lmt is '前期启用额度';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.lmt_nmal_amt is '额度名义金额';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.circl_flg is '循环标志';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.invo_syn_crdt_apv_reply_modif_flg is '涉及综合信贷审批批复变更标志';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_crdt_partner_proj_basic_info_h.etl_timestamp is 'ETL处理时间戳';
