/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_val_cfg_pro_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_val_cfg_pro_info
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_val_cfg_pro_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_val_cfg_pro_info(
    v_proid varchar2(30) -- 产品码
    ,is_account varchar2(2) -- 是否入账：1是0否
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
grant select on ${iol_schema}.ifrs_val_cfg_pro_info to ${iml_schema};
grant select on ${iol_schema}.ifrs_val_cfg_pro_info to ${icl_schema};
grant select on ${iol_schema}.ifrs_val_cfg_pro_info to ${idl_schema};
grant select on ${iol_schema}.ifrs_val_cfg_pro_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_val_cfg_pro_info is '入账产品配置表';
comment on column ${iol_schema}.ifrs_val_cfg_pro_info.v_proid is '产品码';
comment on column ${iol_schema}.ifrs_val_cfg_pro_info.is_account is '是否入账：1是0否';
comment on column ${iol_schema}.ifrs_val_cfg_pro_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_val_cfg_pro_info.etl_timestamp is 'ETL处理时间戳';
