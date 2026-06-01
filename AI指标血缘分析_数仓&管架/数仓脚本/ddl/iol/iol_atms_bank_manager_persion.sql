/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_bank_manager_persion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_bank_manager_persion
whenever sqlerror continue none;
drop table ${iol_schema}.atms_bank_manager_persion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_bank_manager_persion(
    no varchar2(20) -- 用户ID
    ,name varchar2(40) -- 用户姓名
    ,org_no varchar2(20) -- 所属机构
    ,phone varchar2(20) -- 办公电话
    ,mobile varchar2(20) -- 手机号码
    ,email varchar2(40) -- 电子邮件
    ,is_leader varchar2(1) -- 是否是网点经理
    ,is_lobbymanager varchar2(1) -- 是否是大堂经理
    ,is_devmanager varchar2(1) -- 是否是设备管机员
    ,is_deskmanager varchar2(1) -- 是否是柜台人员
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
grant select on ${iol_schema}.atms_bank_manager_persion to ${iml_schema};
grant select on ${iol_schema}.atms_bank_manager_persion to ${icl_schema};
grant select on ${iol_schema}.atms_bank_manager_persion to ${idl_schema};
grant select on ${iol_schema}.atms_bank_manager_persion to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_bank_manager_persion is '银行网点人员表';
comment on column ${iol_schema}.atms_bank_manager_persion.no is '用户ID';
comment on column ${iol_schema}.atms_bank_manager_persion.name is '用户姓名';
comment on column ${iol_schema}.atms_bank_manager_persion.org_no is '所属机构';
comment on column ${iol_schema}.atms_bank_manager_persion.phone is '办公电话';
comment on column ${iol_schema}.atms_bank_manager_persion.mobile is '手机号码';
comment on column ${iol_schema}.atms_bank_manager_persion.email is '电子邮件';
comment on column ${iol_schema}.atms_bank_manager_persion.is_leader is '是否是网点经理';
comment on column ${iol_schema}.atms_bank_manager_persion.is_lobbymanager is '是否是大堂经理';
comment on column ${iol_schema}.atms_bank_manager_persion.is_devmanager is '是否是设备管机员';
comment on column ${iol_schema}.atms_bank_manager_persion.is_deskmanager is '是否是柜台人员';
comment on column ${iol_schema}.atms_bank_manager_persion.start_dt is '开始时间';
comment on column ${iol_schema}.atms_bank_manager_persion.end_dt is '结束时间';
comment on column ${iol_schema}.atms_bank_manager_persion.id_mark is '增删标志';
comment on column ${iol_schema}.atms_bank_manager_persion.etl_timestamp is 'ETL处理时间戳';
