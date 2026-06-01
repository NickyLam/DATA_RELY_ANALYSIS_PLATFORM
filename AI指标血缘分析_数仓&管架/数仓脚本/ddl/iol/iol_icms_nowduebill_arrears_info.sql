/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_nowduebill_arrears_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_nowduebill_arrears_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_nowduebill_arrears_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_nowduebill_arrears_info(
    serialno varchar2(40) -- 流水号
    ,arrearsdate varchar2(18) -- 入账日期
    ,currentbalance number(18,2) -- 当前余额
    ,balanceserialno varchar2(20) -- 余额序号
    ,duebillflag varchar2(2) -- 借据状态
    ,duebillno varchar2(40) -- 借据号
    ,balancemoduletype varchar2(2) -- 余额组件类型
    ,arrearssum number(18,2) -- 入账金额
    ,interesttype varchar2(2) -- 利息类别
    ,lastinterest number(18,2) -- 当期未结余额
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
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
grant select on ${iol_schema}.icms_nowduebill_arrears_info to ${iml_schema};
grant select on ${iol_schema}.icms_nowduebill_arrears_info to ${icl_schema};
grant select on ${iol_schema}.icms_nowduebill_arrears_info to ${idl_schema};
grant select on ${iol_schema}.icms_nowduebill_arrears_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_nowduebill_arrears_info is '欠款记录表';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.serialno is '流水号';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.arrearsdate is '入账日期';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.currentbalance is '当前余额';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.balanceserialno is '余额序号';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.duebillflag is '借据状态';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.duebillno is '借据号';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.balancemoduletype is '余额组件类型';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.arrearssum is '入账金额';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.interesttype is '利息类别';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.lastinterest is '当期未结余额';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_nowduebill_arrears_info.etl_timestamp is 'ETL处理时间戳';
