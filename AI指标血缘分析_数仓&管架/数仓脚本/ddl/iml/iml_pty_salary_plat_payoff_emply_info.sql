/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_salary_plat_payoff_emply_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_salary_plat_payoff_emply_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_salary_plat_payoff_emply_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_salary_plat_payoff_emply_info(
    party_id varchar2(250) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,emply_id varchar2(250) -- 员工编号
    ,emply_name varchar2(1000) -- 员工姓名
    ,postning_flg varchar2(10) -- 在职标志
    ,start_use_flg varchar2(10) -- 启用标志
    ,user_id varchar2(250) -- 用户编号
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(250) -- 证件号码
    ,gender_cd varchar2(30) -- 性别代码
    ,emply_type_cd varchar2(30) -- 员工类型代码
    ,acct_id varchar2(250) -- 账户编号
    ,tel_num varchar2(100) -- 电话号码
    ,corp_id varchar2(250) -- 企业编号
    ,postn_id varchar2(250) -- 职位编号
    ,org_id varchar2(250) -- 组织编号
    ,post_id varchar2(250) -- 岗位编号
    ,empyt_dt date -- 入职日期
    ,out_corp_flg varchar2(10) -- 退出公司标志
    ,dimission_status_cd varchar2(30) -- 离职状态代码
    ,dimission_resume_flg varchar2(10) -- 离职恢复标志
    ,jcm_stop_use_flg varchar2(10) -- 运管端停用标志
    ,batch_create_dt date -- 批次创建日期
    ,batch_update_dt date -- 批次更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_salary_plat_payoff_emply_info to ${icl_schema};
grant select on ${iml_schema}.pty_salary_plat_payoff_emply_info to ${idl_schema};
grant select on ${iml_schema}.pty_salary_plat_payoff_emply_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_salary_plat_payoff_emply_info is '薪酬平台代发员工信息';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.emply_id is '员工编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.emply_name is '员工姓名';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.postning_flg is '在职标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.start_use_flg is '启用标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.user_id is '用户编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.cert_no is '证件号码';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.gender_cd is '性别代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.emply_type_cd is '员工类型代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.acct_id is '账户编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.tel_num is '电话号码';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.corp_id is '企业编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.postn_id is '职位编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.org_id is '组织编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.post_id is '岗位编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.empyt_dt is '入职日期';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.out_corp_flg is '退出公司标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.dimission_status_cd is '离职状态代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.dimission_resume_flg is '离职恢复标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.jcm_stop_use_flg is '运管端停用标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.batch_create_dt is '批次创建日期';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.batch_update_dt is '批次更新日期';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_salary_plat_payoff_emply_info.etl_timestamp is 'ETL处理时间戳';
