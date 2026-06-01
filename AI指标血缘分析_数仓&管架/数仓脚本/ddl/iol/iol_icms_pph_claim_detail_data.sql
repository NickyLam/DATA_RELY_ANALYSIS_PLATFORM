/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_pph_claim_detail_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_pph_claim_detail_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_pph_claim_detail_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pph_claim_detail_data(
    serialno varchar2(32) -- 借据号
    ,inputdate varchar2(10) -- 录入日期
    ,tradedate varchar2(8) -- 理赔日期
    ,status varchar2(2) -- 理赔处理标识1：成功，0：失败
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,tradeamt number(15,2) -- 应理赔金额
    ,screditclaimamt number(15,2) -- 借据余额（尚欠本金）
    ,compid varchar2(8) -- 产品编号
    ,bankclaimamt number(15,2) -- 实际理赔金额
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
grant select on ${iol_schema}.icms_pph_claim_detail_data to ${iml_schema};
grant select on ${iol_schema}.icms_pph_claim_detail_data to ${icl_schema};
grant select on ${iol_schema}.icms_pph_claim_detail_data to ${idl_schema};
grant select on ${iol_schema}.icms_pph_claim_detail_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_pph_claim_detail_data is '平安普惠、恒兴股份、粤海';
comment on column ${iol_schema}.icms_pph_claim_detail_data.serialno is '借据号';
comment on column ${iol_schema}.icms_pph_claim_detail_data.inputdate is '录入日期';
comment on column ${iol_schema}.icms_pph_claim_detail_data.tradedate is '理赔日期';
comment on column ${iol_schema}.icms_pph_claim_detail_data.status is '理赔处理标识1：成功，0：失败';
comment on column ${iol_schema}.icms_pph_claim_detail_data.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_pph_claim_detail_data.tradeamt is '应理赔金额';
comment on column ${iol_schema}.icms_pph_claim_detail_data.screditclaimamt is '借据余额（尚欠本金）';
comment on column ${iol_schema}.icms_pph_claim_detail_data.compid is '产品编号';
comment on column ${iol_schema}.icms_pph_claim_detail_data.bankclaimamt is '实际理赔金额';
comment on column ${iol_schema}.icms_pph_claim_detail_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_pph_claim_detail_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_pph_claim_detail_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_pph_claim_detail_data.etl_timestamp is 'ETL处理时间戳';
