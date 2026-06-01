/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_per_cust_ext_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_per_cust_ext_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_per_cust_ext_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_cust_ext_info(
    party_id varchar2(45) -- 参与人id
    ,cust_card_level_cd varchar2(2) -- 客户持卡等级
    ,cust_asset_level_cd varchar2(2) -- 客户资产等级
    ,cust_risk_level_cd varchar2(2) -- 风险等级
    ,bad_rec_reason varchar2(90) -- 不良记录原因
    ,credit_limit_flag_cd number(20,2) -- 综合授信额度
    ,used_crdt_limit number(20,2) -- 已用授信额度
    ,avail_crdt_limit number(20,2) -- 可用授信额度
    ,loan_card_num varchar2(45) -- 贷款卡号
    ,resdnt_char_cd varchar2(2) -- 居民性质
    ,resdnt_situ_cd varchar2(30) -- 居住状况
    ,socl_card_no varchar2(45) -- 社保卡卡号
    ,fund_acct_no varchar2(30) -- 公积金账号
    ,hght varchar2(8) -- 身高
    ,wght varchar2(8) -- 体重
    ,mon_in number(20,2) -- 月收入
    ,year_in number(20,2) -- 年收入
    ,family_mon_in number(20,2) -- 家庭月收入
    ,family_in number(20,2) -- 家庭年收入
    ,salary_acc_num varchar2(150) -- 工资帐号
    ,salary_acc_num_bank varchar2(150) -- 工资帐号开户银行
    ,interests varchar2(150) -- 兴趣爱好
    ,blood_type_cd varchar2(11) -- 血型
    ,security_grade varchar2(75) -- 客户安全等级
    ,is_indiv_merchant varchar2(2) -- 是否为个体工商户
    ,indiv_busi_type varchar2(150) -- 个体工商户证件类型
    ,indiv_busi_license varchar2(150) -- 个体工商户证件号码
    ,is_small_micro_ent varchar2(2) -- 是否为小微企业主
    ,small_micro_ent_type varchar2(150) -- 小微企业主证件类型
    ,small_micro_ent_license varchar2(150) -- 小微企业主证件号码
    ,marketing_num varchar2(30) -- 营销活动编号
    ,int_crdt_rating_cd varchar2(3) -- 内部信用评级
    ,loan_card_num_status varchar2(3) -- 贷款卡号状态
    ,graduate_school varchar2(450) -- 毕业院校
    ,card_type varchar2(2) -- 开卡类型
    ,create_te varchar2(12) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,tax_year_in number(20,6) -- 纳税人年收入
    ,cust_risk_level varchar2(3) -- 客户风评等级
    ,risk_validity_period timestamp -- 风评有效期
    ,risk_assessment_completed varchar2(30) -- 是否已完成临柜风评
    ,risk_assessment_version varchar2(30) -- 风评问卷版本号
    ,risk_estim_score varchar2(30) -- 风评评估得分
    ,risk_update_ts timestamp -- 风评更新时间
    ,risk_update_te varchar2(30) -- 风评更新渠道
    ,send_marketing_sms_flag varchar2(3) -- 是否同意发送营销信息短信
    ,elig_inve_cert_flg varchar2(9) -- 合格投资者认证标志
    ,elig_inve_validper varchar2(12) -- 合格投资者有限期
    ,elig_inve_src_chn varchar2(15) -- 合格投资者来源渠道
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
    ,revenue_currency varchar2(5) -- 收入币种
    ,belong_indus_cd varchar2(30) -- 所属行业类型
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
grant select on ${iol_schema}.eifs_t01_per_cust_ext_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_ext_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_ext_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_per_cust_ext_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_per_cust_ext_info is '对私客户扩展信息';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.cust_card_level_cd is '客户持卡等级';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.cust_asset_level_cd is '客户资产等级';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.cust_risk_level_cd is '风险等级';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.bad_rec_reason is '不良记录原因';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.credit_limit_flag_cd is '综合授信额度';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.used_crdt_limit is '已用授信额度';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.avail_crdt_limit is '可用授信额度';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.loan_card_num is '贷款卡号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.resdnt_char_cd is '居民性质';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.resdnt_situ_cd is '居住状况';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.socl_card_no is '社保卡卡号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.fund_acct_no is '公积金账号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.hght is '身高';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.wght is '体重';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.mon_in is '月收入';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.year_in is '年收入';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.family_mon_in is '家庭月收入';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.family_in is '家庭年收入';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.salary_acc_num is '工资帐号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.salary_acc_num_bank is '工资帐号开户银行';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.interests is '兴趣爱好';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.blood_type_cd is '血型';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.security_grade is '客户安全等级';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.is_indiv_merchant is '是否为个体工商户';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.indiv_busi_type is '个体工商户证件类型';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.indiv_busi_license is '个体工商户证件号码';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.is_small_micro_ent is '是否为小微企业主';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.small_micro_ent_type is '小微企业主证件类型';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.small_micro_ent_license is '小微企业主证件号码';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.marketing_num is '营销活动编号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.int_crdt_rating_cd is '内部信用评级';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.loan_card_num_status is '贷款卡号状态';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.graduate_school is '毕业院校';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.card_type is '开卡类型';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.tax_year_in is '纳税人年收入';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.cust_risk_level is '客户风评等级';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.risk_validity_period is '风评有效期';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.risk_assessment_completed is '是否已完成临柜风评';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.risk_assessment_version is '风评问卷版本号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.risk_estim_score is '风评评估得分';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.risk_update_ts is '风评更新时间';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.risk_update_te is '风评更新渠道';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.send_marketing_sms_flag is '是否同意发送营销信息短信';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.elig_inve_cert_flg is '合格投资者认证标志';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.elig_inve_validper is '合格投资者有限期';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.elig_inve_src_chn is '合格投资者来源渠道';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.revenue_currency is '收入币种';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.belong_indus_cd is '所属行业类型';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_per_cust_ext_info.etl_timestamp is 'ETL处理时间戳';
