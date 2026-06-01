/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_per_rel_per_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_per_rel_per_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_per_rel_per_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_rel_per_info(
    rel_id varchar2(45) -- 关系人id
    ,party_id varchar2(45) -- 参与人id
    ,rela_cust_rela_cd varchar2(8) -- 关联方关系
    ,rela_num varchar2(45) -- 关联方编号
    ,rela_name varchar2(300) -- 关联方名称
    ,rela_cert_type_cd varchar2(6) -- 关联方证件类型
    ,rela_cert_num varchar2(90) -- 关联方证件号码
    ,exp_date_of_rela_cert varchar2(12) -- 关联方证件失效日期
    ,birth_dt varchar2(12) -- 出生日期
    ,gender_cd varchar2(30) -- 性别
    ,party_occupation varchar2(15) -- 关联方职业标志
    ,work_corp_name varchar2(300) -- 工作单位名称
    ,work_unit_addr varchar2(600) -- 工作单位地址
    ,work_unit_property varchar2(150) -- 工作单位性质
    ,title_cd varchar2(3) -- 职称
    ,pos_level_cd varchar2(2) -- 职务类型
    ,mon_in number(20,2) -- 月收入
    ,rela_tel_num varchar2(45) -- 关联方联系电话
    ,rela_addr varchar2(600) -- 关联方联系地址
    ,tax_pay_ctzn_idnt varchar2(11) -- 税收居民身份
    ,rela_stat_cd varchar2(30) -- 关联关系状态
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
    ,other_pos_level varchar2(75) -- 其他职务
    ,rela_qualify varchar2(3) -- 关联人最高学历代码
    ,rela_nation_cd varchar2(30) -- 关联方国籍
    ,rela_zone_code varchar2(45) -- 关联人电话国内区号
    ,phone_no varchar2(45) -- 手机号码
    ,mobile_phone varchar2(45) -- 联系手机
    ,rela_cert_effect_dt varchar2(30) -- 关联人证件生效日期
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
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
grant select on ${iol_schema}.eifs_t01_per_rel_per_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_per_rel_per_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_per_rel_per_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_per_rel_per_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_per_rel_per_info is '对私关系自然人信息';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rel_id is '关系人id';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_cust_rela_cd is '关联方关系';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_num is '关联方编号';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_name is '关联方名称';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_cert_type_cd is '关联方证件类型';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_cert_num is '关联方证件号码';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.exp_date_of_rela_cert is '关联方证件失效日期';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.birth_dt is '出生日期';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.gender_cd is '性别';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.party_occupation is '关联方职业标志';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.work_corp_name is '工作单位名称';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.work_unit_addr is '工作单位地址';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.work_unit_property is '工作单位性质';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.title_cd is '职称';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.pos_level_cd is '职务类型';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.mon_in is '月收入';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_tel_num is '关联方联系电话';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_addr is '关联方联系地址';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.tax_pay_ctzn_idnt is '税收居民身份';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_stat_cd is '关联关系状态';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.other_pos_level is '其他职务';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_qualify is '关联人最高学历代码';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_nation_cd is '关联方国籍';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_zone_code is '关联人电话国内区号';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.phone_no is '手机号码';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.mobile_phone is '联系手机';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.rela_cert_effect_dt is '关联人证件生效日期';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_per_rel_per_info.etl_timestamp is 'ETL处理时间戳';
