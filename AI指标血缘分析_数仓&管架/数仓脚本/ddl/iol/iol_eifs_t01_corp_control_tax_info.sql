/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_corp_control_tax_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_corp_control_tax_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_corp_control_tax_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_control_tax_info(
    rel_id varchar2(45) -- 关系人ID
    ,party_id varchar2(45) -- 参与人ID
    ,controller_type_cd varchar2(11) -- 控制人类型
    ,controller_cert_type_cd varchar2(11) -- 控制人证件类型
    ,controller_cert_num varchar2(90) -- 控制人证件号码
    ,tax_country varchar2(545) -- 税收居民国（地区）代码
    ,tax_number varchar2(546) -- 纳税人识别号
    ,issued_by varchar2(545) -- 发放识别号的国家（地区）代码
    ,tax_null_reason varchar2(3605) -- 纳税人识别号空值原因
    ,birth_city varchar2(90) -- 出生城市
    ,birth_country_cd varchar2(30) -- 出生国代码
    ,birth_country_en varchar2(300) -- 出生国英文名称
    ,legal_en_family_name varchar2(180) -- 法定英文（拼音）姓
    ,middle_name varchar2(180) -- 英文中间名
    ,legal_en_first_name varchar2(180) -- 法定英文（拼音）名
    ,controller_birth_place_cn varchar2(300) -- 控制人出生地（中文）
    ,controller_address_cn varchar2(300) -- 控制人现居地（中文）
    ,controller_address_en varchar2(300) -- 控制人现居地（英文或拼音）
    ,controller_tax_statement varchar2(300) -- 是否取得自证声明(税收居民)
    ,cn_name varchar2(300) -- 中文姓名
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,created_ts timestamp -- 进入ECIF的时间
    ,updated_ts timestamp -- 在ECIF中失效的时间
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
    ,create_org varchar2(15) -- 创建机构号
    ,create_te varchar2(12) -- 开户柜员编号
    ,tax_pay_ctzn_idnt varchar2(11) -- 税收居民身份代码
    ,birth_dt varchar2(12) -- 出生日期
    ,cert_invalid_dt varchar2(12) -- 证件失效日期
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
grant select on ${iol_schema}.eifs_t01_corp_control_tax_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_corp_control_tax_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_corp_control_tax_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_corp_control_tax_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_corp_control_tax_info is '对公控制人涉税信息';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.rel_id is '关系人ID';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.party_id is '参与人ID';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.controller_type_cd is '控制人类型';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.controller_cert_type_cd is '控制人证件类型';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.controller_cert_num is '控制人证件号码';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.tax_country is '税收居民国（地区）代码';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.tax_number is '纳税人识别号';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.issued_by is '发放识别号的国家（地区）代码';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.tax_null_reason is '纳税人识别号空值原因';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.birth_city is '出生城市';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.birth_country_cd is '出生国代码';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.birth_country_en is '出生国英文名称';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.legal_en_family_name is '法定英文（拼音）姓';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.middle_name is '英文中间名';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.legal_en_first_name is '法定英文（拼音）名';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.controller_birth_place_cn is '控制人出生地（中文）';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.controller_address_cn is '控制人现居地（中文）';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.controller_address_en is '控制人现居地（英文或拼音）';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.controller_tax_statement is '是否取得自证声明(税收居民)';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.cn_name is '中文姓名';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.created_ts is '进入ECIF的时间';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.updated_ts is '在ECIF中失效的时间';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.create_te is '开户柜员编号';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.tax_pay_ctzn_idnt is '税收居民身份代码';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.birth_dt is '出生日期';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.cert_invalid_dt is '证件失效日期';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_corp_control_tax_info.etl_timestamp is 'ETL处理时间戳';
