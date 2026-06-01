/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_iva_book_rclm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_iva_book_rclm
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_iva_book_rclm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_iva_book_rclm(
    vaticd varchar2(20) -- 发票代码
    ,vatino varchar2(20) -- 发票号码
    ,dealcd varchar2(20) -- 处理人
    ,deptcd varchar2(12) -- 处理机构
    ,dealdt varchar2(8) -- 处理日期
    ,status varchar2(1) -- 索票状态：0，未处理1，不索回2，已索回
    ,smrytx varchar2(200) -- 备注
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
grant select on ${iol_schema}.tgls_iva_book_rclm to ${iml_schema};
grant select on ${iol_schema}.tgls_iva_book_rclm to ${icl_schema};
grant select on ${iol_schema}.tgls_iva_book_rclm to ${idl_schema};
grant select on ${iol_schema}.tgls_iva_book_rclm to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_iva_book_rclm is '冲正索票信息';
comment on column ${iol_schema}.tgls_iva_book_rclm.vaticd is '发票代码';
comment on column ${iol_schema}.tgls_iva_book_rclm.vatino is '发票号码';
comment on column ${iol_schema}.tgls_iva_book_rclm.dealcd is '处理人';
comment on column ${iol_schema}.tgls_iva_book_rclm.deptcd is '处理机构';
comment on column ${iol_schema}.tgls_iva_book_rclm.dealdt is '处理日期';
comment on column ${iol_schema}.tgls_iva_book_rclm.status is '索票状态：0，未处理1，不索回2，已索回';
comment on column ${iol_schema}.tgls_iva_book_rclm.smrytx is '备注';
comment on column ${iol_schema}.tgls_iva_book_rclm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_iva_book_rclm.etl_timestamp is 'ETL处理时间戳';
