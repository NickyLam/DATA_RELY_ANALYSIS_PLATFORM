/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ref_card_bin_para_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ref_card_bin_para_h
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ref_card_bin_para_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ref_card_bin_para_h(
    card_idf_id varchar2(100) -- 卡标识编号
    ,lp_id varchar2(60) -- 法人编号
    ,card_bin_name varchar2(500) -- 卡BIN名称
    ,card_bin_type_cd varchar2(30) -- 卡BIN类型代码
    ,stop_card_iss_flg varchar2(30) -- 停止发卡标志
    ,ic_card_make_permit_cd varchar2(30) -- IC卡制作许可代码
    ,card_no_length number(10) -- 卡号长度
    ,vouch_kind_cd varchar2(30) -- 凭证种类代码
    ,vouch_no_begin_position number(10) -- 凭证号码起始位置
    ,vouch_no_length number(10) -- 凭证号码长度
    ,etl_dt date -- 数据日期
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
grant select on ${itl_schema}.itl_edw_ref_card_bin_para_h to ${icl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ref_card_bin_para_h is '卡BIN参数历史';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.card_idf_id is '卡标识编号';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.card_bin_name is '卡BIN名称';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.card_bin_type_cd is '卡BIN类型代码';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.stop_card_iss_flg is '停止发卡标志';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.ic_card_make_permit_cd is 'IC卡制作许可代码';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.card_no_length is '卡号长度';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.vouch_kind_cd is '凭证种类代码';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.vouch_no_begin_position is '凭证号码起始位置';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.vouch_no_length is '凭证号码长度';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_ref_card_bin_para_h.etl_timestamp is 'ETL处理时间戳';
