/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_huikehongye_document_company_info_arr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr(
    gendate varchar2(4000) -- 生成时间
    ,sequenceid varchar2(4000) -- 系统流水号
    ,location varchar2(4000) -- 所在地
    ,label_id varchar2(4000) -- 标签号
    ,industry_1 varchar2(4000) -- 行业分类1级
    ,industry_2 varchar2(4000) -- 行业分类2级
    ,industry_3 varchar2(4000) -- 行业分类3级
    ,industry_4 varchar2(4000) -- 行业分类4级
    ,sentiment varchar2(4000) -- 情感得分
    ,sentiment_score varchar2(4000) -- 情感得分
    ,cn_name varchar2(4000) -- 中文名称
    ,en_name varchar2(4000) -- 英文名称
    ,cn_short_name varchar2(4000) -- 中文名称简称
    ,type varchar2(4000) -- 公司类型
    ,br_code varchar2(4000) -- 商业登记号(备用)
    ,stock_name varchar2(4000) -- 股票名称
    ,stock_code varchar2(4000) -- 股票代码
    ,bond_code varchar2(4000) -- 债劵代码
    ,credit_code varchar2(4000) -- 统一社会信用代码
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
grant select on ${iol_schema}.uxds_f_huikehongye_document_company_info_arr to ${iml_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document_company_info_arr to ${icl_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document_company_info_arr to ${idl_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document_company_info_arr to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_huikehongye_document_company_info_arr is '慧科讯业主题标签表';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.location is '所在地';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.label_id is '标签号';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.industry_1 is '行业分类1级';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.industry_2 is '行业分类2级';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.industry_3 is '行业分类3级';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.industry_4 is '行业分类4级';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.sentiment is '情感得分';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.sentiment_score is '情感得分';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.cn_name is '中文名称';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.en_name is '英文名称';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.cn_short_name is '中文名称简称';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.type is '公司类型';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.br_code is '商业登记号(备用)';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.stock_name is '股票名称';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.stock_code is '股票代码';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.bond_code is '债劵代码';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.credit_code is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_huikehongye_document_company_info_arr.etl_timestamp is 'ETL处理时间戳';
