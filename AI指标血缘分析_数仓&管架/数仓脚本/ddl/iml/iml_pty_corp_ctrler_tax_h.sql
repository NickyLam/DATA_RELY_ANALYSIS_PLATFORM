/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_corp_ctrler_tax_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_corp_ctrler_tax_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_corp_ctrler_tax_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_ctrler_tax_h(
    party_id varchar2(100) -- 当事人编号
    ,rela_party_id varchar2(60) -- 关联当事人编号
    ,ctrler_type_cd varchar2(30) -- 控制人类型代码
    ,ctrler_cert_type_cd varchar2(30) -- 控制人证件类型代码
    ,ctrler_cert_no varchar2(60) -- 控制人证件号码
    ,ctrler_name varchar2(250) -- 控制人名称
    ,ctrler_legal_en_last_name varchar2(500) -- 控制人法定英文姓氏
    ,ctrler_en_mdl_name varchar2(500) -- 控制人英文中间名
    ,ctrler_legal_en_first_name varchar2(500) -- 控制人法定英文名字
    ,ctrler_tax_red_cty_cd_comb varchar2(500) -- 控制人税收居民国家代码组合
    ,get_stament_flg varchar2(30) -- 取得自证声明标志
    ,tax_num varchar2(500) -- 纳税人识别号
    ,distr_idtfy_num_cty_cd_comb varchar2(500) -- 发放识别号国家代码组合
    ,tax_num_null_rs_descb varchar2(3000) -- 纳税人识别号空值原因描述
    ,ctrler_birth_city_name varchar2(500) -- 控制人出生城市名称
    ,birth_cty_home_and_rg_cd varchar2(30) -- 出生国家和地区代码
    ,ctrler_birth_cty_en_name varchar2(500) -- 控制人出生国英文名称
    ,ctrler_cn_birth_addr varchar2(500) -- 控制人中文出生地址
    ,ctrler_cn_resd_addr varchar2(500) -- 控制人中文现居地址
    ,ctrler_en_resd_addr varchar2(500) -- 控制人英文现居地址
    ,ctrler_birth_dt date -- 控制人出生日期
    ,tax_resdnt_idti_cd	varchar2(30) -- 税收居民身份代码	
    ,cert_invalid_dt	date --证件失效日期	
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_corp_ctrler_tax_h to ${icl_schema};
grant select on ${iml_schema}.pty_corp_ctrler_tax_h to ${idl_schema};
grant select on ${iml_schema}.pty_corp_ctrler_tax_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_corp_ctrler_tax_h is '公司控制人涉税历史';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.rela_party_id is '关联当事人编号';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_type_cd is '控制人类型代码';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_cert_type_cd is '控制人证件类型代码';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_cert_no is '控制人证件号码';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_name is '控制人名称';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_legal_en_last_name is '控制人法定英文姓氏';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_en_mdl_name is '控制人英文中间名';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_legal_en_first_name is '控制人法定英文名字';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_tax_red_cty_cd_comb is '控制人税收居民国家代码组合';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.get_stament_flg is '取得自证声明标志';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.tax_num is '纳税人识别号';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.distr_idtfy_num_cty_cd_comb is '发放识别号国家代码组合';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.tax_num_null_rs_descb is '纳税人识别号空值原因描述';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_birth_city_name is '控制人出生城市名称';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.birth_cty_home_and_rg_cd is '出生国家和地区代码';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_birth_cty_en_name is '控制人出生国英文名称';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_cn_birth_addr is '控制人中文出生地址';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_cn_resd_addr is '控制人中文现居地址';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_en_resd_addr is '控制人英文现居地址';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.ctrler_birth_dt is '控制人出生日期';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.Tax_resdnt_idti_cd is '税收居民身份代码';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.cert_invalid_dt is '证件失效日期';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_corp_ctrler_tax_h.etl_timestamp is 'ETL处理时间戳';
