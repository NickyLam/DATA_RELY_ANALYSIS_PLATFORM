/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_apv_lmt_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_apv_lmt_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_lmt_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,lmt_next_bus_higt_pm_ratio -- 额度下业务最高抵质押比例
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
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用名义金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,lmt_invalid_dt -- 额度失效日期
    ,group_apv_id -- 集团审批编号
    ,group_cust_spcl_lmt_flow_num -- 集群客户专项额度流水号
    ,group_cust_spcl_lmt_owner_name -- 集群客户专项额度所有人名称
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_name -- 他用额度所有人名称
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,crdtc_auth_blip_flow_num -- 征信授权影像流水号
    ,need_annual_vrfction_flg -- 需年审标志
    ,cust_rating_rest_cd -- 客户评级结果代码
    ,final_apv_opinion_one -- 最终审批意见一
    ,final_apv_opinion_two -- 最终审批意见二
    ,apv_dt -- 审批日期
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,corp_lmt_amt -- 公司额度金额
    ,corp_open_amt -- 公司敞口金额
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,under_bus_provi_guar_guar_flg -- 项下业务提供保证担保标志
    ,under_bus_bear_repo_duty_flg -- 项下业务承担回购责任标志
    ,under_bus_major_guar_way_cd -- 项下业务主要担保方式代码
    ,proj_name -- 项目名称
    ,proj_tot_area -- 项目总面积
    ,proj_addr -- 项目地址
    ,pre_sell_lics_id -- 销(预)售许可证编号
    ,arch_land_plan_lics_id -- 建设用地规划可证编号
    ,nation_land_use_cert_id -- 国有土地使用证编号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证编号
    ,arch_proj_cnstr_lics_id -- 建筑工程施工可证编号
    ,higt_apv_ratio -- 最高审批比例
    ,lont_year_tenor -- 最长年期限
    ,provi_fund_loan_comm_fee_ratio -- 公积金贷款手续费比例
    ,guar_mon_tenor -- 担保月期限
    ,onl_lmt -- 线上额度
    ,cap_src_cd -- 资金来源代码
    ,crdt_rg_cd -- 授信区域代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,have_incre_crdt_flg -- 有增信标志
    ,turn_crdt_flg -- 转授信标志
    ,host_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,patip_loan_bank_no -- 参贷行行号
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_no -- 代理行行号
    ,agent_bank_name -- 代理行名称
    ,prtcpt_way_cd -- 参与方式代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,invest_underly_descb -- 投资标的描述
    ,issue_site_cd -- 发行场所代码
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,guar_way_cd -- 担保方式代码
    ,level5_cls_cd -- 五级分类代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,debt_regroup_cnt -- 债务重组次数
    ,manu_flg -- 人工填写标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团的限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,anti_mon_lau_sys_rating_cd -- 反洗钱系统评级代码
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,lon_post_request_attach_comnt -- 贷后要求补充说明
    ,group_cust_crdt_prop_remark -- 集群客户授信方案备注
    ,bfdistr_pay_impt_esp_restrcond -- 发放与支付前须落实的特殊限制性条件
    ,impt_reach_cont_esp_request -- 需落实到合约的特殊要求
    ,crdt_prop_remark -- 授信方案备注
    ,lon_post_request -- 贷后要求
    ,lon_post_mgmt_request -- 贷后管理要求
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_apv_lmt_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_lmt_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_lmt_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bap_cl_info-1
insert into ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,lmt_next_bus_higt_pm_ratio -- 额度下业务最高抵质押比例
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
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用名义金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,lmt_invalid_dt -- 额度失效日期
    ,group_apv_id -- 集团审批编号
    ,group_cust_spcl_lmt_flow_num -- 集群客户专项额度流水号
    ,group_cust_spcl_lmt_owner_name -- 集群客户专项额度所有人名称
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_name -- 他用额度所有人名称
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,crdtc_auth_blip_flow_num -- 征信授权影像流水号
    ,need_annual_vrfction_flg -- 需年审标志
    ,cust_rating_rest_cd -- 客户评级结果代码
    ,final_apv_opinion_one -- 最终审批意见一
    ,final_apv_opinion_two -- 最终审批意见二
    ,apv_dt -- 审批日期
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,corp_lmt_amt -- 公司额度金额
    ,corp_open_amt -- 公司敞口金额
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,under_bus_provi_guar_guar_flg -- 项下业务提供保证担保标志
    ,under_bus_bear_repo_duty_flg -- 项下业务承担回购责任标志
    ,under_bus_major_guar_way_cd -- 项下业务主要担保方式代码
    ,proj_name -- 项目名称
    ,proj_tot_area -- 项目总面积
    ,proj_addr -- 项目地址
    ,pre_sell_lics_id -- 销(预)售许可证编号
    ,arch_land_plan_lics_id -- 建设用地规划可证编号
    ,nation_land_use_cert_id -- 国有土地使用证编号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证编号
    ,arch_proj_cnstr_lics_id -- 建筑工程施工可证编号
    ,higt_apv_ratio -- 最高审批比例
    ,lont_year_tenor -- 最长年期限
    ,provi_fund_loan_comm_fee_ratio -- 公积金贷款手续费比例
    ,guar_mon_tenor -- 担保月期限
    ,onl_lmt -- 线上额度
    ,cap_src_cd -- 资金来源代码
    ,crdt_rg_cd -- 授信区域代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,have_incre_crdt_flg -- 有增信标志
    ,turn_crdt_flg -- 转授信标志
    ,host_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,patip_loan_bank_no -- 参贷行行号
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_no -- 代理行行号
    ,agent_bank_name -- 代理行名称
    ,prtcpt_way_cd -- 参与方式代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,invest_underly_descb -- 投资标的描述
    ,issue_site_cd -- 发行场所代码
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,guar_way_cd -- 担保方式代码
    ,level5_cls_cd -- 五级分类代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,debt_regroup_cnt -- 债务重组次数
    ,manu_flg -- 人工填写标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团的限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,anti_mon_lau_sys_rating_cd -- 反洗钱系统评级代码
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,lon_post_request_attach_comnt -- 贷后要求补充说明
    ,group_cust_crdt_prop_remark -- 集群客户授信方案备注
    ,bfdistr_pay_impt_esp_restrcond -- 发放与支付前须落实的特殊限制性条件
    ,impt_reach_cont_esp_request -- 需落实到合约的特殊要求
    ,crdt_prop_remark -- 授信方案备注
    ,lon_post_request -- 贷后要求
    ,lon_post_mgmt_request -- 贷后管理要求
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300006'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 审批流水号
    ,P1.BIZMOSTMORTGAGERATE -- 额度下业务最高抵质押比例
    ,P1.BIZBAILINITIALRATE -- 额度下业务初始保证金比例
    ,P1.BIZLOWESTFLOATRATE -- 额度下业务利率最低浮动值
    ,P1.SINGLEBIZMOSTAMOUNT -- 额度下业务单笔最大金额
    ,P1.BIZLONGESTTERM -- 额度下业务最长期限
    ,P1.BIZEXTENDEDTERM -- 额度下业务延展期限
    ,nvl(trim(P1.ISPUBLICCREDIT),'-') -- 公开授信标志
    ,nvl(trim(P1.USEWITHOUTCONDITION),'-') -- 额度可直接使用标志
    ,nvl(trim(P1.TERMTYPE),'-') -- 期限类型代码
    ,nvl(trim(P1.LINECLASS),'-') -- 额度种类代码
    ,nvl(trim(P1.LINECONTROLMODE),'-') -- 集团额度管控模式代码
    ,nvl(trim(P1.CURRENCYRANGE),'-') -- 项下业务币种代码范围
    ,P1.NOMINALSUM -- 额度名义金额
    ,P1.EXPOSURESUM -- 额度敞口金额
    ,P1.OCCUPYNOMINALSUM -- 已用名义金额
    ,P1.OCCUPYEXPOSURESUM -- 已用授信额度
    ,P1.AVAILABLENOMINALSUM -- 可用名义金额
    ,P1.AVAILABLEEXPOSURESUM -- 可用敞口金额
    ,nvl(trim(P1.OTHERLIMITFLAG),'-') -- 占用他用额度标志
    ,P1.RISKEXPOSURESUM -- 一般风险敞口限额
    ,nvl(trim(P1.ISLIKELOWRISK),'-') -- 类低风险标志
    ,P1.LOWRISKEXPOSURESUM -- 类低风险敞口金额
    ,P1.LATESTUSEDATE -- 额度失效日期
    ,P1.BELONGGROUPAPPROVENO -- 集团审批编号
    ,P1.FINANCIALCREDITSERIALNO -- 集群客户专项额度流水号
    ,P1.FINANCIALCREDITOWNER -- 集群客户专项额度所有人名称
    ,P1.OTHERLIMITNO -- 他用额度流水号
    ,nvl(trim(P1.OTHERLIMITTYPE),'-') -- 他用额度类型代码
    ,P1.OTHERLIMITOWNERID -- 他用额度所有人名称
    ,P1.SQDKZE -- 申请银团贷款总额
    ,nvl(trim(P1.DLCDBZ),'-') -- 代理参贷标志
    ,P1.ISQUERYCREDITREPORT -- 自动查询贷后报告标志
    ,P1.CREDITAUTHNO -- 征信授权影像流水号
    ,P1.ISYEARTOCHECK -- 需年审标志
    ,P1.RATEOPINION -- 客户评级结果代码
    ,P1.APPROVEOPINION -- 最终审批意见一
    ,P1.APPROVEOPINION1 -- 最终审批意见二
    ,decode(P1.APPROVEDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date( '2999/12/31','yyyy/mm/dd'),P1.APPROVEDATE) -- 审批日期
    ,P1.SQCHECKYEARDATE -- 上期年审日期
    ,P1.BQCHECKYEARDATE -- 本期年审日期
    ,P1.BUSINESSSUMENTPART -- 公司额度金额
    ,P1.TOTALSUMENTPART -- 公司敞口金额
    ,P1.BUSINESSSUMTYPART -- 同业额度金额
    ,P1.TOTALSUMTYPART -- 同业敞口金额
    ,P1.FLAG1 -- 项下业务提供保证担保标志
    ,P1.FLAG2 -- 项下业务承担回购责任标志
    ,nvl(trim(P1.DESCRIBE1),'-') -- 项下业务主要担保方式代码
    ,P1.PROJECTNAME -- 项目名称
    ,P1.CONSTRUCTIONAREA -- 项目总面积
    ,P1.DESCRIBE2 -- 项目地址
    ,P1.THIRDPARTY1 -- 销(预)售许可证编号
    ,P1.THIRDPARTYID1 -- 建设用地规划可证编号
    ,P1.LANDUSECERTID -- 国有土地使用证编号
    ,P1.THIRDPARTYID2 -- 建设工程规划许可证编号
    ,P1.THIRDPARTY3 -- 建筑工程施工可证编号
    ,nvl(trim(p1.THIRDPARTYID3),0) -- 最高审批比例
    ,nvl(trim(p1.THIRDPARTYADD1),0) -- 最长年期限
    ,nvl(trim(p1.THIRDPARTYZIP1),0) -- 公积金贷款手续费比例
    ,P1.GURANTYMONTH -- 担保月期限
    ,P1.ONLINEAMOUNT -- 线上额度
    ,nvl(trim(P1.FUNDSOURCE),'-') -- 资金来源代码
    ,NVL(TRIM(P1.CREDITAREA),'00') -- 授信区域代码
    ,nvl(trim(P1.ISESTATEFINANCE),'-') -- 涉及房地产融资标志
    ,nvl(trim(P1.ISGOVERNFINANCE),'-') -- 涉及政府类融资标志
    ,nvl(trim(P1.ISCONSUMERFINANCE),'-') -- 消费服务类融资标志
    ,nvl(trim(P1.ISBELTROADFINANCE),'-') -- 一带一路建设投融资标志
    ,nvl(trim(P1.ISGREENFINANCE),'-') -- 绿色信贷融资标志
    ,nvl(trim(P1.INVESTWAY),'-') -- 投资方式代码
    ,nvl(trim(P1.ISLIKELOAN),'-') -- 类信贷标志
    ,nvl(trim(P1.ISFINANCIALCREDIT),'-') -- 商圈授信标志
    ,nvl(trim(P1.ISYHCUSTOMER),'-') -- 优合授信客户标志
    ,nvl(trim(P1.ISSMEANDRETAIL),'-') -- 小微零售标志
    ,nvl(trim(P1.ISBILLAPPLY),'-') -- 新增银承额度专项贴现标志
    ,P1.ISSME -- 小微企业贷款标志
    ,P1.SUREMODEL -- 总行认定模式标志
    ,nvl(trim(P1.ISCREDITINCREMENT),'-') -- 有增信标志
    ,nvl(trim(P1.ISTRANS),'-') -- 转授信标志
    ,P1.HOSTBANKNO -- 主办行行号
    ,P1.HOSTBANKNAME -- 主办行名称
    ,P1.REFBANKNO -- 参贷行行号
    ,P1.REFBANKNAME -- 参贷行名称
    ,P1.AGENTBANKNO -- 代理行行号
    ,P1.AGENTBANKNAME -- 代理行名称
    ,nvl(trim(P1.PLAYTYPE),'6') -- 参与方式代码
    ,P1.BAILRATIO -- 保证金比例
    ,P1.BAILSUM -- 保证金金额
    ,nvl(trim(P1.CUSTRATERISKLEVEL),'-') -- 内部评级结果代码
    ,case when r4.target_cd_val is not null then r4.target_cd_val else '@'||P1.OUTCLASSIFYLEVEL end -- 外部债项评级代码
    ,P1.OUTCLASSIFYORG -- 外部评级机构名称
    ,${iml_schema}.dateformat_max2(P1.OUTCLASSIFYDATE) -- 外部评级日期
    ,P1.INVESTTARGET -- 投资标的描述
    ,case when r1.target_cd_val is not null then r1.target_cd_val else '@'||P1.PUBLICORG end -- 发行场所代码
    ,P1.HXTYOPERATEORG -- 归口管理部门编号
    ,nvl(trim(P1.AUTHVOUCHTYPE),'-') -- 担保方式代码
    ,case when r2.target_cd_val is not null then r2.target_cd_val else '@'||P1.HXTYCLASSIFYLEVEL end -- 五级分类代码
    ,case when r5.target_cd_val is not null then r5.target_cd_val else '@'||P1.HXTYMAINRATELEVEL end -- 外部主体评级代码
    ,P1.MAINLEVELORG -- 主体评级机构名称
    ,${iml_schema}.dateformat_max2(P1.MAINLEVELDATE) -- 主体评级日期
    ,P1.MAXNOMINALAMOUNT -- 单一最高授信额度名义金额
    ,P1.MAXEXPOSUREAMOUNT -- 单一最高授信额度敞口金额
    ,P1.DRTIMES -- 债务重组次数
    ,nvl(trim(P1.IFAPPROVE),'-') -- 人工填写标志
    ,nvl(trim(P1.ISINNOVATE),'-') -- 创新业务标志
    ,nvl(trim(P1.ISSUPPLYCHAINFINANCE),'-') -- 供应链金融业务标志
    ,nvl(trim(P1.ISJOINLIMITS),'-') -- 纳入单一客户或集团的限额标志
    ,nvl(trim(P1.ISCOLLECTIONAGENCY),'-') -- 集合类代销标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ANTIMONEYLAUNDERLEVEL END -- 反洗钱系统评级代码
    ,nvl(trim(P1.ISLIMIT),'-') -- 设置单一客户限额标志
    ,P1.MANAGENAME -- 管理人名称
    ,P1.MANAGEID -- 管理人客户编号
    ,P1.APPROVEOPINION7 -- 贷后要求补充说明
    ,P1.OTHERCONDITION -- 集群客户授信方案备注
    ,P1.AFTERPAYREQ -- 发放与支付前须落实的特殊限制性条件
    ,P1.CONTRACTREQ -- 需落实到合约的特殊要求
    ,P1.PAYREQ -- 授信方案备注
    ,P1.APPROVEOPINION6 -- 贷后要求
    ,P1.LOANMANAGEREQ -- 贷后管理要求
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bap_cl_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bap_cl_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PUBLICORG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_BAP_CL_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'PUBLICORG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_APV_LMT_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ISSUE_SITE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.HXTYCLASSIFYLEVEL = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_BAP_CL_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'HXTYCLASSIFYLEVEL'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LOAN_APV_LMT_ATTACH_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on nvl(trim(P1.ANTIMONEYLAUNDERLEVEL),' ') = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_BAP_CL_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'ANTIMONEYLAUNDERLEVEL'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_LOAN_APV_LMT_ATTACH_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ANTI_MON_LAU_SYS_RATING_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.OUTCLASSIFYLEVEL = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'ICMS_BAP_CL_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'OUTCLASSIFYLEVEL'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_LOAN_APV_LMT_ATTACH_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'EXT_BOND_ITEM_RATING_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.HXTYMAINRATELEVEL = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ICMS'
        AND R5.SRC_TAB_EN_NAME= 'ICMS_BAP_CL_INFO'
        AND R5.SRC_FIELD_EN_NAME= 'HXTYMAINRATELEVEL'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_LOAN_APV_LMT_ATTACH_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'EXT_MAIN_RATING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,apv_flow_num
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
        into ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,lmt_next_bus_higt_pm_ratio -- 额度下业务最高抵质押比例
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
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用名义金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,lmt_invalid_dt -- 额度失效日期
    ,group_apv_id -- 集团审批编号
    ,group_cust_spcl_lmt_flow_num -- 集群客户专项额度流水号
    ,group_cust_spcl_lmt_owner_name -- 集群客户专项额度所有人名称
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_name -- 他用额度所有人名称
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,crdtc_auth_blip_flow_num -- 征信授权影像流水号
    ,need_annual_vrfction_flg -- 需年审标志
    ,cust_rating_rest_cd -- 客户评级结果代码
    ,final_apv_opinion_one -- 最终审批意见一
    ,final_apv_opinion_two -- 最终审批意见二
    ,apv_dt -- 审批日期
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,corp_lmt_amt -- 公司额度金额
    ,corp_open_amt -- 公司敞口金额
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,under_bus_provi_guar_guar_flg -- 项下业务提供保证担保标志
    ,under_bus_bear_repo_duty_flg -- 项下业务承担回购责任标志
    ,under_bus_major_guar_way_cd -- 项下业务主要担保方式代码
    ,proj_name -- 项目名称
    ,proj_tot_area -- 项目总面积
    ,proj_addr -- 项目地址
    ,pre_sell_lics_id -- 销(预)售许可证编号
    ,arch_land_plan_lics_id -- 建设用地规划可证编号
    ,nation_land_use_cert_id -- 国有土地使用证编号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证编号
    ,arch_proj_cnstr_lics_id -- 建筑工程施工可证编号
    ,higt_apv_ratio -- 最高审批比例
    ,lont_year_tenor -- 最长年期限
    ,provi_fund_loan_comm_fee_ratio -- 公积金贷款手续费比例
    ,guar_mon_tenor -- 担保月期限
    ,onl_lmt -- 线上额度
    ,cap_src_cd -- 资金来源代码
    ,crdt_rg_cd -- 授信区域代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,have_incre_crdt_flg -- 有增信标志
    ,turn_crdt_flg -- 转授信标志
    ,host_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,patip_loan_bank_no -- 参贷行行号
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_no -- 代理行行号
    ,agent_bank_name -- 代理行名称
    ,prtcpt_way_cd -- 参与方式代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,invest_underly_descb -- 投资标的描述
    ,issue_site_cd -- 发行场所代码
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,guar_way_cd -- 担保方式代码
    ,level5_cls_cd -- 五级分类代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,debt_regroup_cnt -- 债务重组次数
    ,manu_flg -- 人工填写标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团的限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,anti_mon_lau_sys_rating_cd -- 反洗钱系统评级代码
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,lon_post_request_attach_comnt -- 贷后要求补充说明
    ,group_cust_crdt_prop_remark -- 集群客户授信方案备注
    ,bfdistr_pay_impt_esp_restrcond -- 发放与支付前须落实的特殊限制性条件
    ,impt_reach_cont_esp_request -- 需落实到合约的特殊要求
    ,crdt_prop_remark -- 授信方案备注
    ,lon_post_request -- 贷后要求
    ,lon_post_mgmt_request -- 贷后管理要求
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,lmt_next_bus_higt_pm_ratio -- 额度下业务最高抵质押比例
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
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用名义金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,lmt_invalid_dt -- 额度失效日期
    ,group_apv_id -- 集团审批编号
    ,group_cust_spcl_lmt_flow_num -- 集群客户专项额度流水号
    ,group_cust_spcl_lmt_owner_name -- 集群客户专项额度所有人名称
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_name -- 他用额度所有人名称
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,crdtc_auth_blip_flow_num -- 征信授权影像流水号
    ,need_annual_vrfction_flg -- 需年审标志
    ,cust_rating_rest_cd -- 客户评级结果代码
    ,final_apv_opinion_one -- 最终审批意见一
    ,final_apv_opinion_two -- 最终审批意见二
    ,apv_dt -- 审批日期
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,corp_lmt_amt -- 公司额度金额
    ,corp_open_amt -- 公司敞口金额
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,under_bus_provi_guar_guar_flg -- 项下业务提供保证担保标志
    ,under_bus_bear_repo_duty_flg -- 项下业务承担回购责任标志
    ,under_bus_major_guar_way_cd -- 项下业务主要担保方式代码
    ,proj_name -- 项目名称
    ,proj_tot_area -- 项目总面积
    ,proj_addr -- 项目地址
    ,pre_sell_lics_id -- 销(预)售许可证编号
    ,arch_land_plan_lics_id -- 建设用地规划可证编号
    ,nation_land_use_cert_id -- 国有土地使用证编号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证编号
    ,arch_proj_cnstr_lics_id -- 建筑工程施工可证编号
    ,higt_apv_ratio -- 最高审批比例
    ,lont_year_tenor -- 最长年期限
    ,provi_fund_loan_comm_fee_ratio -- 公积金贷款手续费比例
    ,guar_mon_tenor -- 担保月期限
    ,onl_lmt -- 线上额度
    ,cap_src_cd -- 资金来源代码
    ,crdt_rg_cd -- 授信区域代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,have_incre_crdt_flg -- 有增信标志
    ,turn_crdt_flg -- 转授信标志
    ,host_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,patip_loan_bank_no -- 参贷行行号
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_no -- 代理行行号
    ,agent_bank_name -- 代理行名称
    ,prtcpt_way_cd -- 参与方式代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,invest_underly_descb -- 投资标的描述
    ,issue_site_cd -- 发行场所代码
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,guar_way_cd -- 担保方式代码
    ,level5_cls_cd -- 五级分类代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,debt_regroup_cnt -- 债务重组次数
    ,manu_flg -- 人工填写标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团的限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,anti_mon_lau_sys_rating_cd -- 反洗钱系统评级代码
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,lon_post_request_attach_comnt -- 贷后要求补充说明
    ,group_cust_crdt_prop_remark -- 集群客户授信方案备注
    ,bfdistr_pay_impt_esp_restrcond -- 发放与支付前须落实的特殊限制性条件
    ,impt_reach_cont_esp_request -- 需落实到合约的特殊要求
    ,crdt_prop_remark -- 授信方案备注
    ,lon_post_request -- 贷后要求
    ,lon_post_mgmt_request -- 贷后管理要求
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.apv_flow_num, o.apv_flow_num) as apv_flow_num -- 审批流水号
    ,nvl(n.lmt_next_bus_higt_pm_ratio, o.lmt_next_bus_higt_pm_ratio) as lmt_next_bus_higt_pm_ratio -- 额度下业务最高抵质押比例
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
    ,nvl(n.lmt_nmal_amt, o.lmt_nmal_amt) as lmt_nmal_amt -- 额度名义金额
    ,nvl(n.lmt_open_amt, o.lmt_open_amt) as lmt_open_amt -- 额度敞口金额
    ,nvl(n.used_nmal_amt, o.used_nmal_amt) as used_nmal_amt -- 已用名义金额
    ,nvl(n.used_open_amt, o.used_open_amt) as used_open_amt -- 已用授信额度
    ,nvl(n.aval_nmal_amt, o.aval_nmal_amt) as aval_nmal_amt -- 可用名义金额
    ,nvl(n.aval_open_amt, o.aval_open_amt) as aval_open_amt -- 可用敞口金额
    ,nvl(n.ocup_o_use_lmt_flg, o.ocup_o_use_lmt_flg) as ocup_o_use_lmt_flg -- 占用他用额度标志
    ,nvl(n.comn_risk_open_lmt, o.comn_risk_open_lmt) as comn_risk_open_lmt -- 一般风险敞口限额
    ,nvl(n.class_low_risk_flg, o.class_low_risk_flg) as class_low_risk_flg -- 类低风险标志
    ,nvl(n.class_low_risk_open_amt, o.class_low_risk_open_amt) as class_low_risk_open_amt -- 类低风险敞口金额
    ,nvl(n.lmt_invalid_dt, o.lmt_invalid_dt) as lmt_invalid_dt -- 额度失效日期
    ,nvl(n.group_apv_id, o.group_apv_id) as group_apv_id -- 集团审批编号
    ,nvl(n.group_cust_spcl_lmt_flow_num, o.group_cust_spcl_lmt_flow_num) as group_cust_spcl_lmt_flow_num -- 集群客户专项额度流水号
    ,nvl(n.group_cust_spcl_lmt_owner_name, o.group_cust_spcl_lmt_owner_name) as group_cust_spcl_lmt_owner_name -- 集群客户专项额度所有人名称
    ,nvl(n.o_use_lmt_flow_num, o.o_use_lmt_flow_num) as o_use_lmt_flow_num -- 他用额度流水号
    ,nvl(n.o_use_lmt_type_cd, o.o_use_lmt_type_cd) as o_use_lmt_type_cd -- 他用额度类型代码
    ,nvl(n.o_use_lmt_owner_name, o.o_use_lmt_owner_name) as o_use_lmt_owner_name -- 他用额度所有人名称
    ,nvl(n.appl_syn_loan_tot, o.appl_syn_loan_tot) as appl_syn_loan_tot -- 申请银团贷款总额
    ,nvl(n.agent_patip_loan_flg, o.agent_patip_loan_flg) as agent_patip_loan_flg -- 代理参贷标志
    ,nvl(n.auto_que_lon_post_rept_flg, o.auto_que_lon_post_rept_flg) as auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,nvl(n.crdtc_auth_blip_flow_num, o.crdtc_auth_blip_flow_num) as crdtc_auth_blip_flow_num -- 征信授权影像流水号
    ,nvl(n.need_annual_vrfction_flg, o.need_annual_vrfction_flg) as need_annual_vrfction_flg -- 需年审标志
    ,nvl(n.cust_rating_rest_cd, o.cust_rating_rest_cd) as cust_rating_rest_cd -- 客户评级结果代码
    ,nvl(n.final_apv_opinion_one, o.final_apv_opinion_one) as final_apv_opinion_one -- 最终审批意见一
    ,nvl(n.final_apv_opinion_two, o.final_apv_opinion_two) as final_apv_opinion_two -- 最终审批意见二
    ,nvl(n.apv_dt, o.apv_dt) as apv_dt -- 审批日期
    ,nvl(n.l_ped_annual_vrfction_dt, o.l_ped_annual_vrfction_dt) as l_ped_annual_vrfction_dt -- 上期年审日期
    ,nvl(n.curr_issue_annual_vrfction_dt, o.curr_issue_annual_vrfction_dt) as curr_issue_annual_vrfction_dt -- 本期年审日期
    ,nvl(n.corp_lmt_amt, o.corp_lmt_amt) as corp_lmt_amt -- 公司额度金额
    ,nvl(n.corp_open_amt, o.corp_open_amt) as corp_open_amt -- 公司敞口金额
    ,nvl(n.ibank_lmt_amt, o.ibank_lmt_amt) as ibank_lmt_amt -- 同业额度金额
    ,nvl(n.ibank_open_amt, o.ibank_open_amt) as ibank_open_amt -- 同业敞口金额
    ,nvl(n.under_bus_provi_guar_guar_flg, o.under_bus_provi_guar_guar_flg) as under_bus_provi_guar_guar_flg -- 项下业务提供保证担保标志
    ,nvl(n.under_bus_bear_repo_duty_flg, o.under_bus_bear_repo_duty_flg) as under_bus_bear_repo_duty_flg -- 项下业务承担回购责任标志
    ,nvl(n.under_bus_major_guar_way_cd, o.under_bus_major_guar_way_cd) as under_bus_major_guar_way_cd -- 项下业务主要担保方式代码
    ,nvl(n.proj_name, o.proj_name) as proj_name -- 项目名称
    ,nvl(n.proj_tot_area, o.proj_tot_area) as proj_tot_area -- 项目总面积
    ,nvl(n.proj_addr, o.proj_addr) as proj_addr -- 项目地址
    ,nvl(n.pre_sell_lics_id, o.pre_sell_lics_id) as pre_sell_lics_id -- 销(预)售许可证编号
    ,nvl(n.arch_land_plan_lics_id, o.arch_land_plan_lics_id) as arch_land_plan_lics_id -- 建设用地规划可证编号
    ,nvl(n.nation_land_use_cert_id, o.nation_land_use_cert_id) as nation_land_use_cert_id -- 国有土地使用证编号
    ,nvl(n.cnstr_proj_plan_permit_id, o.cnstr_proj_plan_permit_id) as cnstr_proj_plan_permit_id -- 建设工程规划许可证编号
    ,nvl(n.arch_proj_cnstr_lics_id, o.arch_proj_cnstr_lics_id) as arch_proj_cnstr_lics_id -- 建筑工程施工可证编号
    ,nvl(n.higt_apv_ratio, o.higt_apv_ratio) as higt_apv_ratio -- 最高审批比例
    ,nvl(n.lont_year_tenor, o.lont_year_tenor) as lont_year_tenor -- 最长年期限
    ,nvl(n.provi_fund_loan_comm_fee_ratio, o.provi_fund_loan_comm_fee_ratio) as provi_fund_loan_comm_fee_ratio -- 公积金贷款手续费比例
    ,nvl(n.guar_mon_tenor, o.guar_mon_tenor) as guar_mon_tenor -- 担保月期限
    ,nvl(n.onl_lmt, o.onl_lmt) as onl_lmt -- 线上额度
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.crdt_rg_cd, o.crdt_rg_cd) as crdt_rg_cd -- 授信区域代码
    ,nvl(n.invo_estate_fin_flg, o.invo_estate_fin_flg) as invo_estate_fin_flg -- 涉及房地产融资标志
    ,nvl(n.invo_gover_class_fin_flg, o.invo_gover_class_fin_flg) as invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,nvl(n.consm_serv_class_fin_flg, o.consm_serv_class_fin_flg) as consm_serv_class_fin_flg -- 消费服务类融资标志
    ,nvl(n.br_build_ifin_flg, o.br_build_ifin_flg) as br_build_ifin_flg -- 一带一路建设投融资标志
    ,nvl(n.green_crdt_fin_flg, o.green_crdt_fin_flg) as green_crdt_fin_flg -- 绿色信贷融资标志
    ,nvl(n.invest_way_cd, o.invest_way_cd) as invest_way_cd -- 投资方式代码
    ,nvl(n.class_crdt_flg, o.class_crdt_flg) as class_crdt_flg -- 类信贷标志
    ,nvl(n.ta_crdt_flg, o.ta_crdt_flg) as ta_crdt_flg -- 商圈授信标志
    ,nvl(n.yh_crdt_cust_flg, o.yh_crdt_cust_flg) as yh_crdt_cust_flg -- 优合授信客户标志
    ,nvl(n.sm_retl_flg, o.sm_retl_flg) as sm_retl_flg -- 小微零售标志
    ,nvl(n.add_ba_lmt_spcl_discnt_flg, o.add_ba_lmt_spcl_discnt_flg) as add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,nvl(n.sm_corp_loan_flg, o.sm_corp_loan_flg) as sm_corp_loan_flg -- 小微企业贷款标志
    ,nvl(n.hq_idtfy_mode_flg, o.hq_idtfy_mode_flg) as hq_idtfy_mode_flg -- 总行认定模式标志
    ,nvl(n.have_incre_crdt_flg, o.have_incre_crdt_flg) as have_incre_crdt_flg -- 有增信标志
    ,nvl(n.turn_crdt_flg, o.turn_crdt_flg) as turn_crdt_flg -- 转授信标志
    ,nvl(n.host_bank_no, o.host_bank_no) as host_bank_no -- 主办行行号
    ,nvl(n.host_bank_name, o.host_bank_name) as host_bank_name -- 主办行名称
    ,nvl(n.patip_loan_bank_no, o.patip_loan_bank_no) as patip_loan_bank_no -- 参贷行行号
    ,nvl(n.patip_loan_bank_name, o.patip_loan_bank_name) as patip_loan_bank_name -- 参贷行名称
    ,nvl(n.agent_bank_no, o.agent_bank_no) as agent_bank_no -- 代理行行号
    ,nvl(n.agent_bank_name, o.agent_bank_name) as agent_bank_name -- 代理行名称
    ,nvl(n.prtcpt_way_cd, o.prtcpt_way_cd) as prtcpt_way_cd -- 参与方式代码
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.intnal_rating_rest_cd, o.intnal_rating_rest_cd) as intnal_rating_rest_cd -- 内部评级结果代码
    ,nvl(n.ext_bond_item_rating_cd, o.ext_bond_item_rating_cd) as ext_bond_item_rating_cd -- 外部债项评级代码
    ,nvl(n.ext_rating_org_name, o.ext_rating_org_name) as ext_rating_org_name -- 外部评级机构名称
    ,nvl(n.ext_rating_dt, o.ext_rating_dt) as ext_rating_dt -- 外部评级日期
    ,nvl(n.invest_underly_descb, o.invest_underly_descb) as invest_underly_descb -- 投资标的描述
    ,nvl(n.issue_site_cd, o.issue_site_cd) as issue_site_cd -- 发行场所代码
    ,nvl(n.cent_mgmt_dept_id, o.cent_mgmt_dept_id) as cent_mgmt_dept_id -- 归口管理部门编号
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.ext_main_rating_cd, o.ext_main_rating_cd) as ext_main_rating_cd -- 外部主体评级代码
    ,nvl(n.main_rating_org_name, o.main_rating_org_name) as main_rating_org_name -- 主体评级机构名称
    ,nvl(n.main_rating_dt, o.main_rating_dt) as main_rating_dt -- 主体评级日期
    ,nvl(n.single_higt_crdt_lmt_nmal_amt, o.single_higt_crdt_lmt_nmal_amt) as single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,nvl(n.single_higt_crdt_lmt_open_amt, o.single_higt_crdt_lmt_open_amt) as single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,nvl(n.debt_regroup_cnt, o.debt_regroup_cnt) as debt_regroup_cnt -- 债务重组次数
    ,nvl(n.manu_flg, o.manu_flg) as manu_flg -- 人工填写标志
    ,nvl(n.inovt_bus_flg, o.inovt_bus_flg) as inovt_bus_flg -- 创新业务标志
    ,nvl(n.sup_chain_fin_bus_flg, o.sup_chain_fin_bus_flg) as sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,nvl(n.fit_in_single_cust_or_group_lmt_flg, o.fit_in_single_cust_or_group_lmt_flg) as fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团的限额标志
    ,nvl(n.comb_class_consmt_flg, o.comb_class_consmt_flg) as comb_class_consmt_flg -- 集合类代销标志
    ,nvl(n.anti_mon_lau_sys_rating_cd, o.anti_mon_lau_sys_rating_cd) as anti_mon_lau_sys_rating_cd -- 反洗钱系统评级代码
    ,nvl(n.set_single_cust_lmt_flg, o.set_single_cust_lmt_flg) as set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,nvl(n.mger_name, o.mger_name) as mger_name -- 管理人名称
    ,nvl(n.mger_cust_id, o.mger_cust_id) as mger_cust_id -- 管理人客户编号
    ,nvl(n.lon_post_request_attach_comnt, o.lon_post_request_attach_comnt) as lon_post_request_attach_comnt -- 贷后要求补充说明
    ,nvl(n.group_cust_crdt_prop_remark, o.group_cust_crdt_prop_remark) as group_cust_crdt_prop_remark -- 集群客户授信方案备注
    ,nvl(n.bfdistr_pay_impt_esp_restrcond, o.bfdistr_pay_impt_esp_restrcond) as bfdistr_pay_impt_esp_restrcond -- 发放与支付前须落实的特殊限制性条件
    ,nvl(n.impt_reach_cont_esp_request, o.impt_reach_cont_esp_request) as impt_reach_cont_esp_request -- 需落实到合约的特殊要求
    ,nvl(n.crdt_prop_remark, o.crdt_prop_remark) as crdt_prop_remark -- 授信方案备注
    ,nvl(n.lon_post_request, o.lon_post_request) as lon_post_request -- 贷后要求
    ,nvl(n.lon_post_mgmt_request, o.lon_post_mgmt_request) as lon_post_mgmt_request -- 贷后管理要求
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.apv_flow_num = n.apv_flow_num
where (
        o.agt_id is null
        and o.apv_flow_num is null
    )
    or (
        n.agt_id is null
        and n.apv_flow_num is null
    )
    or (
        o.lmt_next_bus_higt_pm_ratio <> n.lmt_next_bus_higt_pm_ratio
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
        or o.lmt_nmal_amt <> n.lmt_nmal_amt
        or o.lmt_open_amt <> n.lmt_open_amt
        or o.used_nmal_amt <> n.used_nmal_amt
        or o.used_open_amt <> n.used_open_amt
        or o.aval_nmal_amt <> n.aval_nmal_amt
        or o.aval_open_amt <> n.aval_open_amt
        or o.ocup_o_use_lmt_flg <> n.ocup_o_use_lmt_flg
        or o.comn_risk_open_lmt <> n.comn_risk_open_lmt
        or o.class_low_risk_flg <> n.class_low_risk_flg
        or o.class_low_risk_open_amt <> n.class_low_risk_open_amt
        or o.lmt_invalid_dt <> n.lmt_invalid_dt
        or o.group_apv_id <> n.group_apv_id
        or o.group_cust_spcl_lmt_flow_num <> n.group_cust_spcl_lmt_flow_num
        or o.group_cust_spcl_lmt_owner_name <> n.group_cust_spcl_lmt_owner_name
        or o.o_use_lmt_flow_num <> n.o_use_lmt_flow_num
        or o.o_use_lmt_type_cd <> n.o_use_lmt_type_cd
        or o.o_use_lmt_owner_name <> n.o_use_lmt_owner_name
        or o.appl_syn_loan_tot <> n.appl_syn_loan_tot
        or o.agent_patip_loan_flg <> n.agent_patip_loan_flg
        or o.auto_que_lon_post_rept_flg <> n.auto_que_lon_post_rept_flg
        or o.crdtc_auth_blip_flow_num <> n.crdtc_auth_blip_flow_num
        or o.need_annual_vrfction_flg <> n.need_annual_vrfction_flg
        or o.cust_rating_rest_cd <> n.cust_rating_rest_cd
        or o.final_apv_opinion_one <> n.final_apv_opinion_one
        or o.final_apv_opinion_two <> n.final_apv_opinion_two
        or o.apv_dt <> n.apv_dt
        or o.l_ped_annual_vrfction_dt <> n.l_ped_annual_vrfction_dt
        or o.curr_issue_annual_vrfction_dt <> n.curr_issue_annual_vrfction_dt
        or o.corp_lmt_amt <> n.corp_lmt_amt
        or o.corp_open_amt <> n.corp_open_amt
        or o.ibank_lmt_amt <> n.ibank_lmt_amt
        or o.ibank_open_amt <> n.ibank_open_amt
        or o.under_bus_provi_guar_guar_flg <> n.under_bus_provi_guar_guar_flg
        or o.under_bus_bear_repo_duty_flg <> n.under_bus_bear_repo_duty_flg
        or o.under_bus_major_guar_way_cd <> n.under_bus_major_guar_way_cd
        or o.proj_name <> n.proj_name
        or o.proj_tot_area <> n.proj_tot_area
        or o.proj_addr <> n.proj_addr
        or o.pre_sell_lics_id <> n.pre_sell_lics_id
        or o.arch_land_plan_lics_id <> n.arch_land_plan_lics_id
        or o.nation_land_use_cert_id <> n.nation_land_use_cert_id
        or o.cnstr_proj_plan_permit_id <> n.cnstr_proj_plan_permit_id
        or o.arch_proj_cnstr_lics_id <> n.arch_proj_cnstr_lics_id
        or o.higt_apv_ratio <> n.higt_apv_ratio
        or o.lont_year_tenor <> n.lont_year_tenor
        or o.provi_fund_loan_comm_fee_ratio <> n.provi_fund_loan_comm_fee_ratio
        or o.guar_mon_tenor <> n.guar_mon_tenor
        or o.onl_lmt <> n.onl_lmt
        or o.cap_src_cd <> n.cap_src_cd
        or o.crdt_rg_cd <> n.crdt_rg_cd
        or o.invo_estate_fin_flg <> n.invo_estate_fin_flg
        or o.invo_gover_class_fin_flg <> n.invo_gover_class_fin_flg
        or o.consm_serv_class_fin_flg <> n.consm_serv_class_fin_flg
        or o.br_build_ifin_flg <> n.br_build_ifin_flg
        or o.green_crdt_fin_flg <> n.green_crdt_fin_flg
        or o.invest_way_cd <> n.invest_way_cd
        or o.class_crdt_flg <> n.class_crdt_flg
        or o.ta_crdt_flg <> n.ta_crdt_flg
        or o.yh_crdt_cust_flg <> n.yh_crdt_cust_flg
        or o.sm_retl_flg <> n.sm_retl_flg
        or o.add_ba_lmt_spcl_discnt_flg <> n.add_ba_lmt_spcl_discnt_flg
        or o.sm_corp_loan_flg <> n.sm_corp_loan_flg
        or o.hq_idtfy_mode_flg <> n.hq_idtfy_mode_flg
        or o.have_incre_crdt_flg <> n.have_incre_crdt_flg
        or o.turn_crdt_flg <> n.turn_crdt_flg
        or o.host_bank_no <> n.host_bank_no
        or o.host_bank_name <> n.host_bank_name
        or o.patip_loan_bank_no <> n.patip_loan_bank_no
        or o.patip_loan_bank_name <> n.patip_loan_bank_name
        or o.agent_bank_no <> n.agent_bank_no
        or o.agent_bank_name <> n.agent_bank_name
        or o.prtcpt_way_cd <> n.prtcpt_way_cd
        or o.margin_ratio <> n.margin_ratio
        or o.margin_amt <> n.margin_amt
        or o.intnal_rating_rest_cd <> n.intnal_rating_rest_cd
        or o.ext_bond_item_rating_cd <> n.ext_bond_item_rating_cd
        or o.ext_rating_org_name <> n.ext_rating_org_name
        or o.ext_rating_dt <> n.ext_rating_dt
        or o.invest_underly_descb <> n.invest_underly_descb
        or o.issue_site_cd <> n.issue_site_cd
        or o.cent_mgmt_dept_id <> n.cent_mgmt_dept_id
        or o.guar_way_cd <> n.guar_way_cd
        or o.level5_cls_cd <> n.level5_cls_cd
        or o.ext_main_rating_cd <> n.ext_main_rating_cd
        or o.main_rating_org_name <> n.main_rating_org_name
        or o.main_rating_dt <> n.main_rating_dt
        or o.single_higt_crdt_lmt_nmal_amt <> n.single_higt_crdt_lmt_nmal_amt
        or o.single_higt_crdt_lmt_open_amt <> n.single_higt_crdt_lmt_open_amt
        or o.debt_regroup_cnt <> n.debt_regroup_cnt
        or o.manu_flg <> n.manu_flg
        or o.inovt_bus_flg <> n.inovt_bus_flg
        or o.sup_chain_fin_bus_flg <> n.sup_chain_fin_bus_flg
        or o.fit_in_single_cust_or_group_lmt_flg <> n.fit_in_single_cust_or_group_lmt_flg
        or o.comb_class_consmt_flg <> n.comb_class_consmt_flg
        or o.anti_mon_lau_sys_rating_cd <> n.anti_mon_lau_sys_rating_cd
        or o.set_single_cust_lmt_flg <> n.set_single_cust_lmt_flg
        or o.mger_name <> n.mger_name
        or o.mger_cust_id <> n.mger_cust_id
        or o.lon_post_request_attach_comnt <> n.lon_post_request_attach_comnt
        or o.group_cust_crdt_prop_remark <> n.group_cust_crdt_prop_remark
        or o.bfdistr_pay_impt_esp_restrcond <> n.bfdistr_pay_impt_esp_restrcond
        or o.impt_reach_cont_esp_request <> n.impt_reach_cont_esp_request
        or o.crdt_prop_remark <> n.crdt_prop_remark
        or o.lon_post_request <> n.lon_post_request
        or o.lon_post_mgmt_request <> n.lon_post_mgmt_request
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,lmt_next_bus_higt_pm_ratio -- 额度下业务最高抵质押比例
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
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用名义金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,lmt_invalid_dt -- 额度失效日期
    ,group_apv_id -- 集团审批编号
    ,group_cust_spcl_lmt_flow_num -- 集群客户专项额度流水号
    ,group_cust_spcl_lmt_owner_name -- 集群客户专项额度所有人名称
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_name -- 他用额度所有人名称
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,crdtc_auth_blip_flow_num -- 征信授权影像流水号
    ,need_annual_vrfction_flg -- 需年审标志
    ,cust_rating_rest_cd -- 客户评级结果代码
    ,final_apv_opinion_one -- 最终审批意见一
    ,final_apv_opinion_two -- 最终审批意见二
    ,apv_dt -- 审批日期
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,corp_lmt_amt -- 公司额度金额
    ,corp_open_amt -- 公司敞口金额
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,under_bus_provi_guar_guar_flg -- 项下业务提供保证担保标志
    ,under_bus_bear_repo_duty_flg -- 项下业务承担回购责任标志
    ,under_bus_major_guar_way_cd -- 项下业务主要担保方式代码
    ,proj_name -- 项目名称
    ,proj_tot_area -- 项目总面积
    ,proj_addr -- 项目地址
    ,pre_sell_lics_id -- 销(预)售许可证编号
    ,arch_land_plan_lics_id -- 建设用地规划可证编号
    ,nation_land_use_cert_id -- 国有土地使用证编号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证编号
    ,arch_proj_cnstr_lics_id -- 建筑工程施工可证编号
    ,higt_apv_ratio -- 最高审批比例
    ,lont_year_tenor -- 最长年期限
    ,provi_fund_loan_comm_fee_ratio -- 公积金贷款手续费比例
    ,guar_mon_tenor -- 担保月期限
    ,onl_lmt -- 线上额度
    ,cap_src_cd -- 资金来源代码
    ,crdt_rg_cd -- 授信区域代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,have_incre_crdt_flg -- 有增信标志
    ,turn_crdt_flg -- 转授信标志
    ,host_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,patip_loan_bank_no -- 参贷行行号
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_no -- 代理行行号
    ,agent_bank_name -- 代理行名称
    ,prtcpt_way_cd -- 参与方式代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,invest_underly_descb -- 投资标的描述
    ,issue_site_cd -- 发行场所代码
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,guar_way_cd -- 担保方式代码
    ,level5_cls_cd -- 五级分类代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,debt_regroup_cnt -- 债务重组次数
    ,manu_flg -- 人工填写标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团的限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,anti_mon_lau_sys_rating_cd -- 反洗钱系统评级代码
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,lon_post_request_attach_comnt -- 贷后要求补充说明
    ,group_cust_crdt_prop_remark -- 集群客户授信方案备注
    ,bfdistr_pay_impt_esp_restrcond -- 发放与支付前须落实的特殊限制性条件
    ,impt_reach_cont_esp_request -- 需落实到合约的特殊要求
    ,crdt_prop_remark -- 授信方案备注
    ,lon_post_request -- 贷后要求
    ,lon_post_mgmt_request -- 贷后管理要求
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,lmt_next_bus_higt_pm_ratio -- 额度下业务最高抵质押比例
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
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用名义金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,comn_risk_open_lmt -- 一般风险敞口限额
    ,class_low_risk_flg -- 类低风险标志
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,lmt_invalid_dt -- 额度失效日期
    ,group_apv_id -- 集团审批编号
    ,group_cust_spcl_lmt_flow_num -- 集群客户专项额度流水号
    ,group_cust_spcl_lmt_owner_name -- 集群客户专项额度所有人名称
    ,o_use_lmt_flow_num -- 他用额度流水号
    ,o_use_lmt_type_cd -- 他用额度类型代码
    ,o_use_lmt_owner_name -- 他用额度所有人名称
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,agent_patip_loan_flg -- 代理参贷标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,crdtc_auth_blip_flow_num -- 征信授权影像流水号
    ,need_annual_vrfction_flg -- 需年审标志
    ,cust_rating_rest_cd -- 客户评级结果代码
    ,final_apv_opinion_one -- 最终审批意见一
    ,final_apv_opinion_two -- 最终审批意见二
    ,apv_dt -- 审批日期
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,corp_lmt_amt -- 公司额度金额
    ,corp_open_amt -- 公司敞口金额
    ,ibank_lmt_amt -- 同业额度金额
    ,ibank_open_amt -- 同业敞口金额
    ,under_bus_provi_guar_guar_flg -- 项下业务提供保证担保标志
    ,under_bus_bear_repo_duty_flg -- 项下业务承担回购责任标志
    ,under_bus_major_guar_way_cd -- 项下业务主要担保方式代码
    ,proj_name -- 项目名称
    ,proj_tot_area -- 项目总面积
    ,proj_addr -- 项目地址
    ,pre_sell_lics_id -- 销(预)售许可证编号
    ,arch_land_plan_lics_id -- 建设用地规划可证编号
    ,nation_land_use_cert_id -- 国有土地使用证编号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证编号
    ,arch_proj_cnstr_lics_id -- 建筑工程施工可证编号
    ,higt_apv_ratio -- 最高审批比例
    ,lont_year_tenor -- 最长年期限
    ,provi_fund_loan_comm_fee_ratio -- 公积金贷款手续费比例
    ,guar_mon_tenor -- 担保月期限
    ,onl_lmt -- 线上额度
    ,cap_src_cd -- 资金来源代码
    ,crdt_rg_cd -- 授信区域代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,ta_crdt_flg -- 商圈授信标志
    ,yh_crdt_cust_flg -- 优合授信客户标志
    ,sm_retl_flg -- 小微零售标志
    ,add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,sm_corp_loan_flg -- 小微企业贷款标志
    ,hq_idtfy_mode_flg -- 总行认定模式标志
    ,have_incre_crdt_flg -- 有增信标志
    ,turn_crdt_flg -- 转授信标志
    ,host_bank_no -- 主办行行号
    ,host_bank_name -- 主办行名称
    ,patip_loan_bank_no -- 参贷行行号
    ,patip_loan_bank_name -- 参贷行名称
    ,agent_bank_no -- 代理行行号
    ,agent_bank_name -- 代理行名称
    ,prtcpt_way_cd -- 参与方式代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,intnal_rating_rest_cd -- 内部评级结果代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,invest_underly_descb -- 投资标的描述
    ,issue_site_cd -- 发行场所代码
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,guar_way_cd -- 担保方式代码
    ,level5_cls_cd -- 五级分类代码
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,debt_regroup_cnt -- 债务重组次数
    ,manu_flg -- 人工填写标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团的限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,anti_mon_lau_sys_rating_cd -- 反洗钱系统评级代码
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,lon_post_request_attach_comnt -- 贷后要求补充说明
    ,group_cust_crdt_prop_remark -- 集群客户授信方案备注
    ,bfdistr_pay_impt_esp_restrcond -- 发放与支付前须落实的特殊限制性条件
    ,impt_reach_cont_esp_request -- 需落实到合约的特殊要求
    ,crdt_prop_remark -- 授信方案备注
    ,lon_post_request -- 贷后要求
    ,lon_post_mgmt_request -- 贷后管理要求
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.apv_flow_num -- 审批流水号
    ,o.lmt_next_bus_higt_pm_ratio -- 额度下业务最高抵质押比例
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
    ,o.lmt_nmal_amt -- 额度名义金额
    ,o.lmt_open_amt -- 额度敞口金额
    ,o.used_nmal_amt -- 已用名义金额
    ,o.used_open_amt -- 已用授信额度
    ,o.aval_nmal_amt -- 可用名义金额
    ,o.aval_open_amt -- 可用敞口金额
    ,o.ocup_o_use_lmt_flg -- 占用他用额度标志
    ,o.comn_risk_open_lmt -- 一般风险敞口限额
    ,o.class_low_risk_flg -- 类低风险标志
    ,o.class_low_risk_open_amt -- 类低风险敞口金额
    ,o.lmt_invalid_dt -- 额度失效日期
    ,o.group_apv_id -- 集团审批编号
    ,o.group_cust_spcl_lmt_flow_num -- 集群客户专项额度流水号
    ,o.group_cust_spcl_lmt_owner_name -- 集群客户专项额度所有人名称
    ,o.o_use_lmt_flow_num -- 他用额度流水号
    ,o.o_use_lmt_type_cd -- 他用额度类型代码
    ,o.o_use_lmt_owner_name -- 他用额度所有人名称
    ,o.appl_syn_loan_tot -- 申请银团贷款总额
    ,o.agent_patip_loan_flg -- 代理参贷标志
    ,o.auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,o.crdtc_auth_blip_flow_num -- 征信授权影像流水号
    ,o.need_annual_vrfction_flg -- 需年审标志
    ,o.cust_rating_rest_cd -- 客户评级结果代码
    ,o.final_apv_opinion_one -- 最终审批意见一
    ,o.final_apv_opinion_two -- 最终审批意见二
    ,o.apv_dt -- 审批日期
    ,o.l_ped_annual_vrfction_dt -- 上期年审日期
    ,o.curr_issue_annual_vrfction_dt -- 本期年审日期
    ,o.corp_lmt_amt -- 公司额度金额
    ,o.corp_open_amt -- 公司敞口金额
    ,o.ibank_lmt_amt -- 同业额度金额
    ,o.ibank_open_amt -- 同业敞口金额
    ,o.under_bus_provi_guar_guar_flg -- 项下业务提供保证担保标志
    ,o.under_bus_bear_repo_duty_flg -- 项下业务承担回购责任标志
    ,o.under_bus_major_guar_way_cd -- 项下业务主要担保方式代码
    ,o.proj_name -- 项目名称
    ,o.proj_tot_area -- 项目总面积
    ,o.proj_addr -- 项目地址
    ,o.pre_sell_lics_id -- 销(预)售许可证编号
    ,o.arch_land_plan_lics_id -- 建设用地规划可证编号
    ,o.nation_land_use_cert_id -- 国有土地使用证编号
    ,o.cnstr_proj_plan_permit_id -- 建设工程规划许可证编号
    ,o.arch_proj_cnstr_lics_id -- 建筑工程施工可证编号
    ,o.higt_apv_ratio -- 最高审批比例
    ,o.lont_year_tenor -- 最长年期限
    ,o.provi_fund_loan_comm_fee_ratio -- 公积金贷款手续费比例
    ,o.guar_mon_tenor -- 担保月期限
    ,o.onl_lmt -- 线上额度
    ,o.cap_src_cd -- 资金来源代码
    ,o.crdt_rg_cd -- 授信区域代码
    ,o.invo_estate_fin_flg -- 涉及房地产融资标志
    ,o.invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,o.consm_serv_class_fin_flg -- 消费服务类融资标志
    ,o.br_build_ifin_flg -- 一带一路建设投融资标志
    ,o.green_crdt_fin_flg -- 绿色信贷融资标志
    ,o.invest_way_cd -- 投资方式代码
    ,o.class_crdt_flg -- 类信贷标志
    ,o.ta_crdt_flg -- 商圈授信标志
    ,o.yh_crdt_cust_flg -- 优合授信客户标志
    ,o.sm_retl_flg -- 小微零售标志
    ,o.add_ba_lmt_spcl_discnt_flg -- 新增银承额度专项贴现标志
    ,o.sm_corp_loan_flg -- 小微企业贷款标志
    ,o.hq_idtfy_mode_flg -- 总行认定模式标志
    ,o.have_incre_crdt_flg -- 有增信标志
    ,o.turn_crdt_flg -- 转授信标志
    ,o.host_bank_no -- 主办行行号
    ,o.host_bank_name -- 主办行名称
    ,o.patip_loan_bank_no -- 参贷行行号
    ,o.patip_loan_bank_name -- 参贷行名称
    ,o.agent_bank_no -- 代理行行号
    ,o.agent_bank_name -- 代理行名称
    ,o.prtcpt_way_cd -- 参与方式代码
    ,o.margin_ratio -- 保证金比例
    ,o.margin_amt -- 保证金金额
    ,o.intnal_rating_rest_cd -- 内部评级结果代码
    ,o.ext_bond_item_rating_cd -- 外部债项评级代码
    ,o.ext_rating_org_name -- 外部评级机构名称
    ,o.ext_rating_dt -- 外部评级日期
    ,o.invest_underly_descb -- 投资标的描述
    ,o.issue_site_cd -- 发行场所代码
    ,o.cent_mgmt_dept_id -- 归口管理部门编号
    ,o.guar_way_cd -- 担保方式代码
    ,o.level5_cls_cd -- 五级分类代码
    ,o.ext_main_rating_cd -- 外部主体评级代码
    ,o.main_rating_org_name -- 主体评级机构名称
    ,o.main_rating_dt -- 主体评级日期
    ,o.single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,o.single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,o.debt_regroup_cnt -- 债务重组次数
    ,o.manu_flg -- 人工填写标志
    ,o.inovt_bus_flg -- 创新业务标志
    ,o.sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,o.fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团的限额标志
    ,o.comb_class_consmt_flg -- 集合类代销标志
    ,o.anti_mon_lau_sys_rating_cd -- 反洗钱系统评级代码
    ,o.set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,o.mger_name -- 管理人名称
    ,o.mger_cust_id -- 管理人客户编号
    ,o.lon_post_request_attach_comnt -- 贷后要求补充说明
    ,o.group_cust_crdt_prop_remark -- 集群客户授信方案备注
    ,o.bfdistr_pay_impt_esp_restrcond -- 发放与支付前须落实的特殊限制性条件
    ,o.impt_reach_cont_esp_request -- 需落实到合约的特殊要求
    ,o.crdt_prop_remark -- 授信方案备注
    ,o.lon_post_request -- 贷后要求
    ,o.lon_post_mgmt_request -- 贷后管理要求
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
from ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.apv_flow_num = n.apv_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.apv_flow_num = d.apv_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_apv_lmt_attach_info_h;
--alter table ${iml_schema}.agt_loan_apv_lmt_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_apv_lmt_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_apv_lmt_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_apv_lmt_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_apv_lmt_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_apv_lmt_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_apv_lmt_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_apv_lmt_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_apv_lmt_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
