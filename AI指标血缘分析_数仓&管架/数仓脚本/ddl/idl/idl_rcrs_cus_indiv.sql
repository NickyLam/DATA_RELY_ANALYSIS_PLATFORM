/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl rcrs_cus_indiv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.rcrs_cus_indiv
whenever sqlerror continue none;
drop table ${idl_schema}.rcrs_cus_indiv purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.rcrs_cus_indiv(
    etl_dt date -- 数据日期
    ,inner_cus_id varchar2(30) -- 内部客户号
    ,cus_id varchar2(30) -- 客户代码
    ,mng_br_id varchar2(20) -- 所属法人机构
    ,cus_type varchar2(3) -- 客户类型
    ,cus_name varchar2(80) -- 客户姓名
    ,indiv_sex varchar2(1) -- 性别
    ,cert_type varchar2(2) -- 证件类型
    ,cert_code varchar2(32) -- 证件号码
    ,indiv_id_exp_dt varchar2(10) -- 证件到期日
    ,agri_flg varchar2(1) -- 是否农户
    ,cus_bank_rel varchar2(2) -- 与我行关联关系
    ,com_hold_stk_amt number(16,2) -- 拥有我行股份金额
    ,bank_duty varchar2(1) -- 在我行职务
    ,indiv_ntn varchar2(2) -- 民族
    ,indiv_brt_place varchar2(200) -- 籍贯
    ,indiv_houh_reg_add varchar2(255) -- 户籍地址
    ,indiv_dt_of_birth varchar2(10) -- 出生年月日
    ,indiv_pol_st varchar2(2) -- 政治面貌
    ,indiv_edt varchar2(2) -- 教育程度
    ,indiv_dgr varchar2(1) -- 最高学位
    ,indiv_mar_st varchar2(2) -- 婚姻状况
    ,indiv_heal_st varchar2(1) -- 健康状况
    ,post_addr varchar2(200) -- 通讯地址
    ,post_code varchar2(11) -- 邮政编码
    ,area_code varchar2(14) -- 区域编码
    ,area_name varchar2(100) -- 区域名称
    ,phone varchar2(35) -- 联系电话
    ,fphone varchar2(35) -- 家庭电话
    ,mobile varchar2(35) -- 手机
    ,fax_code varchar2(35) -- 传真
    ,email varchar2(80) -- emal地址
    ,indiv_rsd_addr varchar2(255) -- 居住地址
    ,indiv_zip_code varchar2(11) -- 居住地邮政编码
    ,indiv_rsd_st varchar2(2) -- 居住状况
    ,indiv_soc_scr varchar2(60) -- 社会保障情况
    ,indiv_hobby varchar2(200) -- 爱好
    ,indiv_occ varchar2(1) -- 从事职业
    ,indiv_com_name varchar2(255) -- 工作单位
    ,indiv_com_typ varchar2(4) -- 单位性质
    ,indiv_com_fld varchar2(5) -- 单位所属行业
    ,indiv_com_phn varchar2(50) -- 单位电话
    ,indiv_com_fax varchar2(25) -- 单位传真
    ,indiv_com_addr varchar2(255) -- 单位地址
    ,indiv_com_zip_code varchar2(6) -- 单位邮政编码
    ,indiv_com_cnt_name varchar2(30) -- 单位联系人
    ,indiv_work_job_y varchar2(10) -- 单位工作起始年限
    ,indiv_com_job_ttl varchar2(2) -- 职务
    ,indiv_crtfctn varchar2(1) -- 职称
    ,indiv_ann_incm number(16,2) -- 年收入情况
    ,indiv_sal_acc_bank varchar2(80) -- 工资账户开户行
    ,indiv_sal_acc_no varchar2(32) -- 工资账号
    ,indiv_sps_name varchar2(35) -- 配偶姓名
    ,indiv_sps_id_typ varchar2(2) -- 配偶证件类型
    ,indiv_sps_id_code varchar2(20) -- 配偶证件号码
    ,indiv_scom_name varchar2(80) -- 配偶工作单位
    ,indiv_sps_occ varchar2(1) -- 配偶职业
    ,indiv_sps_duty varchar2(1) -- 配偶职务
    ,indiv_sps_mincm number(16,2) -- 配偶月收入
    ,indiv_sps_phn varchar2(35) -- 配偶单位联系电话
    ,indiv_sps_mphn varchar2(35) -- 配偶手机号码
    ,indiv_sps_job_dt varchar2(10) -- 配偶参加工作时间
    ,com_rel_dgr varchar2(2) -- 与我行合作关系
    ,com_init_loan_date varchar2(10) -- 建立信贷关系时间
    ,indiv_hld_acnt varchar2(1) -- 在我行开立账户情况
    ,hold_card varchar2(1) -- 持卡情况
    ,passport_flg varchar2(1) -- 是否拥有外国护照或居住权
    ,crd_grade varchar2(2) -- 信用等级
    ,crd_date varchar2(10) -- 信用评定日期
    ,remark varchar2(500) -- 备注
    ,cust_mgr varchar2(20) -- 客户经理
    ,main_br_id varchar2(50) -- 主管机构
    ,input_id varchar2(20) -- 登记人
    ,input_br_id varchar2(20) -- 登记机构
    ,input_date varchar2(10) -- 登记日期
    ,last_upd_id varchar2(20) -- 更新人
    ,last_upd_date varchar2(10) -- 更新日期
    ,cus_status varchar2(2) -- 状态
    ,indiv_com_fld_name varchar2(200) -- 单位所属行业名称
    ,crd_end_dt varchar2(10) -- 信用等级到期日期
    ,indiv_psp_crtfctn varchar2(1) -- 配偶职称
    ,indiv_sps_mar_code varchar2(20) -- 结婚证号码
    ,cus_id_rel varchar2(30) -- 配偶关联客户码
    ,work_resume varchar2(250) -- 个人简历
    ,accredit_status varchar2(1) -- 授权状态
    ,former_name varchar2(35) -- 曾用名
    ,lay_off_flag varchar2(1) -- 是否有工作单位
    ,lay_off_code varchar2(20) -- 下岗证号
    ,loan_card_flg varchar2(1) -- 有无贷款卡
    ,loan_card_id varchar2(16) -- 贷款卡编号
    ,loan_card_pwd varchar2(20) -- 贷款卡密码
    ,loan_card_eff_flg varchar2(2) -- 贷款卡有效标识
    ,loan_card_audit_dt varchar2(10) -- 贷款卡年审到期日
    ,businesses_flag varchar2(1) -- 客户性质
    ,vocation_type varchar2(2) -- 从业类型
    ,family_population number(16,2) -- 供养人口（人）
    ,family_labor_population number(16,2) -- 家庭劳动力数量
    ,reg_state_code varchar2(20) -- 
    ,card_org_name varchar2(50) -- 发证机关名称
    ,sps_remark varchar2(250) -- 配偶备注
    ,if_micro_business_owner varchar2(1) -- 是否小微企业主
    ,if_industrial_areas varchar2(1) -- 注册地是否工业园区
    ,issue_info varchar2(2) -- 贵宾客户等级
    ,card_id varchar2(20) -- 卡号
    ,indiv_month_income number(16,2) -- 个人月收入(元)
    ,yes_no_contract varchar2(1) -- 是否农村承包经营户
    ,yes_no_vip_cus varchar2(1) -- 是否贵宾客户
    ,yes_no_annexamine varchar2(1) -- 是否年审通过
    ,indiv_province varchar2(10) -- 户籍所在省份（直辖市、自治区）
    ,indiv_city varchar2(10) -- 户籍所在城市
    ,core_cus_id varchar2(30) -- 核心客户号
    ,whetherbankblacklist varchar2(1) -- 是否本行黑名客户
    ,indiv_id_st_dt varchar2(10) -- 证件起始日
    ,nationality varchar2(3) -- 国籍
    ,houh_reg_property varchar2(3) -- 户籍性质
    ,local_reg_time varchar2(10) -- 本地居住时间
    ,has_children number(16,2) -- 其中子女（人）
    ,children_situation varchar2(1) -- 子女情况
    ,family_month_income number(16,2) -- 家庭月收入
    ,has_car varchar2(1) -- 自有汽车情况
    ,car_cost number(16,2) -- 汽车价值
    ,has_other_code varchar2(1) -- 是否有第三方注册账号
    ,other_code varchar2(20) -- 第三方账号
    ,working_condition varchar2(3) -- 现工作状态
    ,work_unit_size varchar2(3) -- 工作单位规模
    ,working_life varchar2(10) -- 从业年限
    ,working_stablity varchar2(3) -- 工作稳定性
    ,urgency_name varchar2(35) -- 紧急联系人姓名
    ,relation varchar2(1) -- 与申请人关系
    ,urgency_tel varchar2(11) -- 联系电话
    ,urgency_address varchar2(100) -- 联系地址
    ,urgency_zip_code varchar2(11) -- 联系邮编
    ,cosurety_cont_no varchar2(32) -- 联保申请编号
    ,other_code_type varchar2(2) -- 第三方注册账号类型
    ,authentica_type varchar2(1) -- 安全等级认证方式
    ,house_cost number(16,2) -- 房产价值
    ,identity_card varchar2(32) -- 身份证号码
    ,is_rcrs_cus varchar2(1) -- 是否零售信贷新开客户
    ,indiv_soc_years varchar2(6) -- 社保缴纳时长（年）
    ,relative_name1 varchar2(80) -- 亲属联系人1姓名
    ,relative_type1 varchar2(1) -- 与亲属联系人1关系
    ,relative_phone1 varchar2(80) -- 亲属联系人1手机号码
    ,relative_name2 varchar2(80) -- 亲属联系人2姓名
    ,relative_type2 varchar2(1) -- 与亲属联系人2关系
    ,relative_phone2 varchar2(80) -- 亲属联系人2手机号码
    ,relative_name3 varchar2(80) -- 非亲属联系人3姓名
    ,relative_type3 varchar2(1) -- 与非亲属联系人3关系
    ,relative_phone3 varchar2(80) -- 非亲属联系人3手机号码
    ,relative_name4 varchar2(80) -- 非亲属联系人4姓名
    ,relative_type4 varchar2(1) -- 与非亲属联系人4关系
    ,relative_phone4 varchar2(80) -- 非亲属联系人4手机号码
    ,relative_fphone1 varchar2(80) -- 亲属联系人1家庭电话
    ,relative_fphone2 varchar2(80) -- 亲属联系人2家庭电话
    ,relative_fphone3 varchar2(80) -- 亲属联系人3家庭电话
    ,relative_fphone4 varchar2(80) -- 亲属联系人4家庭电话
    ,email2 varchar2(80) -- 电子邮箱2
    ,qq varchar2(80) -- QQ号码
    ,wechat varchar2(80) -- 微信号码
    ,tenpay varchar2(80) -- 财付通账号
    ,sinablog varchar2(80) -- 新浪微博
    ,taobao_account varchar2(80) -- 淘宝账号
    ,alipay varchar2(80) -- 支付宝账号
    ,jingdong_account varchar2(80) -- 京东账号
    ,is_cl varchar2(1) -- 
    ,indiv_com_no varchar2(32) -- 工作信息序号
    ,indiv_addr_no varchar2(32) -- 居住地址序号
    ,is_relative varchar2(1) -- 是否行内关联交易
    ,rel_no varchar2(32) -- 关系人编号（同步ECIF客户信息时使用）
    ,work_no varchar2(32) -- 工作单位编号（同步ECIF客户信息时使用）
    ,addr_no varchar2(32) -- 联系地址编号（同步ECIF客户信息时使用）
    ,family_addr_no varchar2(32) -- 家庭地址编号（同步ECIF客户信息时使用）
    ,businesses_flag_1 varchar2(1) -- 客户性质副本
    ,is_limit_apply varchar2(1) -- 是否授信暂禁 1-是 2-否
    ,pass_type varchar2(2) -- 港澳台通行证类型
    ,pass_code varchar2(32) -- 港澳台通行证号码
    ,register_type varchar2(1) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.rcrs_cus_indiv to ${iel_schema};

-- comment
comment on table ${idl_schema}.rcrs_cus_indiv is '对私客户信息表';
comment on column ${idl_schema}.rcrs_cus_indiv.etl_dt is '数据日期';
comment on column ${idl_schema}.rcrs_cus_indiv.inner_cus_id is '内部客户号';
comment on column ${idl_schema}.rcrs_cus_indiv.cus_id is '客户代码';
comment on column ${idl_schema}.rcrs_cus_indiv.mng_br_id is '所属法人机构';
comment on column ${idl_schema}.rcrs_cus_indiv.cus_type is '客户类型';
comment on column ${idl_schema}.rcrs_cus_indiv.cus_name is '客户姓名';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sex is '性别';
comment on column ${idl_schema}.rcrs_cus_indiv.cert_type is '证件类型';
comment on column ${idl_schema}.rcrs_cus_indiv.cert_code is '证件号码';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_id_exp_dt is '证件到期日';
comment on column ${idl_schema}.rcrs_cus_indiv.agri_flg is '是否农户';
comment on column ${idl_schema}.rcrs_cus_indiv.cus_bank_rel is '与我行关联关系';
comment on column ${idl_schema}.rcrs_cus_indiv.com_hold_stk_amt is '拥有我行股份金额';
comment on column ${idl_schema}.rcrs_cus_indiv.bank_duty is '在我行职务';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_ntn is '民族';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_brt_place is '籍贯';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_houh_reg_add is '户籍地址';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_dt_of_birth is '出生年月日';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_pol_st is '政治面貌';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_edt is '教育程度';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_dgr is '最高学位';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_mar_st is '婚姻状况';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_heal_st is '健康状况';
comment on column ${idl_schema}.rcrs_cus_indiv.post_addr is '通讯地址';
comment on column ${idl_schema}.rcrs_cus_indiv.post_code is '邮政编码';
comment on column ${idl_schema}.rcrs_cus_indiv.area_code is '区域编码';
comment on column ${idl_schema}.rcrs_cus_indiv.area_name is '区域名称';
comment on column ${idl_schema}.rcrs_cus_indiv.phone is '联系电话';
comment on column ${idl_schema}.rcrs_cus_indiv.fphone is '家庭电话';
comment on column ${idl_schema}.rcrs_cus_indiv.mobile is '手机';
comment on column ${idl_schema}.rcrs_cus_indiv.fax_code is '传真';
comment on column ${idl_schema}.rcrs_cus_indiv.email is 'emal地址';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_rsd_addr is '居住地址';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_zip_code is '居住地邮政编码';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_rsd_st is '居住状况';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_soc_scr is '社会保障情况';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_hobby is '爱好';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_occ is '从事职业';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_name is '工作单位';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_typ is '单位性质';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_fld is '单位所属行业';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_phn is '单位电话';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_fax is '单位传真';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_addr is '单位地址';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_zip_code is '单位邮政编码';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_cnt_name is '单位联系人';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_work_job_y is '单位工作起始年限';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_job_ttl is '职务';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_crtfctn is '职称';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_ann_incm is '年收入情况';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sal_acc_bank is '工资账户开户行';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sal_acc_no is '工资账号';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_name is '配偶姓名';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_id_typ is '配偶证件类型';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_id_code is '配偶证件号码';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_scom_name is '配偶工作单位';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_occ is '配偶职业';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_duty is '配偶职务';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_mincm is '配偶月收入';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_phn is '配偶单位联系电话';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_mphn is '配偶手机号码';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_job_dt is '配偶参加工作时间';
comment on column ${idl_schema}.rcrs_cus_indiv.com_rel_dgr is '与我行合作关系';
comment on column ${idl_schema}.rcrs_cus_indiv.com_init_loan_date is '建立信贷关系时间';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_hld_acnt is '在我行开立账户情况';
comment on column ${idl_schema}.rcrs_cus_indiv.hold_card is '持卡情况';
comment on column ${idl_schema}.rcrs_cus_indiv.passport_flg is '是否拥有外国护照或居住权';
comment on column ${idl_schema}.rcrs_cus_indiv.crd_grade is '信用等级';
comment on column ${idl_schema}.rcrs_cus_indiv.crd_date is '信用评定日期';
comment on column ${idl_schema}.rcrs_cus_indiv.remark is '备注';
comment on column ${idl_schema}.rcrs_cus_indiv.cust_mgr is '客户经理';
comment on column ${idl_schema}.rcrs_cus_indiv.main_br_id is '主管机构';
comment on column ${idl_schema}.rcrs_cus_indiv.input_id is '登记人';
comment on column ${idl_schema}.rcrs_cus_indiv.input_br_id is '登记机构';
comment on column ${idl_schema}.rcrs_cus_indiv.input_date is '登记日期';
comment on column ${idl_schema}.rcrs_cus_indiv.last_upd_id is '更新人';
comment on column ${idl_schema}.rcrs_cus_indiv.last_upd_date is '更新日期';
comment on column ${idl_schema}.rcrs_cus_indiv.cus_status is '状态';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_fld_name is '单位所属行业名称';
comment on column ${idl_schema}.rcrs_cus_indiv.crd_end_dt is '信用等级到期日期';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_psp_crtfctn is '配偶职称';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_sps_mar_code is '结婚证号码';
comment on column ${idl_schema}.rcrs_cus_indiv.cus_id_rel is '配偶关联客户码';
comment on column ${idl_schema}.rcrs_cus_indiv.work_resume is '个人简历';
comment on column ${idl_schema}.rcrs_cus_indiv.accredit_status is '授权状态';
comment on column ${idl_schema}.rcrs_cus_indiv.former_name is '曾用名';
comment on column ${idl_schema}.rcrs_cus_indiv.lay_off_flag is '是否有工作单位';
comment on column ${idl_schema}.rcrs_cus_indiv.lay_off_code is '下岗证号';
comment on column ${idl_schema}.rcrs_cus_indiv.loan_card_flg is '有无贷款卡';
comment on column ${idl_schema}.rcrs_cus_indiv.loan_card_id is '贷款卡编号';
comment on column ${idl_schema}.rcrs_cus_indiv.loan_card_pwd is '贷款卡密码';
comment on column ${idl_schema}.rcrs_cus_indiv.loan_card_eff_flg is '贷款卡有效标识';
comment on column ${idl_schema}.rcrs_cus_indiv.loan_card_audit_dt is '贷款卡年审到期日';
comment on column ${idl_schema}.rcrs_cus_indiv.businesses_flag is '客户性质';
comment on column ${idl_schema}.rcrs_cus_indiv.vocation_type is '从业类型';
comment on column ${idl_schema}.rcrs_cus_indiv.family_population is '供养人口（人）';
comment on column ${idl_schema}.rcrs_cus_indiv.family_labor_population is '家庭劳动力数量';
comment on column ${idl_schema}.rcrs_cus_indiv.reg_state_code is '';
comment on column ${idl_schema}.rcrs_cus_indiv.card_org_name is '发证机关名称';
comment on column ${idl_schema}.rcrs_cus_indiv.sps_remark is '配偶备注';
comment on column ${idl_schema}.rcrs_cus_indiv.if_micro_business_owner is '是否小微企业主';
comment on column ${idl_schema}.rcrs_cus_indiv.if_industrial_areas is '注册地是否工业园区';
comment on column ${idl_schema}.rcrs_cus_indiv.issue_info is '贵宾客户等级';
comment on column ${idl_schema}.rcrs_cus_indiv.card_id is '卡号';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_month_income is '个人月收入(元)';
comment on column ${idl_schema}.rcrs_cus_indiv.yes_no_contract is '是否农村承包经营户';
comment on column ${idl_schema}.rcrs_cus_indiv.yes_no_vip_cus is '是否贵宾客户';
comment on column ${idl_schema}.rcrs_cus_indiv.yes_no_annexamine is '是否年审通过';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_province is '户籍所在省份（直辖市、自治区）';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_city is '户籍所在城市';
comment on column ${idl_schema}.rcrs_cus_indiv.core_cus_id is '核心客户号';
comment on column ${idl_schema}.rcrs_cus_indiv.whetherbankblacklist is '是否本行黑名客户';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_id_st_dt is '证件起始日';
comment on column ${idl_schema}.rcrs_cus_indiv.nationality is '国籍';
comment on column ${idl_schema}.rcrs_cus_indiv.houh_reg_property is '户籍性质';
comment on column ${idl_schema}.rcrs_cus_indiv.local_reg_time is '本地居住时间';
comment on column ${idl_schema}.rcrs_cus_indiv.has_children is '其中子女（人）';
comment on column ${idl_schema}.rcrs_cus_indiv.children_situation is '子女情况';
comment on column ${idl_schema}.rcrs_cus_indiv.family_month_income is '家庭月收入';
comment on column ${idl_schema}.rcrs_cus_indiv.has_car is '自有汽车情况';
comment on column ${idl_schema}.rcrs_cus_indiv.car_cost is '汽车价值';
comment on column ${idl_schema}.rcrs_cus_indiv.has_other_code is '是否有第三方注册账号';
comment on column ${idl_schema}.rcrs_cus_indiv.other_code is '第三方账号';
comment on column ${idl_schema}.rcrs_cus_indiv.working_condition is '现工作状态';
comment on column ${idl_schema}.rcrs_cus_indiv.work_unit_size is '工作单位规模';
comment on column ${idl_schema}.rcrs_cus_indiv.working_life is '从业年限';
comment on column ${idl_schema}.rcrs_cus_indiv.working_stablity is '工作稳定性';
comment on column ${idl_schema}.rcrs_cus_indiv.urgency_name is '紧急联系人姓名';
comment on column ${idl_schema}.rcrs_cus_indiv.relation is '与申请人关系';
comment on column ${idl_schema}.rcrs_cus_indiv.urgency_tel is '联系电话';
comment on column ${idl_schema}.rcrs_cus_indiv.urgency_address is '联系地址';
comment on column ${idl_schema}.rcrs_cus_indiv.urgency_zip_code is '联系邮编';
comment on column ${idl_schema}.rcrs_cus_indiv.cosurety_cont_no is '联保申请编号';
comment on column ${idl_schema}.rcrs_cus_indiv.other_code_type is '第三方注册账号类型';
comment on column ${idl_schema}.rcrs_cus_indiv.authentica_type is '安全等级认证方式';
comment on column ${idl_schema}.rcrs_cus_indiv.house_cost is '房产价值';
comment on column ${idl_schema}.rcrs_cus_indiv.identity_card is '身份证号码';
comment on column ${idl_schema}.rcrs_cus_indiv.is_rcrs_cus is '是否零售信贷新开客户';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_soc_years is '社保缴纳时长（年）';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_name1 is '亲属联系人1姓名';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_type1 is '与亲属联系人1关系';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_phone1 is '亲属联系人1手机号码';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_name2 is '亲属联系人2姓名';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_type2 is '与亲属联系人2关系';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_phone2 is '亲属联系人2手机号码';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_name3 is '非亲属联系人3姓名';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_type3 is '与非亲属联系人3关系';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_phone3 is '非亲属联系人3手机号码';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_name4 is '非亲属联系人4姓名';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_type4 is '与非亲属联系人4关系';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_phone4 is '非亲属联系人4手机号码';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_fphone1 is '亲属联系人1家庭电话';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_fphone2 is '亲属联系人2家庭电话';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_fphone3 is '亲属联系人3家庭电话';
comment on column ${idl_schema}.rcrs_cus_indiv.relative_fphone4 is '亲属联系人4家庭电话';
comment on column ${idl_schema}.rcrs_cus_indiv.email2 is '电子邮箱2';
comment on column ${idl_schema}.rcrs_cus_indiv.qq is 'QQ号码';
comment on column ${idl_schema}.rcrs_cus_indiv.wechat is '微信号码';
comment on column ${idl_schema}.rcrs_cus_indiv.tenpay is '财付通账号';
comment on column ${idl_schema}.rcrs_cus_indiv.sinablog is '新浪微博';
comment on column ${idl_schema}.rcrs_cus_indiv.taobao_account is '淘宝账号';
comment on column ${idl_schema}.rcrs_cus_indiv.alipay is '支付宝账号';
comment on column ${idl_schema}.rcrs_cus_indiv.jingdong_account is '京东账号';
comment on column ${idl_schema}.rcrs_cus_indiv.is_cl is '';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_com_no is '工作信息序号';
comment on column ${idl_schema}.rcrs_cus_indiv.indiv_addr_no is '居住地址序号';
comment on column ${idl_schema}.rcrs_cus_indiv.is_relative is '是否行内关联交易';
comment on column ${idl_schema}.rcrs_cus_indiv.rel_no is '关系人编号（同步ECIF客户信息时使用）';
comment on column ${idl_schema}.rcrs_cus_indiv.work_no is '工作单位编号（同步ECIF客户信息时使用）';
comment on column ${idl_schema}.rcrs_cus_indiv.addr_no is '联系地址编号（同步ECIF客户信息时使用）';
comment on column ${idl_schema}.rcrs_cus_indiv.family_addr_no is '家庭地址编号（同步ECIF客户信息时使用）';
comment on column ${idl_schema}.rcrs_cus_indiv.businesses_flag_1 is '客户性质副本';
comment on column ${idl_schema}.rcrs_cus_indiv.is_limit_apply is '是否授信暂禁 1-是 2-否';
comment on column ${idl_schema}.rcrs_cus_indiv.pass_type is '港澳台通行证类型';
comment on column ${idl_schema}.rcrs_cus_indiv.pass_code is '港澳台通行证号码';
comment on column ${idl_schema}.rcrs_cus_indiv.register_type is '';
comment on column ${idl_schema}.rcrs_cus_indiv.start_dt is '开始时间';
comment on column ${idl_schema}.rcrs_cus_indiv.end_dt is '结束时间';
comment on column ${idl_schema}.rcrs_cus_indiv.id_mark is '增删标志';
comment on column ${idl_schema}.rcrs_cus_indiv.etl_timestamp is 'ETL处理时间戳';