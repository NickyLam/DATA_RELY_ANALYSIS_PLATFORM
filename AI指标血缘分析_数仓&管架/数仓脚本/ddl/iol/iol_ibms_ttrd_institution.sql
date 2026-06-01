/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_institution
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_institution
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_institution purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution(
    i_id number(22) -- 机构id
    ,org_id varchar2(45) -- 机构号
    ,i_name varchar2(383) -- 公司名称
    ,i_fullname varchar2(383) -- 公司全称
    ,i_alias varchar2(383) -- 公司别名
    ,py_code varchar2(383) -- 拼音码
    ,status varchar2(12) -- 状态 0 创建中 1 以启用 2 停用
    ,t_code number(22) -- 分类代码(对机构进行多级分类)
    ,p_type number(22) -- 产品类型
    ,online_date varchar2(15) -- 成立日期
    ,i_business_license varchar2(75) -- 营业执照
    ,i_lr_inst_code varchar2(75) -- 机构代码证
    ,i_financial_license varchar2(75) -- 金融许可证
    ,cnaps_code varchar2(75) -- 现代支付系统行号(本币)
    ,swift_code varchar2(150) -- 现代支付系统行号(外币)
    ,update_user varchar2(150) -- 更新用户
    ,update_date varchar2(15) -- 更新日期
    ,update_time varchar2(15) -- 更新时间
    ,belong_to_area varchar2(150) -- 总行或总公司注册地
    ,pipe_id number(22) -- 导入管道
    ,imp_date varchar2(15) -- 导入日期
    ,core_sys_customer_code varchar2(75) -- 核心客户号
    ,t_path varchar2(300) -- 客户分类
    ,i_level varchar2(2) -- 机构层级
    ,edit_iid number(22) -- 维护机构
    ,edit_iname varchar2(383) -- 维护机构名称
    ,issuer_code varchar2(90) -- 发行代码
    ,cfets_member_id varchar2(75) -- 外汇交易中心会员号
    ,inst_class varchar2(45) -- 客户类型
    ,member_id varchar2(75) -- 中心会员id
    ,is_market_maker varchar2(2) -- 1:做市商 0:非做市商
    ,rev_state varchar2(2) -- 是否生效
    ,en_name varchar2(383) -- 英文简称
    ,en_fullname varchar2(383) -- 英文全称
    ,cfets_org_code varchar2(45) -- 下行机构代码
    ,create_user varchar2(150) -- 创建用户
    ,acctg_i_id varchar2(75) -- 记账机构
    ,is_spv varchar2(2) -- 是否是spv  0：非spv（默认） 1: spv
    ,rwa_code number(22) -- rwa客户分类代码
    ,rwa_name varchar2(300) -- rwa客户分类名称
    ,spv_manager varchar2(383) -- spv管理人
    ,address varchar2(300) -- 
    ,legal_representative varchar2(150) -- 
    ,is_ticketinfo varchar2(2) -- 
    ,main_protocol_code varchar2(150) -- 
    ,i_level_m varchar2(15) -- 机构级别,数据标准落标,触发器添加
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
grant select on ${iol_schema}.ibms_ttrd_institution to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_institution to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_institution is '客户信息及机构表';
comment on column ${iol_schema}.ibms_ttrd_institution.i_id is '机构id';
comment on column ${iol_schema}.ibms_ttrd_institution.org_id is '机构号';
comment on column ${iol_schema}.ibms_ttrd_institution.i_name is '公司名称';
comment on column ${iol_schema}.ibms_ttrd_institution.i_fullname is '公司全称';
comment on column ${iol_schema}.ibms_ttrd_institution.i_alias is '公司别名';
comment on column ${iol_schema}.ibms_ttrd_institution.py_code is '拼音码';
comment on column ${iol_schema}.ibms_ttrd_institution.status is '状态 0 创建中 1 以启用 2 停用';
comment on column ${iol_schema}.ibms_ttrd_institution.t_code is '分类代码(对机构进行多级分类)';
comment on column ${iol_schema}.ibms_ttrd_institution.p_type is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_institution.online_date is '成立日期';
comment on column ${iol_schema}.ibms_ttrd_institution.i_business_license is '营业执照';
comment on column ${iol_schema}.ibms_ttrd_institution.i_lr_inst_code is '机构代码证';
comment on column ${iol_schema}.ibms_ttrd_institution.i_financial_license is '金融许可证';
comment on column ${iol_schema}.ibms_ttrd_institution.cnaps_code is '现代支付系统行号(本币)';
comment on column ${iol_schema}.ibms_ttrd_institution.swift_code is '现代支付系统行号(外币)';
comment on column ${iol_schema}.ibms_ttrd_institution.update_user is '更新用户';
comment on column ${iol_schema}.ibms_ttrd_institution.update_date is '更新日期';
comment on column ${iol_schema}.ibms_ttrd_institution.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_institution.belong_to_area is '总行或总公司注册地';
comment on column ${iol_schema}.ibms_ttrd_institution.pipe_id is '导入管道';
comment on column ${iol_schema}.ibms_ttrd_institution.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_ttrd_institution.core_sys_customer_code is '核心客户号';
comment on column ${iol_schema}.ibms_ttrd_institution.t_path is '客户分类';
comment on column ${iol_schema}.ibms_ttrd_institution.i_level is '机构层级';
comment on column ${iol_schema}.ibms_ttrd_institution.edit_iid is '维护机构';
comment on column ${iol_schema}.ibms_ttrd_institution.edit_iname is '维护机构名称';
comment on column ${iol_schema}.ibms_ttrd_institution.issuer_code is '发行代码';
comment on column ${iol_schema}.ibms_ttrd_institution.cfets_member_id is '外汇交易中心会员号';
comment on column ${iol_schema}.ibms_ttrd_institution.inst_class is '客户类型';
comment on column ${iol_schema}.ibms_ttrd_institution.member_id is '中心会员id';
comment on column ${iol_schema}.ibms_ttrd_institution.is_market_maker is '1:做市商 0:非做市商';
comment on column ${iol_schema}.ibms_ttrd_institution.rev_state is '是否生效';
comment on column ${iol_schema}.ibms_ttrd_institution.en_name is '英文简称';
comment on column ${iol_schema}.ibms_ttrd_institution.en_fullname is '英文全称';
comment on column ${iol_schema}.ibms_ttrd_institution.cfets_org_code is '下行机构代码';
comment on column ${iol_schema}.ibms_ttrd_institution.create_user is '创建用户';
comment on column ${iol_schema}.ibms_ttrd_institution.acctg_i_id is '记账机构';
comment on column ${iol_schema}.ibms_ttrd_institution.is_spv is '是否是spv  0：非spv（默认） 1: spv';
comment on column ${iol_schema}.ibms_ttrd_institution.rwa_code is 'rwa客户分类代码';
comment on column ${iol_schema}.ibms_ttrd_institution.rwa_name is 'rwa客户分类名称';
comment on column ${iol_schema}.ibms_ttrd_institution.spv_manager is 'spv管理人';
comment on column ${iol_schema}.ibms_ttrd_institution.address is '';
comment on column ${iol_schema}.ibms_ttrd_institution.legal_representative is '';
comment on column ${iol_schema}.ibms_ttrd_institution.is_ticketinfo is '';
comment on column ${iol_schema}.ibms_ttrd_institution.main_protocol_code is '';
comment on column ${iol_schema}.ibms_ttrd_institution.i_level_m is '机构级别,数据标准落标,触发器添加';
comment on column ${iol_schema}.ibms_ttrd_institution.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_institution.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_institution.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_institution.etl_timestamp is 'ETL处理时间戳';
