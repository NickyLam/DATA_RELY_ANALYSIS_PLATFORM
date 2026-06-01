/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_ncbs_lpdc_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_ncbs_lpdc_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_ncbs_lpdc_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_ncbs_lpdc_info(
    reference varchar2(50) -- 交易流水号
    ,compensatedate varchar2(8) -- 代偿日期
    ,compensateamt number(17,2) -- 代偿金额
    ,compensatepriamt number(17,2) -- 代偿本金
    ,compensateintamt number(17,2) -- 代偿利息
    ,compensatedueodpamt number(17,2) -- 代偿逾期罚息
    ,compensateway varchar2(10) -- 代偿方式
    ,cmisloanno varchar2(30) -- 借据号
    ,guarcompensateacctno varchar2(50) -- 代偿清算账户
    ,compensatereceiptamt number(17,2) -- 代偿账户扣收金额
    ,guarcompensatetype varchar2(10) -- 代偿清算类型
    ,compensateratio number(5,2) -- 代偿比例
    ,guarcompensateamt number(17,2) -- 应代偿金额
    ,guarcompensatestatus varchar2(1) -- 处理标识
    ,acctbalance number(17,2) -- 借据余额（尚欠本金
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
grant select on ${iol_schema}.icms_tmp_ncbs_lpdc_info to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_ncbs_lpdc_info to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_ncbs_lpdc_info to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_ncbs_lpdc_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_ncbs_lpdc_info is '理赔代偿中间表';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.reference is '交易流水号';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.compensatedate is '代偿日期';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.compensateamt is '代偿金额';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.compensatepriamt is '代偿本金';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.compensateintamt is '代偿利息';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.compensatedueodpamt is '代偿逾期罚息';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.compensateway is '代偿方式';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.cmisloanno is '借据号';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.guarcompensateacctno is '代偿清算账户';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.compensatereceiptamt is '代偿账户扣收金额';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.guarcompensatetype is '代偿清算类型';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.compensateratio is '代偿比例';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.guarcompensateamt is '应代偿金额';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.guarcompensatestatus is '处理标识';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.acctbalance is '借据余额（尚欠本金';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_ncbs_lpdc_info.etl_timestamp is 'ETL处理时间戳';
