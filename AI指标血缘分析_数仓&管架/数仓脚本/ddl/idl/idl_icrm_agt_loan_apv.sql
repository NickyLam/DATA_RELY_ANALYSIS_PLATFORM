/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_agt_loan_apv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_agt_loan_apv
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_agt_loan_apv purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_agt_loan_apv(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,apv_flow_num varchar2(60) -- 审批流水号
    ,rela_appl_flow_num varchar2(60) -- 相关申请流水号
    ,happ_dt date -- 发生日期
    ,party_id varchar2(60) -- 当事人编号
    ,bus_breed_id varchar2(60) -- 业务品种编号
    ,happ_type_cd varchar2(10) -- 发生类型代码
    ,bank_fin_tot number(30,2) -- 银行融资总额
    ,curr_cd varchar2(10) -- 币种代码
    ,apv_amt number(30,2) -- 审批金额
    ,tenor_mon number(10) -- 期限月
    ,loan_usage_descb varchar2(2000) -- 贷款用途描述
    ,oper_org_id varchar2(60) -- 经办机构编号
    ,oper_teller_id varchar2(60) -- 经办柜员编号
    ,oper_dt date -- 经办日期
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,modif_dt date -- 变更日期
    ,reply_type_cd varchar2(10) -- 批复类型代码
    ,circl_flg varchar2(10) -- 循环标志
    ,apved_dt date -- 审批通过日期
    ,lmt_circl_flg varchar2(10) -- 额度循环标志
    ,effect_flg varchar2(10) -- 生效标志
    ,loan_tenor number(10) -- 贷款期限
    ,attach_rgst_flg varchar2(10) -- 补登标志
    ,turn_crdt_flg varchar2(10) -- 转授信标志
    ,matn_flg varchar2(10) -- 维护标志
    ,host_bk_name varchar2(250) -- 主办行行名名称
    ,patip_loan_bank_name varchar2(250) -- 参贷行行名名称
    ,agent_bank_name varchar2(250) -- 代理行行名名称
    ,agent_patip_loan_flg varchar2(10) -- 代理参贷标志
    ,final_jud_pass_dt date -- 终审通过日期
    ,crdt_rg_cd varchar2(10) -- 授信区域代码
    ,invo_estate_fin_flg varchar2(10) -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg varchar2(10) -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg varchar2(10) -- 消费服务类融资标志
    ,br_build_ifin_flg varchar2(10) -- 一带一路建设投融资标志
    ,green_crdt_fin_flg varchar2(10) -- 绿色信贷融资标志
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,reply_id varchar2(60) -- 批复编号
    ,final_apv_opinion varchar2(4000) -- 最终审批意见
    ,final_apv_opinion_2 varchar2(4000) -- 最终审批意见2
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_agt_loan_apv to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_agt_loan_apv is '公司贷款审批';
comment on column ${idl_schema}.icrm_agt_loan_apv.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_agt_loan_apv.agt_id is '协议编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.apv_flow_num is '审批流水号';
comment on column ${idl_schema}.icrm_agt_loan_apv.rela_appl_flow_num is '相关申请流水号';
comment on column ${idl_schema}.icrm_agt_loan_apv.happ_dt is '发生日期';
comment on column ${idl_schema}.icrm_agt_loan_apv.party_id is '当事人编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.bus_breed_id is '业务品种编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.happ_type_cd is '发生类型代码';
comment on column ${idl_schema}.icrm_agt_loan_apv.bank_fin_tot is '银行融资总额';
comment on column ${idl_schema}.icrm_agt_loan_apv.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_agt_loan_apv.apv_amt is '审批金额';
comment on column ${idl_schema}.icrm_agt_loan_apv.tenor_mon is '期限月';
comment on column ${idl_schema}.icrm_agt_loan_apv.loan_usage_descb is '贷款用途描述';
comment on column ${idl_schema}.icrm_agt_loan_apv.oper_org_id is '经办机构编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.oper_teller_id is '经办柜员编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.oper_dt is '经办日期';
comment on column ${idl_schema}.icrm_agt_loan_apv.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.rgst_teller_id is '登记柜员编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.rgst_dt is '登记日期';
comment on column ${idl_schema}.icrm_agt_loan_apv.modif_dt is '变更日期';
comment on column ${idl_schema}.icrm_agt_loan_apv.reply_type_cd is '批复类型代码';
comment on column ${idl_schema}.icrm_agt_loan_apv.circl_flg is '循环标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.apved_dt is '审批通过日期';
comment on column ${idl_schema}.icrm_agt_loan_apv.lmt_circl_flg is '额度循环标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.effect_flg is '生效标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.loan_tenor is '贷款期限';
comment on column ${idl_schema}.icrm_agt_loan_apv.attach_rgst_flg is '补登标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.turn_crdt_flg is '转授信标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.matn_flg is '维护标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.host_bk_name is '主办行行名名称';
comment on column ${idl_schema}.icrm_agt_loan_apv.patip_loan_bank_name is '参贷行行名名称';
comment on column ${idl_schema}.icrm_agt_loan_apv.agent_bank_name is '代理行行名名称';
comment on column ${idl_schema}.icrm_agt_loan_apv.agent_patip_loan_flg is '代理参贷标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.final_jud_pass_dt is '终审通过日期';
comment on column ${idl_schema}.icrm_agt_loan_apv.crdt_rg_cd is '授信区域代码';
comment on column ${idl_schema}.icrm_agt_loan_apv.invo_estate_fin_flg is '涉及房地产融资标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.invo_gover_class_fin_flg is '涉及政府类融资标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.class_crdt_flg is '类信贷标志';
comment on column ${idl_schema}.icrm_agt_loan_apv.reply_id is '批复编号';
comment on column ${idl_schema}.icrm_agt_loan_apv.final_apv_opinion is '最终审批意见';
comment on column ${idl_schema}.icrm_agt_loan_apv.final_apv_opinion_2 is '最终审批意见2';
comment on column ${idl_schema}.icrm_agt_loan_apv.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_agt_loan_apv.etl_timestamp is '数据处理时间';
