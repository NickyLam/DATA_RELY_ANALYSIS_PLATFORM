/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_appl_lmt_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_appl_lmt_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_appl_lmt_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_lmt_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,lmt_next_bus_higt_pm_rat number(18,6) -- 额度下业务最高抵质押率
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
    ,lmt_amt number(30,2) -- 额度金额
    ,lmt_open_amt number(30,2) -- 额度敞口金额
    ,used_amt number(30,2) -- 已用授信额度
    ,used_open_amt number(30,2) -- 已用授信额度
    ,aval_amt number(30,2) -- 可用金额
    ,aval_open_amt number(30,2) -- 可用敞口金额
    ,lmt_latest_use_dt date -- 额度最迟使用日期
    ,ta_crdt_flg varchar2(10) -- 商圈授信标志
    ,yh_crdt_cust_flg varchar2(10) -- 优合授信客户标志
    ,turn_crdt_flg varchar2(10) -- 转授信标志
    ,group_apv_id varchar2(100) -- 集团审批编号
    ,o_use_lmt_flow_num varchar2(100) -- 他用额度流水号
    ,o_use_lmt_type_cd varchar2(30) -- 他用额度类型代码
    ,o_use_lmt_owner_id varchar2(100) -- 他用额度所有人编号
    ,sm_retl_flg varchar2(10) -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg varchar2(10) -- 新增银承额度专项贴现标志
    ,appl_syn_loan_tot_amt number(30,2) -- 申请银团贷款总金额
    ,agent_patip_loan_flg varchar2(10) -- 代理参贷标志
    ,ocup_o_use_lmt_flg varchar2(10) -- 占用他用额度标志
    ,have_incre_crdt_flg varchar2(10) -- 有增信标志
    ,comn_risk_open_lmt number(30,2) -- 一般风险敞口限额
    ,estate_fin_flg varchar2(10) -- 房地产融资标志
    ,gover_class_fin_flg varchar2(10) -- 政府类融资标志
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,ibank_lmt_amt number(30,2) -- 同业额度金额
    ,ibank_open_amt number(30,2) -- 同业敞口金额
    ,onl_lmt_amt number(30,2) -- 线上额度金额
    ,green_crdt_fin_flg varchar2(10) -- 绿色信贷融资标志
    ,consm_serv_class_fin_flg varchar2(10) -- 消费服务类融资标志
    ,br_build_ifin_flg varchar2(10) -- 一带一路建设投融资标志
    ,level11_cls_cd varchar2(30) -- 十一级分类代码
    ,crdt_rg_cd varchar2(30) -- 授信区域代码
    ,ext_rating_rest_cd varchar2(30) -- 外部评级结果代码
    ,ext_rating_org_name varchar2(500) -- 外部评级机构名称
    ,ext_rating_dt date -- 外部评级日期
    ,proj_fin_flg varchar2(10) -- 项目融资标志
    ,cent_mgmt_dept_cd varchar2(30) -- 归口管理部门编号
    ,oa_apv_status_cd varchar2(30) -- OA审批状态代码
    ,inovt_bus_flg varchar2(10) -- 创新业务标志
    ,sup_chain_fin_bus_flg varchar2(10) -- 供应链金融业务标志
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,policy_loan_bus_guar_corp_cd varchar2(250) -- 见保即贷业务担保公司代码
    ,guar_corp_send_tenor number(30) -- 担保公司推送期限
    ,wish_guar_amt number(30,8) -- 意向担保金额
    ,single_higt_crdt_lmt_open_amt number(30,8) -- 单一最高授信额度敞口金额
    ,single_higt_crdt_lmt_nmal_amt number(30,8) -- 单一最高授信额度名义金额
    ,prtcpt_way_cd varchar2(30) -- 参与方式代码
    ,issuer_name varchar2(500) -- 发行方名称
    ,issue_market_type_cd varchar2(30) -- 发行市场类型代码
    ,ths_tm_issue_amt number(30,8) -- 本次发行金额
    ,bfdispay_impt_espec_restr_cond varchar2(500) -- 发放与支付前须落实的特殊限制性条件
    ,patip_loan_bank_name varchar2(500) -- 参贷行名称
    ,agent_bank_name varchar2(500) -- 代理行名称
    ,asset_ctrl_cd varchar2(30) -- 资产控制代码
    ,cap_dir_indus_cd varchar2(60) -- 资金投向行业代码
    ,hq_idtfy_mode_flg varchar2(10) -- 总行认定模式标志
    ,brch_prvlg_int_bus_flg varchar2(10) -- 分行权限内业务标志
    ,host_bk_bank_no varchar2(60) -- 主办行行号
    ,host_bank_name varchar2(500) -- 主办行名称
    ,passer_id varchar2(100) -- 通道方编号
    ,passer_name varchar2(500) -- 通道方名称
    ,risk_mgmt_final_apv_amt number(30,8) -- 风控最终审批金额
    ,risk_mgmt_final_apv_tenor number(30) -- 风控最终审批期限
    ,risk_mgmt_final_status_cd varchar2(30) -- 风控最终状态代码
    ,apprv_issue_tot number(30,8) -- 批准发行总额
    ,corp_open_amt number(30,8) -- 公司敞口金额
    ,corp_crdt_lmt number(30,8) -- 公司授信额度
    ,class_low_risk_flg varchar2(10) -- 类低风险标志
    ,class_low_risk_open_amt number(30,8) -- 类低风险敞口金额
    ,is_single_cust_group_lmt_flg varchar2(10) -- 纳入单一客户或集团限额标志
    ,onl_apv_flg varchar2(10) -- 线上审批标志
    ,onl_apv_lmt number(30,8) -- 线上审批额度
    ,lon_post_mgmt_request varchar2(500) -- 贷后管理要求
    ,crdt_prop_remark varchar2(500) -- 授信方案备注
    ,impt_reach_cont_espec_request varchar2(500) -- 需落实到合约的特殊要求
    ,mgers_cust_id varchar2(100) -- 管理方客户编号
    ,mgers_name varchar2(500) -- 管理方名称
    ,cntpty_cnt number(30) -- 交易对手个数
    ,old_repay_new_oldcont_id varchar2(100) -- 借旧还新旧合同编号
    ,borw_corp_rela_guar_corp_flg varchar2(10) -- 借款企业为担保公司的关联企业标志
    ,borw_corp_hxb_valid_lmt number(30,8) -- 借款企业在我行有效额度
    ,brwer_repay_debt_attr_cd varchar2(30) -- 借款人偿债属性代码
    ,brwer_inco_attr_cd varchar2(30) -- 借款人收入属性代码
    ,brwer_attr_cd varchar2(30) -- 借款人属性代码
    ,can_pente_flg varchar2(10) -- 可穿透标志
    ,flow_calcu_year_sell_inco number(30,8) -- 流水推算的年销售收入
    ,pay_tax_matrl_prev_year_inco number(30,8) -- 纳税申报资料反映的上年度收入
    ,expect_sell_inco_year_grow_rat number(18,6) -- 预计销售收入年增长率
    ,manu_flg varchar2(10) -- 人工填写标志
    ,actl_ctrler_opering_loan_bal number(30,8) -- 实控人经营性贷款余额
    ,inco_ctrl_cd varchar2(30) -- 收入控制代码
    ,invest_underly_descb varchar2(500) -- 投资标的描述
    ,invest_way_cd varchar2(30) -- 投资方式代码
    ,bond_item_cls_cd varchar2(30) -- 债项分类代码
    ,cust_cred_rat_rating_rest_cd varchar2(30) -- 客户内评评级结果代码
    ,ext_main_rating_cd varchar2(60) -- 外部主体评级代码
    ,main_rating_org_name varchar2(500) -- 主体评级机构名称
    ,main_rating_dt date -- 主体评级日期
    ,arti_fin_type_cd varchar2(30) -- 物品融资类型代码
    ,merchd_fin_obj_cd varchar2(30) -- 商品融资对象代码
    ,proj_fin_type_cd varchar2(30) -- 项目融资类型代码
    ,sm_corp_loan_flg varchar2(10) -- 小微企业贷款标志
    ,init_eqty_ps_name varchar2(500) -- 原始权益方名称
    ,debt_regroup_cnt number(30) -- 债务重组次数
    ,auto_que_lon_post_rept_flg varchar2(10) -- 自动查询贷后报告标志
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
grant select on ${iml_schema}.agt_loan_appl_lmt_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_appl_lmt_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_appl_lmt_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_appl_lmt_attach_info_h is '贷款申请额度附属信息历史';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_next_bus_higt_pm_rat is '额度下业务最高抵质押率';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_next_bus_init_margin_ratio is '额度下业务初始保证金比例';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_next_bus_int_rat_lowt_flo_val is '额度下业务利率最低浮动值';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_next_bus_sig_max_amt is '额度下业务单笔最大金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_next_bus_lont_tenor is '额度下业务最长期限';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_next_bus_delay_renew_tenor is '额度下业务延展期限';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.public_crdt_flg is '公开授信标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_dir_use_flg is '额度可直接使用标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_kind_cd is '额度种类代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.group_lmt_crtl_mode_cd is '集团额度管控模式代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.under_bus_curr_cd_range is '项下业务币种代码范围';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_amt is '额度金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_open_amt is '额度敞口金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.used_amt is '已用授信额度';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.used_open_amt is '已用授信额度';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.aval_amt is '可用金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.aval_open_amt is '可用敞口金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lmt_latest_use_dt is '额度最迟使用日期';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ta_crdt_flg is '商圈授信标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.yh_crdt_cust_flg is '优合授信客户标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.turn_crdt_flg is '转授信标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.group_apv_id is '集团审批编号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.o_use_lmt_flow_num is '他用额度流水号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.o_use_lmt_type_cd is '他用额度类型代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.o_use_lmt_owner_id is '他用额度所有人编号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.sm_retl_flg is '小微零售标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.add_ba_lmt_spcl_discnt_flg is '新增银承额度专项贴现标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.appl_syn_loan_tot_amt is '申请银团贷款总金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.agent_patip_loan_flg is '代理参贷标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ocup_o_use_lmt_flg is '占用他用额度标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.have_incre_crdt_flg is '有增信标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.comn_risk_open_lmt is '一般风险敞口限额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.estate_fin_flg is '房地产融资标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.gover_class_fin_flg is '政府类融资标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.class_crdt_flg is '类信贷标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ibank_lmt_amt is '同业额度金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ibank_open_amt is '同业敞口金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.onl_lmt_amt is '线上额度金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.level11_cls_cd is '十一级分类代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.crdt_rg_cd is '授信区域代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ext_rating_rest_cd is '外部评级结果代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ext_rating_org_name is '外部评级机构名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ext_rating_dt is '外部评级日期';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.proj_fin_flg is '项目融资标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.cent_mgmt_dept_cd is '归口管理部门编号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.oa_apv_status_cd is 'OA审批状态代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.inovt_bus_flg is '创新业务标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.sup_chain_fin_bus_flg is '供应链金融业务标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.policy_loan_bus_guar_corp_cd is '见保即贷业务担保公司代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.guar_corp_send_tenor is '担保公司推送期限';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.wish_guar_amt is '意向担保金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.single_higt_crdt_lmt_open_amt is '单一最高授信额度敞口金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.single_higt_crdt_lmt_nmal_amt is '单一最高授信额度名义金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.prtcpt_way_cd is '参与方式代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.issuer_name is '发行方名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.issue_market_type_cd is '发行市场类型代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ths_tm_issue_amt is '本次发行金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.bfdispay_impt_espec_restr_cond is '发放与支付前须落实的特殊限制性条件';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.patip_loan_bank_name is '参贷行名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.agent_bank_name is '代理行名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.asset_ctrl_cd is '资产控制代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.cap_dir_indus_cd is '资金投向行业代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.hq_idtfy_mode_flg is '总行认定模式标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.brch_prvlg_int_bus_flg is '分行权限内业务标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.host_bk_bank_no is '主办行行号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.host_bank_name is '主办行名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.passer_id is '通道方编号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.passer_name is '通道方名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.risk_mgmt_final_apv_amt is '风控最终审批金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.risk_mgmt_final_apv_tenor is '风控最终审批期限';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.risk_mgmt_final_status_cd is '风控最终状态代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.apprv_issue_tot is '批准发行总额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.corp_open_amt is '公司敞口金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.corp_crdt_lmt is '公司授信额度';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.class_low_risk_flg is '类低风险标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.class_low_risk_open_amt is '类低风险敞口金额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.is_single_cust_group_lmt_flg is '纳入单一客户或集团限额标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.onl_apv_flg is '线上审批标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.onl_apv_lmt is '线上审批额度';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.lon_post_mgmt_request is '贷后管理要求';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.crdt_prop_remark is '授信方案备注';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.impt_reach_cont_espec_request is '需落实到合约的特殊要求';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.mgers_cust_id is '管理方客户编号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.mgers_name is '管理方名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.cntpty_cnt is '交易对手个数';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.old_repay_new_oldcont_id is '借旧还新旧合同编号';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.borw_corp_rela_guar_corp_flg is '借款企业为担保公司的关联企业标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.borw_corp_hxb_valid_lmt is '借款企业在我行有效额度';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.brwer_repay_debt_attr_cd is '借款人偿债属性代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.brwer_inco_attr_cd is '借款人收入属性代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.brwer_attr_cd is '借款人属性代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.can_pente_flg is '可穿透标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.flow_calcu_year_sell_inco is '流水推算的年销售收入';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.pay_tax_matrl_prev_year_inco is '纳税申报资料反映的上年度收入';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.expect_sell_inco_year_grow_rat is '预计销售收入年增长率';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.manu_flg is '人工填写标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.actl_ctrler_opering_loan_bal is '实控人经营性贷款余额';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.inco_ctrl_cd is '收入控制代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.invest_underly_descb is '投资标的描述';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.invest_way_cd is '投资方式代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.bond_item_cls_cd is '债项分类代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.cust_cred_rat_rating_rest_cd is '客户内评评级结果代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.ext_main_rating_cd is '外部主体评级代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.main_rating_org_name is '主体评级机构名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.main_rating_dt is '主体评级日期';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.arti_fin_type_cd is '物品融资类型代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.merchd_fin_obj_cd is '商品融资对象代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.proj_fin_type_cd is '项目融资类型代码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.sm_corp_loan_flg is '小微企业贷款标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.init_eqty_ps_name is '原始权益方名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.debt_regroup_cnt is '债务重组次数';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.auto_que_lon_post_rept_flg is '自动查询贷后报告标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_appl_lmt_attach_info_h.etl_timestamp is 'ETL处理时间戳';
