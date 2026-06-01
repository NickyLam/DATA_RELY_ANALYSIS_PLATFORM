/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl non_red_tax_info_mtbl_fund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.non_red_tax_info_mtbl_fund
whenever sqlerror continue none;
drop table ${idl_schema}.non_red_tax_info_mtbl_fund purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.non_red_tax_info_mtbl_fund(
    etl_dt date -- 数据日期
    ,acc_type varchar2(10) -- 客户标识类型
    ,account varchar2(60) -- 客户标识
    ,trans_date date -- 交易日期
    ,client_type varchar2(10) -- 客户类别
    ,resident_tax_type varchar2(30) -- 税收居民身份
    ,resident_inst_type varchar2(30) -- 金融机构类型
    ,english_name varchar2(250) -- 英文全称
    ,inst_nation varchar2(10) -- 机构地址（国家）
    ,inst_address varchar2(250) -- 机构地址详细地址
    ,english_inst_address varchar2(500) -- 机构详细地址（英文）
    ,chinese_name varchar2(100) -- 中文姓名
    ,english_family_name varchar2(500) -- 姓（英文）
    ,english_first_name varchar2(500) -- 名（英文）
    ,born_nation varchar2(10) -- 出生地（国家）
    ,english_present_address varchar2(500) -- 现居详细地址（英文）
    ,present_nation varchar2(10) -- 现居地址（国家）
    ,present_address varchar2(500) -- 现居详细地址
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.non_red_tax_info_mtbl_fund to ${iel_schema};

-- comment
comment on table ${idl_schema}.non_red_tax_info_mtbl_fund is '非居民涉税信息主表(增量)';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.etl_dt is '数据日期';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.acc_type is '客户标识类型';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.account is '客户标识';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.trans_date is '交易日期';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.client_type is '客户类别';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.resident_tax_type is '税收居民身份';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.resident_inst_type is '金融机构类型';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.english_name is '英文全称';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.inst_nation is '机构地址（国家）';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.inst_address is '机构地址详细地址';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.english_inst_address is '机构详细地址（英文）';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.chinese_name is '中文姓名';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.english_family_name is '姓（英文）';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.english_first_name is '名（英文）';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.born_nation is '出生地（国家）';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.english_present_address is '现居详细地址（英文）';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.present_nation is '现居地址（国家）';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.present_address is '现居详细地址';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.job_cd is '任务编码';
comment on column ${idl_schema}.non_red_tax_info_mtbl_fund.etl_timestamp is 'ETL处理时间戳';