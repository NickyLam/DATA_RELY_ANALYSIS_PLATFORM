/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t3b_seif_n
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t3b_seif_n
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t3b_seif_n purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t3b_seif_n(
    rpt_id varchar2(96) -- 报告编号
    ,stat_dt date -- 数据日期
    ,seif_seq number(8,0) -- 客户序号
    ,csnm varchar2(48) -- 客户号
    ,sevc varchar2(48) -- 可疑主体职业（对私）或行业（对公）
    ,senm varchar2(768) -- 可疑主体姓名/名称
    ,setp varchar2(9) -- 可疑主体身份证件/证明文件类型
    ,oitp varchar2(192) -- 其他身份证件/证明文件类型
    ,seid varchar2(192) -- 可疑主体身份证件/证明文件号码
    ,stnt varchar2(5) -- 可疑主体国籍
    ,sctl1 varchar2(96) -- 可疑主体联系电话1
    ,sctl2 varchar2(96) -- 可疑主体联系电话2
    ,sear1 varchar2(768) -- 可疑主体住址/经营地址1
    ,sear2 varchar2(768) -- 可疑主体住址/经营地址2
    ,seei1 varchar2(768) -- 可疑主体其他联系方式1
    ,seei2 varchar2(768) -- 可疑主体其他联系方式2
    ,srnm varchar2(768) -- 可疑主体法定代表人姓名
    ,srit varchar2(48) -- 可疑主体法定代表人身份证件类型
    ,orit varchar2(192) -- 可疑主体法定代表人其他身份证件/证明文件类型
    ,srid varchar2(192) -- 可疑主体法定代表人身份证件号码
    ,scnm varchar2(768) -- 可疑主体控股股东或实际控制人名称
    ,scit varchar2(9) -- 可疑主体控股股东或实际控制人身份证件/证明文件类型
    ,ocit varchar2(192) -- 可疑主体控股股东或实际控制人其他身份证件/证明文件类型
    ,scid varchar2(192) -- 可疑主体控股股东或实际控制人身份证件/证明文件号码
    ,bs_valid varchar2(2) -- 可疑验证（参见[字典:aml0042]））
    ,err_type varchar2(2) -- 1:补正，2：重报
    ,pbc_rcpt_tm varchar2(23) -- 人行回执时间
    ,cust_type varchar2(2) -- 客户类型
    ,org_id varchar2(30) -- 归属机构编号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.amls_t3b_seif_n to ${iml_schema};
grant select on ${iol_schema}.amls_t3b_seif_n to ${icl_schema};
grant select on ${iol_schema}.amls_t3b_seif_n to ${idl_schema};
grant select on ${iol_schema}.amls_t3b_seif_n to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t3b_seif_n is '报送可疑客户';
comment on column ${iol_schema}.amls_t3b_seif_n.rpt_id is '报告编号';
comment on column ${iol_schema}.amls_t3b_seif_n.stat_dt is '数据日期';
comment on column ${iol_schema}.amls_t3b_seif_n.seif_seq is '客户序号';
comment on column ${iol_schema}.amls_t3b_seif_n.csnm is '客户号';
comment on column ${iol_schema}.amls_t3b_seif_n.sevc is '可疑主体职业（对私）或行业（对公）';
comment on column ${iol_schema}.amls_t3b_seif_n.senm is '可疑主体姓名/名称';
comment on column ${iol_schema}.amls_t3b_seif_n.setp is '可疑主体身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3b_seif_n.oitp is '其他身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3b_seif_n.seid is '可疑主体身份证件/证明文件号码';
comment on column ${iol_schema}.amls_t3b_seif_n.stnt is '可疑主体国籍';
comment on column ${iol_schema}.amls_t3b_seif_n.sctl1 is '可疑主体联系电话1';
comment on column ${iol_schema}.amls_t3b_seif_n.sctl2 is '可疑主体联系电话2';
comment on column ${iol_schema}.amls_t3b_seif_n.sear1 is '可疑主体住址/经营地址1';
comment on column ${iol_schema}.amls_t3b_seif_n.sear2 is '可疑主体住址/经营地址2';
comment on column ${iol_schema}.amls_t3b_seif_n.seei1 is '可疑主体其他联系方式1';
comment on column ${iol_schema}.amls_t3b_seif_n.seei2 is '可疑主体其他联系方式2';
comment on column ${iol_schema}.amls_t3b_seif_n.srnm is '可疑主体法定代表人姓名';
comment on column ${iol_schema}.amls_t3b_seif_n.srit is '可疑主体法定代表人身份证件类型';
comment on column ${iol_schema}.amls_t3b_seif_n.orit is '可疑主体法定代表人其他身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3b_seif_n.srid is '可疑主体法定代表人身份证件号码';
comment on column ${iol_schema}.amls_t3b_seif_n.scnm is '可疑主体控股股东或实际控制人名称';
comment on column ${iol_schema}.amls_t3b_seif_n.scit is '可疑主体控股股东或实际控制人身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3b_seif_n.ocit is '可疑主体控股股东或实际控制人其他身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3b_seif_n.scid is '可疑主体控股股东或实际控制人身份证件/证明文件号码';
comment on column ${iol_schema}.amls_t3b_seif_n.bs_valid is '可疑验证（参见[字典:aml0042]））';
comment on column ${iol_schema}.amls_t3b_seif_n.err_type is '1:补正，2：重报';
comment on column ${iol_schema}.amls_t3b_seif_n.pbc_rcpt_tm is '人行回执时间';
comment on column ${iol_schema}.amls_t3b_seif_n.cust_type is '客户类型';
comment on column ${iol_schema}.amls_t3b_seif_n.org_id is '归属机构编号';
comment on column ${iol_schema}.amls_t3b_seif_n.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t3b_seif_n.etl_timestamp is 'ETL处理时间戳';
