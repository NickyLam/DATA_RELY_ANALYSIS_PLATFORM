/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_crdt_lmt_apv_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_crdt_lmt_apv_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_crdt_lmt_apv_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_crdt_lmt_apv_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,crdt_lmt_apv_flow_num varchar2(100) -- 授信额度审批流水号
    ,rela_init_cont_id varchar2(60) -- 关联原合同编号
    ,rela_crdt_lmt_apv_flow_num varchar2(100) -- 关联授信额度审批流水号
    ,bus_breed_id varchar2(100) -- 业务品种编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,happ_type_cd varchar2(30) -- 发生类型代码
    ,crdt_rg_rg_cd varchar2(30) -- 授信区域地区代码
    ,crdt_apv_status_cd varchar2(30) -- 授信审批状态代码
    ,rgst_org_cd varchar2(60) -- 登记机构代码
    ,rgstrat_id varchar2(100) -- 登记人编号
    ,oper_org_cd varchar2(60) -- 经办机构代码
    ,operr_id varchar2(100) -- 业务经办人编号
    ,final_apver_id varchar2(100) -- 最终审批人编号
    ,loan_tenor number(30,2) -- 贷款期限
    ,curr_cd varchar2(10) -- 币种代码
    ,crdt_apv_amt number(30,2) -- 授信审批金额
    ,crdt_apv_open_amt number(30,2) -- 授信审批敞口金额
    ,rgst_dt date -- 登记日期
    ,oper_dt date -- 经办日期
    ,apv_dt date -- 审批日期
    ,apved_dt date -- 审批通过日期
    ,crdt_lmt_begin_dt date -- 授信额度起始日期
    ,crdt_lmt_exp_dt date -- 授信额度到期日期
    ,apved_reply_id varchar2(100) -- 审批通过批复编号
    ,crdt_lmt_effect_flg varchar2(10) -- 授信额度生效标志
    ,lmt_circl_flg varchar2(10) -- 额度可循环标志
    ,group_crdt_flg varchar2(10) -- 集团授信标志
    ,estate_class_fin_flg varchar2(10) -- 房地产类融资标志
    ,gover_class_fin_flg varchar2(10) -- 政府类融资标志
    ,consm_serv_class_fin_flg varchar2(10) -- 消费服务类融资标志
    ,br_build_class_fin_flg varchar2(10) -- 一带一路建设类融资标志
    ,green_crdt_class_fin_flg varchar2(10) -- 绿色信贷类融资标志
    ,crdt_lmt_apv_opinion varchar2(4000) -- 授信额度审批意见
    ,crdt_lmt_usage_descb varchar2(2000) -- 授信额度用途描述
    ,crdt_lmt_spent_plan varchar2(2000) -- 授信额度用款计划
    ,main_guar_way_cd varchar2(30) -- 主担保方式代码
    ,low_risk_biz_ind varchar2(10) -- 低风险业务标志
    ,low_risk_biz_type_cd varchar2(30) -- 低风险业务类型代码
    ,reply_type_cd varchar2(30) -- 批复类型代码
    ,cont_regi_ind varchar2(10) -- 合同登记标志
    ,text_cont_id varchar2(60) -- 文本合同编号
    ,aval_o_use_lmt number(30,2) -- 可用他用额度
    ,ocup_o_use_lmt_flg varchar2(10) -- 占用他用额度标志
    ,o_use_lmt_id varchar2(60) -- 他用额度编号
    ,o_use_lmt_type_cd varchar2(60) -- 他用额度类型代码
    ,o_use_lmt_all_id varchar2(60) -- 他用额度所有人编号
    ,group_crdt_lmt_corp_part number(30,2) -- 集团授信额度公司部分
    ,group_crdt_expos_corp_part number(30,2) -- 集团授信敞口公司部分
    ,group_crdt_lmt_ibank_part number(30,2) -- 集团授信额度同业部分
    ,group_crdt_expos_ibank_part number(30,2) -- 集团授信敞口同业部分
    ,rela_group_reply_id varchar2(60) -- 关联集团批复编号
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
grant select on ${icl_schema}.cmm_corp_crdt_lmt_apv_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_crdt_lmt_apv_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_crdt_lmt_apv_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_crdt_lmt_apv_info is '对公授信额度审批信息';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_lmt_apv_flow_num is '授信额度审批流水号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.rela_init_cont_id is '关联原合同编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.rela_crdt_lmt_apv_flow_num is '关联授信额度审批流水号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.bus_breed_id is '业务品种编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.happ_type_cd is '发生类型代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_rg_rg_cd is '授信区域地区代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_apv_status_cd is '授信审批状态代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.rgst_org_cd is '登记机构代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.rgstrat_id is '登记人编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.oper_org_cd is '经办机构代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.operr_id is '业务经办人编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.final_apver_id is '最终审批人编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.loan_tenor is '贷款期限';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_apv_amt is '授信审批金额';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_apv_open_amt is '授信审批敞口金额';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.rgst_dt is '登记日期';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.oper_dt is '经办日期';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.apv_dt is '审批日期';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.apved_dt is '审批通过日期';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_lmt_begin_dt is '授信额度起始日期';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_lmt_exp_dt is '授信额度到期日期';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.apved_reply_id is '审批通过批复编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_lmt_effect_flg is '授信额度生效标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.lmt_circl_flg is '额度可循环标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.group_crdt_flg is '集团授信标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.estate_class_fin_flg is '房地产类融资标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.gover_class_fin_flg is '政府类融资标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.br_build_class_fin_flg is '一带一路建设类融资标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.green_crdt_class_fin_flg is '绿色信贷类融资标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_lmt_apv_opinion is '授信额度审批意见';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_lmt_usage_descb is '授信额度用途描述';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.crdt_lmt_spent_plan is '授信额度用款计划';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.main_guar_way_cd is '主担保方式代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.low_risk_biz_ind is '低风险业务标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.low_risk_biz_type_cd is '低风险业务类型代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.reply_type_cd is '批复类型代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.cont_regi_ind is '合同登记标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.text_cont_id is '文本合同编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.aval_o_use_lmt is '可用他用额度';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.ocup_o_use_lmt_flg is '占用他用额度标志';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.o_use_lmt_id is '他用额度编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.o_use_lmt_type_cd is '他用额度类型代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.o_use_lmt_all_id is '他用额度所有人编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.group_crdt_lmt_corp_part is '集团授信额度公司部分';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.group_crdt_expos_corp_part is '集团授信敞口公司部分';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.group_crdt_lmt_ibank_part is '集团授信额度同业部分';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.group_crdt_expos_ibank_part is '集团授信敞口同业部分';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.rela_group_reply_id is '关联集团批复编号';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_crdt_lmt_apv_info.etl_timestamp is 'ETL处理时间戳';
