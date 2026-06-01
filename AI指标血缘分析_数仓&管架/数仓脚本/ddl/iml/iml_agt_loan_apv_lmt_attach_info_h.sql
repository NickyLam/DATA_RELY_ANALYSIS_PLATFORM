/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_apv_lmt_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_apv_lmt_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_apv_lmt_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_apv_lmt_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,apv_flow_num varchar2(100) -- 审批流水号
    ,lmt_next_bus_higt_pm_ratio number(18,6) -- 额度下业务最高抵质押比例
    ,lmt_next_bus_init_margin_ratio number(18,6) -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val number(18,6) -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt number(30,2) -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor number(10) -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor number(10) -- 额度下业务延展期限
    ,public_crdt_flg varchar2(10) -- 公开授信标志
    ,lmt_dir_use_flg varchar2(10) -- 额度可直接使用标志
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,lmt_kind_cd varchar2(30) -- 额度种类代码
    ,group_lmt_crtl_mode_cd varchar2(30) -- 集团额度管控模式代码
    ,under_bus_curr_cd_range varchar2(250) -- 项下业务币种代码范围
    ,lmt_nmal_amt number(30,2) -- 额度名义金额
    ,lmt_open_amt number(30,2) -- 额度敞口金额
    ,used_nmal_amt number(30,2) -- 已用名义金额
    ,used_open_amt number(30,2) -- 已用授信额度
    ,aval_nmal_amt number(30,2) -- 可用名义金额
    ,aval_open_amt number(30,2) -- 可用敞口金额
    ,ocup_o_use_lmt_flg varchar2(10) -- 占用他用额度标志
    ,comn_risk_open_lmt number(30,2) -- 一般风险敞口限额
    ,class_low_risk_flg varchar2(10) -- 类低风险标志
    ,class_low_risk_open_amt number(30,8) -- 类低风险敞口金额
    ,lmt_invalid_dt date -- 额度失效日期
    ,group_apv_id varchar2(100) -- 集团审批编号
    ,group_cust_spcl_lmt_flow_num varchar2(100) -- 集群客户专项额度流水号
    ,group_cust_spcl_lmt_owner_name varchar2(500) -- 集群客户专项额度所有人名称
    ,o_use_lmt_flow_num varchar2(100) -- 他用额度流水号
    ,o_use_lmt_type_cd varchar2(30) -- 他用额度类型代码
    ,o_use_lmt_owner_name varchar2(500) -- 他用额度所有人名称
    ,appl_syn_loan_tot number(30,2) -- 申请银团贷款总额
    ,agent_patip_loan_flg varchar2(10) -- 代理参贷标志
    ,auto_que_lon_post_rept_flg varchar2(10) -- 自动查询贷后报告标志
    ,crdtc_auth_blip_flow_num varchar2(100) -- 征信授权影像流水号
    ,need_annual_vrfction_flg varchar2(10) -- 需年审标志
    ,cust_rating_rest_cd varchar2(30) -- 客户评级结果代码
    ,final_apv_opinion_one varchar2(4000) -- 最终审批意见一
    ,final_apv_opinion_two varchar2(4000) -- 最终审批意见二
    ,apv_dt date -- 审批日期
    ,l_ped_annual_vrfction_dt date -- 上期年审日期
    ,curr_issue_annual_vrfction_dt date -- 本期年审日期
    ,corp_lmt_amt number(30,2) -- 公司额度金额
    ,corp_open_amt number(30,2) -- 公司敞口金额
    ,ibank_lmt_amt number(30,2) -- 同业额度金额
    ,ibank_open_amt number(30,2) -- 同业敞口金额
    ,under_bus_provi_guar_guar_flg varchar2(10) -- 项下业务提供保证担保标志
    ,under_bus_bear_repo_duty_flg varchar2(10) -- 项下业务承担回购责任标志
    ,under_bus_major_guar_way_cd varchar2(30) -- 项下业务主要担保方式代码
    ,proj_name varchar2(500) -- 项目名称
    ,proj_tot_area number(30,2) -- 项目总面积
    ,proj_addr varchar2(500) -- 项目地址
    ,pre_sell_lics_id varchar2(100) -- 销(预)售许可证编号
    ,arch_land_plan_lics_id varchar2(100) -- 建设用地规划可证编号
    ,nation_land_use_cert_id varchar2(100) -- 国有土地使用证编号
    ,cnstr_proj_plan_permit_id varchar2(100) -- 建设工程规划许可证编号
    ,arch_proj_cnstr_lics_id varchar2(200) -- 建筑工程施工可证编号
    ,higt_apv_ratio number(18,6) -- 最高审批比例
    ,lont_year_tenor number(10) -- 最长年期限
    ,provi_fund_loan_comm_fee_ratio number(18,6) -- 公积金贷款手续费比例
    ,guar_mon_tenor number(10) -- 担保月期限
    ,onl_lmt number(30,2) -- 线上额度
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,crdt_rg_cd varchar2(30) -- 授信区域代码
    ,invo_estate_fin_flg varchar2(10) -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg varchar2(10) -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg varchar2(10) -- 消费服务类融资标志
    ,br_build_ifin_flg varchar2(10) -- 一带一路建设投融资标志
    ,green_crdt_fin_flg varchar2(10) -- 绿色信贷融资标志
    ,invest_way_cd varchar2(30) -- 投资方式代码
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,ta_crdt_flg varchar2(10) -- 商圈授信标志
    ,yh_crdt_cust_flg varchar2(10) -- 优合授信客户标志
    ,sm_retl_flg varchar2(10) -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg varchar2(10) -- 新增银承额度专项贴现标志
    ,sm_corp_loan_flg varchar2(10) -- 小微企业贷款标志
    ,hq_idtfy_mode_flg varchar2(10) -- 总行认定模式标志
    ,have_incre_crdt_flg varchar2(10) -- 有增信标志
    ,turn_crdt_flg varchar2(10) -- 转授信标志
    ,host_bank_no varchar2(60) -- 主办行行号
    ,host_bank_name varchar2(500) -- 主办行名称
    ,patip_loan_bank_no varchar2(60) -- 参贷行行号
    ,patip_loan_bank_name varchar2(500) -- 参贷行名称
    ,agent_bank_no varchar2(60) -- 代理行行号
    ,agent_bank_name varchar2(500) -- 代理行名称
    ,prtcpt_way_cd varchar2(30) -- 参与方式代码
    ,margin_ratio number(18,6) -- 保证金比例
    ,margin_amt number(30,8) -- 保证金金额
    ,intnal_rating_rest_cd varchar2(30) -- 内部评级结果代码
    ,ext_bond_item_rating_cd varchar2(30) -- 外部债项评级代码
    ,ext_rating_org_name varchar2(500) -- 外部评级机构名称
    ,ext_rating_dt date -- 外部评级日期
    ,invest_underly_descb varchar2(500) -- 投资标的描述
    ,issue_site_cd varchar2(30) -- 发行场所代码
    ,cent_mgmt_dept_id varchar2(100) -- 归口管理部门编号
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,ext_main_rating_cd varchar2(30) -- 外部主体评级代码
    ,main_rating_org_name varchar2(500) -- 主体评级机构名称
    ,main_rating_dt date -- 主体评级日期
    ,single_higt_crdt_lmt_nmal_amt number(30,8) -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt number(30,8) -- 单一最高授信额度敞口金额
    ,debt_regroup_cnt number(10) -- 债务重组次数
    ,manu_flg varchar2(10) -- 人工填写标志
    ,inovt_bus_flg varchar2(10) -- 创新业务标志
    ,sup_chain_fin_bus_flg varchar2(10) -- 供应链金融业务标志
    ,fit_in_single_cust_or_group_lmt_flg varchar2(10) -- 纳入单一客户或集团的限额标志
    ,comb_class_consmt_flg varchar2(10) -- 集合类代销标志
    ,anti_mon_lau_sys_rating_cd varchar2(60) -- 反洗钱系统评级代码
    ,set_single_cust_lmt_flg varchar2(10) -- 设置单一客户限额标志
    ,mger_name varchar2(500) -- 管理人名称
    ,mger_cust_id varchar2(100) -- 管理人客户编号
    ,lon_post_request_attach_comnt varchar2(4000) -- 贷后要求补充说明
    ,group_cust_crdt_prop_remark varchar2(4000) -- 集群客户授信方案备注
    ,bfdistr_pay_impt_esp_restrcond varchar2(4000) -- 发放与支付前须落实的特殊限制性条件
    ,impt_reach_cont_esp_request varchar2(4000) -- 需落实到合约的特殊要求
    ,crdt_prop_remark varchar2(4000) -- 授信方案备注
    ,lon_post_request varchar2(4000) -- 贷后要求
    ,lon_post_mgmt_request varchar2(4000) -- 贷后管理要求
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
grant select on ${iml_schema}.agt_loan_apv_lmt_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_apv_lmt_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_apv_lmt_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_apv_lmt_attach_info_h is '贷款审批额度附属信息历史';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.apv_flow_num is '审批流水号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_next_bus_higt_pm_ratio is '额度下业务最高抵质押比例';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_next_bus_init_margin_ratio is '额度下业务初始保证金比例';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_next_bus_int_rat_lowt_flo_val is '额度下业务利率最低浮动值';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_next_bus_sig_max_amt is '额度下业务单笔最大金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_next_bus_lont_tenor is '额度下业务最长期限';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_next_bus_delay_renew_tenor is '额度下业务延展期限';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.public_crdt_flg is '公开授信标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_dir_use_flg is '额度可直接使用标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_kind_cd is '额度种类代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.group_lmt_crtl_mode_cd is '集团额度管控模式代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.under_bus_curr_cd_range is '项下业务币种代码范围';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_nmal_amt is '额度名义金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_open_amt is '额度敞口金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.used_nmal_amt is '已用名义金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.used_open_amt is '已用授信额度';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.aval_nmal_amt is '可用名义金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.aval_open_amt is '可用敞口金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.ocup_o_use_lmt_flg is '占用他用额度标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.comn_risk_open_lmt is '一般风险敞口限额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.class_low_risk_flg is '类低风险标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.class_low_risk_open_amt is '类低风险敞口金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lmt_invalid_dt is '额度失效日期';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.group_apv_id is '集团审批编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.group_cust_spcl_lmt_flow_num is '集群客户专项额度流水号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.group_cust_spcl_lmt_owner_name is '集群客户专项额度所有人名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.o_use_lmt_flow_num is '他用额度流水号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.o_use_lmt_type_cd is '他用额度类型代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.o_use_lmt_owner_name is '他用额度所有人名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.appl_syn_loan_tot is '申请银团贷款总额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.agent_patip_loan_flg is '代理参贷标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.auto_que_lon_post_rept_flg is '自动查询贷后报告标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.crdtc_auth_blip_flow_num is '征信授权影像流水号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.need_annual_vrfction_flg is '需年审标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.cust_rating_rest_cd is '客户评级结果代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.final_apv_opinion_one is '最终审批意见一';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.final_apv_opinion_two is '最终审批意见二';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.apv_dt is '审批日期';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.l_ped_annual_vrfction_dt is '上期年审日期';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.curr_issue_annual_vrfction_dt is '本期年审日期';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.corp_lmt_amt is '公司额度金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.corp_open_amt is '公司敞口金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.ibank_lmt_amt is '同业额度金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.ibank_open_amt is '同业敞口金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.under_bus_provi_guar_guar_flg is '项下业务提供保证担保标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.under_bus_bear_repo_duty_flg is '项下业务承担回购责任标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.under_bus_major_guar_way_cd is '项下业务主要担保方式代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.proj_name is '项目名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.proj_tot_area is '项目总面积';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.proj_addr is '项目地址';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.pre_sell_lics_id is '销(预)售许可证编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.arch_land_plan_lics_id is '建设用地规划可证编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.nation_land_use_cert_id is '国有土地使用证编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.cnstr_proj_plan_permit_id is '建设工程规划许可证编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.arch_proj_cnstr_lics_id is '建筑工程施工可证编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.higt_apv_ratio is '最高审批比例';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lont_year_tenor is '最长年期限';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.provi_fund_loan_comm_fee_ratio is '公积金贷款手续费比例';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.guar_mon_tenor is '担保月期限';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.onl_lmt is '线上额度';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.crdt_rg_cd is '授信区域代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.invo_estate_fin_flg is '涉及房地产融资标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.invo_gover_class_fin_flg is '涉及政府类融资标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.invest_way_cd is '投资方式代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.class_crdt_flg is '类信贷标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.ta_crdt_flg is '商圈授信标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.yh_crdt_cust_flg is '优合授信客户标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.sm_retl_flg is '小微零售标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.add_ba_lmt_spcl_discnt_flg is '新增银承额度专项贴现标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.sm_corp_loan_flg is '小微企业贷款标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.hq_idtfy_mode_flg is '总行认定模式标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.have_incre_crdt_flg is '有增信标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.turn_crdt_flg is '转授信标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.host_bank_no is '主办行行号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.host_bank_name is '主办行名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.patip_loan_bank_no is '参贷行行号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.patip_loan_bank_name is '参贷行名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.agent_bank_no is '代理行行号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.agent_bank_name is '代理行名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.prtcpt_way_cd is '参与方式代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.margin_ratio is '保证金比例';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.margin_amt is '保证金金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.intnal_rating_rest_cd is '内部评级结果代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.ext_bond_item_rating_cd is '外部债项评级代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.ext_rating_org_name is '外部评级机构名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.ext_rating_dt is '外部评级日期';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.invest_underly_descb is '投资标的描述';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.issue_site_cd is '发行场所代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.cent_mgmt_dept_id is '归口管理部门编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.ext_main_rating_cd is '外部主体评级代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.main_rating_org_name is '主体评级机构名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.main_rating_dt is '主体评级日期';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.single_higt_crdt_lmt_nmal_amt is '单一最高授信额度名义金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.single_higt_crdt_lmt_open_amt is '单一最高授信额度敞口金额';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.debt_regroup_cnt is '债务重组次数';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.manu_flg is '人工填写标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.inovt_bus_flg is '创新业务标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.sup_chain_fin_bus_flg is '供应链金融业务标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.fit_in_single_cust_or_group_lmt_flg is '纳入单一客户或集团的限额标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.comb_class_consmt_flg is '集合类代销标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.anti_mon_lau_sys_rating_cd is '反洗钱系统评级代码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.set_single_cust_lmt_flg is '设置单一客户限额标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.mger_name is '管理人名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.mger_cust_id is '管理人客户编号';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lon_post_request_attach_comnt is '贷后要求补充说明';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.group_cust_crdt_prop_remark is '集群客户授信方案备注';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.bfdistr_pay_impt_esp_restrcond is '发放与支付前须落实的特殊限制性条件';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.impt_reach_cont_esp_request is '需落实到合约的特殊要求';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.crdt_prop_remark is '授信方案备注';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lon_post_request is '贷后要求';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.lon_post_mgmt_request is '贷后管理要求';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_apv_lmt_attach_info_h.etl_timestamp is 'ETL处理时间戳';
