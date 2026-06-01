/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_appl_xked_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_appl_xked_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_appl_xked_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_xked_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,crdt_appl_flow_num varchar2(100) -- 信贷申请流水号
    ,prod_id varchar2(100) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,prod_abbr varchar2(500) -- 产品简称
    ,appl_amt number(30,8) -- 申请金额
    ,loan_tenor number(22) -- 贷款期限
    ,main_guar_way_cd varchar2(60) -- 主担保方式代码
    ,lmt_circl_flg varchar2(10) -- 额度循环标志
    ,corp_name varchar2(2000) -- 企业名称
    ,corp_cert_type_cd varchar2(60) -- 企业证件类型代码
    ,corp_cert_no varchar2(60) -- 企业证件号码
    ,corp_cert_exp_dt date -- 企业证件到期日期
    ,corp_mang_range varchar2(500) -- 企业经营范围
    ,corp_mang_begin_dt date -- 企业经营起始日期
    ,corp_mang_exp_dt date -- 企业经营到期日期
    ,corp_found_dt date -- 企业成立日期
    ,score_val varchar2(60) -- 评分分值
    ,mang_local_prov_cd varchar2(60) -- 经营所在省级代码
    ,mang_local_city_cd varchar2(60) -- 经营所在市级代码
    ,mang_site_cd varchar2(60) -- 经营所在地区代码
    ,mang_addr varchar2(500) -- 经营地址
    ,actl_ctrler_work_years number(30) -- 实控人从业年限
    ,flow_calcu_year_sell_inco number(30,8) -- 流水推算年销售收入
    ,tech_inovt_corp_type_cd varchar2(100) -- 科创企业类型代码
    ,corp_solft_coprit_affi_cnt number(30) -- 企业软著登记公告次数
    ,corp_intel_prop_qtty number(30) -- 企业知识产权数量
    ,intel_prop_invent_qtty number(30) -- 知识产权发明数量
    ,intgd_ciut_design_appl_qtty number(30) -- 集成电路布图设计申请数量
    ,intel_prop_tort_punish_cnt number(30) -- 知识产权侵权处罚次数
    ,int_prop_unfair_comption_cnt number(30) -- 知识产权不正当竞争次数
    ,intel_prop_judge_dfndn_cnt number(30) -- 知识产权裁判文书被告次数
    ,m24_ups_bf_5_purchs_amt number(30,8) -- 近24个月上游前5大采购金额
    ,m24_ups_purchs_amt number(30,8) -- 近24个月上游整体采购金额
    ,m24_dos_bf_5_sell_amt number(30,8) -- 近24个月下游前5大销售金额
    ,m24_dos_sell_amt number(30,8) -- 近24个月下游整体销售金额
    ,m12_ias_provi_bf10_tran_amt number(30,8) -- 近12个月重要稳定供应商（前十）交易金额
    ,m12_i_provi_bf10_tran_amt number(30,8) -- 近12个月重要稳定客户（前十）交易金额
    ,m24_open_invoice_inco number(30,8) -- 近24个月开票收入
    ,th_year_max_new_tech_inco number(30,8) -- 本年度高新技术产品（服务）收入
    ,nx_year_max_new_tech_inco number(30,8) -- 上年度高新技术产品（服务）收入
    ,th_year_degree_bus_inco number(30,8) -- 本年度营业收入
    ,th_year_degree_workr_num number(30) -- 本年度从业人数
    ,nx_year_obtain_emply_number number(30) -- 上年度从业人数
    ,th_year_scen_tech_person_num number(30) -- 本年度科技人员人数
    ,nx_year_scen_tech_person_num number(30) -- 上年度科技人员人数
    ,th_year_degree_resdev_amt number(30,8) -- 本年度研发费用金额
    ,nx_year_resdev_fee_amt number(30,8) -- 上年度研发费用金额
    ,th_year_gover_subsidy_inco number(30,8) -- 本年度企业获取政府补贴收入
    ,nx_year_gover_subsidy_inco number(30,8) -- 上年度企业获取政府补贴收入
    ,pre_scd_year_sales_qtty number(30) -- 预测次年销售量
    ,other_chn_provi_oper_cap number(30,8) -- 其他渠道提供的运营资金
    ,crdtc_not_embody_liab_bal number(30,8) -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke number(30,8) -- 征信未体现的月还款额
    ,corp_mon_second_marke number(30,8) -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg varchar2(60) -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt number(30,8) -- 应收账款质押贷款金额
    ,intel_prop_inpwn_flg varchar2(60) -- 知识产权质押标志
    ,intel_prop_inpwn_loan_amt number(30,8) -- 知识产权质押贷款金额
    ,share_right_inpwn_flg varchar2(60) -- 股权质押标志
    ,share_right_inpwn_loan_amt number(30,8) -- 股权质押贷款金额
    ,crdtc_inquirer_idti_cd varchar2(60) -- 征信查询人身份代码
    ,que_appl_type_cd varchar2(60) -- 查询申请类型代码
    ,data_src_cd varchar2(60) -- 数据来源代码
    ,auth_dt date -- 授权日期
    ,auth_effect_dt date -- 授权生效日期
    ,auth_invalid_dt date -- 授权失效日期
    ,hxb_rela_ps_flg varchar2(10) -- 我行关联人标志
    ,corp_cust_id varchar2(100) -- 企业客户编号
    ,flow_status_cd varchar2(60) -- 流程状态代码
    ,task_status_cd varchar2(60) -- 任务状态代码
    ,apv_status_cd varchar2(60) -- 审批状态代码
    ,apv_lmt number(30,8) -- 审批额度
    ,warn_info varchar2(4000) -- 预警信息
    ,tax_type_cd varchar2(10) -- 涉税类型代码
    ,tax_que_auth_flow_num varchar2(100) -- 税务查询授权流水号
    ,tax_num varchar2(100) -- 纳税人识别号
    ,tax_auth_sucs_flg varchar2(60) -- 广税授权成功标志
    ,apv_appl_dt date -- 审批申请日期
    ,apv_end_dt date -- 审批结束日期
    ,corp_new_flg varchar2(10) -- 企业专精特新标志
    ,refuse_rs varchar2(500) -- 拒绝原因
    ,hxb_rela_corp_flg varchar2(100) -- 我行关联企业标志
    ,rg_lon_flg varchar2(100) -- 园区贷标志
    ,advise_flg varchar2(10) -- 通知展业标志
    ,outline_flg varchar2(10) -- 线下标志
    ,lmt_appl_flow_num varchar2(100) -- 授信申请流水号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,belong_brch_org_id varchar2(100) -- 所属分行机构编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,up_date date -- 更新日期
    ,auth_way_cd varchar2(60) -- 授权方式代码
    ,biome_trics_cd varchar2(60) -- 生物识别技术代码
    ,remark varchar2(4000) -- 备注
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
grant select on ${iml_schema}.agt_loan_appl_xked_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_appl_xked_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_appl_xked_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_appl_xked_attach_info_h is '贷款申请兴科E贷附属信息历史';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.crdt_appl_flow_num is '信贷申请流水号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.prod_name is '产品名称';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.prod_abbr is '产品简称';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.appl_amt is '申请金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.lmt_circl_flg is '额度循环标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_name is '企业名称';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_cert_type_cd is '企业证件类型代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_cert_no is '企业证件号码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_cert_exp_dt is '企业证件到期日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_mang_range is '企业经营范围';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_mang_begin_dt is '企业经营起始日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_mang_exp_dt is '企业经营到期日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_found_dt is '企业成立日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.score_val is '评分分值';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.mang_local_prov_cd is '经营所在省级代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.mang_local_city_cd is '经营所在市级代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.mang_site_cd is '经营所在地区代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.mang_addr is '经营地址';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.actl_ctrler_work_years is '实控人从业年限';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.flow_calcu_year_sell_inco is '流水推算年销售收入';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.tech_inovt_corp_type_cd is '科创企业类型代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_solft_coprit_affi_cnt is '企业软著登记公告次数';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_intel_prop_qtty is '企业知识产权数量';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.intel_prop_invent_qtty is '知识产权发明数量';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.intgd_ciut_design_appl_qtty is '集成电路布图设计申请数量';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.intel_prop_tort_punish_cnt is '知识产权侵权处罚次数';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.int_prop_unfair_comption_cnt is '知识产权不正当竞争次数';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.intel_prop_judge_dfndn_cnt is '知识产权裁判文书被告次数';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.m24_ups_bf_5_purchs_amt is '近24个月上游前5大采购金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.m24_ups_purchs_amt is '近24个月上游整体采购金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.m24_dos_bf_5_sell_amt is '近24个月下游前5大销售金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.m24_dos_sell_amt is '近24个月下游整体销售金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.m12_ias_provi_bf10_tran_amt is '近12个月重要稳定供应商（前十）交易金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.m12_i_provi_bf10_tran_amt is '近12个月重要稳定客户（前十）交易金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.m24_open_invoice_inco is '近24个月开票收入';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.th_year_max_new_tech_inco is '本年度高新技术产品（服务）收入';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.nx_year_max_new_tech_inco is '上年度高新技术产品（服务）收入';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.th_year_degree_bus_inco is '本年度营业收入';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.th_year_degree_workr_num is '本年度从业人数';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.nx_year_obtain_emply_number is '上年度从业人数';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.th_year_scen_tech_person_num is '本年度科技人员人数';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.nx_year_scen_tech_person_num is '上年度科技人员人数';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.th_year_degree_resdev_amt is '本年度研发费用金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.nx_year_resdev_fee_amt is '上年度研发费用金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.th_year_gover_subsidy_inco is '本年度企业获取政府补贴收入';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.nx_year_gover_subsidy_inco is '上年度企业获取政府补贴收入';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.pre_scd_year_sales_qtty is '预测次年销售量';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.other_chn_provi_oper_cap is '其他渠道提供的运营资金';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.crdtc_not_embody_liab_bal is '征信未体现的负债余额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.crdtc_not_mon_second_marke is '征信未体现的月还款额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_mon_second_marke is '企业月还款额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_acct_recvbl_inpwn_flg is '企业应收账款质押标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.acct_recvbl_inpwn_loan_amt is '应收账款质押贷款金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.intel_prop_inpwn_flg is '知识产权质押标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.intel_prop_inpwn_loan_amt is '知识产权质押贷款金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.share_right_inpwn_flg is '股权质押标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.share_right_inpwn_loan_amt is '股权质押贷款金额';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.crdtc_inquirer_idti_cd is '征信查询人身份代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.que_appl_type_cd is '查询申请类型代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.data_src_cd is '数据来源代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.auth_dt is '授权日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.auth_effect_dt is '授权生效日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.auth_invalid_dt is '授权失效日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.hxb_rela_ps_flg is '我行关联人标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_cust_id is '企业客户编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.flow_status_cd is '流程状态代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.task_status_cd is '任务状态代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.apv_lmt is '审批额度';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.warn_info is '预警信息';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.tax_type_cd is '涉税类型代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.tax_que_auth_flow_num is '税务查询授权流水号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.tax_num is '纳税人识别号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.tax_auth_sucs_flg is '广税授权成功标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.apv_appl_dt is '审批申请日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.apv_end_dt is '审批结束日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.corp_new_flg is '企业专精特新标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.refuse_rs is '拒绝原因';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.hxb_rela_corp_flg is '我行关联企业标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.rg_lon_flg is '园区贷标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.advise_flg is '通知展业标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.outline_flg is '线下标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.lmt_appl_flow_num is '授信申请流水号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.belong_brch_org_id is '所属分行机构编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.up_date is '更新日期';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.auth_way_cd is '授权方式代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.biome_trics_cd is '生物识别技术代码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.remark is '备注';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_appl_xked_attach_info_h.etl_timestamp is 'ETL处理时间戳';
