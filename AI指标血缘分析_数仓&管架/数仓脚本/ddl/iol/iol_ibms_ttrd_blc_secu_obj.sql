/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_blc_secu_obj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_blc_secu_obj
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_blc_secu_obj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_blc_secu_obj(
    obj_id varchar2(45) -- 对象id
    ,tsk_id varchar2(45) -- 任务id
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,set_date varchar2(15) -- 结算日期
    ,ext_secu_acct_id varchar2(30) -- 外部证券账户
    ,secu_acct_id varchar2(45) -- 内部证券账户
    ,trade_grp_id varchar2(30) -- 组合交易号
    ,i_code varchar2(120) -- 金融工具代码
    ,a_type varchar2(30) -- 金融工具资产类型
    ,m_type varchar2(30) -- 金融工具市场类型
    ,blc_type number(8,0) -- 余额类型
    ,volume number(31,8) -- 余额
    ,freeze_volume number(31,8) -- 冻结余额
    ,usable_volume number(31,8) -- 可用余额
    ,open_time varchar2(29) -- 开仓时间
    ,update_time varchar2(29) -- 更新时间
    ,p_obj_id varchar2(45) -- 合约对象id
    ,volume_termcur number(31,8) -- 货币对反向余额
    ,custom_dim1 varchar2(300) -- 扩展维度1
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_blc_secu_obj to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_blc_secu_obj to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_blc_secu_obj to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_blc_secu_obj to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_blc_secu_obj is '';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.obj_id is '对象id';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.tsk_id is '任务id';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.end_date is '结束日期';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.set_date is '结算日期';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.ext_secu_acct_id is '外部证券账户';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.secu_acct_id is '内部证券账户';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.trade_grp_id is '组合交易号';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.a_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.m_type is '金融工具市场类型';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.blc_type is '余额类型';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.volume is '余额';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.freeze_volume is '冻结余额';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.usable_volume is '可用余额';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.open_time is '开仓时间';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.p_obj_id is '合约对象id';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.volume_termcur is '货币对反向余额';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.custom_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_blc_secu_obj.etl_timestamp is 'ETL处理时间戳';
