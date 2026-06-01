/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tsys_user_right
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tsys_user_right
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tsys_user_right purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_user_right(
    trans_code varchar2(48) -- 
    ,sub_trans_code varchar2(48) -- 
    ,user_id varchar2(48) -- 
    ,create_by varchar2(48) -- 
    ,create_date number(22) -- 
    ,begin_date number(22) -- 
    ,end_date number(22) -- 
    ,right_flag varchar2(12) -- 
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
grant select on ${iol_schema}.ifms_tsys_user_right to ${iml_schema};
grant select on ${iol_schema}.ifms_tsys_user_right to ${icl_schema};
grant select on ${iol_schema}.ifms_tsys_user_right to ${idl_schema};
grant select on ${iol_schema}.ifms_tsys_user_right to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tsys_user_right is '用户权限授权表';
comment on column ${iol_schema}.ifms_tsys_user_right.trans_code is '';
comment on column ${iol_schema}.ifms_tsys_user_right.sub_trans_code is '';
comment on column ${iol_schema}.ifms_tsys_user_right.user_id is '';
comment on column ${iol_schema}.ifms_tsys_user_right.create_by is '';
comment on column ${iol_schema}.ifms_tsys_user_right.create_date is '';
comment on column ${iol_schema}.ifms_tsys_user_right.begin_date is '';
comment on column ${iol_schema}.ifms_tsys_user_right.end_date is '';
comment on column ${iol_schema}.ifms_tsys_user_right.right_flag is '';
comment on column ${iol_schema}.ifms_tsys_user_right.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tsys_user_right.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tsys_user_right.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tsys_user_right.etl_timestamp is 'ETL处理时间戳';
