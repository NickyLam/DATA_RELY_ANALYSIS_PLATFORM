/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_card_bin
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_card_bin
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_card_bin purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_bin(
    card_bin varchar2(10) -- 卡bin
    ,card_type varchar2(1) -- 卡类型
    ,company varchar2(20) -- 法人
    ,libra_op_time number(15) -- libra执行次数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cups_prod_type varchar2(12) -- 银联卡产品
    ,valid_time number(5) -- 卡bin证书有效期限
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
grant select on ${iol_schema}.ncbs_cd_card_bin to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_card_bin to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_card_bin to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_card_bin to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_card_bin is '卡bin参数表';
comment on column ${iol_schema}.ncbs_cd_card_bin.card_bin is '卡bin';
comment on column ${iol_schema}.ncbs_cd_card_bin.card_type is '卡类型';
comment on column ${iol_schema}.ncbs_cd_card_bin.company is '法人';
comment on column ${iol_schema}.ncbs_cd_card_bin.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_cd_card_bin.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_card_bin.cups_prod_type is '银联卡产品';
comment on column ${iol_schema}.ncbs_cd_card_bin.valid_time is '卡bin证书有效期限';
comment on column ${iol_schema}.ncbs_cd_card_bin.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cd_card_bin.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cd_card_bin.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cd_card_bin.etl_timestamp is 'ETL处理时间戳';
