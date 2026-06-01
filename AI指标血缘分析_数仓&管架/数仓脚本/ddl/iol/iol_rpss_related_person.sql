/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rpss_related_person
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rpss_related_person
whenever sqlerror continue none;
drop table ${iol_schema}.rpss_related_person purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_related_person(
    related_id varchar2(20) -- 关联方编号
    ,person_name varchar2(100) -- 姓名
    ,certificate_type_id varchar2(20) -- 证件类型
    ,certificate_no varchar2(60) -- 证件号码
    ,kinship varchar2(20) -- 近亲属
    ,organization varchar2(60) -- 所属机构
    ,department varchar2(100) -- 所属部门
    ,duty varchar2(100) -- 本行岗位或职务
    ,dimission_date timestamp -- 离职时间
    ,related_unit varchar2(100) -- 关联单位全称
    ,related_duty varchar2(100) -- 在关联单位担任的职务
    ,shareholding_ratio varchar2(20) -- 持股比例
    ,comments varchar2(255) -- 备注
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,certificate_type_id_t varchar2(20) -- 证件类型2
    ,certificate_no_t varchar2(60) -- 证件号码2
    ,belong_org varchar2(60) -- 归属机构
    ,mainten_org varchar2(60) -- 维护机构
    ,domestic_or_foreign varchar2(20) -- 境内外标志1
    ,domestic_or_foreign_t varchar2(20) -- 境内外标志2
    ,hold_related_type varchar2(20) -- 股东或关联方类型
    ,hold_related_industry varchar2(20) -- 股东或关联方所属行业
    ,hold_related_reg_address varchar2(255) -- 股东或关联方注册地
    ,hold_related_rel_type varchar2(20) -- 股东或关联方关系类型
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
grant select on ${iol_schema}.rpss_related_person to ${iml_schema};
grant select on ${iol_schema}.rpss_related_person to ${icl_schema};
grant select on ${iol_schema}.rpss_related_person to ${idl_schema};
grant select on ${iol_schema}.rpss_related_person to ${iel_schema};

-- comment
comment on table ${iol_schema}.rpss_related_person is '个人';
comment on column ${iol_schema}.rpss_related_person.related_id is '关联方编号';
comment on column ${iol_schema}.rpss_related_person.person_name is '姓名';
comment on column ${iol_schema}.rpss_related_person.certificate_type_id is '证件类型';
comment on column ${iol_schema}.rpss_related_person.certificate_no is '证件号码';
comment on column ${iol_schema}.rpss_related_person.kinship is '近亲属';
comment on column ${iol_schema}.rpss_related_person.organization is '所属机构';
comment on column ${iol_schema}.rpss_related_person.department is '所属部门';
comment on column ${iol_schema}.rpss_related_person.duty is '本行岗位或职务';
comment on column ${iol_schema}.rpss_related_person.dimission_date is '离职时间';
comment on column ${iol_schema}.rpss_related_person.related_unit is '关联单位全称';
comment on column ${iol_schema}.rpss_related_person.related_duty is '在关联单位担任的职务';
comment on column ${iol_schema}.rpss_related_person.shareholding_ratio is '持股比例';
comment on column ${iol_schema}.rpss_related_person.comments is '备注';
comment on column ${iol_schema}.rpss_related_person.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.rpss_related_person.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.rpss_related_person.created_stamp is '创建时间';
comment on column ${iol_schema}.rpss_related_person.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.rpss_related_person.certificate_type_id_t is '证件类型2';
comment on column ${iol_schema}.rpss_related_person.certificate_no_t is '证件号码2';
comment on column ${iol_schema}.rpss_related_person.belong_org is '归属机构';
comment on column ${iol_schema}.rpss_related_person.mainten_org is '维护机构';
comment on column ${iol_schema}.rpss_related_person.domestic_or_foreign is '境内外标志1';
comment on column ${iol_schema}.rpss_related_person.domestic_or_foreign_t is '境内外标志2';
comment on column ${iol_schema}.rpss_related_person.hold_related_type is '股东或关联方类型';
comment on column ${iol_schema}.rpss_related_person.hold_related_industry is '股东或关联方所属行业';
comment on column ${iol_schema}.rpss_related_person.hold_related_reg_address is '股东或关联方注册地';
comment on column ${iol_schema}.rpss_related_person.hold_related_rel_type is '股东或关联方关系类型';
comment on column ${iol_schema}.rpss_related_person.start_dt is '开始时间';
comment on column ${iol_schema}.rpss_related_person.end_dt is '结束时间';
comment on column ${iol_schema}.rpss_related_person.id_mark is '增删标志';
comment on column ${iol_schema}.rpss_related_person.etl_timestamp is 'ETL处理时间戳';
