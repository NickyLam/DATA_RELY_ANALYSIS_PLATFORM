/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_sec_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_sec_basic_info
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_sec_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_sec_basic_info(
    seq number(28,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录通讯到用户端时间
    ,sec_issuer_id varchar2(180) -- 证券发行主体id
    ,sec_code varchar2(360) -- 证券代码
    ,sec_short_name_cn varchar2(1800) -- 证券简称(中文)
    ,phonetic_short_name varchar2(450) -- 拼音简称
    ,sec_full_name varchar2(3600) -- 证券全称
    ,sec_type_code varchar2(108) -- 证券类别编码@关联到sec_classi_public_code_table.ctgry_code
    ,sec_type varchar2(540) -- 证券类别@阳光私募
    ,td_mkt_encode varchar2(108) -- 交易市场编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=212
    ,td_mkt varchar2(540) -- 交易市场
    ,listed_date date -- 上市日期
    ,stop_listing_date date -- 终止上市日期
    ,issue_org_id varchar2(101) -- 发行机构id@关联到corp_basic_info.org_id
    ,listed_status_code varchar2(108) -- 上市状态编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=213
    ,listed_status varchar2(540) -- 上市状态@包括：正常上市、终止上市、暂停上市、ST、*ST、已发行未上市等
    ,thscode varchar2(288) -- 同花顺代码
    ,sec_id varchar2(288) -- 证券id
    ,is_listing number(1,0) -- 是否上市@0：否；1：是
    ,is_delisted number(1,0) -- 是否摘牌@0：否；1：是
    ,listed_board_code varchar2(108) -- 上市板编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=216
    ,listed_board_name varchar2(270) -- 上市板名称
    ,td_currency_code varchar2(108) -- 交易货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518
    ,td_currency_name varchar2(270) -- 交易货币名称
    ,isin varchar2(288) -- 全球证券分类识别码
    ,cusip varchar2(108) -- 美国统一证券识别编码
    ,sec_full_name_en varchar2(1800) -- 证券英文全称
    ,sec_short_name_en varchar2(900) -- 证券简称(英文)
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_sec_basic_info to ${iml_schema};
grant select on ${iol_schema}.uxds_sec_basic_info to ${icl_schema};
grant select on ${iol_schema}.uxds_sec_basic_info to ${idl_schema};
grant select on ${iol_schema}.uxds_sec_basic_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_sec_basic_info is 'a股基本资料';
comment on column ${iol_schema}.uxds_sec_basic_info.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_sec_basic_info.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_sec_basic_info.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_sec_basic_info.rtime is '记录通讯到用户端时间';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_issuer_id is '证券发行主体id';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_code is '证券代码';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_short_name_cn is '证券简称(中文)';
comment on column ${iol_schema}.uxds_sec_basic_info.phonetic_short_name is '拼音简称';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_full_name is '证券全称';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_type_code is '证券类别编码@关联到sec_classi_public_code_table.ctgry_code';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_type is '证券类别@阳光私募';
comment on column ${iol_schema}.uxds_sec_basic_info.td_mkt_encode is '交易市场编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=212';
comment on column ${iol_schema}.uxds_sec_basic_info.td_mkt is '交易市场';
comment on column ${iol_schema}.uxds_sec_basic_info.listed_date is '上市日期';
comment on column ${iol_schema}.uxds_sec_basic_info.stop_listing_date is '终止上市日期';
comment on column ${iol_schema}.uxds_sec_basic_info.issue_org_id is '发行机构id@关联到corp_basic_info.org_id';
comment on column ${iol_schema}.uxds_sec_basic_info.listed_status_code is '上市状态编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=213';
comment on column ${iol_schema}.uxds_sec_basic_info.listed_status is '上市状态@包括：正常上市、终止上市、暂停上市、ST、*ST、已发行未上市等';
comment on column ${iol_schema}.uxds_sec_basic_info.thscode is '同花顺代码';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_id is '证券id';
comment on column ${iol_schema}.uxds_sec_basic_info.is_listing is '是否上市@0：否；1：是';
comment on column ${iol_schema}.uxds_sec_basic_info.is_delisted is '是否摘牌@0：否；1：是';
comment on column ${iol_schema}.uxds_sec_basic_info.listed_board_code is '上市板编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=216';
comment on column ${iol_schema}.uxds_sec_basic_info.listed_board_name is '上市板名称';
comment on column ${iol_schema}.uxds_sec_basic_info.td_currency_code is '交易货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518';
comment on column ${iol_schema}.uxds_sec_basic_info.td_currency_name is '交易货币名称';
comment on column ${iol_schema}.uxds_sec_basic_info.isin is '全球证券分类识别码';
comment on column ${iol_schema}.uxds_sec_basic_info.cusip is '美国统一证券识别编码';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_full_name_en is '证券英文全称';
comment on column ${iol_schema}.uxds_sec_basic_info.sec_short_name_en is '证券简称(英文)';
comment on column ${iol_schema}.uxds_sec_basic_info.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_sec_basic_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_sec_basic_info.etl_timestamp is 'ETL处理时间戳';
