/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fkd_pre_loan_appl_info_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_tm purge;
drop table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_fkd_pre_loan_appl_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_fkd_pre_loan_appl_info modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fkd_pre_loan_appl_info partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_tm
compress ${option_switch} for query high
as
select
    bus_flow_num -- 业务流水号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,open_acct_sucs_flg -- 开户成功标志
    ,netw_vrfction_status_flg -- 联网核查状态标志
    ,belong_org_id -- 所属机构编号
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,cust_name -- 客户姓名
    ,loan_usage_cd -- 贷款用途代码
    ,mobile_no -- 手机号码
    ,crdt_amt -- 授信金额
    ,partner_cust_mgr_id -- 合作方客户经理编号
    ,first_trial_appl_dt -- 初审申请日期
    ,first_trial_appl_tm -- 初审申请时间
    ,score_val -- 评分分值
    ,first_trial_apv_status_cd -- 初审审批状态代码
    ,crdtc_que_situ_flg -- 征信查询情况标志
    ,first_trial_advise_sucs_flg -- 初审通知成功标志
    ,refuse_rs -- 拒绝原因
    ,cust_id -- 客户编号
    ,acct_instit_id -- 账务机构编号
    ,mgmt_org_id -- 管理机构编号
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,city_name -- 所在城市名称
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_type_cd -- 涉税类型代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,corp_anl_inco -- 企业年收入
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cert_type_cd -- 白名单客户证件类型代码
    ,white_list_cert_no -- 白名单客户证件号码
    ,main_biz_cd -- 主营业务代码
    ,equip_qtty -- 设备数量
    ,corp_equip_asset_total_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,dir_line_kins_cert_no -- 直系亲属证件号码
    ,brwer_is_actl_ctrler_flg -- 借款人是否实控人标志
    ,prod_name -- 产品名称
    ,recmd_teller_id -- 推荐柜员编号
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,have_house_flg -- 有房标志
    ,estate_tran_price -- 房产交易价格
    ,col_exp_dt -- 押品到期日期
    ,zd_col_cfm_flow_num -- 智贷押品确认流水号
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,bk_price -- 贝壳网房产评估价值
    ,estate_type_cd -- 房产类型代码
    ,estate_addr -- 房产地址
    ,house_area -- 房屋面积
    ,estim_val -- 评估价值
    ,city_cd -- 城市代码
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,ms_first_trial_lmt -- 庙算初审额度
    ,ms_pass_flg -- 庙算通过标志
    ,house_local_rg_cd -- 房屋所在区域代码
    ,have_init_loan_flg -- 有原贷款标志
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_mtg_bank_house_loan_amt -- 原抵押银行房屋贷款金额
    ,old_houslon_surp_unpaid_pri -- 原银行房贷剩余未还本金
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_loan_circl_flg -- 原贷款循环标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,in_lon_bank -- 在途贷款银行
    ,bank_org_flg -- 银行机构标志
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,cust_local_brch_org_id -- 客户所在分行机构编号
    ,cust_loan_amt -- 客户贷款金额
    ,recvbl_acct_name -- 收款账户名称
    ,open_acct_bank_name -- 开户银行名称
    ,cert_begin_dt -- 证件起始日期
    ,custs_cls_cd -- 客群分类代码
    ,custs_cls_name -- 客群分类名称
    ,cust_src_chn -- 客户来源渠道
    ,ths_tm_appl_loan_pric -- 本次申请贷款本金
    ,lot -- 份额
    ,brwer_share_ratio -- 借款人持股比例
    ,tax_risk_mgmt_flg -- 跑涉税风控标志
    ,nation -- 国籍
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,career_type_cd -- 职业类型代码
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,at_mon_inco -- 税后月收入
    ,repay_way_cd -- 还款方式代码
    ,have_car_flg -- 有汽车标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,tax_flg -- 涉税标志
    ,tax_apv_status_cd -- 涉税审批状态代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_dt -- 授权日期
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,risk_cust_flg -- 风险客户标志
    ,warn_info -- 预警信息
    ,face_recn_score_val -- 人脸识别分值
    ,manu_apv_flg -- 人工审批标志
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,brwer_local_ispolicy_cond_flg -- 借款人满足当地购房政策条件标志
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,update_tm -- 更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fkd_pre_loan_appl_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_fkd_pre_loan_appl_info partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_fkd_iqp_loan_prior
insert into ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_tm(
    bus_flow_num -- 业务流水号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,open_acct_sucs_flg -- 开户成功标志
    ,netw_vrfction_status_flg -- 联网核查状态标志
    ,belong_org_id -- 所属机构编号
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,cust_name -- 客户姓名
    ,loan_usage_cd -- 贷款用途代码
    ,mobile_no -- 手机号码
    ,crdt_amt -- 授信金额
    ,partner_cust_mgr_id -- 合作方客户经理编号
    ,first_trial_appl_dt -- 初审申请日期
    ,first_trial_appl_tm -- 初审申请时间
    ,score_val -- 评分分值
    ,first_trial_apv_status_cd -- 初审审批状态代码
    ,crdtc_que_situ_flg -- 征信查询情况标志
    ,first_trial_advise_sucs_flg -- 初审通知成功标志
    ,refuse_rs -- 拒绝原因
    ,cust_id -- 客户编号
    ,acct_instit_id -- 账务机构编号
    ,mgmt_org_id -- 管理机构编号
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,city_name -- 所在城市名称
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_type_cd -- 涉税类型代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,corp_anl_inco -- 企业年收入
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cert_type_cd -- 白名单客户证件类型代码
    ,white_list_cert_no -- 白名单客户证件号码
    ,main_biz_cd -- 主营业务代码
    ,equip_qtty -- 设备数量
    ,corp_equip_asset_total_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,dir_line_kins_cert_no -- 直系亲属证件号码
    ,brwer_is_actl_ctrler_flg -- 借款人是否实控人标志
    ,prod_name -- 产品名称
    ,recmd_teller_id -- 推荐柜员编号
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,have_house_flg -- 有房标志
    ,estate_tran_price -- 房产交易价格
    ,col_exp_dt -- 押品到期日期
    ,zd_col_cfm_flow_num -- 智贷押品确认流水号
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,bk_price -- 贝壳网房产评估价值
    ,estate_type_cd -- 房产类型代码
    ,estate_addr -- 房产地址
    ,house_area -- 房屋面积
    ,estim_val -- 评估价值
    ,city_cd -- 城市代码
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,ms_first_trial_lmt -- 庙算初审额度
    ,ms_pass_flg -- 庙算通过标志
    ,house_local_rg_cd -- 房屋所在区域代码
    ,have_init_loan_flg -- 有原贷款标志
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_mtg_bank_house_loan_amt -- 原抵押银行房屋贷款金额
    ,old_houslon_surp_unpaid_pri -- 原银行房贷剩余未还本金
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_loan_circl_flg -- 原贷款循环标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,in_lon_bank -- 在途贷款银行
    ,bank_org_flg -- 银行机构标志
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,cust_local_brch_org_id -- 客户所在分行机构编号
    ,cust_loan_amt -- 客户贷款金额
    ,recvbl_acct_name -- 收款账户名称
    ,open_acct_bank_name -- 开户银行名称
    ,cert_begin_dt -- 证件起始日期
    ,custs_cls_cd -- 客群分类代码
    ,custs_cls_name -- 客群分类名称
    ,cust_src_chn -- 客户来源渠道
    ,ths_tm_appl_loan_pric -- 本次申请贷款本金
    ,lot -- 份额
    ,brwer_share_ratio -- 借款人持股比例
    ,tax_risk_mgmt_flg -- 跑涉税风控标志
    ,nation -- 国籍
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,career_type_cd -- 职业类型代码
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,at_mon_inco -- 税后月收入
    ,repay_way_cd -- 还款方式代码
    ,have_car_flg -- 有汽车标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,tax_flg -- 涉税标志
    ,tax_apv_status_cd -- 涉税审批状态代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_dt -- 授权日期
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,risk_cust_flg -- 风险客户标志
    ,warn_info -- 预警信息
    ,face_recn_score_val -- 人脸识别分值
    ,manu_apv_flg -- 人工审批标志
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,brwer_local_ispolicy_cond_flg -- 借款人满足当地购房政策条件标志
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,update_tm -- 更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIALNO -- 业务流水号
    ,'9999' -- 法人编号
    ,P1.PRDCODE -- 产品编号
    ,CASE WHEN P1.ISGETCUSCODE='2' THEN '0' ELSE  P1.ISGETCUSCODE END -- 开户成功标志
    ,CASE WHEN  P1.ISCHECKINSPECT=2 THEN '0' ELSE TO_CHAR(P1.ISCHECKINSPECT) END -- 联网核查状态标志
    ,P1.CTRLORG -- 所属机构编号
    ,P1.CTRLBRANCH -- 所属分行编号
    ,P1.APPCHANNEL -- 接入渠道编号
    ,P1.CHANNELNO -- 渠道编号
    ,P1.APPLYNO -- 信贷申请流水号
    ,nvl(trim(P1.CERTTYPE),'0000')  -- 主借人证件类型代码
    ,P1.CERTNO -- 主借人证件编号
    ,P1.CUSTNAME -- 客户姓名
    ,nvl(trim(P1.PURPORS),'000000')  -- 贷款用途代码
    ,P1.PHONE -- 手机号码
    ,P1.CREDITAMT -- 授信金额
    ,P1.COOPNO -- 合作方客户经理编号
    ,P1.INPUTDATE -- 初审申请日期
    ,P1.INPUTTIME -- 初审申请时间
    ,P1.AUTOSCORE -- 评分分值
    ,NVL(TRIM(P1.APPROVESTATUS),'-') -- 初审审批状态代码
    ,CASE WHEN  P1.ISCOLLECTCREDIT='2' THEN '0' ELSE P1.ISCOLLECTCREDIT END -- 征信查询情况标志
    ,CASE WHEN P1.INFORMFLAG='2' THEN '0' ELSE  P1.INFORMFLAG END -- 初审通知成功标志
    ,P1.FAILREASON -- 拒绝原因
    ,P1.CUSID -- 客户编号
    ,P1.FINABRID -- 账务机构编号
    ,P1.INPUTBRID -- 管理机构编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.APPRENDTIME) -- 审批结束时间
    ,CASE WHEN P1.ISEMOJI='2' THEN '0' ELSE  P1.ISEMOJI END -- 有影像文件标志
    ,P1.CITYNAME -- 所在城市名称
    ,P1.DISPLACEOPERATLOANBAL -- 拟置换经营性贷款余额
    ,P1.TAXBUREAUSERNO -- 税局授权流水号
    ,nvl(trim(P1.TAXRELATEDTYPE),'-') -- 涉税类型代码
    ,P1.TAXPAYERIDENTINO -- 纳税人识别号
    ,P1.ENTERPRISEYEARINCOME -- 企业年收入
    ,P1.WHITECUSID -- 白名单客户编号
    ,nvl(trim(P1.WHITECERTTYPE),'0000')  -- 白名单客户证件类型代码
    ,P1.WHITECERTCODE -- 白名单客户证件号码
    ,CASE WHEN TRIM(P1.MAINBUSINESS) IS NULL THEN '-'
     WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.MAINBUSINESS END -- 主营业务代码
    ,NVL(TRIM(P1.DEVICEAMOUNT),0) -- 设备数量
    ,P1.DEVICETOTALPRICE -- 企业设备资产总值
    ,P1.FIXEDFUNDLOANBALANCE -- 企业固定资产贷款余额
    ,P1.DEVICELOANBALANCE -- 企业设备融资租赁贷款余额
    ,P1.WORKINGLOANBALANCE -- 企业流动资金贷款余额
    ,P1.RELATIONCERTCODE -- 直系亲属证件号码
    ,CASE WHEN P1.OWNERFLAG='1' THEN '1' ELSE '0' END -- 借款人是否实控人标志
    ,P1.PRDNAME -- 产品名称
    ,P1.INPUTID -- 推荐柜员编号
    ,decode(trim(P1.ISBANKREL),'','-','Y','1','N','0',P1.ISBANKREL) -- 我行关联人标志
    ,nvl(trim(P1.ISOVERDUEMAIN),'-') -- 主借款人触碰征信逾期金额过大标志
    ,nvl(trim(P1.ISHOUSE),'-') -- 有房标志
    ,P1.HOUSETXNPRICE -- 房产交易价格
    ,P1.GRTDUEDATE -- 押品到期日期
    ,P1.CFMSEQNUM -- 智贷押品确认流水号
    ,nvl(trim(P1.WISDOMLOANMODE),'-') -- 华兴智贷模式代码
    ,P1.BKPRICE -- 贝壳网房产评估价值
    ,nvl(trim(P1.PROPERTYTYPE),'0000000') -- 房产类型代码
    ,P1.DETAILADDR -- 房产地址
    ,P1.ROOMSIZE -- 房屋面积
    ,P1.ROOMPRICE -- 评估价值
    ,nvl(trim(P1.CITYAREACODE),'000000') -- 城市代码
    ,P1.VILLATYPE -- 别墅类型
    ,P1.HOUSETYPELOCATION -- 户型位置
    ,nvl(to_number(regexp_replace(P1.ROWNO,'[^0-9.]','')) ,0) -- 联排数
    ,P1.GARDENAREA -- 花园面积
    ,P1.FREEAREA -- 赠送面积
    ,P1.MSCREDITAMT -- 庙算初审额度
    ,nvl(trim(P1.MSFLAG),'-') -- 庙算通过标志
    ,nvl(trim(P1.AREACODE),'000000') -- 房屋所在区域代码
    ,nvl(trim(P1.ORIGINALLOAN),'-') -- 有原贷款标志
    ,P1.ORGMTGBANK -- 原抵押银行名称
    ,P1.ORGMTGBANKBRANCH -- 原抵押银行分行名称
    ,P1.OBANKLOANAMT -- 原抵押银行房屋贷款金额
    ,P1.OBANKLOANSURNOTBAL -- 原银行房贷剩余未还本金
    ,P1.OLOANSURTERM -- 原贷款剩余期限
    ,nvl(trim(P1.OLOANISCIRCLE),'-') -- 原贷款循环标志
    ,nvl(trim(P1.ISOTHERBANKMTG),'-') -- 他行在押房产标志
    ,P1.ORGHOUSELOANBALANCE -- 在押房产贷款余额
    ,P1.ISONLOANBANK -- 在途贷款银行
    ,nvl(trim(P1.ISBANKORG),'-') -- 银行机构标志
    ,P1.ACCOUNTNAME -- 账户名称
    ,P1.ACCOUNTNUMBER -- 账户编号
    ,P1.ONBRANCHBANK -- 客户所在分行机构编号
    ,P1.LOANAMT -- 客户贷款金额
    ,P1.RECACCT -- 收款账户名称
    ,P1.RECACCTBANKNAME -- 开户银行名称
    ,P1.CERTIDSTARTDATE -- 证件起始日期
    ,nvl(trim(P1.CUSTOMGROUPCODE),'-') -- 客群分类代码
    ,P1.CUTTOMGROUPNAME -- 客群分类名称
    ,P1.SYSID -- 客户来源渠道
    ,P1.PRINCIPALAMT -- 本次申请贷款本金
    ,P1.LOT -- 份额
    ,P1.INVTSTKPERC -- 借款人持股比例
    ,nvl(trim(P1.ISTAXRELA),'-') -- 跑涉税风控标志
    ,P1.NATIONALITY -- 国籍
    ,nvl(trim(P1.RESILOCZONECD),'000000') -- 户籍地址所在地区代码
    ,nvl(trim(P1.UNTLOCZONECD),'000000') -- 单位地址所在地区代码
    ,P1.COMPPHONE -- 单位电话
    ,nvl(trim(P1.INDIVOCC),'-') -- 职业类型代码
    ,P1.RELATIONNAME -- 直系亲属姓名
    ,P1.RELATIONPHONE -- 直系亲属联系电话
    ,P1.URGENTCONTACTNAME -- 紧急联系人姓名
    ,P1.URGENTCONTACTPHONE -- 紧急联系人电话
    ,nvl(to_number(regexp_replace(P1.SOCIALMON,'[^0-9.]','')) ,0) -- 社保连续缴存月数
    ,nvl(to_number(regexp_replace(P1.ACCUMULFUNDMON,'[^0-9.]','')) ,0) -- 公积金连续缴存月数
    ,P1.MONINCOME -- 税后月收入
    ,nvl(trim(P1.REPAYWAY),'-') -- 还款方式代码
    ,nvl(trim(P1.ISHAVECAR),'-') -- 有汽车标志
    ,P1.LICENSENUMBER -- 车牌号码
    ,P1.DRIVINGLICENSEDATE -- 行驶证发证日期
    ,P1.CARINVOICE -- 汽车裸车价格发票
    ,nvl(to_number(regexp_replace(P1.PRELOANTERM,'[^0-9.]','')) ,0) -- 兴车贷贷款期限
    ,nvl(trim(P1.TAXFLG),'-') -- 涉税标志
    ,nvl(trim(P1.TAXAPPROVESTATUS),'-') -- 涉税审批状态代码
    ,nvl(trim(P1.QRYOPERTP),'-') -- 查询申请类型代码
    ,nvl(trim(P1.AUTHOTYPE),'-') -- 授权方式代码
    ,nvl(trim(P1.BIOMETRICS),'-') -- 生物识别技术代码
    ,${iml_schema}.dateformat_max2(P1.AUTHOTIME) -- 授权日期
    ,P1.AUTHOSTRDATE -- 授权开始日期
    ,P1.AUTHOENDDATE -- 授权结束日期
    ,nvl(trim(P1.ISRISKCUST),'-') -- 风险客户标志
    ,P1.WARNINGINFO -- 预警信息
    ,nvl(to_number(regexp_replace(P1.FACEIDENTIFISCORE,'[^0-9.]','')) ,0) -- 人脸识别分值
    ,nvl(trim(P1.MANUALAPPROVAL),'-') -- 人工审批标志
    ,nvl(trim(P1.ISCROSSREGIONRUN),'-') -- 跨区域经营标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUSCREDITSCORELEVEL END -- 客户信用等级代码
    ,nvl(trim(P1.MATCHPURCHHOUSECONDITION),'-') -- 借款人满足当地购房政策条件标志
    ,nvl(trim(P1.ISADDEDVALUE),'-') -- 选择附加权益标志
    ,nvl(trim(P1.ISNEWCOBORROWER),'-') -- 新增共同借款人标志
    ,P1.UPDATEDATE -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_fkd_iqp_loan_prior' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_fkd_iqp_loan_prior p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUSCREDITSCORELEVEL = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_FKD_IQP_LOAN_PRIOR'
        AND R1.SRC_FIELD_EN_NAME= 'CUSCREDITSCORELEVEL'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FKD_PRE_LOAN_APPL_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_CRDT_LEVEL_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.MAINBUSINESS = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ICMS'
        AND R5.SRC_TAB_EN_NAME= 'ICMS_FKD_IQP_LOAN_PRIOR'
        AND R5.SRC_FIELD_EN_NAME= 'MAINBUSINESS'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_FKD_PRE_LOAN_APPL_INFO'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'MAIN_BIZ_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_tm 
  	                                group by 
  	                                        bus_flow_num
  	                                        ,lp_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_ex(
    bus_flow_num -- 业务流水号
    ,lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,open_acct_sucs_flg -- 开户成功标志
    ,netw_vrfction_status_flg -- 联网核查状态标志
    ,belong_org_id -- 所属机构编号
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,cust_name -- 客户姓名
    ,loan_usage_cd -- 贷款用途代码
    ,mobile_no -- 手机号码
    ,crdt_amt -- 授信金额
    ,partner_cust_mgr_id -- 合作方客户经理编号
    ,first_trial_appl_dt -- 初审申请日期
    ,first_trial_appl_tm -- 初审申请时间
    ,score_val -- 评分分值
    ,first_trial_apv_status_cd -- 初审审批状态代码
    ,crdtc_que_situ_flg -- 征信查询情况标志
    ,first_trial_advise_sucs_flg -- 初审通知成功标志
    ,refuse_rs -- 拒绝原因
    ,cust_id -- 客户编号
    ,acct_instit_id -- 账务机构编号
    ,mgmt_org_id -- 管理机构编号
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,city_name -- 所在城市名称
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_type_cd -- 涉税类型代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,corp_anl_inco -- 企业年收入
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cert_type_cd -- 白名单客户证件类型代码
    ,white_list_cert_no -- 白名单客户证件号码
    ,main_biz_cd -- 主营业务代码
    ,equip_qtty -- 设备数量
    ,corp_equip_asset_total_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,dir_line_kins_cert_no -- 直系亲属证件号码
    ,brwer_is_actl_ctrler_flg -- 借款人是否实控人标志
    ,prod_name -- 产品名称
    ,recmd_teller_id -- 推荐柜员编号
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,have_house_flg -- 有房标志
    ,estate_tran_price -- 房产交易价格
    ,col_exp_dt -- 押品到期日期
    ,zd_col_cfm_flow_num -- 智贷押品确认流水号
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,bk_price -- 贝壳网房产评估价值
    ,estate_type_cd -- 房产类型代码
    ,estate_addr -- 房产地址
    ,house_area -- 房屋面积
    ,estim_val -- 评估价值
    ,city_cd -- 城市代码
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,ms_first_trial_lmt -- 庙算初审额度
    ,ms_pass_flg -- 庙算通过标志
    ,house_local_rg_cd -- 房屋所在区域代码
    ,have_init_loan_flg -- 有原贷款标志
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_mtg_bank_house_loan_amt -- 原抵押银行房屋贷款金额
    ,old_houslon_surp_unpaid_pri -- 原银行房贷剩余未还本金
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_loan_circl_flg -- 原贷款循环标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,in_lon_bank -- 在途贷款银行
    ,bank_org_flg -- 银行机构标志
    ,acct_name -- 账户名称
    ,acct_id -- 账户编号
    ,cust_local_brch_org_id -- 客户所在分行机构编号
    ,cust_loan_amt -- 客户贷款金额
    ,recvbl_acct_name -- 收款账户名称
    ,open_acct_bank_name -- 开户银行名称
    ,cert_begin_dt -- 证件起始日期
    ,custs_cls_cd -- 客群分类代码
    ,custs_cls_name -- 客群分类名称
    ,cust_src_chn -- 客户来源渠道
    ,ths_tm_appl_loan_pric -- 本次申请贷款本金
    ,lot -- 份额
    ,brwer_share_ratio -- 借款人持股比例
    ,tax_risk_mgmt_flg -- 跑涉税风控标志
    ,nation -- 国籍
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,career_type_cd -- 职业类型代码
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,at_mon_inco -- 税后月收入
    ,repay_way_cd -- 还款方式代码
    ,have_car_flg -- 有汽车标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,tax_flg -- 涉税标志
    ,tax_apv_status_cd -- 涉税审批状态代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_dt -- 授权日期
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,risk_cust_flg -- 风险客户标志
    ,warn_info -- 预警信息
    ,face_recn_score_val -- 人脸识别分值
    ,manu_apv_flg -- 人工审批标志
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,brwer_local_ispolicy_cond_flg -- 借款人满足当地购房政策条件标志
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,update_tm -- 更新时间
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.open_acct_sucs_flg, o.open_acct_sucs_flg) as open_acct_sucs_flg -- 开户成功标志
    ,nvl(n.netw_vrfction_status_flg, o.netw_vrfction_status_flg) as netw_vrfction_status_flg -- 联网核查状态标志
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.belong_brch_id, o.belong_brch_id) as belong_brch_id -- 所属分行编号
    ,nvl(n.access_chn_id, o.access_chn_id) as access_chn_id -- 接入渠道编号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.crdt_appl_flow_num, o.crdt_appl_flow_num) as crdt_appl_flow_num -- 信贷申请流水号
    ,nvl(n.main_debit_ps_cert_type_cd, o.main_debit_ps_cert_type_cd) as main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,nvl(n.main_debit_ps_cert_id, o.main_debit_ps_cert_id) as main_debit_ps_cert_id -- 主借人证件编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户姓名
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.crdt_amt, o.crdt_amt) as crdt_amt -- 授信金额
    ,nvl(n.partner_cust_mgr_id, o.partner_cust_mgr_id) as partner_cust_mgr_id -- 合作方客户经理编号
    ,nvl(n.first_trial_appl_dt, o.first_trial_appl_dt) as first_trial_appl_dt -- 初审申请日期
    ,nvl(n.first_trial_appl_tm, o.first_trial_appl_tm) as first_trial_appl_tm -- 初审申请时间
    ,nvl(n.score_val, o.score_val) as score_val -- 评分分值
    ,nvl(n.first_trial_apv_status_cd, o.first_trial_apv_status_cd) as first_trial_apv_status_cd -- 初审审批状态代码
    ,nvl(n.crdtc_que_situ_flg, o.crdtc_que_situ_flg) as crdtc_que_situ_flg -- 征信查询情况标志
    ,nvl(n.first_trial_advise_sucs_flg, o.first_trial_advise_sucs_flg) as first_trial_advise_sucs_flg -- 初审通知成功标志
    ,nvl(n.refuse_rs, o.refuse_rs) as refuse_rs -- 拒绝原因
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.apv_end_tm, o.apv_end_tm) as apv_end_tm -- 审批结束时间
    ,nvl(n.blip_doc_flg, o.blip_doc_flg) as blip_doc_flg -- 有影像文件标志
    ,nvl(n.city_name, o.city_name) as city_name -- 所在城市名称
    ,nvl(n.prep_repl_opering_loan_bal, o.prep_repl_opering_loan_bal) as prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,nvl(n.tax_bur_auth_flow_num, o.tax_bur_auth_flow_num) as tax_bur_auth_flow_num -- 税局授权流水号
    ,nvl(n.tax_type_cd, o.tax_type_cd) as tax_type_cd -- 涉税类型代码
    ,nvl(n.taxpayer_idtfy_num, o.taxpayer_idtfy_num) as taxpayer_idtfy_num -- 纳税人识别号
    ,nvl(n.corp_anl_inco, o.corp_anl_inco) as corp_anl_inco -- 企业年收入
    ,nvl(n.white_list_cust_id, o.white_list_cust_id) as white_list_cust_id -- 白名单客户编号
    ,nvl(n.white_list_cert_type_cd, o.white_list_cert_type_cd) as white_list_cert_type_cd -- 白名单客户证件类型代码
    ,nvl(n.white_list_cert_no, o.white_list_cert_no) as white_list_cert_no -- 白名单客户证件号码
    ,nvl(n.main_biz_cd, o.main_biz_cd) as main_biz_cd -- 主营业务代码
    ,nvl(n.equip_qtty, o.equip_qtty) as equip_qtty -- 设备数量
    ,nvl(n.corp_equip_asset_total_val, o.corp_equip_asset_total_val) as corp_equip_asset_total_val -- 企业设备资产总值
    ,nvl(n.corp_fix_asset_loan_bal, o.corp_fix_asset_loan_bal) as corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,nvl(n.corp_equip_fin_rent_loan_bal, o.corp_equip_fin_rent_loan_bal) as corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,nvl(n.corp_curt_cap_loan_bal, o.corp_curt_cap_loan_bal) as corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,nvl(n.dir_line_kins_cert_no, o.dir_line_kins_cert_no) as dir_line_kins_cert_no -- 直系亲属证件号码
    ,nvl(n.brwer_is_actl_ctrler_flg, o.brwer_is_actl_ctrler_flg) as brwer_is_actl_ctrler_flg -- 借款人是否实控人标志
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.recmd_teller_id, o.recmd_teller_id) as recmd_teller_id -- 推荐柜员编号
    ,nvl(n.hxb_rela_ps_flg, o.hxb_rela_ps_flg) as hxb_rela_ps_flg -- 我行关联人标志
    ,nvl(n.main_brwer_amt_over_flg, o.main_brwer_amt_over_flg) as main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,nvl(n.have_house_flg, o.have_house_flg) as have_house_flg -- 有房标志
    ,nvl(n.estate_tran_price, o.estate_tran_price) as estate_tran_price -- 房产交易价格
    ,nvl(n.col_exp_dt, o.col_exp_dt) as col_exp_dt -- 押品到期日期
    ,nvl(n.zd_col_cfm_flow_num, o.zd_col_cfm_flow_num) as zd_col_cfm_flow_num -- 智贷押品确认流水号
    ,nvl(n.hxzd_mode_cd, o.hxzd_mode_cd) as hxzd_mode_cd -- 华兴智贷模式代码
    ,nvl(n.bk_price, o.bk_price) as bk_price -- 贝壳网房产评估价值
    ,nvl(n.estate_type_cd, o.estate_type_cd) as estate_type_cd -- 房产类型代码
    ,nvl(n.estate_addr, o.estate_addr) as estate_addr -- 房产地址
    ,nvl(n.house_area, o.house_area) as house_area -- 房屋面积
    ,nvl(n.estim_val, o.estim_val) as estim_val -- 评估价值
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 城市代码
    ,nvl(n.villa_type, o.villa_type) as villa_type -- 别墅类型
    ,nvl(n.dir_position, o.dir_position) as dir_position -- 户型位置
    ,nvl(n.row_num, o.row_num) as row_num -- 联排数
    ,nvl(n.rg_area, o.rg_area) as rg_area -- 花园面积
    ,nvl(n.present_area, o.present_area) as present_area -- 赠送面积
    ,nvl(n.ms_first_trial_lmt, o.ms_first_trial_lmt) as ms_first_trial_lmt -- 庙算初审额度
    ,nvl(n.ms_pass_flg, o.ms_pass_flg) as ms_pass_flg -- 庙算通过标志
    ,nvl(n.house_local_rg_cd, o.house_local_rg_cd) as house_local_rg_cd -- 房屋所在区域代码
    ,nvl(n.have_init_loan_flg, o.have_init_loan_flg) as have_init_loan_flg -- 有原贷款标志
    ,nvl(n.init_mtg_bank_name, o.init_mtg_bank_name) as init_mtg_bank_name -- 原抵押银行名称
    ,nvl(n.init_mtg_bank_brch_name, o.init_mtg_bank_brch_name) as init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,nvl(n.init_mtg_bank_house_loan_amt, o.init_mtg_bank_house_loan_amt) as init_mtg_bank_house_loan_amt -- 原抵押银行房屋贷款金额
    ,nvl(n.old_houslon_surp_unpaid_pri, o.old_houslon_surp_unpaid_pri) as old_houslon_surp_unpaid_pri -- 原银行房贷剩余未还本金
    ,nvl(n.init_loan_surp_tenor, o.init_loan_surp_tenor) as init_loan_surp_tenor -- 原贷款剩余期限
    ,nvl(n.init_loan_circl_flg, o.init_loan_circl_flg) as init_loan_circl_flg -- 原贷款循环标志
    ,nvl(n.obank_estate_mtg_flg, o.obank_estate_mtg_flg) as obank_estate_mtg_flg -- 他行在押房产标志
    ,nvl(n.mtg_estate_loan_bal, o.mtg_estate_loan_bal) as mtg_estate_loan_bal -- 在押房产贷款余额
    ,nvl(n.in_lon_bank, o.in_lon_bank) as in_lon_bank -- 在途贷款银行
    ,nvl(n.bank_org_flg, o.bank_org_flg) as bank_org_flg -- 银行机构标志
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_local_brch_org_id, o.cust_local_brch_org_id) as cust_local_brch_org_id -- 客户所在分行机构编号
    ,nvl(n.cust_loan_amt, o.cust_loan_amt) as cust_loan_amt -- 客户贷款金额
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.open_acct_bank_name, o.open_acct_bank_name) as open_acct_bank_name -- 开户银行名称
    ,nvl(n.cert_begin_dt, o.cert_begin_dt) as cert_begin_dt -- 证件起始日期
    ,nvl(n.custs_cls_cd, o.custs_cls_cd) as custs_cls_cd -- 客群分类代码
    ,nvl(n.custs_cls_name, o.custs_cls_name) as custs_cls_name -- 客群分类名称
    ,nvl(n.cust_src_chn, o.cust_src_chn) as cust_src_chn -- 客户来源渠道
    ,nvl(n.ths_tm_appl_loan_pric, o.ths_tm_appl_loan_pric) as ths_tm_appl_loan_pric -- 本次申请贷款本金
    ,nvl(n.lot, o.lot) as lot -- 份额
    ,nvl(n.brwer_share_ratio, o.brwer_share_ratio) as brwer_share_ratio -- 借款人持股比例
    ,nvl(n.tax_risk_mgmt_flg, o.tax_risk_mgmt_flg) as tax_risk_mgmt_flg -- 跑涉税风控标志
    ,nvl(n.nation, o.nation) as nation -- 国籍
    ,nvl(n.rpr_addr_site_cd, o.rpr_addr_site_cd) as rpr_addr_site_cd -- 户籍地址所在地区代码
    ,nvl(n.corp_addr_site_cd, o.corp_addr_site_cd) as corp_addr_site_cd -- 单位地址所在地区代码
    ,nvl(n.work_tel, o.work_tel) as work_tel -- 单位电话
    ,nvl(n.career_type_cd, o.career_type_cd) as career_type_cd -- 职业类型代码
    ,nvl(n.dir_line_kins_name, o.dir_line_kins_name) as dir_line_kins_name -- 直系亲属姓名
    ,nvl(n.dir_line_kins_phone, o.dir_line_kins_phone) as dir_line_kins_phone -- 直系亲属联系电话
    ,nvl(n.emerg_contact_name, o.emerg_contact_name) as emerg_contact_name -- 紧急联系人姓名
    ,nvl(n.emerg_contact_tel, o.emerg_contact_tel) as emerg_contact_tel -- 紧急联系人电话
    ,nvl(n.soci_secu_conti_mons, o.soci_secu_conti_mons) as soci_secu_conti_mons -- 社保连续缴存月数
    ,nvl(n.provi_fund_conti_deposite_mons, o.provi_fund_conti_deposite_mons) as provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,nvl(n.at_mon_inco, o.at_mon_inco) as at_mon_inco -- 税后月收入
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.have_car_flg, o.have_car_flg) as have_car_flg -- 有汽车标志
    ,nvl(n.licen_no, o.licen_no) as licen_no -- 车牌号码
    ,nvl(n.drv_lics_issue_dt, o.drv_lics_issue_dt) as drv_lics_issue_dt -- 行驶证发证日期
    ,nvl(n.car_single_price_inv, o.car_single_price_inv) as car_single_price_inv -- 汽车裸车价格发票
    ,nvl(n.xcd_loan_tenor, o.xcd_loan_tenor) as xcd_loan_tenor -- 兴车贷贷款期限
    ,nvl(n.tax_flg, o.tax_flg) as tax_flg -- 涉税标志
    ,nvl(n.tax_apv_status_cd, o.tax_apv_status_cd) as tax_apv_status_cd -- 涉税审批状态代码
    ,nvl(n.que_appl_type_cd, o.que_appl_type_cd) as que_appl_type_cd -- 查询申请类型代码
    ,nvl(n.auth_way_cd, o.auth_way_cd) as auth_way_cd -- 授权方式代码
    ,nvl(n.biome_trics, o.biome_trics) as biome_trics -- 生物识别技术代码
    ,nvl(n.auth_dt, o.auth_dt) as auth_dt -- 授权日期
    ,nvl(n.auth_start_dt, o.auth_start_dt) as auth_start_dt -- 授权开始日期
    ,nvl(n.auth_end_dt, o.auth_end_dt) as auth_end_dt -- 授权结束日期
    ,nvl(n.risk_cust_flg, o.risk_cust_flg) as risk_cust_flg -- 风险客户标志
    ,nvl(n.warn_info, o.warn_info) as warn_info -- 预警信息
    ,nvl(n.face_recn_score_val, o.face_recn_score_val) as face_recn_score_val -- 人脸识别分值
    ,nvl(n.manu_apv_flg, o.manu_apv_flg) as manu_apv_flg -- 人工审批标志
    ,nvl(n.acrs_rg_mang_flg, o.acrs_rg_mang_flg) as acrs_rg_mang_flg -- 跨区域经营标志
    ,nvl(n.cust_crdt_level_cd, o.cust_crdt_level_cd) as cust_crdt_level_cd -- 客户信用等级代码
    ,nvl(n.brwer_local_ispolicy_cond_flg, o.brwer_local_ispolicy_cond_flg) as brwer_local_ispolicy_cond_flg -- 借款人满足当地购房政策条件标志
    ,nvl(n.choice_addit_eqty_flg, o.choice_addit_eqty_flg) as choice_addit_eqty_flg -- 选择附加权益标志
    ,nvl(n.add_co_brwer_flg, o.add_co_brwer_flg) as add_co_brwer_flg -- 新增共同借款人标志
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.bus_flow_num is null
                and o.lp_id is null
            ) or (
                o.prod_id <> n.prod_id
                or o.open_acct_sucs_flg <> n.open_acct_sucs_flg
                or o.netw_vrfction_status_flg <> n.netw_vrfction_status_flg
                or o.belong_org_id <> n.belong_org_id
                or o.belong_brch_id <> n.belong_brch_id
                or o.access_chn_id <> n.access_chn_id
                or o.chn_id <> n.chn_id
                or o.crdt_appl_flow_num <> n.crdt_appl_flow_num
                or o.main_debit_ps_cert_type_cd <> n.main_debit_ps_cert_type_cd
                or o.main_debit_ps_cert_id <> n.main_debit_ps_cert_id
                or o.cust_name <> n.cust_name
                or o.loan_usage_cd <> n.loan_usage_cd
                or o.mobile_no <> n.mobile_no
                or o.crdt_amt <> n.crdt_amt
                or o.partner_cust_mgr_id <> n.partner_cust_mgr_id
                or o.first_trial_appl_dt <> n.first_trial_appl_dt
                or o.first_trial_appl_tm <> n.first_trial_appl_tm
                or o.score_val <> n.score_val
                or o.first_trial_apv_status_cd <> n.first_trial_apv_status_cd
                or o.crdtc_que_situ_flg <> n.crdtc_que_situ_flg
                or o.first_trial_advise_sucs_flg <> n.first_trial_advise_sucs_flg
                or o.refuse_rs <> n.refuse_rs
                or o.cust_id <> n.cust_id
                or o.acct_instit_id <> n.acct_instit_id
                or o.mgmt_org_id <> n.mgmt_org_id
                or o.apv_end_tm <> n.apv_end_tm
                or o.blip_doc_flg <> n.blip_doc_flg
                or o.city_name <> n.city_name
                or o.prep_repl_opering_loan_bal <> n.prep_repl_opering_loan_bal
                or o.tax_bur_auth_flow_num <> n.tax_bur_auth_flow_num
                or o.tax_type_cd <> n.tax_type_cd
                or o.taxpayer_idtfy_num <> n.taxpayer_idtfy_num
                or o.corp_anl_inco <> n.corp_anl_inco
                or o.white_list_cust_id <> n.white_list_cust_id
                or o.white_list_cert_type_cd <> n.white_list_cert_type_cd
                or o.white_list_cert_no <> n.white_list_cert_no
                or o.main_biz_cd <> n.main_biz_cd
                or o.equip_qtty <> n.equip_qtty
                or o.corp_equip_asset_total_val <> n.corp_equip_asset_total_val
                or o.corp_fix_asset_loan_bal <> n.corp_fix_asset_loan_bal
                or o.corp_equip_fin_rent_loan_bal <> n.corp_equip_fin_rent_loan_bal
                or o.corp_curt_cap_loan_bal <> n.corp_curt_cap_loan_bal
                or o.dir_line_kins_cert_no <> n.dir_line_kins_cert_no
                or o.brwer_is_actl_ctrler_flg <> n.brwer_is_actl_ctrler_flg
                or o.prod_name <> n.prod_name
                or o.recmd_teller_id <> n.recmd_teller_id
                or o.hxb_rela_ps_flg <> n.hxb_rela_ps_flg
                or o.main_brwer_amt_over_flg <> n.main_brwer_amt_over_flg
                or o.have_house_flg <> n.have_house_flg
                or o.estate_tran_price <> n.estate_tran_price
                or o.col_exp_dt <> n.col_exp_dt
                or o.zd_col_cfm_flow_num <> n.zd_col_cfm_flow_num
                or o.hxzd_mode_cd <> n.hxzd_mode_cd
                or o.bk_price <> n.bk_price
                or o.estate_type_cd <> n.estate_type_cd
                or o.estate_addr <> n.estate_addr
                or o.house_area <> n.house_area
                or o.estim_val <> n.estim_val
                or o.city_cd <> n.city_cd
                or o.villa_type <> n.villa_type
                or o.dir_position <> n.dir_position
                or o.row_num <> n.row_num
                or o.rg_area <> n.rg_area
                or o.present_area <> n.present_area
                or o.ms_first_trial_lmt <> n.ms_first_trial_lmt
                or o.ms_pass_flg <> n.ms_pass_flg
                or o.house_local_rg_cd <> n.house_local_rg_cd
                or o.have_init_loan_flg <> n.have_init_loan_flg
                or o.init_mtg_bank_name <> n.init_mtg_bank_name
                or o.init_mtg_bank_brch_name <> n.init_mtg_bank_brch_name
                or o.init_mtg_bank_house_loan_amt <> n.init_mtg_bank_house_loan_amt
                or o.old_houslon_surp_unpaid_pri <> n.old_houslon_surp_unpaid_pri
                or o.init_loan_surp_tenor <> n.init_loan_surp_tenor
                or o.init_loan_circl_flg <> n.init_loan_circl_flg
                or o.obank_estate_mtg_flg <> n.obank_estate_mtg_flg
                or o.mtg_estate_loan_bal <> n.mtg_estate_loan_bal
                or o.in_lon_bank <> n.in_lon_bank
                or o.bank_org_flg <> n.bank_org_flg
                or o.acct_name <> n.acct_name
                or o.acct_id <> n.acct_id
                or o.cust_local_brch_org_id <> n.cust_local_brch_org_id
                or o.cust_loan_amt <> n.cust_loan_amt
                or o.recvbl_acct_name <> n.recvbl_acct_name
                or o.open_acct_bank_name <> n.open_acct_bank_name
                or o.cert_begin_dt <> n.cert_begin_dt
                or o.custs_cls_cd <> n.custs_cls_cd
                or o.custs_cls_name <> n.custs_cls_name
                or o.cust_src_chn <> n.cust_src_chn
                or o.ths_tm_appl_loan_pric <> n.ths_tm_appl_loan_pric
                or o.lot <> n.lot
                or o.brwer_share_ratio <> n.brwer_share_ratio
                or o.tax_risk_mgmt_flg <> n.tax_risk_mgmt_flg
                or o.nation <> n.nation
                or o.rpr_addr_site_cd <> n.rpr_addr_site_cd
                or o.corp_addr_site_cd <> n.corp_addr_site_cd
                or o.work_tel <> n.work_tel
                or o.career_type_cd <> n.career_type_cd
                or o.dir_line_kins_name <> n.dir_line_kins_name
                or o.dir_line_kins_phone <> n.dir_line_kins_phone
                or o.emerg_contact_name <> n.emerg_contact_name
                or o.emerg_contact_tel <> n.emerg_contact_tel
                or o.soci_secu_conti_mons <> n.soci_secu_conti_mons
                or o.provi_fund_conti_deposite_mons <> n.provi_fund_conti_deposite_mons
                or o.at_mon_inco <> n.at_mon_inco
                or o.repay_way_cd <> n.repay_way_cd
                or o.have_car_flg <> n.have_car_flg
                or o.licen_no <> n.licen_no
                or o.drv_lics_issue_dt <> n.drv_lics_issue_dt
                or o.car_single_price_inv <> n.car_single_price_inv
                or o.xcd_loan_tenor <> n.xcd_loan_tenor
                or o.tax_flg <> n.tax_flg
                or o.tax_apv_status_cd <> n.tax_apv_status_cd
                or o.que_appl_type_cd <> n.que_appl_type_cd
                or o.auth_way_cd <> n.auth_way_cd
                or o.biome_trics <> n.biome_trics
                or o.auth_dt <> n.auth_dt
                or o.auth_start_dt <> n.auth_start_dt
                or o.auth_end_dt <> n.auth_end_dt
                or o.risk_cust_flg <> n.risk_cust_flg
                or o.warn_info <> n.warn_info
                or o.face_recn_score_val <> n.face_recn_score_val
                or o.manu_apv_flg <> n.manu_apv_flg
                or o.acrs_rg_mang_flg <> n.acrs_rg_mang_flg
                or o.cust_crdt_level_cd <> n.cust_crdt_level_cd
                or o.brwer_local_ispolicy_cond_flg <> n.brwer_local_ispolicy_cond_flg
                or o.choice_addit_eqty_flg <> n.choice_addit_eqty_flg
                or o.add_co_brwer_flg <> n.add_co_brwer_flg
                or o.update_tm <> n.update_tm
            ) or (
                 case when (
                           n.bus_flow_num is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.bus_flow_num is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_tm n
    full join ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_bk o
        on
            o.bus_flow_num = n.bus_flow_num
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_fkd_pre_loan_appl_info truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_fkd_pre_loan_appl_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_fkd_pre_loan_appl_info drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fkd_pre_loan_appl_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_tm purge;
drop table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_ex purge;
drop table ${iml_schema}.agt_fkd_pre_loan_appl_info_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fkd_pre_loan_appl_info', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);