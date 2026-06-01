/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_dir_mcht_mcc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_dir_mcht_mcc
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_dir_mcht_mcc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_dir_mcht_mcc(
    mcc_id varchar2(9) -- 业务类型ID
    ,mcc_disc varchar2(150) -- 业务类型描述
    ,mcc_rate number(22,0) -- 回扣率
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
grant select on ${iol_schema}.mrms_tbl_dir_mcht_mcc to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_dir_mcht_mcc to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_dir_mcht_mcc to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_dir_mcht_mcc to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_dir_mcht_mcc is '商户业务类别表';
comment on column ${iol_schema}.mrms_tbl_dir_mcht_mcc.mcc_id is '业务类型ID';
comment on column ${iol_schema}.mrms_tbl_dir_mcht_mcc.mcc_disc is '业务类型描述';
comment on column ${iol_schema}.mrms_tbl_dir_mcht_mcc.mcc_rate is '回扣率';
comment on column ${iol_schema}.mrms_tbl_dir_mcht_mcc.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mrms_tbl_dir_mcht_mcc.etl_timestamp is 'ETL处理时间戳';
