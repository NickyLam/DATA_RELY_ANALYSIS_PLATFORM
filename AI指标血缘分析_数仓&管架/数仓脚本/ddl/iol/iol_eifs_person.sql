/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_person
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_person
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_person purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_person(
    party_id varchar2(30) -- 当事人标识
    ,salutation varchar2(150) -- 称呼
    ,first_name varchar2(150) -- 名
    ,middle_name varchar2(150) -- 中间名
    ,last_name varchar2(150) -- 姓
    ,personal_title varchar2(150) -- 头衔  创建时间
    ,suffix varchar2(150) -- 后缀  创建时间
    ,nickname varchar2(150) -- 昵称
    ,first_name_local varchar2(150) -- 名本地语言
    ,middle_name_local varchar2(150) -- 中间名本地语言
    ,last_name_local varchar2(150) -- 姓本地语言
    ,other_local varchar2(150) -- 其它本地语言
    ,member_id varchar2(30) -- 成员标识
    ,gender varchar2(15) -- 性别
    ,birth_date date -- 生日
    ,height number(18,6) -- 身高
    ,weight number(18,6) -- 体重
    ,mothers_maiden_name varchar2(383) -- 母亲娘家姓
    ,marital_status varchar2(3) -- 婚姻状态
    ,social_security_number varchar2(383) -- 社保号
    ,passport_number varchar2(383) -- 护照号
    ,passport_expire_date date -- 护照过期时间
    ,total_years_work_experience number(18,6) -- 总工作年限
    ,comments varchar2(383) -- 备注
    ,employment_status_enum_id varchar2(30) -- 雇用状态枚举标识
    ,residence_status_enum_id varchar2(30) -- 居住状态枚举标识
    ,occupation varchar2(150) -- 职业
    ,years_with_employer number(20) -- 雇用年数
    ,months_with_employer number(20) -- 雇用月数
    ,existing_customer varchar2(2) -- 存在的客户
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,nation varchar2(30) -- 国籍/国家
    ,country varchar2(30) -- 民族代码
    ,qualify varchar2(30) -- 最高学历
    ,native_place varchar2(383) -- 籍贯
    ,degree varchar2(30) -- 学位
    ,fund_acct_no varchar2(30) -- 公积金账号
    ,cust_type_code varchar2(30) -- 客户类型码
    ,head_portrait varchar2(383) -- 头像
    ,had_used_name varchar2(90) -- 法定曾用名
    ,blood_type varchar2(12) -- 血型
    ,customer_feature varchar2(383) -- 客户标签
    ,individual_sites varchar2(383) -- 个人网页
    ,english_name varchar2(383) -- 客户英文/拼音名
    ,is_interconnect_check varchar2(12) -- 是否联网核查
    ,birthplace varchar2(383) -- 
    ,real_name_mark varchar2(30) -- 实名标志
    ,depositor_type varchar2(3) -- 
    ,whether_individual_merchant varchar2(3) -- 是否为个体工商户
    ,individual_business_type varchar2(15) -- 个体工商户证件类型
    ,individual_business_license varchar2(150) -- 个体工商户证件类型
    ,whether_small_micro_ent varchar2(3) -- 是否为小微企业主
    ,small_micro_ent_type varchar2(15) -- 小微企业主证件类型
    ,small_micro_ent_license varchar2(150) -- 小微企业主证件类型
    ,birth_place varchar2(150) -- 出生地
    ,tax_resident varchar2(2) -- 税收居民身份
    ,tax_area varchar2(450) -- 税收居民国（地区）
    ,tax_number varchar2(546) -- 纳税人识别号
    ,tax_null_reason varchar2(3605) -- 纳税人识别号空值原因
    ,tax_statement varchar2(2) -- 是否取得自证声明(税收居民)
    ,customer_name_english varchar2(150) -- 客户姓名
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.eifs_person to ${iml_schema};
grant select on ${iol_schema}.eifs_person to ${icl_schema};
grant select on ${iol_schema}.eifs_person to ${idl_schema};
grant select on ${iol_schema}.eifs_person to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_person is '人员表';
comment on column ${iol_schema}.eifs_person.party_id is '当事人标识';
comment on column ${iol_schema}.eifs_person.salutation is '称呼';
comment on column ${iol_schema}.eifs_person.first_name is '名';
comment on column ${iol_schema}.eifs_person.middle_name is '中间名';
comment on column ${iol_schema}.eifs_person.last_name is '姓';
comment on column ${iol_schema}.eifs_person.personal_title is '头衔  创建时间';
comment on column ${iol_schema}.eifs_person.suffix is '后缀  创建时间';
comment on column ${iol_schema}.eifs_person.nickname is '昵称';
comment on column ${iol_schema}.eifs_person.first_name_local is '名本地语言';
comment on column ${iol_schema}.eifs_person.middle_name_local is '中间名本地语言';
comment on column ${iol_schema}.eifs_person.last_name_local is '姓本地语言';
comment on column ${iol_schema}.eifs_person.other_local is '其它本地语言';
comment on column ${iol_schema}.eifs_person.member_id is '成员标识';
comment on column ${iol_schema}.eifs_person.gender is '性别';
comment on column ${iol_schema}.eifs_person.birth_date is '生日';
comment on column ${iol_schema}.eifs_person.height is '身高';
comment on column ${iol_schema}.eifs_person.weight is '体重';
comment on column ${iol_schema}.eifs_person.mothers_maiden_name is '母亲娘家姓';
comment on column ${iol_schema}.eifs_person.marital_status is '婚姻状态';
comment on column ${iol_schema}.eifs_person.social_security_number is '社保号';
comment on column ${iol_schema}.eifs_person.passport_number is '护照号';
comment on column ${iol_schema}.eifs_person.passport_expire_date is '护照过期时间';
comment on column ${iol_schema}.eifs_person.total_years_work_experience is '总工作年限';
comment on column ${iol_schema}.eifs_person.comments is '备注';
comment on column ${iol_schema}.eifs_person.employment_status_enum_id is '雇用状态枚举标识';
comment on column ${iol_schema}.eifs_person.residence_status_enum_id is '居住状态枚举标识';
comment on column ${iol_schema}.eifs_person.occupation is '职业';
comment on column ${iol_schema}.eifs_person.years_with_employer is '雇用年数';
comment on column ${iol_schema}.eifs_person.months_with_employer is '雇用月数';
comment on column ${iol_schema}.eifs_person.existing_customer is '存在的客户';
comment on column ${iol_schema}.eifs_person.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_person.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_person.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_person.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_person.nation is '国籍/国家';
comment on column ${iol_schema}.eifs_person.country is '民族代码';
comment on column ${iol_schema}.eifs_person.qualify is '最高学历';
comment on column ${iol_schema}.eifs_person.native_place is '籍贯';
comment on column ${iol_schema}.eifs_person.degree is '学位';
comment on column ${iol_schema}.eifs_person.fund_acct_no is '公积金账号';
comment on column ${iol_schema}.eifs_person.cust_type_code is '客户类型码';
comment on column ${iol_schema}.eifs_person.head_portrait is '头像';
comment on column ${iol_schema}.eifs_person.had_used_name is '法定曾用名';
comment on column ${iol_schema}.eifs_person.blood_type is '血型';
comment on column ${iol_schema}.eifs_person.customer_feature is '客户标签';
comment on column ${iol_schema}.eifs_person.individual_sites is '个人网页';
comment on column ${iol_schema}.eifs_person.english_name is '客户英文/拼音名';
comment on column ${iol_schema}.eifs_person.is_interconnect_check is '是否联网核查';
comment on column ${iol_schema}.eifs_person.birthplace is '';
comment on column ${iol_schema}.eifs_person.real_name_mark is '实名标志';
comment on column ${iol_schema}.eifs_person.depositor_type is '';
comment on column ${iol_schema}.eifs_person.whether_individual_merchant is '是否为个体工商户';
comment on column ${iol_schema}.eifs_person.individual_business_type is '个体工商户证件类型';
comment on column ${iol_schema}.eifs_person.individual_business_license is '个体工商户证件类型';
comment on column ${iol_schema}.eifs_person.whether_small_micro_ent is '是否为小微企业主';
comment on column ${iol_schema}.eifs_person.small_micro_ent_type is '小微企业主证件类型';
comment on column ${iol_schema}.eifs_person.small_micro_ent_license is '小微企业主证件类型';
comment on column ${iol_schema}.eifs_person.birth_place is '出生地';
comment on column ${iol_schema}.eifs_person.tax_resident is '税收居民身份';
comment on column ${iol_schema}.eifs_person.tax_area is '税收居民国（地区）';
comment on column ${iol_schema}.eifs_person.tax_number is '纳税人识别号';
comment on column ${iol_schema}.eifs_person.tax_null_reason is '纳税人识别号空值原因';
comment on column ${iol_schema}.eifs_person.tax_statement is '是否取得自证声明(税收居民)';
comment on column ${iol_schema}.eifs_person.customer_name_english is '客户姓名';
comment on column ${iol_schema}.eifs_person.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_person.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_person.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_person.etl_timestamp is 'ETL处理时间戳';
