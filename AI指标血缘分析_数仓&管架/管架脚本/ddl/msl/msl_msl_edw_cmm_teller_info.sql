/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cmm_teller_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_teller_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_teller_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_teller_info(
    etl_dt date
    ,lp_id varchar2(60)
    ,teller_id varchar2(100)
    ,teller_name varchar2(100)
    ,teller_type_cd varchar2(30)
    ,teller_status_cd varchar2(30)
    ,teller_user_lev_cd varchar2(30)
    ,teller_prvlg_lev_cd varchar2(30)
    ,belong_org_id varchar2(100)
    ,jobs_cd varchar2(30)
    ,jobs_cate varchar2(10)
    ,jobs_name varchar2(100)
    ,empyt_dt date
    ,cust_mgr_flg varchar2(10)
    ,enty_teller_flg varchar2(10)
    ,syn_teller_flg varchar2(10)
    ,super_teller_flg varchar2(100)
    ,acct_teller_flg varchar2(10)
    ,prvlg_mgmt_flg varchar2(10)
    ,director_mgmt_flg varchar2(10)
    ,crdt_cust_mgr_flg varchar2(10)
    ,wah_kepr_flg varchar2(10)
    ,auth_flg varchar2(10)
    ,auth_range varchar2(100)
    ,cors_moy_box_id varchar2(100)
    ,teller_type_subclass_cd varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_teller_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_teller_info is '柜员信息';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.teller_id is '柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.teller_name is '柜员名称';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.teller_type_cd is '柜员类型代码';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.teller_status_cd is '柜员状态代码';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.teller_user_lev_cd is '柜员用户级别代码';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.teller_prvlg_lev_cd is '柜员权限级别代码';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.belong_org_id is '所属机构编号';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.jobs_cd is '岗位代码';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.jobs_cate is '岗位类别';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.jobs_name is '岗位名称';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.empyt_dt is '入职日期';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.cust_mgr_flg is '客户经理标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.enty_teller_flg is '实体柜员标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.syn_teller_flg is '综合柜员标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.super_teller_flg is '超级柜员标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.acct_teller_flg is '账务柜员标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.prvlg_mgmt_flg is '权限管理标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.director_mgmt_flg is '主管管理标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.crdt_cust_mgr_flg is '信贷客户经理标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.wah_kepr_flg is '库管员标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.auth_flg is '授权标志';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.auth_range is '授权范围';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.cors_moy_box_id is '对应钱箱编号';
comment on column ${msl_schema}.msl_edw_cmm_teller_info.teller_type_subclass_cd is '柜员类型细类代码';
