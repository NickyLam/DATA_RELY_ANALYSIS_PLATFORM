/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fkd_pre_loan_appl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fkd_pre_loan_appl_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fkd_pre_loan_appl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fkd_pre_loan_appl_info(
    bus_flow_num varchar2(60) -- 业务流水号
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,open_acct_sucs_flg varchar2(10) -- 开户成功标志
    ,netw_vrfction_status_flg varchar2(10) -- 联网核查状态标志
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,belong_brch_id varchar2(60) -- 所属分行编号
    ,access_chn_id varchar2(60) -- 接入渠道编号
    ,chn_id varchar2(60) -- 渠道编号
    ,crdt_appl_flow_num varchar2(60) -- 信贷申请流水号
    ,main_debit_ps_cert_type_cd varchar2(10) -- 主借人证件类型代码
    ,main_debit_ps_cert_id varchar2(60) -- 主借人证件编号
    ,cust_name varchar2(100) -- 客户姓名
    ,loan_usage_cd varchar2(10) -- 贷款用途代码
    ,mobile_no varchar2(60) -- 手机号码
    ,crdt_amt number(30,8) -- 授信金额
    ,partner_cust_mgr_id varchar2(60) -- 合作方客户经理编号
    ,first_trial_appl_dt date -- 初审申请日期
    ,first_trial_appl_tm varchar2(10) -- 初审申请时间
    ,score_val varchar2(10) -- 评分分值
    ,first_trial_apv_status_cd varchar2(30) -- 初审审批状态代码
    ,crdtc_que_situ_flg varchar2(10) -- 征信查询情况标志
    ,first_trial_advise_sucs_flg varchar2(10) -- 初审通知成功标志
    ,refuse_rs varchar2(1000) -- 拒绝原因
    ,cust_id varchar2(60) -- 客户编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,apv_end_tm timestamp -- 审批结束时间
    ,blip_doc_flg varchar2(10) -- 有影像文件标志
    ,city_name varchar2(250) -- 所在城市名称
    ,prep_repl_opering_loan_bal number(30,8) -- 拟置换经营性贷款余额
    ,tax_bur_auth_flow_num varchar2(100) -- 税局授权流水号
    ,tax_type_cd varchar2(30) -- 涉税类型代码
    ,taxpayer_idtfy_num varchar2(100) -- 纳税人识别号
    ,corp_anl_inco number(30,8) -- 企业年收入
    ,white_list_cust_id varchar2(60) -- 白名单客户编号
    ,white_list_cert_type_cd varchar2(10) -- 白名单客户证件类型代码
    ,white_list_cert_no varchar2(60) -- 白名单客户证件号码
    ,main_biz_cd varchar2(10) -- 主营业务代码
    ,equip_qtty number(30,2) -- 设备数量
    ,corp_equip_asset_total_val number(30,8) -- 企业设备资产总值
    ,corp_fix_asset_loan_bal number(30,8) -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal number(30,8) -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal number(30,8) -- 企业流动资金贷款余额
    ,dir_line_kins_cert_no varchar2(60) -- 直系亲属证件号码
    ,brwer_is_actl_ctrler_flg varchar2(10) -- 借款人是否实控人标志
    ,prod_name varchar2(500) -- 产品名称
    ,recmd_teller_id varchar2(100) -- 推荐柜员编号
    ,hxb_rela_ps_flg varchar2(10) -- 我行关联人标志
    ,main_brwer_amt_over_flg varchar2(10) -- 主借款人触碰征信逾期金额过大标志
    ,have_house_flg varchar2(10) -- 有房标志
    ,estate_tran_price number(30,8) -- 房产交易价格
    ,col_exp_dt date -- 押品到期日期
    ,zd_col_cfm_flow_num varchar2(100) -- 智贷押品确认流水号
    ,hxzd_mode_cd varchar2(30) -- 华兴智贷模式代码
    ,bk_price number(30,2) -- 贝壳网房产评估价值
    ,estate_type_cd varchar2(30) -- 房产类型代码
    ,estate_addr varchar2(500) -- 房产地址
    ,house_area number(30,2) -- 房屋面积
    ,estim_val number(30,2) -- 评估价值
    ,city_cd varchar2(30) -- 城市代码
    ,villa_type varchar2(500) -- 别墅类型
    ,dir_position varchar2(500) -- 户型位置
    ,row_num number(30) -- 联排数
    ,rg_area number(30,8) -- 花园面积
    ,present_area number(30,8) -- 赠送面积
    ,ms_first_trial_lmt number(30,8) -- 庙算初审额度
    ,ms_pass_flg varchar2(10) -- 庙算通过标志
    ,house_local_rg_cd varchar2(30) -- 房屋所在区域代码
    ,have_init_loan_flg varchar2(10) -- 有原贷款标志
    ,init_mtg_bank_name varchar2(500) -- 原抵押银行名称
    ,init_mtg_bank_brch_name varchar2(500) -- 原抵押银行分行名称
    ,init_mtg_bank_house_loan_amt number(30,2) -- 原抵押银行房屋贷款金额
    ,old_houslon_surp_unpaid_pri number(30,2) -- 原银行房贷剩余未还本金
    ,init_loan_surp_tenor number(30,2) -- 原贷款剩余期限
    ,init_loan_circl_flg varchar2(10) -- 原贷款循环标志
    ,obank_estate_mtg_flg varchar2(10) -- 他行在押房产标志
    ,mtg_estate_loan_bal number(30,2) -- 在押房产贷款余额
    ,in_lon_bank varchar2(500) -- 在途贷款银行
    ,bank_org_flg varchar2(10) -- 银行机构标志
    ,acct_name varchar2(500) -- 账户名称
    ,acct_id varchar2(100) -- 账户编号
    ,cust_local_brch_org_id varchar2(100) -- 客户所在分行机构编号
    ,cust_loan_amt number(30,2) -- 客户贷款金额
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,open_acct_bank_name varchar2(500) -- 开户银行名称
    ,cert_begin_dt date -- 证件起始日期
    ,custs_cls_cd varchar2(30) -- 客群分类代码
    ,custs_cls_name varchar2(500) -- 客群分类名称
    ,cust_src_chn varchar2(500) -- 客户来源渠道
    ,ths_tm_appl_loan_pric number(30,2) -- 本次申请贷款本金
    ,lot number(30,2) -- 份额
    ,brwer_share_ratio number(18,6) -- 借款人持股比例
    ,tax_risk_mgmt_flg varchar2(10) -- 跑涉税风控标志
    ,nation varchar2(500) -- 国籍
    ,rpr_addr_site_cd varchar2(30) -- 户籍地址所在地区代码
    ,corp_addr_site_cd varchar2(30) -- 单位地址所在地区代码
    ,work_tel varchar2(60) -- 单位电话
    ,career_type_cd varchar2(30) -- 职业类型代码
    ,dir_line_kins_name varchar2(500) -- 直系亲属姓名
    ,dir_line_kins_phone varchar2(60) -- 直系亲属联系电话
    ,emerg_contact_name varchar2(500) -- 紧急联系人姓名
    ,emerg_contact_tel varchar2(100) -- 紧急联系人电话
    ,soci_secu_conti_mons number(30) -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons number(30) -- 公积金连续缴存月数
    ,at_mon_inco number(30,2) -- 税后月收入
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,have_car_flg varchar2(10) -- 有汽车标志
    ,licen_no varchar2(100) -- 车牌号码
    ,drv_lics_issue_dt date -- 行驶证发证日期
    ,car_single_price_inv number(30,8) -- 汽车裸车价格发票
    ,xcd_loan_tenor number(10) -- 兴车贷贷款期限
    ,tax_flg varchar2(10) -- 涉税标志
    ,tax_apv_status_cd varchar2(30) -- 涉税审批状态代码
    ,que_appl_type_cd varchar2(30) -- 查询申请类型代码
    ,auth_way_cd varchar2(30) -- 授权方式代码
    ,biome_trics varchar2(30) -- 生物识别技术代码
    ,auth_dt date -- 授权日期
    ,auth_start_dt date -- 授权开始日期
    ,auth_end_dt date -- 授权结束日期
    ,risk_cust_flg varchar2(10) -- 风险客户标志
    ,warn_info varchar2(4000) -- 预警信息
    ,face_recn_score_val number(18,8) -- 人脸识别分值
    ,manu_apv_flg varchar2(10) -- 人工审批标志
    ,acrs_rg_mang_flg varchar2(10) -- 跨区域经营标志
    ,cust_crdt_level_cd varchar2(30) -- 客户信用等级代码
    ,brwer_local_ispolicy_cond_flg varchar2(10) -- 借款人满足当地购房政策条件标志
    ,choice_addit_eqty_flg varchar2(10) -- 选择附加权益标志
    ,add_co_brwer_flg varchar2(10) -- 新增共同借款人标志
    ,update_tm timestamp -- 更新时间
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_fkd_pre_loan_appl_info to ${icl_schema};
grant select on ${iml_schema}.agt_fkd_pre_loan_appl_info to ${idl_schema};
grant select on ${iml_schema}.agt_fkd_pre_loan_appl_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fkd_pre_loan_appl_info is '房快贷预审批贷款申请信息';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.prod_id is '产品编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.open_acct_sucs_flg is '开户成功标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.netw_vrfction_status_flg is '联网核查状态标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.belong_brch_id is '所属分行编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.access_chn_id is '接入渠道编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.crdt_appl_flow_num is '信贷申请流水号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.main_debit_ps_cert_type_cd is '主借人证件类型代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.main_debit_ps_cert_id is '主借人证件编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.cust_name is '客户姓名';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.crdt_amt is '授信金额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.partner_cust_mgr_id is '合作方客户经理编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.first_trial_appl_dt is '初审申请日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.first_trial_appl_tm is '初审申请时间';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.score_val is '评分分值';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.first_trial_apv_status_cd is '初审审批状态代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.crdtc_que_situ_flg is '征信查询情况标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.first_trial_advise_sucs_flg is '初审通知成功标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.refuse_rs is '拒绝原因';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.cust_id is '客户编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.apv_end_tm is '审批结束时间';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.blip_doc_flg is '有影像文件标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.city_name is '所在城市名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.prep_repl_opering_loan_bal is '拟置换经营性贷款余额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.tax_bur_auth_flow_num is '税局授权流水号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.tax_type_cd is '涉税类型代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.taxpayer_idtfy_num is '纳税人识别号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.corp_anl_inco is '企业年收入';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.white_list_cust_id is '白名单客户编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.white_list_cert_type_cd is '白名单客户证件类型代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.white_list_cert_no is '白名单客户证件号码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.main_biz_cd is '主营业务代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.equip_qtty is '设备数量';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.corp_equip_asset_total_val is '企业设备资产总值';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.corp_fix_asset_loan_bal is '企业固定资产贷款余额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.corp_equip_fin_rent_loan_bal is '企业设备融资租赁贷款余额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.corp_curt_cap_loan_bal is '企业流动资金贷款余额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.dir_line_kins_cert_no is '直系亲属证件号码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.brwer_is_actl_ctrler_flg is '借款人是否实控人标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.prod_name is '产品名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.recmd_teller_id is '推荐柜员编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.hxb_rela_ps_flg is '我行关联人标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.main_brwer_amt_over_flg is '主借款人触碰征信逾期金额过大标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.have_house_flg is '有房标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.estate_tran_price is '房产交易价格';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.col_exp_dt is '押品到期日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.zd_col_cfm_flow_num is '智贷押品确认流水号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.hxzd_mode_cd is '华兴智贷模式代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.bk_price is '贝壳网房产评估价值';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.estate_type_cd is '房产类型代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.estate_addr is '房产地址';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.house_area is '房屋面积';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.estim_val is '评估价值';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.city_cd is '城市代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.villa_type is '别墅类型';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.dir_position is '户型位置';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.row_num is '联排数';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.rg_area is '花园面积';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.present_area is '赠送面积';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.ms_first_trial_lmt is '庙算初审额度';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.ms_pass_flg is '庙算通过标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.house_local_rg_cd is '房屋所在区域代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.have_init_loan_flg is '有原贷款标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.init_mtg_bank_name is '原抵押银行名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.init_mtg_bank_brch_name is '原抵押银行分行名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.init_mtg_bank_house_loan_amt is '原抵押银行房屋贷款金额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.old_houslon_surp_unpaid_pri is '原银行房贷剩余未还本金';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.init_loan_surp_tenor is '原贷款剩余期限';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.init_loan_circl_flg is '原贷款循环标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.obank_estate_mtg_flg is '他行在押房产标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.mtg_estate_loan_bal is '在押房产贷款余额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.in_lon_bank is '在途贷款银行';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.bank_org_flg is '银行机构标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.acct_name is '账户名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.acct_id is '账户编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.cust_local_brch_org_id is '客户所在分行机构编号';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.cust_loan_amt is '客户贷款金额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.open_acct_bank_name is '开户银行名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.cert_begin_dt is '证件起始日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.custs_cls_cd is '客群分类代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.custs_cls_name is '客群分类名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.cust_src_chn is '客户来源渠道';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.ths_tm_appl_loan_pric is '本次申请贷款本金';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.lot is '份额';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.brwer_share_ratio is '借款人持股比例';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.tax_risk_mgmt_flg is '跑涉税风控标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.nation is '国籍';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.rpr_addr_site_cd is '户籍地址所在地区代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.corp_addr_site_cd is '单位地址所在地区代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.work_tel is '单位电话';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.career_type_cd is '职业类型代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.dir_line_kins_name is '直系亲属姓名';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.dir_line_kins_phone is '直系亲属联系电话';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.emerg_contact_name is '紧急联系人姓名';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.emerg_contact_tel is '紧急联系人电话';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.soci_secu_conti_mons is '社保连续缴存月数';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.provi_fund_conti_deposite_mons is '公积金连续缴存月数';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.at_mon_inco is '税后月收入';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.have_car_flg is '有汽车标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.licen_no is '车牌号码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.drv_lics_issue_dt is '行驶证发证日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.car_single_price_inv is '汽车裸车价格发票';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.xcd_loan_tenor is '兴车贷贷款期限';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.tax_flg is '涉税标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.tax_apv_status_cd is '涉税审批状态代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.que_appl_type_cd is '查询申请类型代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.auth_way_cd is '授权方式代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.biome_trics is '生物识别技术代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.auth_dt is '授权日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.auth_start_dt is '授权开始日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.auth_end_dt is '授权结束日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.risk_cust_flg is '风险客户标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.warn_info is '预警信息';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.face_recn_score_val is '人脸识别分值';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.manu_apv_flg is '人工审批标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.acrs_rg_mang_flg is '跨区域经营标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.cust_crdt_level_cd is '客户信用等级代码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.brwer_local_ispolicy_cond_flg is '借款人满足当地购房政策条件标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.choice_addit_eqty_flg is '选择附加权益标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.add_co_brwer_flg is '新增共同借款人标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.update_tm is '更新时间';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.create_dt is '创建日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.update_dt is '更新日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fkd_pre_loan_appl_info.etl_timestamp is 'ETL处理时间戳';
