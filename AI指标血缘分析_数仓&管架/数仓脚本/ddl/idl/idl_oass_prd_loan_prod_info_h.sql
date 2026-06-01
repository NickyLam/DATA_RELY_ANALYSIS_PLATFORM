/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_prd_loan_prod_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_prd_loan_prod_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_prd_loan_prod_info_h(
etl_dt date --数据日期
,prod_name varchar2(500) --产品名称
,bus_breed_cd varchar2(30) --业务品种代码
,super_prod_id varchar2(100) --上级产品编号
,leaf_node_flg varchar2(10) --叶节点标志
,mgmt_dept_id varchar2(100) --管理部门编号
,bus_dept_id varchar2(100) --产品发行机构编号
,exlus_prod_flg varchar2(10) --专属产品标志
,off_bs_flg varchar2(10) --表外标志
,allow_pkg_flg varchar2(10) --允许打包标志
,lmt_prod_flg varchar2(10) --额度产品标志
,loan_mon_tenor number(22,0) --期限值
,lmt_ocup_way_cd varchar2(30) --额度被占用方式代码
,lmt_rela_agt_flg varchar2(10) --额度关联协议标志
,ocup_lmt_flg varchar2(10) --占用额度标志
,lmt_ocup_comnt varchar2(2000) --额度占用说明
,public_lmt_flg varchar2(10) --公开额度标志
,lmt_uniq_flg varchar2(10) --额度唯一标志
,uniq_fit_range_cd varchar2(30) --唯一性适用范围代码
,fit_role_descb varchar2(1000) --适用角色描述
,lmt_fit_prod_descb varchar2(4000) --额度适用产品描述
,circl_idf_flg varchar2(10) --循环标识标志
,aval_curr_cd varchar2(30) --可用币种代码
,prod_status_cd varchar2(30) --产品状态代码
,prod_descb varchar2(800) --产品描述
,prod_effect_dt date --产品生效日期
,prod_invalid_dt date --产品失效日期
,prod_belong_gen_cd varchar2(30) --产品所属大类代码
,base_claus_model_id varchar2(100) --基础条款模型编号
,rela_claus_model_id varchar2(100) --关联条款模型编号
,noth_risk_bus_flg varchar2(10) --无风险业务标志
,all_open_bus_flg varchar2(10) --全敞口业务标志
,allow_multi_out_acct_flg varchar2(10) --允许多次出账标志
,allow_adv_repay_flg varchar2(10) --允许提前还款标志
,prod_type_cd varchar2(30) --产品类型代码
,allow_multi_distr_flg varchar2(10) --允许多次放款标志
,proc_cap_usage_check_flg varchar2(10) --进行资金用途检查标志
,lmt_ctrl_stage_cd varchar2(30) --额度管控阶段代码
,rgst_teller_id varchar2(100) --登记柜员编号
,rgst_org_id varchar2(100) --登记机构编号
,rgst_dt date --登记日期
,update_teller_id varchar2(100) --更新柜员编号
,update_org_id varchar2(100) --更新机构编号
,modif_dt date --变更日期
,crdt_prod_cate_cd varchar2(30) --信贷产品类别代码
,asset_thd_cls_cd varchar2(30) --资产三分类代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,prod_id varchar2(100) --产品编号
,lp_id varchar2(100) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_prd_loan_prod_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_prd_loan_prod_info_h is '贷款产品信息历史';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.prod_name is '产品名称';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.bus_breed_cd is '业务品种代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.super_prod_id is '上级产品编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.leaf_node_flg is '叶节点标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.mgmt_dept_id is '管理部门编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.bus_dept_id is '产品发行机构编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.exlus_prod_flg is '专属产品标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.off_bs_flg is '表外标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.allow_pkg_flg is '允许打包标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.lmt_prod_flg is '额度产品标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.loan_mon_tenor is '期限值';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.lmt_ocup_way_cd is '额度被占用方式代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.lmt_rela_agt_flg is '额度关联协议标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.ocup_lmt_flg is '占用额度标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.lmt_ocup_comnt is '额度占用说明';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.public_lmt_flg is '公开额度标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.lmt_uniq_flg is '额度唯一标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.uniq_fit_range_cd is '唯一性适用范围代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.fit_role_descb is '适用角色描述';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.lmt_fit_prod_descb is '额度适用产品描述';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.circl_idf_flg is '循环标识标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.aval_curr_cd is '可用币种代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.prod_status_cd is '产品状态代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.prod_descb is '产品描述';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.prod_effect_dt is '产品生效日期';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.prod_invalid_dt is '产品失效日期';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.prod_belong_gen_cd is '产品所属大类代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.base_claus_model_id is '基础条款模型编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.rela_claus_model_id is '关联条款模型编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.noth_risk_bus_flg is '无风险业务标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.all_open_bus_flg is '全敞口业务标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.allow_multi_out_acct_flg is '允许多次出账标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.allow_adv_repay_flg is '允许提前还款标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.prod_type_cd is '产品类型代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.allow_multi_distr_flg is '允许多次放款标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.proc_cap_usage_check_flg is '进行资金用途检查标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.lmt_ctrl_stage_cd is '额度管控阶段代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.rgst_dt is '登记日期';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.update_teller_id is '更新柜员编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.update_org_id is '更新机构编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.modif_dt is '变更日期';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.crdt_prod_cate_cd is '信贷产品类别代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.asset_thd_cls_cd is '资产三分类代码';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.prod_id is '产品编号';
comment on column ${idl_schema}.oass_prd_loan_prod_info_h.lp_id is '法人编号';

