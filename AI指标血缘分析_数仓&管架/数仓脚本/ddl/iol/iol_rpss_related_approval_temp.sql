/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rpss_related_approval_temp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rpss_related_approval_temp
whenever sqlerror continue none;
drop table ${iol_schema}.rpss_related_approval_temp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_related_approval_temp(
    last_updated_stamp timestamp -- 最后更新时间
    ,approval_person varchar2(50) -- 审批人
    ,status_id varchar2(20) -- 状态
    ,registration_org varchar2(100) -- 登记机构
    ,registration_date timestamp -- 登记时间
    ,thru_date timestamp -- 失效时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,related_duty varchar2(100) -- 在关联单位担任的职务
    ,certificate_no varchar2(60) -- 证件号码1
    ,certificate_no_dg_t varchar2(60) -- 对公证件号码2
    ,certificate_no_dg varchar2(60) -- 对公证件号码1
    ,approval_date timestamp -- 审批时间
    ,relation_type varchar2(20) -- 与上一层的管理方关系
    ,domestic_or_foreign_dg_t varchar2(20) -- 对公证件类型境内外2
    ,domestic_or_foreign_dg varchar2(20) -- 对公证件类型境内外1
    ,domestic_or_foreign_t varchar2(20) -- 证件类型境内外2
    ,domestic_or_foreign varchar2(20) -- 证件类型境内外1
    ,product_name varchar2(200) -- 金融产品全称
    ,product_issue_no varchar2(100) -- 产品批准/注册/备案号
    ,product_register_no varchar2(100) -- 产品代码
    ,product_type varchar2(10) -- 产品分类
    ,register_org varchar2(100) -- 产品登记机构
    ,product_owner varchar2(100) -- 产品管理人全称
    ,product_owner_unisc_code varchar2(40) -- 产品管理人统一社会信用代码
    ,product_custodian varchar2(100) -- 产品托管人全称
    ,product_custodian_unisc_code varchar2(40) -- 产品托管人统一社会信用代码
    ,from_date varchar2(20) -- 有效开始日期
    ,certificate_type_id_dg varchar2(60) -- 对公证件类型1
    ,organization varchar2(60) -- 所属机构
    ,reject_reason varchar2(500) -- 拒绝原因
    ,group_name varchar2(60) -- 单位归属的企业集团全称
    ,comments varchar2(255) -- 备注
    ,related_unit varchar2(100) -- 关联单位全称
    ,registrant varchar2(100) -- 登记人
    ,registration_org_apl varchar2(100) -- 审批机构
    ,certificate_type_id varchar2(20) -- 证件类型1
    ,created_tx_stamp timestamp -- 创建业务时间
    ,shareholding_ratio varchar2(20) -- 持股比例
    ,unit_name varchar2(100) -- 关联方名称(对公)
    ,kinship varchar2(20) -- 近亲属
    ,belong_org varchar2(60) -- 归属机构
    ,related_relationship_type_id varchar2(20) -- 关联关系
    ,department varchar2(100) -- 所属部门
    ,certificate_type_id_dg_t varchar2(60) -- 对公证件类型2
    ,relation varchar2(30) -- 担任职务或关联关系
    ,mainten_org varchar2(60) -- 维护机构
    ,duty varchar2(100) -- 本行岗位或职务
    ,related_id varchar2(20) -- 关联方编号
    ,created_stamp timestamp -- 创建时间
    ,related_id_from varchar2(20) -- 上级关联方编号
    ,certificate_type_id_t varchar2(20) -- 证件类型2
    ,person_name varchar2(100) -- 姓名
    ,certificate_no_t varchar2(60) -- 证件号码2
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
grant select on ${iol_schema}.rpss_related_approval_temp to ${iml_schema};
grant select on ${iol_schema}.rpss_related_approval_temp to ${icl_schema};
grant select on ${iol_schema}.rpss_related_approval_temp to ${idl_schema};
grant select on ${iol_schema}.rpss_related_approval_temp to ${iel_schema};

-- comment
comment on table ${iol_schema}.rpss_related_approval_temp is '关联方审批信息表';
comment on column ${iol_schema}.rpss_related_approval_temp.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.rpss_related_approval_temp.approval_person is '审批人';
comment on column ${iol_schema}.rpss_related_approval_temp.status_id is '状态';
comment on column ${iol_schema}.rpss_related_approval_temp.registration_org is '登记机构';
comment on column ${iol_schema}.rpss_related_approval_temp.registration_date is '登记时间';
comment on column ${iol_schema}.rpss_related_approval_temp.thru_date is '失效时间';
comment on column ${iol_schema}.rpss_related_approval_temp.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.rpss_related_approval_temp.related_duty is '在关联单位担任的职务';
comment on column ${iol_schema}.rpss_related_approval_temp.certificate_no is '证件号码1';
comment on column ${iol_schema}.rpss_related_approval_temp.certificate_no_dg_t is '对公证件号码2';
comment on column ${iol_schema}.rpss_related_approval_temp.certificate_no_dg is '对公证件号码1';
comment on column ${iol_schema}.rpss_related_approval_temp.approval_date is '审批时间';
comment on column ${iol_schema}.rpss_related_approval_temp.relation_type is '与上一层的管理方关系';
comment on column ${iol_schema}.rpss_related_approval_temp.domestic_or_foreign_dg_t is '对公证件类型境内外2';
comment on column ${iol_schema}.rpss_related_approval_temp.domestic_or_foreign_dg is '对公证件类型境内外1';
comment on column ${iol_schema}.rpss_related_approval_temp.domestic_or_foreign_t is '证件类型境内外2';
comment on column ${iol_schema}.rpss_related_approval_temp.domestic_or_foreign is '证件类型境内外1';
comment on column ${iol_schema}.rpss_related_approval_temp.product_name is '金融产品全称';
comment on column ${iol_schema}.rpss_related_approval_temp.product_issue_no is '产品批准/注册/备案号';
comment on column ${iol_schema}.rpss_related_approval_temp.product_register_no is '产品代码';
comment on column ${iol_schema}.rpss_related_approval_temp.product_type is '产品分类';
comment on column ${iol_schema}.rpss_related_approval_temp.register_org is '产品登记机构';
comment on column ${iol_schema}.rpss_related_approval_temp.product_owner is '产品管理人全称';
comment on column ${iol_schema}.rpss_related_approval_temp.product_owner_unisc_code is '产品管理人统一社会信用代码';
comment on column ${iol_schema}.rpss_related_approval_temp.product_custodian is '产品托管人全称';
comment on column ${iol_schema}.rpss_related_approval_temp.product_custodian_unisc_code is '产品托管人统一社会信用代码';
comment on column ${iol_schema}.rpss_related_approval_temp.from_date is '有效开始日期';
comment on column ${iol_schema}.rpss_related_approval_temp.certificate_type_id_dg is '对公证件类型1';
comment on column ${iol_schema}.rpss_related_approval_temp.organization is '所属机构';
comment on column ${iol_schema}.rpss_related_approval_temp.reject_reason is '拒绝原因';
comment on column ${iol_schema}.rpss_related_approval_temp.group_name is '单位归属的企业集团全称';
comment on column ${iol_schema}.rpss_related_approval_temp.comments is '备注';
comment on column ${iol_schema}.rpss_related_approval_temp.related_unit is '关联单位全称';
comment on column ${iol_schema}.rpss_related_approval_temp.registrant is '登记人';
comment on column ${iol_schema}.rpss_related_approval_temp.registration_org_apl is '审批机构';
comment on column ${iol_schema}.rpss_related_approval_temp.certificate_type_id is '证件类型1';
comment on column ${iol_schema}.rpss_related_approval_temp.created_tx_stamp is '创建业务时间';
comment on column ${iol_schema}.rpss_related_approval_temp.shareholding_ratio is '持股比例';
comment on column ${iol_schema}.rpss_related_approval_temp.unit_name is '关联方名称(对公)';
comment on column ${iol_schema}.rpss_related_approval_temp.kinship is '近亲属';
comment on column ${iol_schema}.rpss_related_approval_temp.belong_org is '归属机构';
comment on column ${iol_schema}.rpss_related_approval_temp.related_relationship_type_id is '关联关系';
comment on column ${iol_schema}.rpss_related_approval_temp.department is '所属部门';
comment on column ${iol_schema}.rpss_related_approval_temp.certificate_type_id_dg_t is '对公证件类型2';
comment on column ${iol_schema}.rpss_related_approval_temp.relation is '担任职务或关联关系';
comment on column ${iol_schema}.rpss_related_approval_temp.mainten_org is '维护机构';
comment on column ${iol_schema}.rpss_related_approval_temp.duty is '本行岗位或职务';
comment on column ${iol_schema}.rpss_related_approval_temp.related_id is '关联方编号';
comment on column ${iol_schema}.rpss_related_approval_temp.created_stamp is '创建时间';
comment on column ${iol_schema}.rpss_related_approval_temp.related_id_from is '上级关联方编号';
comment on column ${iol_schema}.rpss_related_approval_temp.certificate_type_id_t is '证件类型2';
comment on column ${iol_schema}.rpss_related_approval_temp.person_name is '姓名';
comment on column ${iol_schema}.rpss_related_approval_temp.certificate_no_t is '证件号码2';
comment on column ${iol_schema}.rpss_related_approval_temp.hold_related_type is '股东或关联方类型';
comment on column ${iol_schema}.rpss_related_approval_temp.hold_related_industry is '股东或关联方所属行业';
comment on column ${iol_schema}.rpss_related_approval_temp.hold_related_reg_address is '股东或关联方注册地';
comment on column ${iol_schema}.rpss_related_approval_temp.hold_related_rel_type is '股东或关联方关系类型';
comment on column ${iol_schema}.rpss_related_approval_temp.start_dt is '开始时间';
comment on column ${iol_schema}.rpss_related_approval_temp.end_dt is '结束时间';
comment on column ${iol_schema}.rpss_related_approval_temp.id_mark is '增删标志';
comment on column ${iol_schema}.rpss_related_approval_temp.etl_timestamp is 'ETL处理时间戳';
