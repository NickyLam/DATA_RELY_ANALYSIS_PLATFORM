/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_party_relationship
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_party_relationship
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_party_relationship purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_party_relationship(
    party_id_from varchar2(30) -- 源当事人标识
    ,party_id_to varchar2(30) -- 目标当事人标识
    ,role_type_id_from varchar2(30) -- 源当事人角色类型标识
    ,role_type_id_to varchar2(30) -- 目标当事人角色类型标识
    ,from_date timestamp -- 开始日期
    ,thru_date timestamp -- 结束日期
    ,status_id varchar2(30) -- 状态标识
    ,relationship_name varchar2(150) -- 当事人关系名称
    ,security_group_id varchar2(30) -- 安全组标识
    ,priority_type_id varchar2(30) -- 优先类型标识
    ,party_relationship_type_id varchar2(30) -- 当事人关系类型标识
    ,permissions_enum_id varchar2(30) -- 权限枚举标识
    ,position_title varchar2(150) -- 职位头衔
    ,comments varchar2(383) -- 说明
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,cifseq varchar2(90) -- CIF编号
    ,shareholding_ratio varchar2(90) -- 持股比例
    ,sharetp varchar2(90) -- 高管类型/股东类型
    ,relationship_id varchar2(90) -- 
    ,share_holder_id varchar2(45) -- 股东编号
    ,share_holder_amount varchar2(23) -- 出资金额
    ,whether_controller varchar2(2) -- 是否控制人
    ,controller_tax_resident varchar2(2) -- 控制人税收居民身份
    ,controller_birth_date varchar2(12) -- 控制人出生日期
    ,controller_birth_place varchar2(300) -- 控制人出生地（中文）
    ,controller_address varchar2(300) -- 控制人现居地（中文）
    ,controller_tax_area varchar2(450) -- 控制人税收居民国（地区）
    ,controller_tax_number varchar2(450) -- 控制人纳税人识别号
    ,controller_tax_null_reason varchar2(1200) -- 控制人纳税人识别号空值原因
    ,controller_tax_statement varchar2(2) -- 是否取得自证声明(税收居民)
    ,controller_type varchar2(9) -- 控制人类型
    ,controller_english_name varchar2(150) -- 控制人姓名
    ,controller_birth_place_en varchar2(300) -- 控制人出生地（英文或拼音）
    ,controller_address_en varchar2(300) -- 控制人现居地（英文或拼音）
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
grant select on ${iol_schema}.eifs_party_relationship to ${iml_schema};
grant select on ${iol_schema}.eifs_party_relationship to ${icl_schema};
grant select on ${iol_schema}.eifs_party_relationship to ${idl_schema};
grant select on ${iol_schema}.eifs_party_relationship to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_party_relationship is '当事人关系表';
comment on column ${iol_schema}.eifs_party_relationship.party_id_from is '源当事人标识';
comment on column ${iol_schema}.eifs_party_relationship.party_id_to is '目标当事人标识';
comment on column ${iol_schema}.eifs_party_relationship.role_type_id_from is '源当事人角色类型标识';
comment on column ${iol_schema}.eifs_party_relationship.role_type_id_to is '目标当事人角色类型标识';
comment on column ${iol_schema}.eifs_party_relationship.from_date is '开始日期';
comment on column ${iol_schema}.eifs_party_relationship.thru_date is '结束日期';
comment on column ${iol_schema}.eifs_party_relationship.status_id is '状态标识';
comment on column ${iol_schema}.eifs_party_relationship.relationship_name is '当事人关系名称';
comment on column ${iol_schema}.eifs_party_relationship.security_group_id is '安全组标识';
comment on column ${iol_schema}.eifs_party_relationship.priority_type_id is '优先类型标识';
comment on column ${iol_schema}.eifs_party_relationship.party_relationship_type_id is '当事人关系类型标识';
comment on column ${iol_schema}.eifs_party_relationship.permissions_enum_id is '权限枚举标识';
comment on column ${iol_schema}.eifs_party_relationship.position_title is '职位头衔';
comment on column ${iol_schema}.eifs_party_relationship.comments is '说明';
comment on column ${iol_schema}.eifs_party_relationship.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_party_relationship.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_party_relationship.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_party_relationship.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_party_relationship.cifseq is 'CIF编号';
comment on column ${iol_schema}.eifs_party_relationship.shareholding_ratio is '持股比例';
comment on column ${iol_schema}.eifs_party_relationship.sharetp is '高管类型/股东类型';
comment on column ${iol_schema}.eifs_party_relationship.relationship_id is '';
comment on column ${iol_schema}.eifs_party_relationship.share_holder_id is '股东编号';
comment on column ${iol_schema}.eifs_party_relationship.share_holder_amount is '出资金额';
comment on column ${iol_schema}.eifs_party_relationship.whether_controller is '是否控制人';
comment on column ${iol_schema}.eifs_party_relationship.controller_tax_resident is '控制人税收居民身份';
comment on column ${iol_schema}.eifs_party_relationship.controller_birth_date is '控制人出生日期';
comment on column ${iol_schema}.eifs_party_relationship.controller_birth_place is '控制人出生地（中文）';
comment on column ${iol_schema}.eifs_party_relationship.controller_address is '控制人现居地（中文）';
comment on column ${iol_schema}.eifs_party_relationship.controller_tax_area is '控制人税收居民国（地区）';
comment on column ${iol_schema}.eifs_party_relationship.controller_tax_number is '控制人纳税人识别号';
comment on column ${iol_schema}.eifs_party_relationship.controller_tax_null_reason is '控制人纳税人识别号空值原因';
comment on column ${iol_schema}.eifs_party_relationship.controller_tax_statement is '是否取得自证声明(税收居民)';
comment on column ${iol_schema}.eifs_party_relationship.controller_type is '控制人类型';
comment on column ${iol_schema}.eifs_party_relationship.controller_english_name is '控制人姓名';
comment on column ${iol_schema}.eifs_party_relationship.controller_birth_place_en is '控制人出生地（英文或拼音）';
comment on column ${iol_schema}.eifs_party_relationship.controller_address_en is '控制人现居地（英文或拼音）';
comment on column ${iol_schema}.eifs_party_relationship.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_party_relationship.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_party_relationship.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_party_relationship.etl_timestamp is 'ETL处理时间戳';
