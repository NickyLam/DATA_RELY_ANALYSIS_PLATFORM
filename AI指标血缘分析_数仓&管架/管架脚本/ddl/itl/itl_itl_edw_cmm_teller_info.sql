/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_cmm_teller_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_cmm_teller_info
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_cmm_teller_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_cmm_teller_info(
    lp_id varchar2(60) -- 法人编号
    ,teller_id varchar2(100) -- 柜员编号
    ,cors_moy_box_id varchar2(100) -- 对应钱箱编号
    ,teller_name varchar2(100) -- 柜员名称
    ,teller_type_cd varchar2(30) -- 柜员类型代码
    ,teller_status_cd varchar2(30) -- 柜员状态代码
    ,teller_user_lev_cd varchar2(30) -- 柜员用户级别代码
    ,teller_prvlg_lev_cd varchar2(30) -- 柜员权限级别代码
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,jobs_cd varchar2(30) -- 岗位代码
    ,jobs_cate varchar2(10) -- 岗位类别
    ,jobs_name varchar2(100) -- 岗位名称
    ,empyt_dt date -- 入职日期
    ,cust_mgr_flg varchar2(10) -- 客户经理标志
    ,enty_teller_flg varchar2(10) -- 实体柜员标志
    ,syn_teller_flg varchar2(10) -- 综合柜员标志
    ,super_teller_flg varchar2(100) -- 超级柜员标志
    ,acct_teller_flg varchar2(10) -- 账务柜员标志
    ,prvlg_mgmt_flg varchar2(10) -- 权限管理标志
    ,director_mgmt_flg varchar2(10) -- 主管管理标志
    ,crdt_cust_mgr_flg varchar2(10) -- 信贷客户经理标志
    ,wah_kepr_flg varchar2(10) -- 库管员标志
    ,auth_flg varchar2(10) -- 授权标志
    ,auth_range varchar2(100) -- 授权范围
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
grant select on ${itl_schema}.itl_edw_cmm_teller_info to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_cmm_teller_info is '柜员信息';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.teller_id is '柜员编号';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.cors_moy_box_id is '对应钱箱编号';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.teller_name is '柜员名称';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.teller_type_cd is '柜员类型代码';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.teller_status_cd is '柜员状态代码';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.teller_user_lev_cd is '柜员用户级别代码';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.teller_prvlg_lev_cd is '柜员权限级别代码';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.belong_org_id is '所属机构编号';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.jobs_cd is '岗位代码';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.jobs_cate is '岗位类别';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.jobs_name is '岗位名称';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.empyt_dt is '入职日期';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.cust_mgr_flg is '客户经理标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.enty_teller_flg is '实体柜员标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.syn_teller_flg is '综合柜员标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.super_teller_flg is '超级柜员标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.acct_teller_flg is '账务柜员标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.prvlg_mgmt_flg is '权限管理标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.director_mgmt_flg is '主管管理标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.crdt_cust_mgr_flg is '信贷客户经理标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.wah_kepr_flg is '库管员标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.auth_flg is '授权标志';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.auth_range is '授权范围';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_cmm_teller_info.etl_timestamp is 'ETL处理时间戳';
