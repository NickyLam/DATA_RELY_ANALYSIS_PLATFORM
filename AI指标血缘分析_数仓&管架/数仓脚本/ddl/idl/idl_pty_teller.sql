/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl pty_teller
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.pty_teller
whenever sqlerror continue none;
drop table ${idl_schema}.pty_teller purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.pty_teller(
    etl_dt date -- 数据日期   
    ,emply_id varchar2(60) -- 员工编号   
    ,party_id varchar2(60) -- 当事人编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,belong_org_id varchar2(60) -- 所属机构编号   
    ,teller_id varchar2(60) -- 柜员编号   
    ,belong_dept_id varchar2(60) -- 归属部门编号   
    ,teller_status_cd varchar2(10) -- 柜员状态代码   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识 
    ,job_cd varchar2(10) -- 任务编码  
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.pty_teller to ${iel_schema};

-- comment
comment on table ${idl_schema}.pty_teller is '柜员';
comment on column ${idl_schema}.pty_teller.etl_dt is '数据日期';
comment on column ${idl_schema}.pty_teller.emply_id is '员工编号';
comment on column ${idl_schema}.pty_teller.party_id is '当事人编号';
comment on column ${idl_schema}.pty_teller.lp_id is '法人编号';
comment on column ${idl_schema}.pty_teller.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.pty_teller.teller_id is '柜员编号';
comment on column ${idl_schema}.pty_teller.belong_dept_id is '归属部门编号';
comment on column ${idl_schema}.pty_teller.teller_status_cd is '柜员状态代码';
comment on column ${idl_schema}.pty_teller.create_dt is '创建日期';
comment on column ${idl_schema}.pty_teller.update_dt is '更新日期';
comment on column ${idl_schema}.pty_teller.id_mark is '删除标识';