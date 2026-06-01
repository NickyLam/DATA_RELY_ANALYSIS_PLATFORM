/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rcrs_cus_indiv
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.rcrs_cus_indiv drop partition p_${last_date};
alter table ${idl_schema}.rcrs_cus_indiv drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rcrs_cus_indiv add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rcrs_cus_indiv (
    etl_dt  -- 数据日期
    ,inner_cus_id  -- 内部客户号
    ,cus_id  -- 客户代码
    ,mng_br_id  -- 所属法人机构
    ,cus_type  -- 客户类型
    ,cus_name  -- 客户姓名
    ,indiv_sex  -- 性别
    ,cert_type  -- 证件类型
    ,cert_code  -- 证件号码
    ,indiv_id_exp_dt  -- 证件到期日
    ,agri_flg  -- 是否农户
    ,cus_bank_rel  -- 与我行关联关系
    ,com_hold_stk_amt  -- 拥有我行股份金额
    ,bank_duty  -- 在我行职务
    ,indiv_ntn  -- 民族
    ,indiv_brt_place  -- 籍贯
    ,indiv_houh_reg_add  -- 户籍地址
    ,indiv_dt_of_birth  -- 出生年月日
    ,indiv_pol_st  -- 政治面貌
    ,indiv_edt  -- 教育程度
    ,indiv_dgr  -- 最高学位
    ,indiv_mar_st  -- 婚姻状况
    ,indiv_heal_st  -- 健康状况
    ,post_addr  -- 通讯地址
    ,post_code  -- 邮政编码
    ,area_code  -- 区域编码
    ,area_name  -- 区域名称
    ,phone  -- 联系电话
    ,fphone  -- 家庭电话
    ,mobile  -- 手机
    ,fax_code  -- 传真
    ,email  -- emal地址
    ,indiv_rsd_addr  -- 居住地址
    ,indiv_zip_code  -- 居住地邮政编码
    ,indiv_rsd_st  -- 居住状况
    ,indiv_soc_scr  -- 社会保障情况
    ,indiv_hobby  -- 爱好
    ,indiv_occ  -- 从事职业
    ,indiv_com_name  -- 工作单位
    ,indiv_com_typ  -- 单位性质
    ,indiv_com_fld  -- 单位所属行业
    ,indiv_com_phn  -- 单位电话
    ,indiv_com_fax  -- 单位传真
    ,indiv_com_addr  -- 单位地址
    ,indiv_com_zip_code  -- 单位邮政编码
    ,indiv_com_cnt_name  -- 单位联系人
    ,indiv_work_job_y  -- 单位工作起始年限
    ,indiv_com_job_ttl  -- 职务
    ,indiv_crtfctn  -- 职称
    ,indiv_ann_incm  -- 年收入情况
    ,indiv_sal_acc_bank  -- 工资账户开户行
    ,indiv_sal_acc_no  -- 工资账号
    ,indiv_sps_name  -- 配偶姓名
    ,indiv_sps_id_typ  -- 配偶证件类型
    ,indiv_sps_id_code  -- 配偶证件号码
    ,indiv_scom_name  -- 配偶工作单位
    ,indiv_sps_occ  -- 配偶职业
    ,indiv_sps_duty  -- 配偶职务
    ,indiv_sps_mincm  -- 配偶月收入
    ,indiv_sps_phn  -- 配偶单位联系电话
    ,indiv_sps_mphn  -- 配偶手机号码
    ,indiv_sps_job_dt  -- 配偶参加工作时间
    ,com_rel_dgr  -- 与我行合作关系
    ,com_init_loan_date  -- 建立信贷关系时间
    ,indiv_hld_acnt  -- 在我行开立账户情况
    ,hold_card  -- 持卡情况
    ,passport_flg  -- 是否拥有外国护照或居住权
    ,crd_grade  -- 信用等级
    ,crd_date  -- 信用评定日期
    ,remark  -- 备注
    ,cust_mgr  -- 客户经理
    ,main_br_id  -- 主管机构
    ,input_id  -- 登记人
    ,input_br_id  -- 登记机构
    ,input_date  -- 登记日期
    ,last_upd_id  -- 更新人
    ,last_upd_date  -- 更新日期
    ,cus_status  -- 状态
    ,indiv_com_fld_name  -- 单位所属行业名称
    ,crd_end_dt  -- 信用等级到期日期
    ,indiv_psp_crtfctn  -- 配偶职称
    ,indiv_sps_mar_code  -- 结婚证号码
    ,cus_id_rel  -- 配偶关联客户码
    ,work_resume  -- 个人简历
    ,accredit_status  -- 授权状态
    ,former_name  -- 曾用名
    ,lay_off_flag  -- 是否有工作单位
    ,lay_off_code  -- 下岗证号
    ,loan_card_flg  -- 有无贷款卡
    ,loan_card_id  -- 贷款卡编号
    ,loan_card_pwd  -- 贷款卡密码
    ,loan_card_eff_flg  -- 贷款卡有效标识
    ,loan_card_audit_dt  -- 贷款卡年审到期日
    ,businesses_flag  -- 客户性质
    ,vocation_type  -- 从业类型
    ,family_population  -- 供养人口（人）
    ,family_labor_population  -- 家庭劳动力数量
    ,reg_state_code  -- 
    ,card_org_name  -- 发证机关名称
    ,sps_remark  -- 配偶备注
    ,if_micro_business_owner  -- 是否小微企业主
    ,if_industrial_areas  -- 注册地是否工业园区
    ,issue_info  -- 贵宾客户等级
    ,card_id  -- 卡号
    ,indiv_month_income  -- 个人月收入(元)
    ,yes_no_contract  -- 是否农村承包经营户
    ,yes_no_vip_cus  -- 是否贵宾客户
    ,yes_no_annexamine  -- 是否年审通过
    ,indiv_province  -- 户籍所在省份（直辖市、自治区）
    ,indiv_city  -- 户籍所在城市
    ,core_cus_id  -- 核心客户号
    ,whetherbankblacklist  -- 是否本行黑名客户
    ,indiv_id_st_dt  -- 证件起始日
    ,nationality  -- 国籍
    ,houh_reg_property  -- 户籍性质
    ,local_reg_time  -- 本地居住时间
    ,has_children  -- 其中子女（人）
    ,children_situation  -- 子女情况
    ,family_month_income  -- 家庭月收入
    ,has_car  -- 自有汽车情况
    ,car_cost  -- 汽车价值
    ,has_other_code  -- 是否有第三方注册账号
    ,other_code  -- 第三方账号
    ,working_condition  -- 现工作状态
    ,work_unit_size  -- 工作单位规模
    ,working_life  -- 从业年限
    ,working_stablity  -- 工作稳定性
    ,urgency_name  -- 紧急联系人姓名
    ,relation  -- 与申请人关系
    ,urgency_tel  -- 联系电话
    ,urgency_address  -- 联系地址
    ,urgency_zip_code  -- 联系邮编
    ,cosurety_cont_no  -- 联保申请编号
    ,other_code_type  -- 第三方注册账号类型
    ,authentica_type  -- 安全等级认证方式
    ,house_cost  -- 房产价值
    ,identity_card  -- 身份证号码
    ,is_rcrs_cus  -- 是否零售信贷新开客户
    ,indiv_soc_years  -- 社保缴纳时长（年）
    ,relative_name1  -- 亲属联系人1姓名
    ,relative_type1  -- 与亲属联系人1关系
    ,relative_phone1  -- 亲属联系人1手机号码
    ,relative_name2  -- 亲属联系人2姓名
    ,relative_type2  -- 与亲属联系人2关系
    ,relative_phone2  -- 亲属联系人2手机号码
    ,relative_name3  -- 非亲属联系人3姓名
    ,relative_type3  -- 与非亲属联系人3关系
    ,relative_phone3  -- 非亲属联系人3手机号码
    ,relative_name4  -- 非亲属联系人4姓名
    ,relative_type4  -- 与非亲属联系人4关系
    ,relative_phone4  -- 非亲属联系人4手机号码
    ,relative_fphone1  -- 亲属联系人1家庭电话
    ,relative_fphone2  -- 亲属联系人2家庭电话
    ,relative_fphone3  -- 亲属联系人3家庭电话
    ,relative_fphone4  -- 亲属联系人4家庭电话
    ,email2  -- 电子邮箱2
    ,qq  -- QQ号码
    ,wechat  -- 微信号码
    ,tenpay  -- 财付通账号
    ,sinablog  -- 新浪微博
    ,taobao_account  -- 淘宝账号
    ,alipay  -- 支付宝账号
    ,jingdong_account  -- 京东账号
    ,is_cl  -- 
    ,indiv_com_no  -- 工作信息序号
    ,indiv_addr_no  -- 居住地址序号
    ,is_relative  -- 是否行内关联交易
    ,rel_no  -- 关系人编号（同步ECIF客户信息时使用）
    ,work_no  -- 工作单位编号（同步ECIF客户信息时使用）
    ,addr_no  -- 联系地址编号（同步ECIF客户信息时使用）
    ,family_addr_no  -- 家庭地址编号（同步ECIF客户信息时使用）
    ,businesses_flag_1  -- 客户性质副本
    ,is_limit_apply  -- 是否授信暂禁 1-是 2-否
    ,pass_type  -- 港澳台通行证类型
    ,pass_code  -- 港澳台通行证号码
    ,register_type  -- 
    ,start_dt  -- 开始时间
    ,end_dt  -- 结束时间
    ,id_mark  -- 增删标志
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(p1.inner_cus_id,chr(13),''),chr(10),'')  -- 内部客户号
    ,replace(replace(p1.cus_id,chr(13),''),chr(10),'')  -- 客户代码
    ,replace(replace(p1.mng_br_id,chr(13),''),chr(10),'')  -- 所属法人机构
    ,replace(replace(p1.cus_type,chr(13),''),chr(10),'')  -- 客户类型
    ,replace(replace(p1.cus_name,chr(13),''),chr(10),'')  -- 客户姓名
    ,replace(replace(p1.indiv_sex,chr(13),''),chr(10),'')  -- 性别
    ,replace(replace(p1.cert_type,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(p1.cert_code,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(p1.indiv_id_exp_dt,chr(13),''),chr(10),'')  -- 证件到期日
    ,replace(replace(p1.agri_flg,chr(13),''),chr(10),'')  -- 是否农户
    ,replace(replace(p1.cus_bank_rel,chr(13),''),chr(10),'')  -- 与我行关联关系
    ,p1.com_hold_stk_amt  -- 拥有我行股份金额
    ,replace(replace(p1.bank_duty,chr(13),''),chr(10),'')  -- 在我行职务
    ,replace(replace(p1.indiv_ntn,chr(13),''),chr(10),'')  -- 民族
    ,replace(replace(p1.indiv_brt_place,chr(13),''),chr(10),'')  -- 籍贯
    ,replace(replace(p1.indiv_houh_reg_add,chr(13),''),chr(10),'')  -- 户籍地址
    ,replace(replace(p1.indiv_dt_of_birth,chr(13),''),chr(10),'')  -- 出生年月日
    ,replace(replace(p1.indiv_pol_st,chr(13),''),chr(10),'')  -- 政治面貌
    ,replace(replace(p1.indiv_edt,chr(13),''),chr(10),'')  -- 教育程度
    ,replace(replace(p1.indiv_dgr,chr(13),''),chr(10),'')  -- 最高学位
    ,replace(replace(p1.indiv_mar_st,chr(13),''),chr(10),'')  -- 婚姻状况
    ,replace(replace(p1.indiv_heal_st,chr(13),''),chr(10),'')  -- 健康状况
    ,replace(replace(p1.post_addr,chr(13),''),chr(10),'')  -- 通讯地址
    ,replace(replace(p1.post_code,chr(13),''),chr(10),'')  -- 邮政编码
    ,replace(replace(p1.area_code,chr(13),''),chr(10),'')  -- 区域编码
    ,replace(replace(p1.area_name,chr(13),''),chr(10),'')  -- 区域名称
    ,replace(replace(p1.phone,chr(13),''),chr(10),'')  -- 联系电话
    ,replace(replace(p1.fphone,chr(13),''),chr(10),'')  -- 家庭电话
    ,replace(replace(p1.mobile,chr(13),''),chr(10),'')  -- 手机
    ,replace(replace(p1.fax_code,chr(13),''),chr(10),'')  -- 传真
    ,replace(replace(p1.email,chr(13),''),chr(10),'')  -- emal地址
    ,replace(replace(p1.indiv_rsd_addr,chr(13),''),chr(10),'')  -- 居住地址
    ,replace(replace(p1.indiv_zip_code,chr(13),''),chr(10),'')  -- 居住地邮政编码
    ,replace(replace(p1.indiv_rsd_st,chr(13),''),chr(10),'')  -- 居住状况
    ,replace(replace(p1.indiv_soc_scr,chr(13),''),chr(10),'')  -- 社会保障情况
    ,replace(replace(p1.indiv_hobby,chr(13),''),chr(10),'')  -- 爱好
    ,replace(replace(p1.indiv_occ,chr(13),''),chr(10),'')  -- 从事职业
    ,replace(replace(p1.indiv_com_name,chr(13),''),chr(10),'')  -- 工作单位
    ,replace(replace(p1.indiv_com_typ,chr(13),''),chr(10),'')  -- 单位性质
    ,replace(replace(p1.indiv_com_fld,chr(13),''),chr(10),'')  -- 单位所属行业
    ,replace(replace(p1.indiv_com_phn,chr(13),''),chr(10),'')  -- 单位电话
    ,replace(replace(p1.indiv_com_fax,chr(13),''),chr(10),'')  -- 单位传真
    ,replace(replace(p1.indiv_com_addr,chr(13),''),chr(10),'')  -- 单位地址
    ,replace(replace(p1.indiv_com_zip_code,chr(13),''),chr(10),'')  -- 单位邮政编码
    ,replace(replace(p1.indiv_com_cnt_name,chr(13),''),chr(10),'')  -- 单位联系人
    ,replace(replace(p1.indiv_work_job_y,chr(13),''),chr(10),'')  -- 单位工作起始年限
    ,replace(replace(p1.indiv_com_job_ttl,chr(13),''),chr(10),'')  -- 职务
    ,replace(replace(p1.indiv_crtfctn,chr(13),''),chr(10),'')  -- 职称
    ,p1.indiv_ann_incm  -- 年收入情况
    ,replace(replace(p1.indiv_sal_acc_bank,chr(13),''),chr(10),'')  -- 工资账户开户行
    ,replace(replace(p1.indiv_sal_acc_no,chr(13),''),chr(10),'')  -- 工资账号
    ,replace(replace(p1.indiv_sps_name,chr(13),''),chr(10),'')  -- 配偶姓名
    ,replace(replace(p1.indiv_sps_id_typ,chr(13),''),chr(10),'')  -- 配偶证件类型
    ,replace(replace(p1.indiv_sps_id_code,chr(13),''),chr(10),'')  -- 配偶证件号码
    ,replace(replace(p1.indiv_scom_name,chr(13),''),chr(10),'')  -- 配偶工作单位
    ,replace(replace(p1.indiv_sps_occ,chr(13),''),chr(10),'')  -- 配偶职业
    ,replace(replace(p1.indiv_sps_duty,chr(13),''),chr(10),'')  -- 配偶职务
    ,p1.indiv_sps_mincm  -- 配偶月收入
    ,replace(replace(p1.indiv_sps_phn,chr(13),''),chr(10),'')  -- 配偶单位联系电话
    ,replace(replace(p1.indiv_sps_mphn,chr(13),''),chr(10),'')  -- 配偶手机号码
    ,replace(replace(p1.indiv_sps_job_dt,chr(13),''),chr(10),'')  -- 配偶参加工作时间
    ,replace(replace(p1.com_rel_dgr,chr(13),''),chr(10),'')  -- 与我行合作关系
    ,replace(replace(p1.com_init_loan_date,chr(13),''),chr(10),'')  -- 建立信贷关系时间
    ,replace(replace(p1.indiv_hld_acnt,chr(13),''),chr(10),'')  -- 在我行开立账户情况
    ,replace(replace(p1.hold_card,chr(13),''),chr(10),'')  -- 持卡情况
    ,replace(replace(p1.passport_flg,chr(13),''),chr(10),'')  -- 是否拥有外国护照或居住权
    ,replace(replace(p1.crd_grade,chr(13),''),chr(10),'')  -- 信用等级
    ,replace(replace(p1.crd_date,chr(13),''),chr(10),'')  -- 信用评定日期
    ,replace(replace(p1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(p1.cust_mgr,chr(13),''),chr(10),'')  -- 客户经理
    ,replace(replace(p1.main_br_id,chr(13),''),chr(10),'')  -- 主管机构
    ,replace(replace(p1.input_id,chr(13),''),chr(10),'')  -- 登记人
    ,replace(replace(p1.input_br_id,chr(13),''),chr(10),'')  -- 登记机构
    ,replace(replace(p1.input_date,chr(13),''),chr(10),'')  -- 登记日期
    ,replace(replace(p1.last_upd_id,chr(13),''),chr(10),'')  -- 更新人
    ,replace(replace(p1.last_upd_date,chr(13),''),chr(10),'')  -- 更新日期
    ,replace(replace(p1.cus_status,chr(13),''),chr(10),'')  -- 状态
    ,replace(replace(p1.indiv_com_fld_name,chr(13),''),chr(10),'')  -- 单位所属行业名称
    ,replace(replace(p1.crd_end_dt,chr(13),''),chr(10),'')  -- 信用等级到期日期
    ,replace(replace(p1.indiv_psp_crtfctn,chr(13),''),chr(10),'')  -- 配偶职称
    ,replace(replace(p1.indiv_sps_mar_code,chr(13),''),chr(10),'')  -- 结婚证号码
    ,replace(replace(p1.cus_id_rel,chr(13),''),chr(10),'')  -- 配偶关联客户码
    ,replace(replace(p1.work_resume,chr(13),''),chr(10),'')  -- 个人简历
    ,replace(replace(p1.accredit_status,chr(13),''),chr(10),'')  -- 授权状态
    ,replace(replace(p1.former_name,chr(13),''),chr(10),'')  -- 曾用名
    ,replace(replace(p1.lay_off_flag,chr(13),''),chr(10),'')  -- 是否有工作单位
    ,replace(replace(p1.lay_off_code,chr(13),''),chr(10),'')  -- 下岗证号
    ,replace(replace(p1.loan_card_flg,chr(13),''),chr(10),'')  -- 有无贷款卡
    ,replace(replace(p1.loan_card_id,chr(13),''),chr(10),'')  -- 贷款卡编号
    ,replace(replace(p1.loan_card_pwd,chr(13),''),chr(10),'')  -- 贷款卡密码
    ,replace(replace(p1.loan_card_eff_flg,chr(13),''),chr(10),'')  -- 贷款卡有效标识
    ,replace(replace(p1.loan_card_audit_dt,chr(13),''),chr(10),'')  -- 贷款卡年审到期日
    ,replace(replace(p1.businesses_flag,chr(13),''),chr(10),'')  -- 客户性质
    ,replace(replace(p1.vocation_type,chr(13),''),chr(10),'')  -- 从业类型
    ,p1.family_population  -- 供养人口（人）
    ,p1.family_labor_population  -- 家庭劳动力数量
    ,replace(replace(p1.reg_state_code,chr(13),''),chr(10),'')  -- 
    ,replace(replace(p1.card_org_name,chr(13),''),chr(10),'')  -- 发证机关名称
    ,replace(replace(p1.sps_remark,chr(13),''),chr(10),'')  -- 配偶备注
    ,replace(replace(p1.if_micro_business_owner,chr(13),''),chr(10),'')  -- 是否小微企业主
    ,replace(replace(p1.if_industrial_areas,chr(13),''),chr(10),'')  -- 注册地是否工业园区
    ,replace(replace(p1.issue_info,chr(13),''),chr(10),'')  -- 贵宾客户等级
    ,replace(replace(p1.card_id,chr(13),''),chr(10),'')  -- 卡号
    ,p1.indiv_month_income  -- 个人月收入(元)
    ,replace(replace(p1.yes_no_contract,chr(13),''),chr(10),'')  -- 是否农村承包经营户
    ,replace(replace(p1.yes_no_vip_cus,chr(13),''),chr(10),'')  -- 是否贵宾客户
    ,replace(replace(p1.yes_no_annexamine,chr(13),''),chr(10),'')  -- 是否年审通过
    ,replace(replace(p1.indiv_province,chr(13),''),chr(10),'')  -- 户籍所在省份（直辖市、自治区）
    ,replace(replace(p1.indiv_city,chr(13),''),chr(10),'')  -- 户籍所在城市
    ,replace(replace(p1.core_cus_id,chr(13),''),chr(10),'')  -- 核心客户号
    ,replace(replace(p1.whetherbankblacklist,chr(13),''),chr(10),'')  -- 是否本行黑名客户
    ,replace(replace(p1.indiv_id_st_dt,chr(13),''),chr(10),'')  -- 证件起始日
    ,replace(replace(p1.nationality,chr(13),''),chr(10),'')  -- 国籍
    ,replace(replace(p1.houh_reg_property,chr(13),''),chr(10),'')  -- 户籍性质
    ,replace(replace(p1.local_reg_time,chr(13),''),chr(10),'')  -- 本地居住时间
    ,p1.has_children  -- 其中子女（人）
    ,replace(replace(p1.children_situation,chr(13),''),chr(10),'')  -- 子女情况
    ,p1.family_month_income  -- 家庭月收入
    ,replace(replace(p1.has_car,chr(13),''),chr(10),'')  -- 自有汽车情况
    ,p1.car_cost  -- 汽车价值
    ,replace(replace(p1.has_other_code,chr(13),''),chr(10),'')  -- 是否有第三方注册账号
    ,replace(replace(p1.other_code,chr(13),''),chr(10),'')  -- 第三方账号
    ,replace(replace(p1.working_condition,chr(13),''),chr(10),'')  -- 现工作状态
    ,replace(replace(p1.work_unit_size,chr(13),''),chr(10),'')  -- 工作单位规模
    ,replace(replace(p1.working_life,chr(13),''),chr(10),'')  -- 从业年限
    ,replace(replace(p1.working_stablity,chr(13),''),chr(10),'')  -- 工作稳定性
    ,replace(replace(p1.urgency_name,chr(13),''),chr(10),'')  -- 紧急联系人姓名
    ,replace(replace(p1.relation,chr(13),''),chr(10),'')  -- 与申请人关系
    ,replace(replace(p1.urgency_tel,chr(13),''),chr(10),'')  -- 联系电话
    ,replace(replace(p1.urgency_address,chr(13),''),chr(10),'')  -- 联系地址
    ,replace(replace(p1.urgency_zip_code,chr(13),''),chr(10),'')  -- 联系邮编
    ,replace(replace(p1.cosurety_cont_no,chr(13),''),chr(10),'')  -- 联保申请编号
    ,replace(replace(p1.other_code_type,chr(13),''),chr(10),'')  -- 第三方注册账号类型
    ,replace(replace(p1.authentica_type,chr(13),''),chr(10),'')  -- 安全等级认证方式
    ,p1.house_cost  -- 房产价值
    ,replace(replace(p1.identity_card,chr(13),''),chr(10),'')  -- 身份证号码
    ,replace(replace(p1.is_rcrs_cus,chr(13),''),chr(10),'')  -- 是否零售信贷新开客户
    ,replace(replace(p1.indiv_soc_years,chr(13),''),chr(10),'')  -- 社保缴纳时长（年）
    ,replace(replace(p1.relative_name1,chr(13),''),chr(10),'')  -- 亲属联系人1姓名
    ,replace(replace(p1.relative_type1,chr(13),''),chr(10),'')  -- 与亲属联系人1关系
    ,replace(replace(p1.relative_phone1,chr(13),''),chr(10),'')  -- 亲属联系人1手机号码
    ,replace(replace(p1.relative_name2,chr(13),''),chr(10),'')  -- 亲属联系人2姓名
    ,replace(replace(p1.relative_type2,chr(13),''),chr(10),'')  -- 与亲属联系人2关系
    ,replace(replace(p1.relative_phone2,chr(13),''),chr(10),'')  -- 亲属联系人2手机号码
    ,replace(replace(p1.relative_name3,chr(13),''),chr(10),'')  -- 非亲属联系人3姓名
    ,replace(replace(p1.relative_type3,chr(13),''),chr(10),'')  -- 与非亲属联系人3关系
    ,replace(replace(p1.relative_phone3,chr(13),''),chr(10),'')  -- 非亲属联系人3手机号码
    ,replace(replace(p1.relative_name4,chr(13),''),chr(10),'')  -- 非亲属联系人4姓名
    ,replace(replace(p1.relative_type4,chr(13),''),chr(10),'')  -- 与非亲属联系人4关系
    ,replace(replace(p1.relative_phone4,chr(13),''),chr(10),'')  -- 非亲属联系人4手机号码
    ,replace(replace(p1.relative_fphone1,chr(13),''),chr(10),'')  -- 亲属联系人1家庭电话
    ,replace(replace(p1.relative_fphone2,chr(13),''),chr(10),'')  -- 亲属联系人2家庭电话
    ,replace(replace(p1.relative_fphone3,chr(13),''),chr(10),'')  -- 亲属联系人3家庭电话
    ,replace(replace(p1.relative_fphone4,chr(13),''),chr(10),'')  -- 亲属联系人4家庭电话
    ,replace(replace(p1.email2,chr(13),''),chr(10),'')  -- 电子邮箱2
    ,replace(replace(p1.qq,chr(13),''),chr(10),'')  -- QQ号码
    ,replace(replace(p1.wechat,chr(13),''),chr(10),'')  -- 微信号码
    ,replace(replace(p1.tenpay,chr(13),''),chr(10),'')  -- 财付通账号
    ,replace(replace(p1.sinablog,chr(13),''),chr(10),'')  -- 新浪微博
    ,replace(replace(p1.taobao_account,chr(13),''),chr(10),'')  -- 淘宝账号
    ,replace(replace(p1.alipay,chr(13),''),chr(10),'')  -- 支付宝账号
    ,replace(replace(p1.jingdong_account,chr(13),''),chr(10),'')  -- 京东账号
    ,replace(replace(p1.is_cl,chr(13),''),chr(10),'')  -- 
    ,replace(replace(p1.indiv_com_no,chr(13),''),chr(10),'')  -- 工作信息序号
    ,replace(replace(p1.indiv_addr_no,chr(13),''),chr(10),'')  -- 居住地址序号
    ,replace(replace(p1.is_relative,chr(13),''),chr(10),'')  -- 是否行内关联交易
    ,replace(replace(p1.rel_no,chr(13),''),chr(10),'')  -- 关系人编号（同步ECIF客户信息时使用）
    ,replace(replace(p1.work_no,chr(13),''),chr(10),'')  -- 工作单位编号（同步ECIF客户信息时使用）
    ,replace(replace(p1.addr_no,chr(13),''),chr(10),'')  -- 联系地址编号（同步ECIF客户信息时使用）
    ,replace(replace(p1.family_addr_no,chr(13),''),chr(10),'')  -- 家庭地址编号（同步ECIF客户信息时使用）
    ,replace(replace(p1.businesses_flag_1,chr(13),''),chr(10),'')  -- 客户性质副本
    ,replace(replace(p1.is_limit_apply,chr(13),''),chr(10),'')  -- 是否授信暂禁 1-是 2-否
    ,replace(replace(p1.pass_type,chr(13),''),chr(10),'')  -- 港澳台通行证类型
    ,replace(replace(p1.pass_code,chr(13),''),chr(10),'')  -- 港澳台通行证号码
    ,replace(replace(p1.register_type,chr(13),''),chr(10),'')  -- 
    ,p1.start_dt  -- 开始时间
    ,p1.end_dt  -- 结束时间
    ,replace(replace(p1.id_mark,chr(13),''),chr(10),'')  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${iol_schema}.rcrs_cus_indiv p1   --对私客户信息表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rcrs_cus_indiv',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);