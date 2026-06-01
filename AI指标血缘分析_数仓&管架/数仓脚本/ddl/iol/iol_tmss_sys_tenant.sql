/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tmss_sys_tenant
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tmss_sys_tenant
whenever sqlerror continue none;
drop table ${iol_schema}.tmss_sys_tenant purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_tenant(
    id varchar2(144) -- 主键ID
    ,tenant_code varchar2(45) -- 客户号
    ,tenant_name varchar2(1350) -- 企业名称
    ,tenant_cert_type varchar2(5) -- 企业证件类型
    ,tenant_cert_code varchar2(225) -- 企业证件号码
    ,sign_code varchar2(90) -- 签约机构
    ,sign_time date -- 签约时间
    ,post_code varchar2(90) -- 邮政编码
    ,tenant_phone varchar2(90) -- 企业联系电话
    ,tenant_sina_name varchar2(450) -- 企业中文名称
    ,tenant_eng_name varchar2(450) -- 企业英文名称
    ,tenant_time date -- 企业证明文件有效期
    ,tenant_addr varchar2(1350) -- 企业地址
    ,fr_name varchar2(90) -- 法人/负责人
    ,fr_mobile varchar2(50) -- 法人联系方式
    ,fr_cert_type varchar2(9) -- 法人证件类型:01 第二代居民身份证、02 户口簿、03 临时身份证、04 中国护照、05 军官证、06 离休干部荣誉证、07 军官退休证、08 军事学员证、09 武警证、10 士兵证、11 香港通行证、12 澳门通行证、13 胞通行证或有效旅行证件、14 外国人永久居留证、15 边民出入境通行证、16:外国护照、99其他 (或采用柜面现有类别代码)
    ,fr_cert_code varchar2(81) -- 法人证件号码
    ,fr_cert_time varchar2(90) -- 法人证件有效期
    ,bank_seal_id varchar2(90) -- 影像流水
    ,charge_mode varchar2(9) -- 管理员模式: 0：否 1：是  如果是双冠 传输两个 校验list长度
    ,create_by varchar2(225) -- 创建人
    ,create_date date -- 创建时间
    ,update_by varchar2(225) -- 更新人
    ,update_date date -- 更新时间
    ,status number(10,0) -- 状态 0禁用 1启用
    ,sign_name varchar2(450) -- 签约机构名称
    ,un_sign_time date -- 解约时间
    ,sign_model varchar2(225) -- 签约客户模式  common：通用功能模式、query：仅查询模式
    ,sign_user_id varchar2(36) -- 签约柜员编码
    ,sign_agreement_id varchar2(450) -- 协议编码
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
grant select on ${iol_schema}.tmss_sys_tenant to ${iml_schema};
grant select on ${iol_schema}.tmss_sys_tenant to ${icl_schema};
grant select on ${iol_schema}.tmss_sys_tenant to ${idl_schema};
grant select on ${iol_schema}.tmss_sys_tenant to ${iel_schema};

-- comment
comment on table ${iol_schema}.tmss_sys_tenant is '租户（签约）信息表';
comment on column ${iol_schema}.tmss_sys_tenant.id is '主键ID';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_code is '客户号';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_name is '企业名称';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_cert_type is '企业证件类型';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_cert_code is '企业证件号码';
comment on column ${iol_schema}.tmss_sys_tenant.sign_code is '签约机构';
comment on column ${iol_schema}.tmss_sys_tenant.sign_time is '签约时间';
comment on column ${iol_schema}.tmss_sys_tenant.post_code is '邮政编码';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_phone is '企业联系电话';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_sina_name is '企业中文名称';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_eng_name is '企业英文名称';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_time is '企业证明文件有效期';
comment on column ${iol_schema}.tmss_sys_tenant.tenant_addr is '企业地址';
comment on column ${iol_schema}.tmss_sys_tenant.fr_name is '法人/负责人';
comment on column ${iol_schema}.tmss_sys_tenant.fr_mobile is '法人联系方式';
comment on column ${iol_schema}.tmss_sys_tenant.fr_cert_type is '法人证件类型:01 第二代居民身份证、02 户口簿、03 临时身份证、04 中国护照、05 军官证、06 离休干部荣誉证、07 军官退休证、08 军事学员证、09 武警证、10 士兵证、11 香港通行证、12 澳门通行证、13 胞通行证或有效旅行证件、14 外国人永久居留证、15 边民出入境通行证、16:外国护照、99其他 (或采用柜面现有类别代码)';
comment on column ${iol_schema}.tmss_sys_tenant.fr_cert_code is '法人证件号码';
comment on column ${iol_schema}.tmss_sys_tenant.fr_cert_time is '法人证件有效期';
comment on column ${iol_schema}.tmss_sys_tenant.bank_seal_id is '影像流水';
comment on column ${iol_schema}.tmss_sys_tenant.charge_mode is '管理员模式: 0：否 1：是  如果是双冠 传输两个 校验list长度';
comment on column ${iol_schema}.tmss_sys_tenant.create_by is '创建人';
comment on column ${iol_schema}.tmss_sys_tenant.create_date is '创建时间';
comment on column ${iol_schema}.tmss_sys_tenant.update_by is '更新人';
comment on column ${iol_schema}.tmss_sys_tenant.update_date is '更新时间';
comment on column ${iol_schema}.tmss_sys_tenant.status is '状态 0禁用 1启用';
comment on column ${iol_schema}.tmss_sys_tenant.sign_name is '签约机构名称';
comment on column ${iol_schema}.tmss_sys_tenant.un_sign_time is '解约时间';
comment on column ${iol_schema}.tmss_sys_tenant.sign_model is '签约客户模式  common：通用功能模式、query：仅查询模式';
comment on column ${iol_schema}.tmss_sys_tenant.sign_user_id is '签约柜员编码';
comment on column ${iol_schema}.tmss_sys_tenant.sign_agreement_id is '协议编码';
comment on column ${iol_schema}.tmss_sys_tenant.start_dt is '开始时间';
comment on column ${iol_schema}.tmss_sys_tenant.end_dt is '结束时间';
comment on column ${iol_schema}.tmss_sys_tenant.id_mark is '增删标志';
comment on column ${iol_schema}.tmss_sys_tenant.etl_timestamp is 'ETL处理时间戳';
