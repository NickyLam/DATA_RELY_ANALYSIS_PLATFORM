/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_wld_fdm_vouchertemp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_wld_fdm_vouchertemp
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_wld_fdm_vouchertemp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_wld_fdm_vouchertemp(
    subject convert_error -- 科目
    ,productcd convert_error -- 产品编码
    ,ccy convert_error -- 币种 156=cny
    ,trandt convert_error -- 交易日期
    ,hostdt convert_error -- 记账日期
    ,opnbrch convert_error -- 开户机构
    ,trnbtch convert_error -- 交易机构
    ,postamt convert_error -- 金额
    ,systenid convert_error -- 系统
    ,chnlid convert_error -- 渠道
    ,glbseq convert_error -- 全局渠道流水
    ,seqno convert_error -- 交易流水
    ,robcksq convert_error -- 冲销流水
    ,redflag convert_error -- 是否冲销 1-冲销
    ,card_no convert_error -- 账号
    ,overdueflg convert_error -- 逾期标识 0正常
    ,dbcrind convert_error -- 借贷标识
    ,etl_dt_ora convert_error -- 
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
grant select on ${iol_schema}.mpcs_wld_fdm_vouchertemp to ${iml_schema};
grant select on ${iol_schema}.mpcs_wld_fdm_vouchertemp to ${icl_schema};
grant select on ${iol_schema}.mpcs_wld_fdm_vouchertemp to ${idl_schema};
grant select on ${iol_schema}.mpcs_wld_fdm_vouchertemp to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_wld_fdm_vouchertemp is '微粒贷供FDM分录明细文件';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.subject is '科目';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.productcd is '产品编码';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.ccy is '币种 156=cny';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.trandt is '交易日期';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.hostdt is '记账日期';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.opnbrch is '开户机构';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.trnbtch is '交易机构';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.postamt is '金额';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.systenid is '系统';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.chnlid is '渠道';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.glbseq is '全局渠道流水';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.seqno is '交易流水';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.robcksq is '冲销流水';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.redflag is '是否冲销 1-冲销';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.card_no is '账号';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.overdueflg is '逾期标识 0正常';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.dbcrind is '借贷标识';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.etl_dt_ora is '';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_wld_fdm_vouchertemp.etl_timestamp is 'ETL处理时间戳';
