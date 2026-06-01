/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_corp_cust_ext_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_corp_cust_ext_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_corp_cust_ext_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_cust_ext_info(
    party_id varchar2(45) -- 参与人id
    ,cust_card_level_cd varchar2(2) -- 客户持卡等级
    ,cust_asset_level_cd varchar2(2) -- 客户资产等级
    ,cust_risk_level_cd varchar2(2) -- 风险等级
    ,bad_rec_reason varchar2(90) -- 不良记录原因
    ,blklist_cust_ind varchar2(2) -- 黑名单客户标志
    ,up_blklist_dt varchar2(12) -- 黑名单登记日期
    ,blklist_type varchar2(600) -- 上黑名单原因
    ,credit_limit_flag_cd number(20,2) -- 综合授信额度
    ,used_crdt_limit number(20,2) -- 已用授信额度
    ,avail_crdt_limit number(20,2) -- 可用授信额度
    ,loan_card_num varchar2(45) -- 贷款卡号
    ,resdnt_char_cd varchar2(2) -- 居民性质
    ,group_cust_ind varchar2(2) -- 集团客户标志
    ,belong_group_num varchar2(45) -- 所属集团编号
    ,belong_group_name varchar2(300) -- 所属集团名称
    ,eco_type varchar2(90) -- 所有制（经济）性质
    ,list_corp_ind varchar2(2) -- 上市公司标志
    ,shares_code varchar2(45) -- 股票代码
    ,listed_address varchar2(5) -- 上市地
    ,national_treatment varchar2(90) -- 国民待遇
    ,first_credit_rela_time varchar2(12) -- 首次建立信贷关系年月
    ,admin_number number(10,0) -- 管理人员人数
    ,lei varchar2(150) -- lei代码
    ,lei_role varchar2(150) -- lei角色
    ,dig_econ varchar2(2) -- 数字经济
    ,new_str_eme varchar2(2) -- 战略性新兴产业
    ,int_crdt_rating_cd varchar2(30) -- 内部信用评级
    ,org_status_cd varchar2(90) -- 机构状态
    ,eco_type_cd varchar2(15) -- 经济类型
    ,rgst_dt varchar2(12) -- 注册日期
    ,indus_type_cd_level5_cls varchar2(15) -- 行业类型(五级分类)
    ,indus_type_cd_crdt_rating varchar2(15) -- 行业类型(信用评级)
    ,open_cap number(18,2) -- 开办资金
    ,lmt_or_encrge_indus_cd varchar2(15) -- 限制或鼓励行业
    ,loan_card_num_status varchar2(3) -- 贷款卡号状态
    ,indus_type_cd_nat_stan varchar2(30) -- 行业类型-国标
    ,industry_type varchar2(15) -- 产业类型
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
    ,owner_type varchar2(3) -- 所有制类型
    ,legal_name varchar2(150) -- 法人机构名称
    ,legal_org_type varchar2(2) -- 法人机构类别
    ,legal_cust_num varchar2(24) -- 法人机构客户号
    ,superior_cust_num varchar2(24) -- 上级机构客户编号
    ,technology_org_type varchar2(2) -- 科技型企业分类
    ,technology_org_affirm_ts timestamp -- 科技型企业认定时间
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
    ,belong_type_cd varchar2(3) -- 所属类别
    ,self_info_flag varchar2(2) -- 自助维护标志
    ,beneficiary_status varchar2(45) -- 受益人识别状态
    ,beneficiary_attr varchar2(45) -- 受益所有人属性
    ,beneficial_owner varchar2(3) -- 受益所有人
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
grant select on ${iol_schema}.eifs_t01_corp_cust_ext_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_corp_cust_ext_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_corp_cust_ext_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_corp_cust_ext_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_corp_cust_ext_info is '对公客户扩展信息';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.cust_card_level_cd is '客户持卡等级';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.cust_asset_level_cd is '客户资产等级';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.cust_risk_level_cd is '风险等级';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.bad_rec_reason is '不良记录原因';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.blklist_cust_ind is '黑名单客户标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.up_blklist_dt is '黑名单登记日期';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.blklist_type is '上黑名单原因';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.credit_limit_flag_cd is '综合授信额度';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.used_crdt_limit is '已用授信额度';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.avail_crdt_limit is '可用授信额度';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.loan_card_num is '贷款卡号';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.resdnt_char_cd is '居民性质';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.group_cust_ind is '集团客户标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.belong_group_num is '所属集团编号';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.belong_group_name is '所属集团名称';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.eco_type is '所有制（经济）性质';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.list_corp_ind is '上市公司标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.shares_code is '股票代码';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.listed_address is '上市地';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.national_treatment is '国民待遇';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.first_credit_rela_time is '首次建立信贷关系年月';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.admin_number is '管理人员人数';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.lei is 'lei代码';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.lei_role is 'lei角色';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.dig_econ is '数字经济';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.new_str_eme is '战略性新兴产业';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.int_crdt_rating_cd is '内部信用评级';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.org_status_cd is '机构状态';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.eco_type_cd is '经济类型';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.rgst_dt is '注册日期';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.indus_type_cd_level5_cls is '行业类型(五级分类)';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.indus_type_cd_crdt_rating is '行业类型(信用评级)';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.open_cap is '开办资金';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.lmt_or_encrge_indus_cd is '限制或鼓励行业';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.loan_card_num_status is '贷款卡号状态';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.indus_type_cd_nat_stan is '行业类型-国标';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.industry_type is '产业类型';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.owner_type is '所有制类型';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.legal_name is '法人机构名称';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.legal_org_type is '法人机构类别';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.legal_cust_num is '法人机构客户号';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.superior_cust_num is '上级机构客户编号';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.technology_org_type is '科技型企业分类';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.technology_org_affirm_ts is '科技型企业认定时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.belong_type_cd is '所属类别';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.self_info_flag is '自助维护标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.beneficiary_status is '受益人识别状态';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.beneficiary_attr is '受益所有人属性';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.beneficial_owner is '受益所有人';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_corp_cust_ext_info.etl_timestamp is 'ETL处理时间戳';
