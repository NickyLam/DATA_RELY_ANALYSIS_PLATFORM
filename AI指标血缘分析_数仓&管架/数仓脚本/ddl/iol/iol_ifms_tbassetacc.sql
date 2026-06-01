/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbassetacc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbassetacc
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbassetacc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbassetacc(
    in_client_no varchar2(30) -- 
    ,ta_code varchar2(18) -- 
    ,asset_acc varchar2(30) -- 
    ,open_branch varchar2(80) -- 
    ,ta_client varchar2(48) -- 
    ,client_manager varchar2(48) -- 
    ,open_flag varchar2(2) -- 
    ,send_freq varchar2(2) -- 
    ,send_mode varchar2(12) -- 
    ,client_type varchar2(2) -- 
    ,prd_type varchar2(2) -- 
    ,status varchar2(2) -- 
    ,open_date number(22) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbassetacc to ${iml_schema};
grant select on ${iol_schema}.ifms_tbassetacc to ${icl_schema};
grant select on ${iol_schema}.ifms_tbassetacc to ${idl_schema};
grant select on ${iol_schema}.ifms_tbassetacc to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbassetacc is '理财账户信息表';
comment on column ${iol_schema}.ifms_tbassetacc.in_client_no is '';
comment on column ${iol_schema}.ifms_tbassetacc.ta_code is '';
comment on column ${iol_schema}.ifms_tbassetacc.asset_acc is '';
comment on column ${iol_schema}.ifms_tbassetacc.open_branch is '';
comment on column ${iol_schema}.ifms_tbassetacc.ta_client is '';
comment on column ${iol_schema}.ifms_tbassetacc.client_manager is '';
comment on column ${iol_schema}.ifms_tbassetacc.open_flag is '';
comment on column ${iol_schema}.ifms_tbassetacc.send_freq is '';
comment on column ${iol_schema}.ifms_tbassetacc.send_mode is '';
comment on column ${iol_schema}.ifms_tbassetacc.client_type is '';
comment on column ${iol_schema}.ifms_tbassetacc.prd_type is '';
comment on column ${iol_schema}.ifms_tbassetacc.status is '';
comment on column ${iol_schema}.ifms_tbassetacc.open_date is '';
comment on column ${iol_schema}.ifms_tbassetacc.reserve1 is '';
comment on column ${iol_schema}.ifms_tbassetacc.reserve2 is '';
comment on column ${iol_schema}.ifms_tbassetacc.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbassetacc.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbassetacc.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbassetacc.etl_timestamp is 'ETL处理时间戳';
