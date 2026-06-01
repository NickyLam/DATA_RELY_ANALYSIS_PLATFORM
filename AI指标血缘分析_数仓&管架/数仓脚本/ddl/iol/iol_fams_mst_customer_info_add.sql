/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_mst_customer_info_add
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_mst_customer_info_add
whenever sqlerror continue none;
drop table ${iol_schema}.fams_mst_customer_info_add purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_customer_info_add(
    customer_id varchar2(32) -- 客户代码
    ,party_type3 varchar2(50) -- 机构类型（技术领域），高新技术企业、其他
    ,party_type2 varchar2(50) -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
    ,party_type1 varchar2(50) -- 机构类型（规模），大型企业、中小微企业
    ,industry varchar2(50) -- 国标一级分类
    ,industry2 varchar2(50) -- 国标二级分类
    ,insititute_code varchar2(50) -- 组织机构代码/统一社会信用代码
    ,is_gov varchar2(50) -- 是否政府融资平台
    ,main_capital number(30,14) -- 核心资本（万元），存的是万元
    ,register_capital number(30,14) -- 注册资本（万元），存的是万元
    ,province varchar2(50) -- 所属省
    ,city varchar2(50) -- 所属市
    ,county varchar2(50) -- 所属县
    ,holding_type varchar2(50) -- 控股类型
    ,customer_obj_type varchar2(50) -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
    ,is_listed_company varchar2(50) -- 是否上市公司
    ,is_group_customer varchar2(50) -- 是否集团客户
    ,parent_customer_id varchar2(32) -- 所属集团客户编号
    ,parent_customer_name varchar2(200) -- 所属集团客户名称
    ,is_private varchar2(50) -- 是否民营企业
    ,is_escape_dept varchar2(50) -- 是否为逃废债企业
    ,credit_type varchar2(50) -- 授信策略
    ,is_credit_related_trd varchar2(50) -- 是否授信类关联交易
    ,struct_adjust_type varchar2(50) -- 产业结构调整类型
    ,indus_upgrate_type varchar2(50) -- 工业转型升级标识
    ,busi_scope varchar2(4000) -- 经营范围
    ,main_busi varchar2(4000) -- 主营业务
    ,sex varchar2(50) -- 性别
    ,person_id varchar2(32) -- 身份证
    ,m_phone varchar2(50) -- 移动电话
    ,phone varchar2(50) -- 办公电话
    ,position varchar2(200) -- 职位
    ,company_name varchar2(200) -- 工作单位
    ,address varchar2(200) -- 住址
    ,mail varchar2(50) -- 电子邮箱
    ,property varchar2(1000) -- 财产状况
    ,company_nature varchar2(50) -- 企业性质
    ,link_id1 varchar2(100) -- 外部代码1，存万得代码
    ,link_id2 varchar2(100) -- 外部代码2，对于平安存客户编号
    ,link_id3 varchar2(100) -- 外部代码3
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,hs_type varchar2(50) -- 核算分类
    ,is_fin_licence varchar2(50) -- 是否持有金融牌照
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
grant select on ${iol_schema}.fams_mst_customer_info_add to ${iml_schema};
grant select on ${iol_schema}.fams_mst_customer_info_add to ${icl_schema};
grant select on ${iol_schema}.fams_mst_customer_info_add to ${idl_schema};
grant select on ${iol_schema}.fams_mst_customer_info_add to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_mst_customer_info_add is '客户信息附属表';
comment on column ${iol_schema}.fams_mst_customer_info_add.customer_id is '客户代码';
comment on column ${iol_schema}.fams_mst_customer_info_add.party_type3 is '机构类型（技术领域），高新技术企业、其他';
comment on column ${iol_schema}.fams_mst_customer_info_add.party_type2 is '机构类型（经济类型），国有企业、集体企业、民营企业、其他企业';
comment on column ${iol_schema}.fams_mst_customer_info_add.party_type1 is '机构类型（规模），大型企业、中小微企业';
comment on column ${iol_schema}.fams_mst_customer_info_add.industry is '国标一级分类';
comment on column ${iol_schema}.fams_mst_customer_info_add.industry2 is '国标二级分类';
comment on column ${iol_schema}.fams_mst_customer_info_add.insititute_code is '组织机构代码/统一社会信用代码';
comment on column ${iol_schema}.fams_mst_customer_info_add.is_gov is '是否政府融资平台';
comment on column ${iol_schema}.fams_mst_customer_info_add.main_capital is '核心资本（万元），存的是万元';
comment on column ${iol_schema}.fams_mst_customer_info_add.register_capital is '注册资本（万元），存的是万元';
comment on column ${iol_schema}.fams_mst_customer_info_add.province is '所属省';
comment on column ${iol_schema}.fams_mst_customer_info_add.city is '所属市';
comment on column ${iol_schema}.fams_mst_customer_info_add.county is '所属县';
comment on column ${iol_schema}.fams_mst_customer_info_add.holding_type is '控股类型';
comment on column ${iol_schema}.fams_mst_customer_info_add.customer_obj_type is '客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等';
comment on column ${iol_schema}.fams_mst_customer_info_add.is_listed_company is '是否上市公司';
comment on column ${iol_schema}.fams_mst_customer_info_add.is_group_customer is '是否集团客户';
comment on column ${iol_schema}.fams_mst_customer_info_add.parent_customer_id is '所属集团客户编号';
comment on column ${iol_schema}.fams_mst_customer_info_add.parent_customer_name is '所属集团客户名称';
comment on column ${iol_schema}.fams_mst_customer_info_add.is_private is '是否民营企业';
comment on column ${iol_schema}.fams_mst_customer_info_add.is_escape_dept is '是否为逃废债企业';
comment on column ${iol_schema}.fams_mst_customer_info_add.credit_type is '授信策略';
comment on column ${iol_schema}.fams_mst_customer_info_add.is_credit_related_trd is '是否授信类关联交易';
comment on column ${iol_schema}.fams_mst_customer_info_add.struct_adjust_type is '产业结构调整类型';
comment on column ${iol_schema}.fams_mst_customer_info_add.indus_upgrate_type is '工业转型升级标识';
comment on column ${iol_schema}.fams_mst_customer_info_add.busi_scope is '经营范围';
comment on column ${iol_schema}.fams_mst_customer_info_add.main_busi is '主营业务';
comment on column ${iol_schema}.fams_mst_customer_info_add.sex is '性别';
comment on column ${iol_schema}.fams_mst_customer_info_add.person_id is '身份证';
comment on column ${iol_schema}.fams_mst_customer_info_add.m_phone is '移动电话';
comment on column ${iol_schema}.fams_mst_customer_info_add.phone is '办公电话';
comment on column ${iol_schema}.fams_mst_customer_info_add.position is '职位';
comment on column ${iol_schema}.fams_mst_customer_info_add.company_name is '工作单位';
comment on column ${iol_schema}.fams_mst_customer_info_add.address is '住址';
comment on column ${iol_schema}.fams_mst_customer_info_add.mail is '电子邮箱';
comment on column ${iol_schema}.fams_mst_customer_info_add.property is '财产状况';
comment on column ${iol_schema}.fams_mst_customer_info_add.company_nature is '企业性质';
comment on column ${iol_schema}.fams_mst_customer_info_add.link_id1 is '外部代码1，存万得代码';
comment on column ${iol_schema}.fams_mst_customer_info_add.link_id2 is '外部代码2，对于平安存客户编号';
comment on column ${iol_schema}.fams_mst_customer_info_add.link_id3 is '外部代码3';
comment on column ${iol_schema}.fams_mst_customer_info_add.remark is '备注';
comment on column ${iol_schema}.fams_mst_customer_info_add.create_user is '创建人';
comment on column ${iol_schema}.fams_mst_customer_info_add.create_dept is '创建部门';
comment on column ${iol_schema}.fams_mst_customer_info_add.create_time is '创建时间';
comment on column ${iol_schema}.fams_mst_customer_info_add.update_user is '更新人';
comment on column ${iol_schema}.fams_mst_customer_info_add.update_time is '更新时间';
comment on column ${iol_schema}.fams_mst_customer_info_add.hs_type is '核算分类';
comment on column ${iol_schema}.fams_mst_customer_info_add.is_fin_licence is '是否持有金融牌照';
comment on column ${iol_schema}.fams_mst_customer_info_add.start_dt is '开始时间';
comment on column ${iol_schema}.fams_mst_customer_info_add.end_dt is '结束时间';
comment on column ${iol_schema}.fams_mst_customer_info_add.id_mark is '增删标志';
comment on column ${iol_schema}.fams_mst_customer_info_add.etl_timestamp is 'ETL处理时间戳';
