/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_pph_claim_confirm_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_pph_claim_confirm_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_pph_claim_confirm_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pph_claim_confirm_data(
    loanno varchar2(32) -- 借据号
    ,applno varchar2(32) -- 申请号
    ,qudlay varchar2(32) -- 渠道来源
    ,tradedate varchar2(10) -- 理赔处理日期
    ,tradeamt number(15,2) -- 总理赔金额
    ,guaclaimamt number(15,2) -- 担保理赔金额
    ,cgiclaimamt number(15,2) -- 产险理赔金额
    ,cgiclaimmsg varchar2(600) -- 默认：理赔确认
    ,inputdate varchar2(10) -- 录入日期
    ,compid varchar2(8) -- 产品编号
    ,grenclaimamt number(15,2) -- 国任理赔金额
    ,migtflag varchar2(80) -- 迁移标志
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
grant select on ${iol_schema}.icms_pph_claim_confirm_data to ${iml_schema};
grant select on ${iol_schema}.icms_pph_claim_confirm_data to ${icl_schema};
grant select on ${iol_schema}.icms_pph_claim_confirm_data to ${idl_schema};
grant select on ${iol_schema}.icms_pph_claim_confirm_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_pph_claim_confirm_data is '平安普惠理赔确认';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.loanno is '借据号';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.applno is '申请号';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.qudlay is '渠道来源';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.tradedate is '理赔处理日期';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.tradeamt is '总理赔金额';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.guaclaimamt is '担保理赔金额';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.cgiclaimamt is '产险理赔金额';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.cgiclaimmsg is '默认：理赔确认';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.inputdate is '录入日期';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.compid is '产品编号';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.grenclaimamt is '国任理赔金额';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_pph_claim_confirm_data.etl_timestamp is 'ETL处理时间戳';
