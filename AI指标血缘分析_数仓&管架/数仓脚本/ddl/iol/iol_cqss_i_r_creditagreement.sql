/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_creditagreement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_creditagreement
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_creditagreement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_creditagreement(
    id varchar2(96) -- 代码主键
    ,crg_agrm_id number(5,0) -- 授信协议编号:pd02ai01
    ,msgidno varchar2(53) -- 报文标识号
    ,inst_tp varchar2(45) -- 机构类型:pd02ad01
    ,mtit_ecd varchar2(36) -- 管理机构编码:pd02ai02
    ,crg_agrm_idr_cd varchar2(90) -- 授信协议标识码:pd02ai03
    ,crgln_use varchar2(9) -- 授信额度用途:pd02ad02
    ,crgln number(38,0) -- 授信额度:pd02aj01
    ,ccycd varchar2(5) -- 币种代码:pd02ad03
    ,efdt date -- 生效日期:pd02ar01
    ,exdat date -- 到期日期:pd02ar02
    ,crg_agrm_st varchar2(9) -- 授信协议状态:pd02ad04
    ,crg_qot number(38,0) -- 授信限额:pd02aj03
    ,crg_qot_id varchar2(90) -- 授信限额编号:pd02ai04
    ,usd_lmt number(38,0) -- 已用额度:pd02aj04
    ,alrdyclsglnhostrtyrmo varchar2(11) -- 已结清贷款历史逾期开始年月
    ,alrdyclsglnhtocofyrmo varchar2(11) -- 已结清贷款历史逾期截止年月
    ,sptxn_num number(3,0) -- 特殊交易个数
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数:pd02zs01
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_i_r_creditagreement to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_creditagreement to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_creditagreement to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_creditagreement to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_creditagreement is '二代授信协议基本信息';
comment on column ${iol_schema}.cqss_i_r_creditagreement.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_creditagreement.crg_agrm_id is '授信协议编号:pd02ai01';
comment on column ${iol_schema}.cqss_i_r_creditagreement.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_creditagreement.inst_tp is '机构类型:pd02ad01';
comment on column ${iol_schema}.cqss_i_r_creditagreement.mtit_ecd is '管理机构编码:pd02ai02';
comment on column ${iol_schema}.cqss_i_r_creditagreement.crg_agrm_idr_cd is '授信协议标识码:pd02ai03';
comment on column ${iol_schema}.cqss_i_r_creditagreement.crgln_use is '授信额度用途:pd02ad02';
comment on column ${iol_schema}.cqss_i_r_creditagreement.crgln is '授信额度:pd02aj01';
comment on column ${iol_schema}.cqss_i_r_creditagreement.ccycd is '币种代码:pd02ad03';
comment on column ${iol_schema}.cqss_i_r_creditagreement.efdt is '生效日期:pd02ar01';
comment on column ${iol_schema}.cqss_i_r_creditagreement.exdat is '到期日期:pd02ar02';
comment on column ${iol_schema}.cqss_i_r_creditagreement.crg_agrm_st is '授信协议状态:pd02ad04';
comment on column ${iol_schema}.cqss_i_r_creditagreement.crg_qot is '授信限额:pd02aj03';
comment on column ${iol_schema}.cqss_i_r_creditagreement.crg_qot_id is '授信限额编号:pd02ai04';
comment on column ${iol_schema}.cqss_i_r_creditagreement.usd_lmt is '已用额度:pd02aj04';
comment on column ${iol_schema}.cqss_i_r_creditagreement.alrdyclsglnhostrtyrmo is '已结清贷款历史逾期开始年月';
comment on column ${iol_schema}.cqss_i_r_creditagreement.alrdyclsglnhtocofyrmo is '已结清贷款历史逾期截止年月';
comment on column ${iol_schema}.cqss_i_r_creditagreement.sptxn_num is '特殊交易个数';
comment on column ${iol_schema}.cqss_i_r_creditagreement.annttn_and_sttmnt_num is '标注及声明个数:pd02zs01';
comment on column ${iol_schema}.cqss_i_r_creditagreement.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_creditagreement.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_creditagreement.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_creditagreement.etl_timestamp is 'ETL处理时间戳';
