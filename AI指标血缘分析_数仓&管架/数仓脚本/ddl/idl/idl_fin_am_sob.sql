/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl fin_am_sob
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.fin_am_sob
whenever sqlerror continue none;
drop table ${idl_schema}.fin_am_sob purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.fin_am_sob(
    etl_dt date -- 数据日期   
    ,sob_id varchar2(60) -- 账套编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,sob_name varchar2(250) -- 账套名称   
    ,sob_fname varchar2(250) -- 账套全称   
    ,sob_cate_cd varchar2(60) -- 账套类别代码   
    ,curr_cd varchar2(60) -- 币种代码   
    ,tepla_sob_id varchar2(60) -- 模板账套编号   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.fin_am_sob to ${iel_schema};

-- comment
comment on table ${idl_schema}.fin_am_sob is '资管账套';
comment on column ${idl_schema}.fin_am_sob.etl_dt is '数据日期';
comment on column ${idl_schema}.fin_am_sob.sob_id is '账套编号';
comment on column ${idl_schema}.fin_am_sob.lp_id is '法人编号';
comment on column ${idl_schema}.fin_am_sob.sob_name is '账套名称';
comment on column ${idl_schema}.fin_am_sob.sob_fname is '账套全称';
comment on column ${idl_schema}.fin_am_sob.sob_cate_cd is '账套类别代码';
comment on column ${idl_schema}.fin_am_sob.curr_cd is '币种代码';
comment on column ${idl_schema}.fin_am_sob.tepla_sob_id is '模板账套编号';
comment on column ${idl_schema}.fin_am_sob.create_dt is '创建日期';
comment on column ${idl_schema}.fin_am_sob.update_dt is '更新日期';
comment on column ${idl_schema}.fin_am_sob.id_mark is '删除标识';