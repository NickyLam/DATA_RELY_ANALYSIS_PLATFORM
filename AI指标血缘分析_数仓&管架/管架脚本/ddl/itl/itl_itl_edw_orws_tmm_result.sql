/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_orws_tmm_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_orws_tmm_result
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_orws_tmm_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_orws_tmm_result(
    id number(18,0) -- 
    ,commissioning_id number(18,0) -- 
    ,biz_date timestamp -- 
    ,biz_organ_id number(18,0) -- 
    ,biz_emp_no varchar2(50) -- 
    ,img_info varchar2(300) -- 
    ,found_date timestamp -- 
    ,handle_date timestamp -- 
    ,handle_user_id number(18,0) -- 
    ,handle_position_id number(18,0) -- 
    ,handle_organ_id number(18,0) -- 
    ,handle_result number(2,0) -- 
    ,biz_info varchar2(4000) -- 
    ,cancel_reason varchar2(300) -- 
    ,problem_id number(18,0) -- 
    ,problem_state number(1,0) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_orws_tmm_result to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_orws_tmm_result is '模型结果对象';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.commissioning_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.biz_date is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.biz_organ_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.biz_emp_no is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.img_info is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.found_date is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.handle_date is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.handle_user_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.handle_position_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.handle_organ_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.handle_result is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.biz_info is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.cancel_reason is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.problem_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.problem_state is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_orws_tmm_result.etl_timestamp is 'ETL处理时间戳';