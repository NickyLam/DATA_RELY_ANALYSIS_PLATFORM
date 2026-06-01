/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_appl_lmt_attach_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_appl_lmt_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_lmt_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,public_crdt_flg -- 公开授信标志
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_amt -- 额度金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_amt -- 已用授信额度
    ,used_open_amt -- 已用授信额度
    ,aval_amt -- 可用金额
    ,aval_open_amt -- 可用敞口金额
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,turn_crdt_flg -- 转授信标志
    ,group_apv_id -- 集团审批编号
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_id -- 他用额度所有人编号
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,appl_syn_loan_tot_amt -- 申请银团贷款总金额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,have_incre_crdt_flg -- 有增信标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,estate_fin_flg -- 房地产融资标志
    ,gover_class_fin_flg -- 政府类融资标志
    ,cap_src_cd -- 资金来源代码
    ,class_crdt_flg -- 类信贷标志
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,onl_lmt_amt -- 线上额度金额
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,level11_cls_cd -- 十一级分类代码
    ,crdt_rg_cd -- 授信区域代码
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,proj_fin_flg -- 项目融资标志
    ,cent_mgmt_dept_cd -- 归口管理部门编号
    ,oa_apv_status_cd -- OA审批状态代码
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,guar_way_cd -- 担保方式代码
    ,policy_loan_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,wish_guar_amt -- 意向担保金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,prtcpt_way_cd -- 参与方式代码
    ,issuer_name -- 发行方名称
    ,issue_market_type_cd -- 发行市场类型代码
    ,ths_tm_issue_amt -- 本次发行金额
    ,bfdispay_impt_espec_restr_cond -- 发放与支付前须落实的特殊限制性条件
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_name -- 代理行名称
    ,asset_ctrl_cd -- 资产控制代码
    ,cap_dir_indus_cd -- 资金投向行业代码
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,brch_prvlg_int_bus_flg -- 分行权限内业务标志
    ,host_bk_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,risk_mgmt_final_apv_amt -- 风控最终审批金额
    ,risk_mgmt_final_apv_tenor -- 风控最终审批期限
    ,risk_mgmt_final_status_cd -- 风控最终状态代码
    ,apprv_issue_tot -- 批准发行总额
    ,corp_open_amt -- 公司敞口金额
    ,corp_crdt_lmt -- 公司授信额度
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,is_single_cust_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,onl_apv_flg -- 线上审批标志
    ,onl_apv_lmt -- 线上审批额度
    ,lon_post_mgmt_request -- 贷后管理要求
    ,crdt_prop_remark -- 授信方案备注
    ,impt_reach_cont_espec_request -- 需落实到合约的特殊要求
    ,mgers_cust_id -- 管理方客户编号
    ,mgers_name -- 管理方名称
    ,cntpty_cnt -- 交易对手个数
    ,old_repay_new_oldcont_id -- 借旧还新旧合同编号
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,borw_corp_hxb_valid_lmt -- 借款企业在我行有效额度
    ,brwer_repay_debt_attr_cd -- 借款人偿债属性代码
    ,brwer_inco_attr_cd -- 借款人收入属性代码
    ,brwer_attr_cd -- 借款人属性代码
    ,can_pente_flg -- 可穿透标志
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,pay_tax_matrl_prev_year_inco -- 纳税申报资料反映的上年度收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,manu_flg -- 人工填写标志
    ,actl_ctrler_opering_loan_bal -- 实控人经营性贷款余额
    ,inco_ctrl_cd -- 收入控制代码
    ,invest_underly_descb -- 投资标的描述
    ,invest_way_cd -- 投资方式代码
    ,bond_item_cls_cd -- 债项分类代码
    ,cust_cred_rat_rating_rest_cd -- 客户内评评级结果代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,arti_fin_type_cd -- 物品融资类型代码
    ,merchd_fin_obj_cd -- 商品融资对象代码
    ,proj_fin_type_cd -- 项目融资类型代码
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,init_eqty_ps_name -- 原始权益方名称
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_lmt_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_lmt_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_lmt_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ba_cl_info-1
insert into ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,public_crdt_flg -- 公开授信标志
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_amt -- 额度金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_amt -- 已用授信额度
    ,used_open_amt -- 已用授信额度
    ,aval_amt -- 可用金额
    ,aval_open_amt -- 可用敞口金额
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,turn_crdt_flg -- 转授信标志
    ,group_apv_id -- 集团审批编号
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_id -- 他用额度所有人编号
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,appl_syn_loan_tot_amt -- 申请银团贷款总金额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,have_incre_crdt_flg -- 有增信标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,estate_fin_flg -- 房地产融资标志
    ,gover_class_fin_flg -- 政府类融资标志
    ,cap_src_cd -- 资金来源代码
    ,class_crdt_flg -- 类信贷标志
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,onl_lmt_amt -- 线上额度金额
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,level11_cls_cd -- 十一级分类代码
    ,crdt_rg_cd -- 授信区域代码
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,proj_fin_flg -- 项目融资标志
    ,cent_mgmt_dept_cd -- 归口管理部门编号
    ,oa_apv_status_cd -- OA审批状态代码
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,guar_way_cd -- 担保方式代码
    ,policy_loan_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,wish_guar_amt -- 意向担保金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,prtcpt_way_cd -- 参与方式代码
    ,issuer_name -- 发行方名称
    ,issue_market_type_cd -- 发行市场类型代码
    ,ths_tm_issue_amt -- 本次发行金额
    ,bfdispay_impt_espec_restr_cond -- 发放与支付前须落实的特殊限制性条件
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_name -- 代理行名称
    ,asset_ctrl_cd -- 资产控制代码
    ,cap_dir_indus_cd -- 资金投向行业代码
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,brch_prvlg_int_bus_flg -- 分行权限内业务标志
    ,host_bk_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,risk_mgmt_final_apv_amt -- 风控最终审批金额
    ,risk_mgmt_final_apv_tenor -- 风控最终审批期限
    ,risk_mgmt_final_status_cd -- 风控最终状态代码
    ,apprv_issue_tot -- 批准发行总额
    ,corp_open_amt -- 公司敞口金额
    ,corp_crdt_lmt -- 公司授信额度
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,is_single_cust_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,onl_apv_flg -- 线上审批标志
    ,onl_apv_lmt -- 线上审批额度
    ,lon_post_mgmt_request -- 贷后管理要求
    ,crdt_prop_remark -- 授信方案备注
    ,impt_reach_cont_espec_request -- 需落实到合约的特殊要求
    ,mgers_cust_id -- 管理方客户编号
    ,mgers_name -- 管理方名称
    ,cntpty_cnt -- 交易对手个数
    ,old_repay_new_oldcont_id -- 借旧还新旧合同编号
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,borw_corp_hxb_valid_lmt -- 借款企业在我行有效额度
    ,brwer_repay_debt_attr_cd -- 借款人偿债属性代码
    ,brwer_inco_attr_cd -- 借款人收入属性代码
    ,brwer_attr_cd -- 借款人属性代码
    ,can_pente_flg -- 可穿透标志
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,pay_tax_matrl_prev_year_inco -- 纳税申报资料反映的上年度收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,manu_flg -- 人工填写标志
    ,actl_ctrler_opering_loan_bal -- 实控人经营性贷款余额
    ,inco_ctrl_cd -- 收入控制代码
    ,invest_underly_descb -- 投资标的描述
    ,invest_way_cd -- 投资方式代码
    ,bond_item_cls_cd -- 债项分类代码
    ,cust_cred_rat_rating_rest_cd -- 客户内评评级结果代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,arti_fin_type_cd -- 物品融资类型代码
    ,merchd_fin_obj_cd -- 商品融资对象代码
    ,proj_fin_type_cd -- 项目融资类型代码
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,init_eqty_ps_name -- 原始权益方名称
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206004'||P1.SERIALNO -- 申请编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.BIZMOSTMORTGAGERATE -- 额度下业务最高抵质押率
    ,P1.BIZBAILINITIALRATE -- 额度下业务初始保证金比例
    ,P1.BIZLOWESTFLOATRATE -- 额度下业务利率最低浮动值
    ,P1.SINGLEBIZMOSTAMOUNT -- 额度下业务单笔最大金额
    ,P1.BIZLONGESTTERM -- 额度下业务最长期限
    ,P1.BIZEXTENDEDTERM -- 额度下业务延展期限
    ,nvl(trim(P1.ISPUBLICCREDIT),'-') -- 公开授信标志
    ,nvl(trim(P1.USEWITHOUTCONDITION),'-') -- 额度可直接使用标志
    ,nvl(trim(P1.TERMTYPE),'-') -- 期限类型代码
    ,nvl(trim(p1.LINECLASS),'-') -- 额度种类代码
    ,nvl(trim(P1.LINECONTROLMODE),'-') -- 集团额度管控模式代码
    ,nvl(trim(P1.CURRENCYRANGE),'-') -- 项下业务币种代码范围
    ,P1.NOMINALSUM -- 额度金额
    ,P1.EXPOSURESUM -- 额度敞口金额
    ,P1.OCCUPYNOMINALSUM -- 已用授信额度
    ,P1.OCCUPYEXPOSURESUM -- 已用授信额度
    ,P1.AVAILABLENOMINALSUM -- 可用金额
    ,P1.AVAILABLEEXPOSURESUM -- 可用敞口金额
    ,P1.LATESTUSEDATE -- 额度最迟使用日期
    ,nvl(trim(P1.ISFINANCIALCREDIT),'-') -- 商圈授信标志
    ,nvl(trim(P1.ISYHCUSTOMER),'-') -- 优合授信客户标志
    ,nvl(trim(P1.ISTRANS),'-') -- 转授信标志
    ,P1.BELONGGROUPAPPROVENO -- 集团审批编号
    ,P1.OTHERLIMITNO -- 他用额度流水号
    ,nvl(trim(P1.OTHERLIMITTYPE),'-') -- 他用额度类型代码
    ,P1.OTHERLIMITOWNERID -- 他用额度所有人编号
    ,nvl(trim(P1.ISSMEANDRETAIL),'-') -- 小微零售标志
    ,nvl(trim(P1.ISBILLAPPLY),'-') -- 新增银承额度专项贴现标志
    ,P1.SQDKZE -- 申请银团贷款总金额
    ,nvl(trim(P1.DLCDBZ),'-') -- 代理参贷标志
    ,nvl(trim(P1.OTHERLIMITFLAG),'-') -- 占用他用额度标志
    ,nvl(trim(P1.ISCREDITINCREMENT),'-') -- 有增信标志
    ,P1.RISKEXPOSURESUM -- 一般风险敞口限额
    ,P1.ISESTATEFINANCE -- 房地产融资标志
    ,P1.ISGOVERNFINANCE -- 政府类融资标志
    ,nvl(trim(P1.FUNDSOURCE),'-') -- 资金来源代码
    ,nvl(trim(P1.ISLIKELOAN),'-') -- 类信贷标志
    ,P1.BUSINESSSUMTYPART -- 同业额度金额
    ,P1.TOTALSUMTYPART -- 同业敞口金额
    ,P1.ONLINEAMOUNT -- 线上额度金额
    ,nvl(trim(P1.ISGREENFINANCE),'-') -- 绿色信贷融资标志
    ,nvl(trim(P1.ISCONSUMERFINANCE),'-') -- 消费服务类融资标志
    ,nvl(trim(P1.ISBELTROADFINANCE),'-') -- 一带一路建设投融资标志
    ,nvl(trim(P1.CLASSIFYRESULTELEVEN),'-') -- 十一级分类代码
    ,NVL(TRIM(P1.CREDITAREA),'00') -- 授信区域代码
    ,nvl(trim(P1.OUTCLASSIFYLEVEL),'-') -- 外部评级结果代码
    ,P1.OUTCLASSIFYORG -- 外部评级机构名称
    ,${iml_schema}.dateformat_max2(P1.OUTCLASSIFYDATE) -- 外部评级日期
    ,nvl(trim(P1.ISPROJECTFINANCING),'-') -- 项目融资标志
    ,nvl(trim(P1.HXTYOPERATEORG),'07') -- 归口管理部门编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.OASTATUS END -- OA审批状态代码
    ,nvl(trim(P1.ISINNOVATE),'-') -- 创新业务标志
    ,nvl(trim(P1.ISSUPPLYCHAINFINANCE),'-') -- 供应链金融业务标志
    ,nvl(trim(P1.AUTHVOUCHTYPE),'-') -- 担保方式代码
    ,nvl(trim(P1.GUARANTEECOMPANYNAME),'-') -- 见保即贷业务担保公司代码
    ,P1.GUARCOMPANYTERM -- 担保公司推送期限
    ,P1.BONDINGCOMPANYINAMT -- 意向担保金额
    ,P1.MAXEXPOSUREAMOUNT -- 单一最高授信额度敞口金额
    ,P1.MAXNOMINALAMOUNT -- 单一最高授信额度名义金额
    ,nvl(trim(P1.PLAYTYPE),'6') -- 参与方式代码
    ,P1.ISSUERNAME -- 发行方名称
    ,decode(trim(P1.PUBLICORG),'01','X_CNBD','02','JYS','03','BJYS','04','YDZX','05','BJZJ','06','QT','','XXX',P1.PUBLICORG) -- 发行市场类型代码
    ,P1.PUBLISHSUM -- 本次发行金额
    ,P1.AFTERPAYREQ -- 发放与支付前须落实的特殊限制性条件
    ,P1.REFBANKNAME -- 参贷行名称
    ,P1.AGENTBANKNAME -- 代理行名称
    ,nvl(trim(P1.PROASSETSCONTROL),'D') -- 资产控制代码
    ,nvl(trim(P1.MONEYINDUSTRYT),'-') -- 资金投向行业代码
    ,nvl(trim(P1.SUREMODEL),'-') -- 总行认定模式标志
    ,nvl(trim(P1.ISBRANCHBUSINESS),'-') -- 分行权限内业务标志
    ,P1.HOSTBANKNO -- 主办行行号
    ,P1.HOSTBANKNAME -- 主办行名称
    ,P1.CHANNELID -- 通道方编号
    ,P1.CHANNELNAME -- 通道方名称
    ,P1.RISKAPPROVEAMOUT -- 风控最终审批金额
    ,P1.RISKTERM -- 风控最终审批期限
    ,nvl(trim(P1.RISKAPPROVESTATUS),'-') -- 风控最终状态代码
    ,P1.APPROVEPUBSUM -- 批准发行总额
    ,P1.TOTALSUMENTPART -- 公司敞口金额
    ,P1.BUSINESSSUMENTPART -- 公司授信额度
    ,nvl(trim(P1.ISLIKELOWRISK),'-') -- 类低风险标志
    ,P1.LOWRISKEXPOSURESUM -- 类低风险敞口金额
    ,nvl(trim(P1.ISJOINLIMITS),'-') -- 纳入单一客户或集团限额标志
    ,nvl(trim(P1.ISONLINEAPPROVE),'-') -- 线上审批标志
    ,P1.ONLINEAPPROVALLIMIT -- 线上审批额度
    ,P1.LOANMANAGEREQ -- 贷后管理要求
    ,P1.PAYREQ -- 授信方案备注
    ,P1.CONTRACTREQ -- 需落实到合约的特殊要求
    ,P1.MANAGEID -- 管理方客户编号
    ,P1.MANAGENAME -- 管理方名称
    ,nvl(to_number(regexp_replace(P1.TRANSCOUNT,'[^0-9.]','')) ,0) -- 交易对手个数
    ,P1.JXHJCONTRACTNO -- 借旧还新旧合同编号
    ,nvl(trim(P1.ISRELATEDCOMPANY),'-') -- 借款企业为担保公司的关联企业标志
    ,P1.ENTERPRISEAMT -- 借款企业在我行有效额度
    ,nvl(trim(P1.PROBORROWERDEBT),'C') -- 借款人偿债属性代码
    ,nvl(trim(P1.PROBORROWERINCOME),'E') -- 借款人收入属性代码
    ,nvl(trim(P1.PROBORROWERATTR),'E') -- 借款人属性代码
    ,nvl(trim(P1.ISPENETRATE),'-') -- 可穿透标志
    ,P1.RUNENTYEARINCOME -- 流水推算的年销售收入
    ,P1.LASTYEARENTYEARINCOME -- 纳税申报资料反映的上年度收入
    ,nvl(to_number(regexp_replace(P1.YEARINCOMERATE,'[^0-9.]','')) ,0) -- 预计销售收入年增长率
    ,nvl(trim(P1.IFAPPROVE),'-') -- 人工填写标志
    ,P1.OPERATIONLOANBALANCESKR -- 实控人经营性贷款余额
    ,nvl(trim(P1.PROREVENUECONTROL),'D') -- 收入控制代码
    ,P1.INVESTTARGET -- 投资标的描述
    ,nvl(trim(P1.INVESTWAY),'00') -- 投资方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.HXTYCLASSIFYLEVEL END -- 债项分类代码
    ,nvl(trim(P1.CUSTRATERISKLEVEL),'-') -- 客户内评评级结果代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.HXTYMAINRATELEVEL END -- 外部主体评级代码
    ,P1.MAINLEVELORG -- 主体评级机构名称
    ,${iml_schema}.dateformat_max2(P1.MAINLEVELDATE) -- 主体评级日期
    ,nvl(trim(P1.ITEMSFINANCINGTYPE),'C') -- 物品融资类型代码
    ,nvl(trim(P1.MERCFINANCINGOBJECT),'C') -- 商品融资对象代码
    ,nvl(trim(P1.PROJFINANCINGTYPE),'C') -- 项目融资类型代码
    ,nvl(trim(P1.ISSME),'-') -- 小微企业贷款标志
    ,P1.ORIGINALNAME -- 原始权益方名称
    ,P1.DRTIMES -- 债务重组次数
    ,nvl(trim(P1.IsQueryCreditReport),'-') -- 自动查询贷后报告标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ba_cl_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ba_cl_info p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.OASTATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_BA_CL_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'OASTATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LOAN_APPL_LMT_ATTACH_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'OA_APV_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.HXTYMAINRATELEVEL = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_BA_CL_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'HXTYMAINRATELEVEL'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_APPL_LMT_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EXT_MAIN_RATING_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.HXTYCLASSIFYLEVEL = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_BA_CL_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'HXTYCLASSIFYLEVEL'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_LOAN_APPL_LMT_ATTACH_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BOND_ITEM_CLS_CD'
 where p1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,appl_flow_num
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,public_crdt_flg -- 公开授信标志
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_amt -- 额度金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_amt -- 已用授信额度
    ,used_open_amt -- 已用授信额度
    ,aval_amt -- 可用金额
    ,aval_open_amt -- 可用敞口金额
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,turn_crdt_flg -- 转授信标志
    ,group_apv_id -- 集团审批编号
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_id -- 他用额度所有人编号
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,appl_syn_loan_tot_amt -- 申请银团贷款总金额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,have_incre_crdt_flg -- 有增信标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,estate_fin_flg -- 房地产融资标志
    ,gover_class_fin_flg -- 政府类融资标志
    ,cap_src_cd -- 资金来源代码
    ,class_crdt_flg -- 类信贷标志
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,onl_lmt_amt -- 线上额度金额
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,level11_cls_cd -- 十一级分类代码
    ,crdt_rg_cd -- 授信区域代码
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,proj_fin_flg -- 项目融资标志
    ,cent_mgmt_dept_cd -- 归口管理部门编号
    ,oa_apv_status_cd -- OA审批状态代码
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,guar_way_cd -- 担保方式代码
    ,policy_loan_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,wish_guar_amt -- 意向担保金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,prtcpt_way_cd -- 参与方式代码
    ,issuer_name -- 发行方名称
    ,issue_market_type_cd -- 发行市场类型代码
    ,ths_tm_issue_amt -- 本次发行金额
    ,bfdispay_impt_espec_restr_cond -- 发放与支付前须落实的特殊限制性条件
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_name -- 代理行名称
    ,asset_ctrl_cd -- 资产控制代码
    ,cap_dir_indus_cd -- 资金投向行业代码
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,brch_prvlg_int_bus_flg -- 分行权限内业务标志
    ,host_bk_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,risk_mgmt_final_apv_amt -- 风控最终审批金额
    ,risk_mgmt_final_apv_tenor -- 风控最终审批期限
    ,risk_mgmt_final_status_cd -- 风控最终状态代码
    ,apprv_issue_tot -- 批准发行总额
    ,corp_open_amt -- 公司敞口金额
    ,corp_crdt_lmt -- 公司授信额度
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,is_single_cust_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,onl_apv_flg -- 线上审批标志
    ,onl_apv_lmt -- 线上审批额度
    ,lon_post_mgmt_request -- 贷后管理要求
    ,crdt_prop_remark -- 授信方案备注
    ,impt_reach_cont_espec_request -- 需落实到合约的特殊要求
    ,mgers_cust_id -- 管理方客户编号
    ,mgers_name -- 管理方名称
    ,cntpty_cnt -- 交易对手个数
    ,old_repay_new_oldcont_id -- 借旧还新旧合同编号
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,borw_corp_hxb_valid_lmt -- 借款企业在我行有效额度
    ,brwer_repay_debt_attr_cd -- 借款人偿债属性代码
    ,brwer_inco_attr_cd -- 借款人收入属性代码
    ,brwer_attr_cd -- 借款人属性代码
    ,can_pente_flg -- 可穿透标志
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,pay_tax_matrl_prev_year_inco -- 纳税申报资料反映的上年度收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,manu_flg -- 人工填写标志
    ,actl_ctrler_opering_loan_bal -- 实控人经营性贷款余额
    ,inco_ctrl_cd -- 收入控制代码
    ,invest_underly_descb -- 投资标的描述
    ,invest_way_cd -- 投资方式代码
    ,bond_item_cls_cd -- 债项分类代码
    ,cust_cred_rat_rating_rest_cd -- 客户内评评级结果代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,arti_fin_type_cd -- 物品融资类型代码
    ,merchd_fin_obj_cd -- 商品融资对象代码
    ,proj_fin_type_cd -- 项目融资类型代码
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,init_eqty_ps_name -- 原始权益方名称
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,public_crdt_flg -- 公开授信标志
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_amt -- 额度金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_amt -- 已用授信额度
    ,used_open_amt -- 已用授信额度
    ,aval_amt -- 可用金额
    ,aval_open_amt -- 可用敞口金额
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,turn_crdt_flg -- 转授信标志
    ,group_apv_id -- 集团审批编号
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_id -- 他用额度所有人编号
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,appl_syn_loan_tot_amt -- 申请银团贷款总金额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,have_incre_crdt_flg -- 有增信标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,estate_fin_flg -- 房地产融资标志
    ,gover_class_fin_flg -- 政府类融资标志
    ,cap_src_cd -- 资金来源代码
    ,class_crdt_flg -- 类信贷标志
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,onl_lmt_amt -- 线上额度金额
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,level11_cls_cd -- 十一级分类代码
    ,crdt_rg_cd -- 授信区域代码
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,proj_fin_flg -- 项目融资标志
    ,cent_mgmt_dept_cd -- 归口管理部门编号
    ,oa_apv_status_cd -- OA审批状态代码
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,guar_way_cd -- 担保方式代码
    ,policy_loan_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,wish_guar_amt -- 意向担保金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,prtcpt_way_cd -- 参与方式代码
    ,issuer_name -- 发行方名称
    ,issue_market_type_cd -- 发行市场类型代码
    ,ths_tm_issue_amt -- 本次发行金额
    ,bfdispay_impt_espec_restr_cond -- 发放与支付前须落实的特殊限制性条件
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_name -- 代理行名称
    ,asset_ctrl_cd -- 资产控制代码
    ,cap_dir_indus_cd -- 资金投向行业代码
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,brch_prvlg_int_bus_flg -- 分行权限内业务标志
    ,host_bk_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,risk_mgmt_final_apv_amt -- 风控最终审批金额
    ,risk_mgmt_final_apv_tenor -- 风控最终审批期限
    ,risk_mgmt_final_status_cd -- 风控最终状态代码
    ,apprv_issue_tot -- 批准发行总额
    ,corp_open_amt -- 公司敞口金额
    ,corp_crdt_lmt -- 公司授信额度
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,is_single_cust_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,onl_apv_flg -- 线上审批标志
    ,onl_apv_lmt -- 线上审批额度
    ,lon_post_mgmt_request -- 贷后管理要求
    ,crdt_prop_remark -- 授信方案备注
    ,impt_reach_cont_espec_request -- 需落实到合约的特殊要求
    ,mgers_cust_id -- 管理方客户编号
    ,mgers_name -- 管理方名称
    ,cntpty_cnt -- 交易对手个数
    ,old_repay_new_oldcont_id -- 借旧还新旧合同编号
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,borw_corp_hxb_valid_lmt -- 借款企业在我行有效额度
    ,brwer_repay_debt_attr_cd -- 借款人偿债属性代码
    ,brwer_inco_attr_cd -- 借款人收入属性代码
    ,brwer_attr_cd -- 借款人属性代码
    ,can_pente_flg -- 可穿透标志
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,pay_tax_matrl_prev_year_inco -- 纳税申报资料反映的上年度收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,manu_flg -- 人工填写标志
    ,actl_ctrler_opering_loan_bal -- 实控人经营性贷款余额
    ,inco_ctrl_cd -- 收入控制代码
    ,invest_underly_descb -- 投资标的描述
    ,invest_way_cd -- 投资方式代码
    ,bond_item_cls_cd -- 债项分类代码
    ,cust_cred_rat_rating_rest_cd -- 客户内评评级结果代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,arti_fin_type_cd -- 物品融资类型代码
    ,merchd_fin_obj_cd -- 商品融资对象代码
    ,proj_fin_type_cd -- 项目融资类型代码
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,init_eqty_ps_name -- 原始权益方名称
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.lmt_next_bus_higt_pm_rat, o.lmt_next_bus_higt_pm_rat) as lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,nvl(n.lmt_next_bus_init_margin_ratio, o.lmt_next_bus_init_margin_ratio) as lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,nvl(n.lmt_next_bus_int_rat_lowt_flo_val, o.lmt_next_bus_int_rat_lowt_flo_val) as lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,nvl(n.lmt_next_bus_sig_max_amt, o.lmt_next_bus_sig_max_amt) as lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,nvl(n.lmt_next_bus_lont_tenor, o.lmt_next_bus_lont_tenor) as lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,nvl(n.lmt_next_bus_delay_renew_tenor, o.lmt_next_bus_delay_renew_tenor) as lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,nvl(n.public_crdt_flg, o.public_crdt_flg) as public_crdt_flg -- 公开授信标志
    ,nvl(n.lmt_dir_use_flg, o.lmt_dir_use_flg) as lmt_dir_use_flg -- 额度可直接使用标志
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.lmt_kind_cd, o.lmt_kind_cd) as lmt_kind_cd -- 额度种类代码
    ,nvl(n.group_lmt_crtl_mode_cd, o.group_lmt_crtl_mode_cd) as group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,nvl(n.under_bus_curr_cd_range, o.under_bus_curr_cd_range) as under_bus_curr_cd_range -- 项下业务币种代码范围
    ,nvl(n.lmt_amt, o.lmt_amt) as lmt_amt -- 额度金额
    ,nvl(n.lmt_open_amt, o.lmt_open_amt) as lmt_open_amt -- 额度敞口金额
    ,nvl(n.used_amt, o.used_amt) as used_amt -- 已用授信额度
    ,nvl(n.used_open_amt, o.used_open_amt) as used_open_amt -- 已用授信额度
    ,nvl(n.aval_amt, o.aval_amt) as aval_amt -- 可用金额
    ,nvl(n.aval_open_amt, o.aval_open_amt) as aval_open_amt -- 可用敞口金额
    ,nvl(n.lmt_latest_use_dt, o.lmt_latest_use_dt) as lmt_latest_use_dt -- 额度最迟使用日期
    ,nvl(n.ta_crdt_flg, o.ta_crdt_flg) as ta_crdt_flg -- 商圈授信标志
    ,nvl(n.yh_crdt_cust_flg, o.yh_crdt_cust_flg) as yh_crdt_cust_flg -- 优合授信客户标志
    ,nvl(n.turn_crdt_flg, o.turn_crdt_flg) as turn_crdt_flg -- 转授信标志
    ,nvl(n.group_apv_id, o.group_apv_id) as group_apv_id -- 集团审批编号
    ,nvl(n.o_use_lmt_flow_num, o.o_use_lmt_flow_num) as o_use_lmt_flow_num -- 他用额度流水号
    ,nvl(n.o_use_lmt_type_cd, o.o_use_lmt_type_cd) as o_use_lmt_type_cd -- 他用额度类型代码
    ,nvl(n.o_use_lmt_owner_id, o.o_use_lmt_owner_id) as o_use_lmt_owner_id -- 他用额度所有人编号
    ,nvl(n.sm_retl_flg, o.sm_retl_flg) as sm_retl_flg -- 小微零售标志
    ,nvl(n.add_ba_lmt_spcl_discnt_flg, o.add_ba_lmt_spcl_discnt_flg) as add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,nvl(n.appl_syn_loan_tot_amt, o.appl_syn_loan_tot_amt) as appl_syn_loan_tot_amt -- 申请银团贷款总金额
    ,nvl(n.agent_patip_loan_flg, o.agent_patip_loan_flg) as agent_patip_loan_flg -- 代理参贷标志
    ,nvl(n.ocup_o_use_lmt_flg, o.ocup_o_use_lmt_flg) as ocup_o_use_lmt_flg -- 占用他用额度标志
    ,nvl(n.have_incre_crdt_flg, o.have_incre_crdt_flg) as have_incre_crdt_flg -- 有增信标志
    ,nvl(n.comn_risk_open_lmt, o.comn_risk_open_lmt) as comn_risk_open_lmt -- 一般风险敞口限额
    ,nvl(n.estate_fin_flg, o.estate_fin_flg) as estate_fin_flg -- 房地产融资标志
    ,nvl(n.gover_class_fin_flg, o.gover_class_fin_flg) as gover_class_fin_flg -- 政府类融资标志
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.class_crdt_flg, o.class_crdt_flg) as class_crdt_flg -- 类信贷标志
    ,nvl(n.ibank_lmt_amt, o.ibank_lmt_amt) as ibank_lmt_amt -- 同业额度金额
    ,nvl(n.ibank_open_amt, o.ibank_open_amt) as ibank_open_amt -- 同业敞口金额
    ,nvl(n.onl_lmt_amt, o.onl_lmt_amt) as onl_lmt_amt -- 线上额度金额
    ,nvl(n.green_crdt_fin_flg, o.green_crdt_fin_flg) as green_crdt_fin_flg -- 绿色信贷融资标志
    ,nvl(n.consm_serv_class_fin_flg, o.consm_serv_class_fin_flg) as consm_serv_class_fin_flg -- 消费服务类融资标志
    ,nvl(n.br_build_ifin_flg, o.br_build_ifin_flg) as br_build_ifin_flg -- 一带一路建设投融资标志
    ,nvl(n.level11_cls_cd, o.level11_cls_cd) as level11_cls_cd -- 十一级分类代码
    ,nvl(n.crdt_rg_cd, o.crdt_rg_cd) as crdt_rg_cd -- 授信区域代码
    ,nvl(n.ext_rating_rest_cd, o.ext_rating_rest_cd) as ext_rating_rest_cd -- 外部评级结果代码
    ,nvl(n.ext_rating_org_name, o.ext_rating_org_name) as ext_rating_org_name -- 外部评级机构名称
    ,nvl(n.ext_rating_dt, o.ext_rating_dt) as ext_rating_dt -- 外部评级日期
    ,nvl(n.proj_fin_flg, o.proj_fin_flg) as proj_fin_flg -- 项目融资标志
    ,nvl(n.cent_mgmt_dept_cd, o.cent_mgmt_dept_cd) as cent_mgmt_dept_cd -- 归口管理部门编号
    ,nvl(n.oa_apv_status_cd, o.oa_apv_status_cd) as oa_apv_status_cd -- OA审批状态代码
    ,nvl(n.inovt_bus_flg, o.inovt_bus_flg) as inovt_bus_flg -- 创新业务标志
    ,nvl(n.sup_chain_fin_bus_flg, o.sup_chain_fin_bus_flg) as sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.policy_loan_bus_guar_corp_cd, o.policy_loan_bus_guar_corp_cd) as policy_loan_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,nvl(n.guar_corp_send_tenor, o.guar_corp_send_tenor) as guar_corp_send_tenor -- 担保公司推送期限
    ,nvl(n.wish_guar_amt, o.wish_guar_amt) as wish_guar_amt -- 意向担保金额
    ,nvl(n.single_higt_crdt_lmt_open_amt, o.single_higt_crdt_lmt_open_amt) as single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,nvl(n.single_higt_crdt_lmt_nmal_amt, o.single_higt_crdt_lmt_nmal_amt) as single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,nvl(n.prtcpt_way_cd, o.prtcpt_way_cd) as prtcpt_way_cd -- 参与方式代码
    ,nvl(n.issuer_name, o.issuer_name) as issuer_name -- 发行方名称
    ,nvl(n.issue_market_type_cd, o.issue_market_type_cd) as issue_market_type_cd -- 发行市场类型代码
    ,nvl(n.ths_tm_issue_amt, o.ths_tm_issue_amt) as ths_tm_issue_amt -- 本次发行金额
    ,nvl(n.bfdispay_impt_espec_restr_cond, o.bfdispay_impt_espec_restr_cond) as bfdispay_impt_espec_restr_cond -- 发放与支付前须落实的特殊限制性条件
    ,nvl(n.patip_loan_bank_name, o.patip_loan_bank_name) as patip_loan_bank_name -- 参贷行名称
    ,nvl(n.agent_bank_name, o.agent_bank_name) as agent_bank_name -- 代理行名称
    ,nvl(n.asset_ctrl_cd, o.asset_ctrl_cd) as asset_ctrl_cd -- 资产控制代码
    ,nvl(n.cap_dir_indus_cd, o.cap_dir_indus_cd) as cap_dir_indus_cd -- 资金投向行业代码
    ,nvl(n.hq_idtfy_mode_flg, o.hq_idtfy_mode_flg) as hq_idtfy_mode_flg -- 总行认定模式标志
    ,nvl(n.brch_prvlg_int_bus_flg, o.brch_prvlg_int_bus_flg) as brch_prvlg_int_bus_flg -- 分行权限内业务标志
    ,nvl(n.host_bk_bank_no, o.host_bk_bank_no) as host_bk_bank_no -- 主办行行号
    ,nvl(n.host_bank_name, o.host_bank_name) as host_bank_name -- 主办行名称
    ,nvl(n.passer_id, o.passer_id) as passer_id -- 通道方编号
    ,nvl(n.passer_name, o.passer_name) as passer_name -- 通道方名称
    ,nvl(n.risk_mgmt_final_apv_amt, o.risk_mgmt_final_apv_amt) as risk_mgmt_final_apv_amt -- 风控最终审批金额
    ,nvl(n.risk_mgmt_final_apv_tenor, o.risk_mgmt_final_apv_tenor) as risk_mgmt_final_apv_tenor -- 风控最终审批期限
    ,nvl(n.risk_mgmt_final_status_cd, o.risk_mgmt_final_status_cd) as risk_mgmt_final_status_cd -- 风控最终状态代码
    ,nvl(n.apprv_issue_tot, o.apprv_issue_tot) as apprv_issue_tot -- 批准发行总额
    ,nvl(n.corp_open_amt, o.corp_open_amt) as corp_open_amt -- 公司敞口金额
    ,nvl(n.corp_crdt_lmt, o.corp_crdt_lmt) as corp_crdt_lmt -- 公司授信额度
    ,nvl(n.class_low_risk_flg, o.class_low_risk_flg) as class_low_risk_flg -- 类低风险标志
    ,nvl(n.class_low_risk_open_amt, o.class_low_risk_open_amt) as class_low_risk_open_amt -- 类低风险敞口金额
    ,nvl(n.is_single_cust_group_lmt_flg, o.is_single_cust_group_lmt_flg) as is_single_cust_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,nvl(n.onl_apv_flg, o.onl_apv_flg) as onl_apv_flg -- 线上审批标志
    ,nvl(n.onl_apv_lmt, o.onl_apv_lmt) as onl_apv_lmt -- 线上审批额度
    ,nvl(n.lon_post_mgmt_request, o.lon_post_mgmt_request) as lon_post_mgmt_request -- 贷后管理要求
    ,nvl(n.crdt_prop_remark, o.crdt_prop_remark) as crdt_prop_remark -- 授信方案备注
    ,nvl(n.impt_reach_cont_espec_request, o.impt_reach_cont_espec_request) as impt_reach_cont_espec_request -- 需落实到合约的特殊要求
    ,nvl(n.mgers_cust_id, o.mgers_cust_id) as mgers_cust_id -- 管理方客户编号
    ,nvl(n.mgers_name, o.mgers_name) as mgers_name -- 管理方名称
    ,nvl(n.cntpty_cnt, o.cntpty_cnt) as cntpty_cnt -- 交易对手个数
    ,nvl(n.old_repay_new_oldcont_id, o.old_repay_new_oldcont_id) as old_repay_new_oldcont_id -- 借旧还新旧合同编号
    ,nvl(n.borw_corp_rela_guar_corp_flg, o.borw_corp_rela_guar_corp_flg) as borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,nvl(n.borw_corp_hxb_valid_lmt, o.borw_corp_hxb_valid_lmt) as borw_corp_hxb_valid_lmt -- 借款企业在我行有效额度
    ,nvl(n.brwer_repay_debt_attr_cd, o.brwer_repay_debt_attr_cd) as brwer_repay_debt_attr_cd -- 借款人偿债属性代码
    ,nvl(n.brwer_inco_attr_cd, o.brwer_inco_attr_cd) as brwer_inco_attr_cd -- 借款人收入属性代码
    ,nvl(n.brwer_attr_cd, o.brwer_attr_cd) as brwer_attr_cd -- 借款人属性代码
    ,nvl(n.can_pente_flg, o.can_pente_flg) as can_pente_flg -- 可穿透标志
    ,nvl(n.flow_calcu_year_sell_inco, o.flow_calcu_year_sell_inco) as flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,nvl(n.pay_tax_matrl_prev_year_inco, o.pay_tax_matrl_prev_year_inco) as pay_tax_matrl_prev_year_inco -- 纳税申报资料反映的上年度收入
    ,nvl(n.expect_sell_inco_year_grow_rat, o.expect_sell_inco_year_grow_rat) as expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,nvl(n.manu_flg, o.manu_flg) as manu_flg -- 人工填写标志
    ,nvl(n.actl_ctrler_opering_loan_bal, o.actl_ctrler_opering_loan_bal) as actl_ctrler_opering_loan_bal -- 实控人经营性贷款余额
    ,nvl(n.inco_ctrl_cd, o.inco_ctrl_cd) as inco_ctrl_cd -- 收入控制代码
    ,nvl(n.invest_underly_descb, o.invest_underly_descb) as invest_underly_descb -- 投资标的描述
    ,nvl(n.invest_way_cd, o.invest_way_cd) as invest_way_cd -- 投资方式代码
    ,nvl(n.bond_item_cls_cd, o.bond_item_cls_cd) as bond_item_cls_cd -- 债项分类代码
    ,nvl(n.cust_cred_rat_rating_rest_cd, o.cust_cred_rat_rating_rest_cd) as cust_cred_rat_rating_rest_cd -- 客户内评评级结果代码
    ,nvl(n.ext_main_rating_cd, o.ext_main_rating_cd) as ext_main_rating_cd -- 外部主体评级代码
    ,nvl(n.main_rating_org_name, o.main_rating_org_name) as main_rating_org_name -- 主体评级机构名称
    ,nvl(n.main_rating_dt, o.main_rating_dt) as main_rating_dt -- 主体评级日期
    ,nvl(n.arti_fin_type_cd, o.arti_fin_type_cd) as arti_fin_type_cd -- 物品融资类型代码
    ,nvl(n.merchd_fin_obj_cd, o.merchd_fin_obj_cd) as merchd_fin_obj_cd -- 商品融资对象代码
    ,nvl(n.proj_fin_type_cd, o.proj_fin_type_cd) as proj_fin_type_cd -- 项目融资类型代码
    ,nvl(n.sm_corp_loan_flg, o.sm_corp_loan_flg) as sm_corp_loan_flg -- 小微企业贷款标志
    ,nvl(n.init_eqty_ps_name, o.init_eqty_ps_name) as init_eqty_ps_name -- 原始权益方名称
    ,nvl(n.debt_regroup_cnt, o.debt_regroup_cnt) as debt_regroup_cnt -- 债务重组次数
    ,nvl(n.auto_que_lon_post_rept_flg, o.auto_que_lon_post_rept_flg) as auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.appl_flow_num = n.appl_flow_num
where (
        o.appl_id is null
        and o.appl_flow_num is null
    )
    or (
        n.appl_id is null
        and n.appl_flow_num is null
    )
    or (
        o.lmt_next_bus_higt_pm_rat <> n.lmt_next_bus_higt_pm_rat
        or o.lmt_next_bus_init_margin_ratio <> n.lmt_next_bus_init_margin_ratio
        or o.lmt_next_bus_int_rat_lowt_flo_val <> n.lmt_next_bus_int_rat_lowt_flo_val
        or o.lmt_next_bus_sig_max_amt <> n.lmt_next_bus_sig_max_amt
        or o.lmt_next_bus_lont_tenor <> n.lmt_next_bus_lont_tenor
        or o.lmt_next_bus_delay_renew_tenor <> n.lmt_next_bus_delay_renew_tenor
        or o.public_crdt_flg <> n.public_crdt_flg
        or o.lmt_dir_use_flg <> n.lmt_dir_use_flg
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.lmt_kind_cd <> n.lmt_kind_cd
        or o.group_lmt_crtl_mode_cd <> n.group_lmt_crtl_mode_cd
        or o.under_bus_curr_cd_range <> n.under_bus_curr_cd_range
        or o.lmt_amt <> n.lmt_amt
        or o.lmt_open_amt <> n.lmt_open_amt
        or o.used_amt <> n.used_amt
        or o.used_open_amt <> n.used_open_amt
        or o.aval_amt <> n.aval_amt
        or o.aval_open_amt <> n.aval_open_amt
        or o.lmt_latest_use_dt <> n.lmt_latest_use_dt
        or o.ta_crdt_flg <> n.ta_crdt_flg
        or o.yh_crdt_cust_flg <> n.yh_crdt_cust_flg
        or o.turn_crdt_flg <> n.turn_crdt_flg
        or o.group_apv_id <> n.group_apv_id
        or o.o_use_lmt_flow_num <> n.o_use_lmt_flow_num
        or o.o_use_lmt_type_cd <> n.o_use_lmt_type_cd
        or o.o_use_lmt_owner_id <> n.o_use_lmt_owner_id
        or o.sm_retl_flg <> n.sm_retl_flg
        or o.add_ba_lmt_spcl_discnt_flg <> n.add_ba_lmt_spcl_discnt_flg
        or o.appl_syn_loan_tot_amt <> n.appl_syn_loan_tot_amt
        or o.agent_patip_loan_flg <> n.agent_patip_loan_flg
        or o.ocup_o_use_lmt_flg <> n.ocup_o_use_lmt_flg
        or o.have_incre_crdt_flg <> n.have_incre_crdt_flg
        or o.comn_risk_open_lmt <> n.comn_risk_open_lmt
        or o.estate_fin_flg <> n.estate_fin_flg
        or o.gover_class_fin_flg <> n.gover_class_fin_flg
        or o.cap_src_cd <> n.cap_src_cd
        or o.class_crdt_flg <> n.class_crdt_flg
        or o.ibank_lmt_amt <> n.ibank_lmt_amt
        or o.ibank_open_amt <> n.ibank_open_amt
        or o.onl_lmt_amt <> n.onl_lmt_amt
        or o.green_crdt_fin_flg <> n.green_crdt_fin_flg
        or o.consm_serv_class_fin_flg <> n.consm_serv_class_fin_flg
        or o.br_build_ifin_flg <> n.br_build_ifin_flg
        or o.level11_cls_cd <> n.level11_cls_cd
        or o.crdt_rg_cd <> n.crdt_rg_cd
        or o.ext_rating_rest_cd <> n.ext_rating_rest_cd
        or o.ext_rating_org_name <> n.ext_rating_org_name
        or o.ext_rating_dt <> n.ext_rating_dt
        or o.proj_fin_flg <> n.proj_fin_flg
        or o.cent_mgmt_dept_cd <> n.cent_mgmt_dept_cd
        or o.oa_apv_status_cd <> n.oa_apv_status_cd
        or o.inovt_bus_flg <> n.inovt_bus_flg
        or o.sup_chain_fin_bus_flg <> n.sup_chain_fin_bus_flg
        or o.guar_way_cd <> n.guar_way_cd
        or o.policy_loan_bus_guar_corp_cd <> n.policy_loan_bus_guar_corp_cd
        or o.guar_corp_send_tenor <> n.guar_corp_send_tenor
        or o.wish_guar_amt <> n.wish_guar_amt
        or o.single_higt_crdt_lmt_open_amt <> n.single_higt_crdt_lmt_open_amt
        or o.single_higt_crdt_lmt_nmal_amt <> n.single_higt_crdt_lmt_nmal_amt
        or o.prtcpt_way_cd <> n.prtcpt_way_cd
        or o.issuer_name <> n.issuer_name
        or o.issue_market_type_cd <> n.issue_market_type_cd
        or o.ths_tm_issue_amt <> n.ths_tm_issue_amt
        or o.bfdispay_impt_espec_restr_cond <> n.bfdispay_impt_espec_restr_cond
        or o.patip_loan_bank_name <> n.patip_loan_bank_name
        or o.agent_bank_name <> n.agent_bank_name
        or o.asset_ctrl_cd <> n.asset_ctrl_cd
        or o.cap_dir_indus_cd <> n.cap_dir_indus_cd
        or o.hq_idtfy_mode_flg <> n.hq_idtfy_mode_flg
        or o.brch_prvlg_int_bus_flg <> n.brch_prvlg_int_bus_flg
        or o.host_bk_bank_no <> n.host_bk_bank_no
        or o.host_bank_name <> n.host_bank_name
        or o.passer_id <> n.passer_id
        or o.passer_name <> n.passer_name
        or o.risk_mgmt_final_apv_amt <> n.risk_mgmt_final_apv_amt
        or o.risk_mgmt_final_apv_tenor <> n.risk_mgmt_final_apv_tenor
        or o.risk_mgmt_final_status_cd <> n.risk_mgmt_final_status_cd
        or o.apprv_issue_tot <> n.apprv_issue_tot
        or o.corp_open_amt <> n.corp_open_amt
        or o.corp_crdt_lmt <> n.corp_crdt_lmt
        or o.class_low_risk_flg <> n.class_low_risk_flg
        or o.class_low_risk_open_amt <> n.class_low_risk_open_amt
        or o.is_single_cust_group_lmt_flg <> n.is_single_cust_group_lmt_flg
        or o.onl_apv_flg <> n.onl_apv_flg
        or o.onl_apv_lmt <> n.onl_apv_lmt
        or o.lon_post_mgmt_request <> n.lon_post_mgmt_request
        or o.crdt_prop_remark <> n.crdt_prop_remark
        or o.impt_reach_cont_espec_request <> n.impt_reach_cont_espec_request
        or o.mgers_cust_id <> n.mgers_cust_id
        or o.mgers_name <> n.mgers_name
        or o.cntpty_cnt <> n.cntpty_cnt
        or o.old_repay_new_oldcont_id <> n.old_repay_new_oldcont_id
        or o.borw_corp_rela_guar_corp_flg <> n.borw_corp_rela_guar_corp_flg
        or o.borw_corp_hxb_valid_lmt <> n.borw_corp_hxb_valid_lmt
        or o.brwer_repay_debt_attr_cd <> n.brwer_repay_debt_attr_cd
        or o.brwer_inco_attr_cd <> n.brwer_inco_attr_cd
        or o.brwer_attr_cd <> n.brwer_attr_cd
        or o.can_pente_flg <> n.can_pente_flg
        or o.flow_calcu_year_sell_inco <> n.flow_calcu_year_sell_inco
        or o.pay_tax_matrl_prev_year_inco <> n.pay_tax_matrl_prev_year_inco
        or o.expect_sell_inco_year_grow_rat <> n.expect_sell_inco_year_grow_rat
        or o.manu_flg <> n.manu_flg
        or o.actl_ctrler_opering_loan_bal <> n.actl_ctrler_opering_loan_bal
        or o.inco_ctrl_cd <> n.inco_ctrl_cd
        or o.invest_underly_descb <> n.invest_underly_descb
        or o.invest_way_cd <> n.invest_way_cd
        or o.bond_item_cls_cd <> n.bond_item_cls_cd
        or o.cust_cred_rat_rating_rest_cd <> n.cust_cred_rat_rating_rest_cd
        or o.ext_main_rating_cd <> n.ext_main_rating_cd
        or o.main_rating_org_name <> n.main_rating_org_name
        or o.main_rating_dt <> n.main_rating_dt
        or o.arti_fin_type_cd <> n.arti_fin_type_cd
        or o.merchd_fin_obj_cd <> n.merchd_fin_obj_cd
        or o.proj_fin_type_cd <> n.proj_fin_type_cd
        or o.sm_corp_loan_flg <> n.sm_corp_loan_flg
        or o.init_eqty_ps_name <> n.init_eqty_ps_name
        or o.debt_regroup_cnt <> n.debt_regroup_cnt
        or o.auto_que_lon_post_rept_flg <> n.auto_que_lon_post_rept_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,public_crdt_flg -- 公开授信标志
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_amt -- 额度金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_amt -- 已用授信额度
    ,used_open_amt -- 已用授信额度
    ,aval_amt -- 可用金额
    ,aval_open_amt -- 可用敞口金额
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,turn_crdt_flg -- 转授信标志
    ,group_apv_id -- 集团审批编号
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_id -- 他用额度所有人编号
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,appl_syn_loan_tot_amt -- 申请银团贷款总金额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,have_incre_crdt_flg -- 有增信标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,estate_fin_flg -- 房地产融资标志
    ,gover_class_fin_flg -- 政府类融资标志
    ,cap_src_cd -- 资金来源代码
    ,class_crdt_flg -- 类信贷标志
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,onl_lmt_amt -- 线上额度金额
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,level11_cls_cd -- 十一级分类代码
    ,crdt_rg_cd -- 授信区域代码
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,proj_fin_flg -- 项目融资标志
    ,cent_mgmt_dept_cd -- 归口管理部门编号
    ,oa_apv_status_cd -- OA审批状态代码
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,guar_way_cd -- 担保方式代码
    ,policy_loan_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,wish_guar_amt -- 意向担保金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,prtcpt_way_cd -- 参与方式代码
    ,issuer_name -- 发行方名称
    ,issue_market_type_cd -- 发行市场类型代码
    ,ths_tm_issue_amt -- 本次发行金额
    ,bfdispay_impt_espec_restr_cond -- 发放与支付前须落实的特殊限制性条件
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_name -- 代理行名称
    ,asset_ctrl_cd -- 资产控制代码
    ,cap_dir_indus_cd -- 资金投向行业代码
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,brch_prvlg_int_bus_flg -- 分行权限内业务标志
    ,host_bk_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,risk_mgmt_final_apv_amt -- 风控最终审批金额
    ,risk_mgmt_final_apv_tenor -- 风控最终审批期限
    ,risk_mgmt_final_status_cd -- 风控最终状态代码
    ,apprv_issue_tot -- 批准发行总额
    ,corp_open_amt -- 公司敞口金额
    ,corp_crdt_lmt -- 公司授信额度
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,is_single_cust_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,onl_apv_flg -- 线上审批标志
    ,onl_apv_lmt -- 线上审批额度
    ,lon_post_mgmt_request -- 贷后管理要求
    ,crdt_prop_remark -- 授信方案备注
    ,impt_reach_cont_espec_request -- 需落实到合约的特殊要求
    ,mgers_cust_id -- 管理方客户编号
    ,mgers_name -- 管理方名称
    ,cntpty_cnt -- 交易对手个数
    ,old_repay_new_oldcont_id -- 借旧还新旧合同编号
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,borw_corp_hxb_valid_lmt -- 借款企业在我行有效额度
    ,brwer_repay_debt_attr_cd -- 借款人偿债属性代码
    ,brwer_inco_attr_cd -- 借款人收入属性代码
    ,brwer_attr_cd -- 借款人属性代码
    ,can_pente_flg -- 可穿透标志
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,pay_tax_matrl_prev_year_inco -- 纳税申报资料反映的上年度收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,manu_flg -- 人工填写标志
    ,actl_ctrler_opering_loan_bal -- 实控人经营性贷款余额
    ,inco_ctrl_cd -- 收入控制代码
    ,invest_underly_descb -- 投资标的描述
    ,invest_way_cd -- 投资方式代码
    ,bond_item_cls_cd -- 债项分类代码
    ,cust_cred_rat_rating_rest_cd -- 客户内评评级结果代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,arti_fin_type_cd -- 物品融资类型代码
    ,merchd_fin_obj_cd -- 商品融资对象代码
    ,proj_fin_type_cd -- 项目融资类型代码
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,init_eqty_ps_name -- 原始权益方名称
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,public_crdt_flg -- 公开授信标志
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_amt -- 额度金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_amt -- 已用授信额度
    ,used_open_amt -- 已用授信额度
    ,aval_amt -- 可用金额
    ,aval_open_amt -- 可用敞口金额
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,turn_crdt_flg -- 转授信标志
    ,group_apv_id -- 集团审批编号
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_id -- 他用额度所有人编号
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,appl_syn_loan_tot_amt -- 申请银团贷款总金额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,have_incre_crdt_flg -- 有增信标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,estate_fin_flg -- 房地产融资标志
    ,gover_class_fin_flg -- 政府类融资标志
    ,cap_src_cd -- 资金来源代码
    ,class_crdt_flg -- 类信贷标志
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,onl_lmt_amt -- 线上额度金额
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,level11_cls_cd -- 十一级分类代码
    ,crdt_rg_cd -- 授信区域代码
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,proj_fin_flg -- 项目融资标志
    ,cent_mgmt_dept_cd -- 归口管理部门编号
    ,oa_apv_status_cd -- OA审批状态代码
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,guar_way_cd -- 担保方式代码
    ,policy_loan_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,wish_guar_amt -- 意向担保金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,prtcpt_way_cd -- 参与方式代码
    ,issuer_name -- 发行方名称
    ,issue_market_type_cd -- 发行市场类型代码
    ,ths_tm_issue_amt -- 本次发行金额
    ,bfdispay_impt_espec_restr_cond -- 发放与支付前须落实的特殊限制性条件
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_name -- 代理行名称
    ,asset_ctrl_cd -- 资产控制代码
    ,cap_dir_indus_cd -- 资金投向行业代码
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,brch_prvlg_int_bus_flg -- 分行权限内业务标志
    ,host_bk_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,risk_mgmt_final_apv_amt -- 风控最终审批金额
    ,risk_mgmt_final_apv_tenor -- 风控最终审批期限
    ,risk_mgmt_final_status_cd -- 风控最终状态代码
    ,apprv_issue_tot -- 批准发行总额
    ,corp_open_amt -- 公司敞口金额
    ,corp_crdt_lmt -- 公司授信额度
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,is_single_cust_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,onl_apv_flg -- 线上审批标志
    ,onl_apv_lmt -- 线上审批额度
    ,lon_post_mgmt_request -- 贷后管理要求
    ,crdt_prop_remark -- 授信方案备注
    ,impt_reach_cont_espec_request -- 需落实到合约的特殊要求
    ,mgers_cust_id -- 管理方客户编号
    ,mgers_name -- 管理方名称
    ,cntpty_cnt -- 交易对手个数
    ,old_repay_new_oldcont_id -- 借旧还新旧合同编号
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,borw_corp_hxb_valid_lmt -- 借款企业在我行有效额度
    ,brwer_repay_debt_attr_cd -- 借款人偿债属性代码
    ,brwer_inco_attr_cd -- 借款人收入属性代码
    ,brwer_attr_cd -- 借款人属性代码
    ,can_pente_flg -- 可穿透标志
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,pay_tax_matrl_prev_year_inco -- 纳税申报资料反映的上年度收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,manu_flg -- 人工填写标志
    ,actl_ctrler_opering_loan_bal -- 实控人经营性贷款余额
    ,inco_ctrl_cd -- 收入控制代码
    ,invest_underly_descb -- 投资标的描述
    ,invest_way_cd -- 投资方式代码
    ,bond_item_cls_cd -- 债项分类代码
    ,cust_cred_rat_rating_rest_cd -- 客户内评评级结果代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,arti_fin_type_cd -- 物品融资类型代码
    ,merchd_fin_obj_cd -- 商品融资对象代码
    ,proj_fin_type_cd -- 项目融资类型代码
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,init_eqty_ps_name -- 原始权益方名称
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.appl_flow_num -- 申请流水号
    ,o.lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,o.lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,o.lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,o.lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,o.lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,o.lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,o.public_crdt_flg -- 公开授信标志
    ,o.lmt_dir_use_flg -- 额度可直接使用标志
    ,o.tenor_type_cd -- 期限类型代码
    ,o.lmt_kind_cd -- 额度种类代码
    ,o.group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,o.under_bus_curr_cd_range -- 项下业务币种代码范围
    ,o.lmt_amt -- 额度金额
    ,o.lmt_open_amt -- 额度敞口金额
    ,o.used_amt -- 已用授信额度
    ,o.used_open_amt -- 已用授信额度
    ,o.aval_amt -- 可用金额
    ,o.aval_open_amt -- 可用敞口金额
    ,o.lmt_latest_use_dt -- 额度最迟使用日期
    ,o.ta_crdt_flg -- 商圈授信标志
    ,o.yh_crdt_cust_flg -- 优合授信客户标志
    ,o.turn_crdt_flg -- 转授信标志
    ,o.group_apv_id -- 集团审批编号
    ,o.o_use_lmt_flow_num -- 他用额度流水号
    ,o.o_use_lmt_type_cd -- 他用额度类型代码
    ,o.o_use_lmt_owner_id -- 他用额度所有人编号
    ,o.sm_retl_flg -- 小微零售标志
    ,o.add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,o.appl_syn_loan_tot_amt -- 申请银团贷款总金额
    ,o.agent_patip_loan_flg -- 代理参贷标志
    ,o.ocup_o_use_lmt_flg -- 占用他用额度标志
    ,o.have_incre_crdt_flg -- 有增信标志
    ,o.comn_risk_open_lmt -- 一般风险敞口限额
    ,o.estate_fin_flg -- 房地产融资标志
    ,o.gover_class_fin_flg -- 政府类融资标志
    ,o.cap_src_cd -- 资金来源代码
    ,o.class_crdt_flg -- 类信贷标志
    ,o.ibank_lmt_amt -- 同业额度金额
    ,o.ibank_open_amt -- 同业敞口金额
    ,o.onl_lmt_amt -- 线上额度金额
    ,o.green_crdt_fin_flg -- 绿色信贷融资标志
    ,o.consm_serv_class_fin_flg -- 消费服务类融资标志
    ,o.br_build_ifin_flg -- 一带一路建设投融资标志
    ,o.level11_cls_cd -- 十一级分类代码
    ,o.crdt_rg_cd -- 授信区域代码
    ,o.ext_rating_rest_cd -- 外部评级结果代码
    ,o.ext_rating_org_name -- 外部评级机构名称
    ,o.ext_rating_dt -- 外部评级日期
    ,o.proj_fin_flg -- 项目融资标志
    ,o.cent_mgmt_dept_cd -- 归口管理部门编号
    ,o.oa_apv_status_cd -- OA审批状态代码
    ,o.inovt_bus_flg -- 创新业务标志
    ,o.sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,o.guar_way_cd -- 担保方式代码
    ,o.policy_loan_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,o.guar_corp_send_tenor -- 担保公司推送期限
    ,o.wish_guar_amt -- 意向担保金额
    ,o.single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,o.single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,o.prtcpt_way_cd -- 参与方式代码
    ,o.issuer_name -- 发行方名称
    ,o.issue_market_type_cd -- 发行市场类型代码
    ,o.ths_tm_issue_amt -- 本次发行金额
    ,o.bfdispay_impt_espec_restr_cond -- 发放与支付前须落实的特殊限制性条件
    ,o.patip_loan_bank_name -- 参贷行名称
    ,o.agent_bank_name -- 代理行名称
    ,o.asset_ctrl_cd -- 资产控制代码
    ,o.cap_dir_indus_cd -- 资金投向行业代码
    ,o.hq_idtfy_mode_flg -- 总行认定模式标志
    ,o.brch_prvlg_int_bus_flg -- 分行权限内业务标志
    ,o.host_bk_bank_no -- 主办行行号
    ,o.host_bank_name -- 主办行名称
    ,o.passer_id -- 通道方编号
    ,o.passer_name -- 通道方名称
    ,o.risk_mgmt_final_apv_amt -- 风控最终审批金额
    ,o.risk_mgmt_final_apv_tenor -- 风控最终审批期限
    ,o.risk_mgmt_final_status_cd -- 风控最终状态代码
    ,o.apprv_issue_tot -- 批准发行总额
    ,o.corp_open_amt -- 公司敞口金额
    ,o.corp_crdt_lmt -- 公司授信额度
    ,o.class_low_risk_flg -- 类低风险标志
    ,o.class_low_risk_open_amt -- 类低风险敞口金额
    ,o.is_single_cust_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,o.onl_apv_flg -- 线上审批标志
    ,o.onl_apv_lmt -- 线上审批额度
    ,o.lon_post_mgmt_request -- 贷后管理要求
    ,o.crdt_prop_remark -- 授信方案备注
    ,o.impt_reach_cont_espec_request -- 需落实到合约的特殊要求
    ,o.mgers_cust_id -- 管理方客户编号
    ,o.mgers_name -- 管理方名称
    ,o.cntpty_cnt -- 交易对手个数
    ,o.old_repay_new_oldcont_id -- 借旧还新旧合同编号
    ,o.borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,o.borw_corp_hxb_valid_lmt -- 借款企业在我行有效额度
    ,o.brwer_repay_debt_attr_cd -- 借款人偿债属性代码
    ,o.brwer_inco_attr_cd -- 借款人收入属性代码
    ,o.brwer_attr_cd -- 借款人属性代码
    ,o.can_pente_flg -- 可穿透标志
    ,o.flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,o.pay_tax_matrl_prev_year_inco -- 纳税申报资料反映的上年度收入
    ,o.expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,o.manu_flg -- 人工填写标志
    ,o.actl_ctrler_opering_loan_bal -- 实控人经营性贷款余额
    ,o.inco_ctrl_cd -- 收入控制代码
    ,o.invest_underly_descb -- 投资标的描述
    ,o.invest_way_cd -- 投资方式代码
    ,o.bond_item_cls_cd -- 债项分类代码
    ,o.cust_cred_rat_rating_rest_cd -- 客户内评评级结果代码
    ,o.ext_main_rating_cd -- 外部主体评级代码
    ,o.main_rating_org_name -- 主体评级机构名称
    ,o.main_rating_dt -- 主体评级日期
    ,o.arti_fin_type_cd -- 物品融资类型代码
    ,o.merchd_fin_obj_cd -- 商品融资对象代码
    ,o.proj_fin_type_cd -- 项目融资类型代码
    ,o.sm_corp_loan_flg -- 小微企业贷款标志
    ,o.init_eqty_ps_name -- 原始权益方名称
    ,o.debt_regroup_cnt -- 债务重组次数
    ,o.auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.appl_flow_num = n.appl_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.appl_flow_num = d.appl_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_appl_lmt_attach_info_h;
--alter table ${iml_schema}.agt_loan_appl_lmt_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_appl_lmt_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_appl_lmt_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_appl_lmt_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_appl_lmt_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_appl_lmt_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_appl_lmt_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_appl_lmt_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_appl_lmt_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
