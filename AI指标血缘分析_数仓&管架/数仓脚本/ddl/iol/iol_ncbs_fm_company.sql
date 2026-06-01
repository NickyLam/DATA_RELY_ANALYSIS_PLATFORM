/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_company
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_company
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_company purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_company(
    company varchar2(20) -- 法人
    ,company_name varchar2(50) -- 公司名称
    ,multi_corp_query_allow varchar2(1) -- 多法人是否允许跨法人查询标志
    ,system_phase varchar2(3) -- 系统所处的阶段
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cny_business_unit varchar2(10) -- 账套(人民币)
    ,company_client_no varchar2(16) -- 法人内部客户号
    ,head_office_code varchar2(12) -- 总行机构代码
    ,hkd_business_unit varchar2(10) -- 账套(港币)
    ,all_dra_company varchar2(20) -- 通兑法人代码
    ,all_dep_company varchar2(20) -- 通存法人代码
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
grant select on ${iol_schema}.ncbs_fm_company to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_company to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_company to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_company to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_company is '法人定义表';
comment on column ${iol_schema}.ncbs_fm_company.company is '法人';
comment on column ${iol_schema}.ncbs_fm_company.company_name is '公司名称';
comment on column ${iol_schema}.ncbs_fm_company.multi_corp_query_allow is '多法人是否允许跨法人查询标志';
comment on column ${iol_schema}.ncbs_fm_company.system_phase is '系统所处的阶段';
comment on column ${iol_schema}.ncbs_fm_company.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_company.cny_business_unit is '账套(人民币)';
comment on column ${iol_schema}.ncbs_fm_company.company_client_no is '法人内部客户号';
comment on column ${iol_schema}.ncbs_fm_company.head_office_code is '总行机构代码';
comment on column ${iol_schema}.ncbs_fm_company.hkd_business_unit is '账套(港币)';
comment on column ${iol_schema}.ncbs_fm_company.all_dra_company is '通兑法人代码';
comment on column ${iol_schema}.ncbs_fm_company.all_dep_company is '通存法人代码';
comment on column ${iol_schema}.ncbs_fm_company.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_company.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_company.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_company.etl_timestamp is 'ETL处理时间戳';
