/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_loan_appl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_loan_appl_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_appl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_appl_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,loan_appl_flow_num varchar2(60) -- 贷款申请流水号
    ,rela_appl_flow_num varchar2(60) -- 关联申请流水号
    ,bus_breed_id varchar2(60) -- 业务品种编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,lmt_under_sellbl_prod_id varchar2(60) -- 额度项下可售产品编号
    ,cust_id varchar2(60) -- 客户编号
    ,appl_dt date -- 申请日期
    ,oper_org_cd varchar2(60) -- 经办机构代码
    ,operr_id varchar2(60) -- 经办人编号
    ,oper_dt date -- 经办日期
    ,rgst_org_cd varchar2(60) -- 登记机构代码
    ,rgstrat_id varchar2(60) -- 登记人编号
    ,rgst_dt date -- 登记日期
    ,cent_mgmt_dept_cd varchar2(30) -- 归口管理部门编号
    ,appl_way_cd varchar2(60) -- 申请方式代码
    ,tenor_mon number(10) -- 期限月份
    ,loan_tenor number(10) -- 贷款期限
    ,circl_lmt_flg varchar2(10) -- 循环额度标志
    ,curr_cd varchar2(10) -- 币种代码
    ,appl_amt number(30,2) -- 申请金额
    ,apved_dt date -- 审批通过日期
    ,latest_apv_amt number(30,2) -- 最新审批金额
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,happ_type_cd varchar2(30) -- 发生类型代码
    ,cap_src_cd varchar2(10) -- 资金来源代码
    ,crdt_agt_id varchar2(60) -- 授信协议编号
    ,bank_fin_tot number(30,2) -- 银行融资总额
    ,major_guartor_id varchar2(60) -- 主要担保人编号
    ,major_guar_way_cd varchar2(10) -- 主要担保方式代码
    ,guar_way_1 varchar2(10) -- 担保方式1
    ,guar_way_2 varchar2(10) -- 担保方式2
    ,other_guar_way_flg varchar2(10) -- 其他担保方式标志
    ,major_guartor_name varchar2(250) -- 主要担保人名称
    ,main_repay_way_cd varchar2(10) -- 主还款方式代码
    ,repay_ped_cd varchar2(10) -- 还款周期代码
    ,sub_repay_way_cd varchar2(10) -- 子还款方式代码
    ,dir_cd varchar2(10) -- 贷款投向行业代码
    ,usage_descb varchar2(2000) -- 用途描述
    ,other_usage_descb varchar2(200) -- 其他用途描述
    ,effect_flg varchar2(10) -- 生效标志
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,camp_corp_name varchar2(60) -- 营销单位名称
    ,camp_chn_id varchar2(60) -- 营销渠道编号
    ,host_bk_bank_no varchar2(60) -- 主办行行号
    ,host_bank_name varchar2(250) -- 主办行行名称
    ,patip_loan_bank_bank_no varchar2(250) -- 参贷行行号
    ,patip_loan_bank_name varchar2(500) -- 参贷行行名称
    ,agent_bank_bank_no varchar2(60) -- 代理行行号
    ,agent_bank_name varchar2(250) -- 代理行行名称
    ,agent_patip_loan_flg varchar2(10) -- 代理参贷标志
    ,low_risk_bus_flg varchar2(10) -- 低风险业务标志
    ,risk_type_cd varchar2(30) -- 风险类型代码
    ,asset_risk_cls_cd varchar2(10) -- 资产风险分类代码
    ,crdt_rg_cd varchar2(10) -- 授信区域代码
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,group_crdt_corp_lmt number(30,2) -- 集团授信公司额度
    ,group_crdt_corp_open number(30,2) -- 集团授信公司敞口
    ,group_crdt_ibank_lmt number(30,2) -- 集团授信同业额度
    ,group_crdt_ibank_open number(30,2) -- 集团授信同业敞口
    ,loan_insure_guar_flg varchar2(10) -- 贷款保险保障标志
    ,remote_loan_flg varchar2(10) -- 异地贷款标志
    ,estate_fin_flg varchar2(10) -- 房地产融资标志
    ,gover_fin_flg varchar2(10) -- 政府类融资标志
    ,consm_serv_fin_flg varchar2(10) -- 消费服务类融资标志
    ,br_build_ifin_flg varchar2(10) -- 一带一路建设投融资标志
    ,green_crdt_fin_flg varchar2(10) -- 绿色信贷融资标志
    ,proj_fin_flg varchar2(30) -- 项目融资标志
    ,turn_crdt_flg varchar2(10) -- 转授信标志
    ,bar_flg varchar2(10) -- 随借随还标志
    ,ta_crdt_flg varchar2(10) -- 商圈授信标志
    ,risk_mgr_simus_oper_flg varchar2(11) -- 风险经理平行操作标志
    ,sm_flg varchar2(10) -- 小微标志
    ,ky_l_flg varchar2(10) -- 快易贷标志
    ,ts_flg varchar2(10) -- 暂存标志
    ,apv_rest_flow_num varchar2(60) -- 审批结果流水号
    ,o_use_lmt_all_id varchar2(60) -- 他用额度所有人编号
    ,o_use_lmt_id varchar2(60) -- 他用额度编号
    ,o_use_lmt_type_cd varchar2(60) -- 他用额度类型代码
    ,ext_rating_rest_cd varchar2(60) -- 外部评级结果代码
    ,ext_rating_org_name varchar2(250) -- 外部评级机构名称
    ,ext_rating_dt date -- 外部评级日期
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
grant select on ${icl_schema}.cmm_corp_loan_appl_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_loan_appl_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_loan_appl_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_loan_appl_info is '对公贷款申请信息';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.loan_appl_flow_num is '贷款申请流水号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.rela_appl_flow_num is '关联申请流水号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.bus_breed_id is '业务品种编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.lmt_under_sellbl_prod_id is '额度项下可售产品编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.appl_dt is '申请日期';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.oper_org_cd is '经办机构代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.operr_id is '经办人编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.oper_dt is '经办日期';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.rgst_org_cd is '登记机构代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.rgstrat_id is '登记人编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.rgst_dt is '登记日期';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.cent_mgmt_dept_cd is '归口管理部门编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.appl_way_cd is '申请方式代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.tenor_mon is '期限月份';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.loan_tenor is '贷款期限';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.circl_lmt_flg is '循环额度标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.appl_amt is '申请金额';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.apved_dt is '审批通过日期';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.latest_apv_amt is '最新审批金额';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.apv_status_cd is '审批状态代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.happ_type_cd is '发生类型代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.cap_src_cd is '资金来源代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.crdt_agt_id is '授信协议编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.bank_fin_tot is '银行融资总额';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.major_guartor_id is '主要担保人编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.major_guar_way_cd is '主要担保方式代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.guar_way_1 is '担保方式1';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.guar_way_2 is '担保方式2';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.other_guar_way_flg is '其他担保方式标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.major_guartor_name is '主要担保人名称';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.main_repay_way_cd is '主还款方式代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.repay_ped_cd is '还款周期代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.sub_repay_way_cd is '子还款方式代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.dir_cd is '贷款投向行业代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.usage_descb is '用途描述';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.other_usage_descb is '其他用途描述';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.effect_flg is '生效标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.camp_corp_name is '营销单位名称';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.camp_chn_id is '营销渠道编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.host_bk_bank_no is '主办行行号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.host_bank_name is '主办行行名称';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.patip_loan_bank_bank_no is '参贷行行号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.patip_loan_bank_name is '参贷行行名称';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.agent_bank_bank_no is '代理行行号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.agent_bank_name is '代理行行名称';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.agent_patip_loan_flg is '代理参贷标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.low_risk_bus_flg is '低风险业务标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.risk_type_cd is '风险类型代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.asset_risk_cls_cd is '资产风险分类代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.crdt_rg_cd is '授信区域代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.class_crdt_flg is '类信贷标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.group_crdt_corp_lmt is '集团授信公司额度';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.group_crdt_corp_open is '集团授信公司敞口';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.group_crdt_ibank_lmt is '集团授信同业额度';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.group_crdt_ibank_open is '集团授信同业敞口';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.loan_insure_guar_flg is '贷款保险保障标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.remote_loan_flg is '异地贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.estate_fin_flg is '房地产融资标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.gover_fin_flg is '政府类融资标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.consm_serv_fin_flg is '消费服务类融资标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.proj_fin_flg is '项目融资标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.turn_crdt_flg is '转授信标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.bar_flg is '随借随还标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.ta_crdt_flg is '商圈授信标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.risk_mgr_simus_oper_flg is '风险经理平行操作标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.sm_flg is '小微标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.ky_l_flg is '快易贷标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.ts_flg is '暂存标志';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.apv_rest_flow_num is '审批结果流水号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.o_use_lmt_all_id is '他用额度所有人编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.o_use_lmt_id is '他用额度编号';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.o_use_lmt_type_cd is '他用额度类型代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.ext_rating_rest_cd is '外部评级结果代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.ext_rating_org_name is '外部评级机构名称';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.ext_rating_dt is '外部评级日期';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_loan_appl_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_loan_appl_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_loan_appl_info.etl_timestamp is 'ETL处理时间戳';
