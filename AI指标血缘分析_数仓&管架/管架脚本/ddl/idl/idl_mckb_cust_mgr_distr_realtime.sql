/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_cust_mgr_distr_realtime
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_cust_mgr_distr_realtime
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_cust_mgr_distr_realtime purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_cust_mgr_distr_realtime(
    ped_no varchar2(10) -- 周期编号(099累计 001当日 002当月 003当季 004当年 005当周）
    ,ped_name varchar2(20) -- 周期名称
    ,rank number(10) -- 排名
    ,org_no varchar2(50) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,mgr_no varchar2(50) -- 客户经理编号
    ,mgr_name varchar2(200) -- 客户经理名称
    ,distr_amt number(38,8) -- 放款金额
    ,lp_cls_id varchar2(10) -- 法人分类编号（1企业 2个人 0合计）
    ,lp_cls_name varchar2(20) -- 法人分类名称
    ,create_date date -- 系统开通权限时间
    ,lp_cls_prod varchar2(10) -- 产品分类(1是IPC/2是数据贷/0是IPC+数据贷)
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
grant select on ${idl_schema}.mckb_cust_mgr_distr_realtime to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_cust_mgr_distr_realtime is '客户经理放款看板_准实时';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.ped_no is '周期编号(099累计 001当日 002当月 003当季 004当年 005当周）';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.ped_name is '周期名称';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.rank is '排名';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.org_no is '机构编号';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.org_name is '机构名称';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.mgr_no is '客户经理编号';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.mgr_name is '客户经理名称';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.distr_amt is '放款金额';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.lp_cls_id is '法人分类编号（1企业 2个人 0合计）';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.lp_cls_name is '法人分类名称';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.create_date is '系统开通权限时间';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.lp_cls_prod is '产品分类(1是IPC/2是数据贷/0是IPC+数据贷)';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_cust_mgr_distr_realtime.etl_timestamp is 'ETL处理时间戳';