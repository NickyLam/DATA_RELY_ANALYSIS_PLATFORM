/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_bank
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_bank
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_bank purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_bank(
    bank_id number(10,0) -- 银行ID.
    ,bank_type number(4,0) -- 银行类型.1:总行;2:分行
    ,bank_name varchar2(256) -- 银行名称.
    ,bank_no varchar2(8) -- 银行编码.银行在我们系统中分配的编码,生成渠道编号时要用到
    ,bank_letter_no varchar2(64) -- 银行英文编码.银行在我们系统中分配的英文编码,导入导出时要用到
    ,bank_tel varchar2(32) -- 银行电话.
    ,bank_letter_code varchar2(32) -- 银行英文缩写.
    ,remark varchar2(256) -- 备注.
    ,create_user number(10,0) -- 创建用户.
    ,create_emp varchar2(32) -- 创建人.
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,bank_code varchar2(16) -- 银行代码（兴业提供的广义联行号）
    ,platform_version number(4,0) -- 银行所属平台字段
    ,deprecated number(4,0) -- 是否废弃
    ,deprecated_comment varchar2(128) -- 废弃注释
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
grant select on ${iol_schema}.amss_cms_bank to ${iml_schema};
grant select on ${iol_schema}.amss_cms_bank to ${icl_schema};
grant select on ${iol_schema}.amss_cms_bank to ${idl_schema};
grant select on ${iol_schema}.amss_cms_bank to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_bank is '银行表';
comment on column ${iol_schema}.amss_cms_bank.bank_id is '银行ID.';
comment on column ${iol_schema}.amss_cms_bank.bank_type is '银行类型.1:总行;2:分行';
comment on column ${iol_schema}.amss_cms_bank.bank_name is '银行名称.';
comment on column ${iol_schema}.amss_cms_bank.bank_no is '银行编码.银行在我们系统中分配的编码,生成渠道编号时要用到';
comment on column ${iol_schema}.amss_cms_bank.bank_letter_no is '银行英文编码.银行在我们系统中分配的英文编码,导入导出时要用到';
comment on column ${iol_schema}.amss_cms_bank.bank_tel is '银行电话.';
comment on column ${iol_schema}.amss_cms_bank.bank_letter_code is '银行英文缩写.';
comment on column ${iol_schema}.amss_cms_bank.remark is '备注.';
comment on column ${iol_schema}.amss_cms_bank.create_user is '创建用户.';
comment on column ${iol_schema}.amss_cms_bank.create_emp is '创建人.';
comment on column ${iol_schema}.amss_cms_bank.create_time is '创建时间.';
comment on column ${iol_schema}.amss_cms_bank.update_time is '更新时间.';
comment on column ${iol_schema}.amss_cms_bank.bank_code is '银行代码（兴业提供的广义联行号）';
comment on column ${iol_schema}.amss_cms_bank.platform_version is '银行所属平台字段';
comment on column ${iol_schema}.amss_cms_bank.deprecated is '是否废弃';
comment on column ${iol_schema}.amss_cms_bank.deprecated_comment is '废弃注释';
comment on column ${iol_schema}.amss_cms_bank.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_bank.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_bank.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_bank.etl_timestamp is 'ETL处理时间戳';
