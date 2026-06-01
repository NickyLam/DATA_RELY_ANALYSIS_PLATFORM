/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl nras_pty_indv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.nras_pty_indv
whenever sqlerror continue none;
drop table ${idl_schema}.nras_pty_indv purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.nras_pty_indv(
    etl_dt date -- 数据日期
    ,party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,indv_en_name varchar2(100) -- 个人英文名称
    ,birth_dt date -- 出生日期
    ,birth_addr varchar2(100) -- 出生地址
    ,depositr_cate_cd varchar2(10) -- 存款人类别代码
    ,party_name varchar2(100) -- 当事人名称
    ,indv_bus_flg varchar2(10) -- 个体工商户标志
    ,indv_bus_cert_no varchar2(60) -- 个体工商户证件号码
    ,nation_cd varchar2(20) -- 国籍代码
    ,marriage_situ_cd varchar2(10) -- 婚姻状况代码
    ,nati_place_cd varchar2(60) -- 籍贯代码
    ,resd_status_cd varchar2(10) -- 居住状态代码
    ,nationty_cd varchar2(10) -- 民族代码
    ,taxpayer_idtfy_num varchar2(60) -- 纳税人识别号
    ,real_name_flg varchar2(10) -- 实名标志
    ,tax_resdnt_cty_cd varchar2(20) -- 税收居民国家代码
    ,tax_resdnt_idti_type_cd varchar2(10) -- 税收居民身份类型代码
    ,sm_bus_owner_flg varchar2(10) -- 小微企业主标志
    ,sm_bus_owner_cert_no varchar2(60) -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd varchar2(10) -- 小微企业主证件类型代码
    ,gender_cd varchar2(10) -- 性别代码
    ,name varchar2(100) -- 姓名
    ,degree_cd varchar2(10) -- 学位代码
    ,blood_type_cd varchar2(10) -- 血型代码
    ,ctysd_contr_oper_acct_flg varchar2(10) -- 农村承包经营户标志
    ,farm_flg varchar2(10) -- 农户标志
    ,have_work_unit_flg varchar2(10) -- 有工作单位标志
    ,post_cd varchar2(10) -- 职务代码
    ,title_cd varchar2(10) -- 职称代码
    ,resdnt_char_cd varchar2(10) -- 居民性质代码
    ,rg_cd varchar2(10) -- 地区代码
    ,emply_flg varchar2(10) -- 员工标志
    ,dist_cd varchar2(10) -- 行政区域代码
    ,resdnt_flg varchar2(10) -- 居民标志
    ,nati_place varchar2(60) -- 籍贯
    ,age number(10) -- 年龄
    ,owner_type_cd varchar2(10) -- 业主类型代码
    ,politic_status_cd varchar2(10) -- 政治面貌代码
    ,ghb_rela_peop_flg varchar2(10) -- 本行关系人标志
    ,health_status_cd varchar2(10) -- 健康状况代码
    ,spoken varchar2(100) -- 口语
    ,sys_in_cust_flg varchar2(10) -- 系统内客户标志
    ,cust_lev_cd varchar2(10) -- 客户级别代码
    ,tax_stament_flg varchar2(10) -- 取得税收居民取得自证声明标志
    ,indv_party_type_cd varchar2(10) -- 个人当事人类型代码
    ,hxb_post_type_cd varchar2(10) -- 在我行职务类型代码
    ,grad_school varchar2(100) -- 毕业院校
    ,crdt_cust_flg varchar2(10) -- 授信客户标志
    ,main_type_cd varchar2(10) -- 主体类型代码
    ,tax_num_null_rs_descb varchar2(250) -- 纳税人识别号空值原因描述
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.nras_pty_indv to ${iel_schema};

-- comment
comment on table ${idl_schema}.nras_pty_indv is '个人当事人';
comment on column ${idl_schema}.nras_pty_indv.etl_dt is '数据日期';
comment on column ${idl_schema}.nras_pty_indv.party_id is '当事人编号';
comment on column ${idl_schema}.nras_pty_indv.lp_id is '法人编号';
comment on column ${idl_schema}.nras_pty_indv.indv_en_name is '个人英文名称';
comment on column ${idl_schema}.nras_pty_indv.birth_dt is '出生日期';
comment on column ${idl_schema}.nras_pty_indv.birth_addr is '出生地址';
comment on column ${idl_schema}.nras_pty_indv.depositr_cate_cd is '存款人类别代码';
comment on column ${idl_schema}.nras_pty_indv.party_name is '当事人名称';
comment on column ${idl_schema}.nras_pty_indv.indv_bus_flg is '个体工商户标志';
comment on column ${idl_schema}.nras_pty_indv.indv_bus_cert_no is '个体工商户证件号码';
comment on column ${idl_schema}.nras_pty_indv.nation_cd is '国籍代码';
comment on column ${idl_schema}.nras_pty_indv.marriage_situ_cd is '婚姻状况代码';
comment on column ${idl_schema}.nras_pty_indv.nati_place_cd is '籍贯代码';
comment on column ${idl_schema}.nras_pty_indv.resd_status_cd is '居住状态代码';
comment on column ${idl_schema}.nras_pty_indv.nationty_cd is '民族代码';
comment on column ${idl_schema}.nras_pty_indv.taxpayer_idtfy_num is '纳税人识别号';
comment on column ${idl_schema}.nras_pty_indv.real_name_flg is '实名标志';
comment on column ${idl_schema}.nras_pty_indv.tax_resdnt_cty_cd is '税收居民国家代码';
comment on column ${idl_schema}.nras_pty_indv.tax_resdnt_idti_type_cd is '税收居民身份类型代码';
comment on column ${idl_schema}.nras_pty_indv.sm_bus_owner_flg is '小微企业主标志';
comment on column ${idl_schema}.nras_pty_indv.sm_bus_owner_cert_no is '小微企业主证件号码';
comment on column ${idl_schema}.nras_pty_indv.sm_bus_owner_cert_type_cd is '小微企业主证件类型代码';
comment on column ${idl_schema}.nras_pty_indv.gender_cd is '性别代码';
comment on column ${idl_schema}.nras_pty_indv.name is '姓名';
comment on column ${idl_schema}.nras_pty_indv.degree_cd is '学位代码';
comment on column ${idl_schema}.nras_pty_indv.blood_type_cd is '血型代码';
comment on column ${idl_schema}.nras_pty_indv.ctysd_contr_oper_acct_flg is '农村承包经营户标志';
comment on column ${idl_schema}.nras_pty_indv.farm_flg is '农户标志';
comment on column ${idl_schema}.nras_pty_indv.have_work_unit_flg is '有工作单位标志';
comment on column ${idl_schema}.nras_pty_indv.post_cd is '职务代码';
comment on column ${idl_schema}.nras_pty_indv.title_cd is '职称代码';
comment on column ${idl_schema}.nras_pty_indv.resdnt_char_cd is '居民性质代码';
comment on column ${idl_schema}.nras_pty_indv.rg_cd is '地区代码';
comment on column ${idl_schema}.nras_pty_indv.emply_flg is '员工标志';
comment on column ${idl_schema}.nras_pty_indv.dist_cd is '行政区域代码';
comment on column ${idl_schema}.nras_pty_indv.resdnt_flg is '居民标志';
comment on column ${idl_schema}.nras_pty_indv.nati_place is '籍贯';
comment on column ${idl_schema}.nras_pty_indv.age is '年龄';
comment on column ${idl_schema}.nras_pty_indv.owner_type_cd is '业主类型代码';
comment on column ${idl_schema}.nras_pty_indv.politic_status_cd is '政治面貌代码';
comment on column ${idl_schema}.nras_pty_indv.ghb_rela_peop_flg is '本行关系人标志';
comment on column ${idl_schema}.nras_pty_indv.health_status_cd is '健康状况代码';
comment on column ${idl_schema}.nras_pty_indv.spoken is '口语';
comment on column ${idl_schema}.nras_pty_indv.sys_in_cust_flg is '系统内客户标志';
comment on column ${idl_schema}.nras_pty_indv.cust_lev_cd is '客户级别代码';
comment on column ${idl_schema}.nras_pty_indv.tax_stament_flg is '取得税收居民取得自证声明标志';
comment on column ${idl_schema}.nras_pty_indv.indv_party_type_cd is '个人当事人类型代码';
comment on column ${idl_schema}.nras_pty_indv.hxb_post_type_cd is '在我行职务类型代码';
comment on column ${idl_schema}.nras_pty_indv.grad_school is '毕业院校';
comment on column ${idl_schema}.nras_pty_indv.crdt_cust_flg is '授信客户标志';
comment on column ${idl_schema}.nras_pty_indv.main_type_cd is '主体类型代码';
comment on column ${idl_schema}.nras_pty_indv.tax_num_null_rs_descb is '纳税人识别号空值原因描述';
comment on column ${idl_schema}.nras_pty_indv.job_cd is '任务代码';
comment on column ${idl_schema}.nras_pty_indv.etl_timestamp is '数据处理时间';
