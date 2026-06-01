/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbgoldacc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbgoldacc
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbgoldacc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbgoldacc(
    in_client_no varchar2(30) -- 
    ,gold_client_no varchar2(15) -- 
    ,bank_no varchar2(3) -- 
    ,bank_acc varchar2(48) -- 
    ,client_name varchar2(375) -- 
    ,client_no varchar2(36) -- 
    ,id_type varchar2(2) -- 
    ,id_code varchar2(45) -- 
    ,branch_id varchar2(24) -- 
    ,grade_id varchar2(24) -- 
    ,area_code varchar2(24) -- 
    ,mobile varchar2(36) -- 
    ,tel varchar2(36) -- 
    ,address varchar2(375) -- 
    ,post_code varchar2(36) -- 
    ,status varchar2(2) -- 
    ,open_date number(22) -- 
    ,pre_close_date number(22) -- 
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
grant select on ${iol_schema}.ifms_tbgoldacc to ${iml_schema};
grant select on ${iol_schema}.ifms_tbgoldacc to ${icl_schema};
grant select on ${iol_schema}.ifms_tbgoldacc to ${idl_schema};
grant select on ${iol_schema}.ifms_tbgoldacc to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbgoldacc is '黄金账户协议表';
comment on column ${iol_schema}.ifms_tbgoldacc.in_client_no is '';
comment on column ${iol_schema}.ifms_tbgoldacc.gold_client_no is '';
comment on column ${iol_schema}.ifms_tbgoldacc.bank_no is '';
comment on column ${iol_schema}.ifms_tbgoldacc.bank_acc is '';
comment on column ${iol_schema}.ifms_tbgoldacc.client_name is '';
comment on column ${iol_schema}.ifms_tbgoldacc.client_no is '';
comment on column ${iol_schema}.ifms_tbgoldacc.id_type is '';
comment on column ${iol_schema}.ifms_tbgoldacc.id_code is '';
comment on column ${iol_schema}.ifms_tbgoldacc.branch_id is '';
comment on column ${iol_schema}.ifms_tbgoldacc.grade_id is '';
comment on column ${iol_schema}.ifms_tbgoldacc.area_code is '';
comment on column ${iol_schema}.ifms_tbgoldacc.mobile is '';
comment on column ${iol_schema}.ifms_tbgoldacc.tel is '';
comment on column ${iol_schema}.ifms_tbgoldacc.address is '';
comment on column ${iol_schema}.ifms_tbgoldacc.post_code is '';
comment on column ${iol_schema}.ifms_tbgoldacc.status is '';
comment on column ${iol_schema}.ifms_tbgoldacc.open_date is '';
comment on column ${iol_schema}.ifms_tbgoldacc.pre_close_date is '';
comment on column ${iol_schema}.ifms_tbgoldacc.close_date is '';
comment on column ${iol_schema}.ifms_tbgoldacc.modify_date is '';
comment on column ${iol_schema}.ifms_tbgoldacc.reserve1 is '';
comment on column ${iol_schema}.ifms_tbgoldacc.reserve2 is '';
comment on column ${iol_schema}.ifms_tbgoldacc.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbgoldacc.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbgoldacc.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbgoldacc.etl_timestamp is 'ETL处理时间戳';
