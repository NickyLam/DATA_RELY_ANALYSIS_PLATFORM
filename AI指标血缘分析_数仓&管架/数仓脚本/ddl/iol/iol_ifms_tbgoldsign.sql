/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbgoldsign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbgoldsign
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbgoldsign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbgoldsign(
    in_client_no varchar2(30) -- 
    ,bank_acc varchar2(48) -- 
    ,gold_client_no varchar2(30) -- 
    ,center_code varchar2(36) -- 
    ,bank_no varchar2(3) -- 
    ,client_no varchar2(36) -- 
    ,client_name varchar2(375) -- 
    ,id_type varchar2(2) -- 
    ,id_code varchar2(45) -- 
    ,curr_type varchar2(5) -- 
    ,status varchar2(2) -- 
    ,open_date number(22) -- 
    ,close_date number(22) -- 
    ,modify_date number(22) -- 
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
grant select on ${iol_schema}.ifms_tbgoldsign to ${iml_schema};
grant select on ${iol_schema}.ifms_tbgoldsign to ${icl_schema};
grant select on ${iol_schema}.ifms_tbgoldsign to ${idl_schema};
grant select on ${iol_schema}.ifms_tbgoldsign to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbgoldsign is '黄金签约协议表';
comment on column ${iol_schema}.ifms_tbgoldsign.in_client_no is '';
comment on column ${iol_schema}.ifms_tbgoldsign.bank_acc is '';
comment on column ${iol_schema}.ifms_tbgoldsign.gold_client_no is '';
comment on column ${iol_schema}.ifms_tbgoldsign.center_code is '';
comment on column ${iol_schema}.ifms_tbgoldsign.bank_no is '';
comment on column ${iol_schema}.ifms_tbgoldsign.client_no is '';
comment on column ${iol_schema}.ifms_tbgoldsign.client_name is '';
comment on column ${iol_schema}.ifms_tbgoldsign.id_type is '';
comment on column ${iol_schema}.ifms_tbgoldsign.id_code is '';
comment on column ${iol_schema}.ifms_tbgoldsign.curr_type is '';
comment on column ${iol_schema}.ifms_tbgoldsign.status is '';
comment on column ${iol_schema}.ifms_tbgoldsign.open_date is '';
comment on column ${iol_schema}.ifms_tbgoldsign.close_date is '';
comment on column ${iol_schema}.ifms_tbgoldsign.modify_date is '';
comment on column ${iol_schema}.ifms_tbgoldsign.reserve1 is '';
comment on column ${iol_schema}.ifms_tbgoldsign.reserve2 is '';
comment on column ${iol_schema}.ifms_tbgoldsign.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbgoldsign.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbgoldsign.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbgoldsign.etl_timestamp is 'ETL处理时间戳';
