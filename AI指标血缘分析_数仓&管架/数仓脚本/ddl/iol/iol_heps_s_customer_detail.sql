/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_s_customer_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_s_customer_detail
whenever sqlerror continue none;
drop table ${iol_schema}.heps_s_customer_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_s_customer_detail(
    cusdetail_id number -- 主键id
    ,flow_id varchar2(50) -- 	业务流水号
    ,loans_usage varchar2(10) -- 贷款用途
    ,concrete_usage varchar2(200) -- 具体用途
    ,paymentsource varchar2(10) -- 还款来源
    ,work_nature varchar2(1) -- 	工作性质
    ,manage_site_type varchar2(10) -- 经营场所类型
    ,manage_age varchar2(10) -- 经营年限
    ,merchant_name varchar2(50) -- 商户名称
    ,manage_site varchar2(384) -- 经营场所
    ,operator varchar2(30) -- 经营者
    ,actual_control varchar2(100) -- 实际控制人
    ,register_time varchar2(10) -- 注册日期
    ,manage_scope varchar2(100) -- 经营范围
    ,detail_address varchar2(384) -- 详细居住地址
    ,children_num varchar2(2) -- 子女数量
    ,qq varchar2(16) -- QQ号
    ,wechat varchar2(40) -- 微信号
    ,email varchar2(50) -- 电子邮箱
    ,household_phone varchar2(16) -- 家庭电话
    ,highest_education varchar2(8) -- 最高学历
    ,work_unit varchar2(384) -- 工作单位
    ,industry_one varchar2(16) -- 所属行业（一级）
    ,industry_two varchar2(16) -- 所属行业（二级）
    ,industry_three varchar2(16) -- 所属行业（三级）
    ,industry_four varchar2(16) -- 所属行业（四级）
    ,job varchar2(10) -- 职业
    ,duty varchar2(10) -- 职务
    ,unit_phone varchar2(20) -- 单位联系电话
    ,income_year varchar2(30) -- 个人年收入
    ,income_family varchar2(30) -- 家庭年收入
    ,other_assets varchar2(15) -- 其他资产证明
    ,status varchar2(16) -- 状态
    ,input_time date -- 录入时间
    ,loan_type varchar2(12) -- 贷款类型
    ,enterprise_name varchar2(100) -- 企业名称
    ,unifysocial_creditnum varchar2(256) -- 统一社会信用编号
    ,enterprise_legal_personname varchar2(60) -- 企业法人姓名
    ,enterprise_legal_personidno varchar2(20) -- 企业法人身份证号
    ,regist_address varchar2(200) -- 注册地址
    ,regist_assets number(24,2) -- 注册资本
    ,validite_date varchar2(10) -- 有效期
    ,regist_date varchar2(10) -- 注册日期
    ,bs_start_date varchar2(10) -- 营业起始日
    ,bs_end_date varchar2(10) -- 营业到期日
    ,pract_years varchar2(2) -- 法人从业年限
    ,company_year number -- 经营年限
    ,unit_property varchar2(4) -- 单位性质
    ,enter_unit_time varchar2(10) -- 进入本单位时间
    ,appraisal varchar2(10) -- 职称
    ,manager_idcard varchar2(18) -- 经营者身份证号码
    ,manager_license_number varchar2(20) -- 营业执照号码
    ,rent_end_date varchar2(10) -- 租赁到期日
    ,industry_involved varchar2(200) -- 所属行业名称
    ,bussiness_scope varchar2(1500) -- 经营范围
    ,certification_type varchar2(20) -- 证件类型
    ,certification_number varchar2(20) -- 证件号码
    ,enterprise_size varchar2(3) -- 企业规模
    ,property_ownership varchar2(20) -- 所有制性质
    ,enterpriseholding_type varchar2(10) -- 企业控股类型
    ,borrow_enterprise_relation varchar2(3) -- 借款人与经营实体的关系
    ,job_number number -- 职工人数
    ,enterprise_address varchar2(384) -- 企业地址
    ,bussiness_income number(24,2) -- 营业收入(年)
    ,main_bussiness varchar2(200) -- 主营业务
    ,individual_name varchar2(100) -- 个体工商户名称
    ,actual_income number(24,2) -- 实收资本
    ,unit_address varchar2(384) -- 单位地址
    ,indiv_comfld_type varchar2(5) -- 所属行业编号
    ,cobo_invt_stk_perc number(10,4) -- 共借人持股比例
    ,invt_stk_perc number(10,4) -- 借款人持股比例
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.heps_s_customer_detail to ${iml_schema};
grant select on ${iol_schema}.heps_s_customer_detail to ${icl_schema};
grant select on ${iol_schema}.heps_s_customer_detail to ${idl_schema};
grant select on ${iol_schema}.heps_s_customer_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_s_customer_detail is '客户详细信息';
comment on column ${iol_schema}.heps_s_customer_detail.cusdetail_id is '主键id';
comment on column ${iol_schema}.heps_s_customer_detail.flow_id is '	业务流水号';
comment on column ${iol_schema}.heps_s_customer_detail.loans_usage is '贷款用途';
comment on column ${iol_schema}.heps_s_customer_detail.concrete_usage is '具体用途';
comment on column ${iol_schema}.heps_s_customer_detail.paymentsource is '还款来源';
comment on column ${iol_schema}.heps_s_customer_detail.work_nature is '	工作性质';
comment on column ${iol_schema}.heps_s_customer_detail.manage_site_type is '经营场所类型';
comment on column ${iol_schema}.heps_s_customer_detail.manage_age is '经营年限';
comment on column ${iol_schema}.heps_s_customer_detail.merchant_name is '商户名称';
comment on column ${iol_schema}.heps_s_customer_detail.manage_site is '经营场所';
comment on column ${iol_schema}.heps_s_customer_detail.operator is '经营者';
comment on column ${iol_schema}.heps_s_customer_detail.actual_control is '实际控制人';
comment on column ${iol_schema}.heps_s_customer_detail.register_time is '注册日期';
comment on column ${iol_schema}.heps_s_customer_detail.manage_scope is '经营范围';
comment on column ${iol_schema}.heps_s_customer_detail.detail_address is '详细居住地址';
comment on column ${iol_schema}.heps_s_customer_detail.children_num is '子女数量';
comment on column ${iol_schema}.heps_s_customer_detail.qq is 'QQ号';
comment on column ${iol_schema}.heps_s_customer_detail.wechat is '微信号';
comment on column ${iol_schema}.heps_s_customer_detail.email is '电子邮箱';
comment on column ${iol_schema}.heps_s_customer_detail.household_phone is '家庭电话';
comment on column ${iol_schema}.heps_s_customer_detail.highest_education is '最高学历';
comment on column ${iol_schema}.heps_s_customer_detail.work_unit is '工作单位';
comment on column ${iol_schema}.heps_s_customer_detail.industry_one is '所属行业（一级）';
comment on column ${iol_schema}.heps_s_customer_detail.industry_two is '所属行业（二级）';
comment on column ${iol_schema}.heps_s_customer_detail.industry_three is '所属行业（三级）';
comment on column ${iol_schema}.heps_s_customer_detail.industry_four is '所属行业（四级）';
comment on column ${iol_schema}.heps_s_customer_detail.job is '职业';
comment on column ${iol_schema}.heps_s_customer_detail.duty is '职务';
comment on column ${iol_schema}.heps_s_customer_detail.unit_phone is '单位联系电话';
comment on column ${iol_schema}.heps_s_customer_detail.income_year is '个人年收入';
comment on column ${iol_schema}.heps_s_customer_detail.income_family is '家庭年收入';
comment on column ${iol_schema}.heps_s_customer_detail.other_assets is '其他资产证明';
comment on column ${iol_schema}.heps_s_customer_detail.status is '状态';
comment on column ${iol_schema}.heps_s_customer_detail.input_time is '录入时间';
comment on column ${iol_schema}.heps_s_customer_detail.loan_type is '贷款类型';
comment on column ${iol_schema}.heps_s_customer_detail.enterprise_name is '企业名称';
comment on column ${iol_schema}.heps_s_customer_detail.unifysocial_creditnum is '统一社会信用编号';
comment on column ${iol_schema}.heps_s_customer_detail.enterprise_legal_personname is '企业法人姓名';
comment on column ${iol_schema}.heps_s_customer_detail.enterprise_legal_personidno is '企业法人身份证号';
comment on column ${iol_schema}.heps_s_customer_detail.regist_address is '注册地址';
comment on column ${iol_schema}.heps_s_customer_detail.regist_assets is '注册资本';
comment on column ${iol_schema}.heps_s_customer_detail.validite_date is '有效期';
comment on column ${iol_schema}.heps_s_customer_detail.regist_date is '注册日期';
comment on column ${iol_schema}.heps_s_customer_detail.bs_start_date is '营业起始日';
comment on column ${iol_schema}.heps_s_customer_detail.bs_end_date is '营业到期日';
comment on column ${iol_schema}.heps_s_customer_detail.pract_years is '法人从业年限';
comment on column ${iol_schema}.heps_s_customer_detail.company_year is '经营年限';
comment on column ${iol_schema}.heps_s_customer_detail.unit_property is '单位性质';
comment on column ${iol_schema}.heps_s_customer_detail.enter_unit_time is '进入本单位时间';
comment on column ${iol_schema}.heps_s_customer_detail.appraisal is '职称';
comment on column ${iol_schema}.heps_s_customer_detail.manager_idcard is '经营者身份证号码';
comment on column ${iol_schema}.heps_s_customer_detail.manager_license_number is '营业执照号码';
comment on column ${iol_schema}.heps_s_customer_detail.rent_end_date is '租赁到期日';
comment on column ${iol_schema}.heps_s_customer_detail.industry_involved is '所属行业名称';
comment on column ${iol_schema}.heps_s_customer_detail.bussiness_scope is '经营范围';
comment on column ${iol_schema}.heps_s_customer_detail.certification_type is '证件类型';
comment on column ${iol_schema}.heps_s_customer_detail.certification_number is '证件号码';
comment on column ${iol_schema}.heps_s_customer_detail.enterprise_size is '企业规模';
comment on column ${iol_schema}.heps_s_customer_detail.property_ownership is '所有制性质';
comment on column ${iol_schema}.heps_s_customer_detail.enterpriseholding_type is '企业控股类型';
comment on column ${iol_schema}.heps_s_customer_detail.borrow_enterprise_relation is '借款人与经营实体的关系';
comment on column ${iol_schema}.heps_s_customer_detail.job_number is '职工人数';
comment on column ${iol_schema}.heps_s_customer_detail.enterprise_address is '企业地址';
comment on column ${iol_schema}.heps_s_customer_detail.bussiness_income is '营业收入(年)';
comment on column ${iol_schema}.heps_s_customer_detail.main_bussiness is '主营业务';
comment on column ${iol_schema}.heps_s_customer_detail.individual_name is '个体工商户名称';
comment on column ${iol_schema}.heps_s_customer_detail.actual_income is '实收资本';
comment on column ${iol_schema}.heps_s_customer_detail.unit_address is '单位地址';
comment on column ${iol_schema}.heps_s_customer_detail.indiv_comfld_type is '所属行业编号';
comment on column ${iol_schema}.heps_s_customer_detail.cobo_invt_stk_perc is '共借人持股比例';
comment on column ${iol_schema}.heps_s_customer_detail.invt_stk_perc is '借款人持股比例';
comment on column ${iol_schema}.heps_s_customer_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_s_customer_detail.etl_timestamp is 'ETL处理时间戳';
