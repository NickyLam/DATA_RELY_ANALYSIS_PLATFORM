/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_acc_secu
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_acc_secu
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_acc_secu purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_secu(
    accid varchar2(45) -- 账户代码
    ,accname varchar2(180) -- 账户名称
    ,cash_accid varchar2(45) -- 二级资金账户
    ,owner varchar2(45) -- 所有者
    ,trdkind varchar2(45) -- 交易目的
    ,trdgrpid varchar2(45) -- 交易组
    ,ps1 varchar2(45) -- 证券账户属性1  理财销售账户对应理财产品i_code,其他账户则该字段为0
    ,ps2 varchar2(45) -- 证券账户属性2 对应的会计账号id
    ,ps3 varchar2(45) -- 证券账户属性3 理财产品账号对应的理财产品的外部资金账号
    ,ps4 varchar2(45) -- 证券账户属性4
    ,status number(22) -- 账户状态 0新建 11 正常 3已停用
    ,trdgrp_auto varchar2(2) -- 是否自动创建交易组
    ,is_lock number(22) -- 是否锁定
    ,lockstatus number(22) -- 锁定状态
    ,accfiscasubject varchar2(75) -- 等待补充
    ,ps5 varchar2(45) -- 等待补充
    ,ps6 varchar2(45) -- 等待补充
    ,ps7 varchar2(45) -- 等待补充
    ,ps8 varchar2(45) -- 等待补充
    ,invest_type number(22) -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,acting_type varchar2(45) -- 会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
    ,i_id number(22) -- 机构号
    ,unit_id varchar2(45) -- 
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
grant select on ${iol_schema}.ibms_ttrd_acc_secu to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_secu to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_secu to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_secu to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_acc_secu is '二级证券账户表';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.accid is '账户代码';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.accname is '账户名称';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.cash_accid is '二级资金账户';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.owner is '所有者';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.trdkind is '交易目的';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.trdgrpid is '交易组';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.ps1 is '证券账户属性1  理财销售账户对应理财产品i_code,其他账户则该字段为0';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.ps2 is '证券账户属性2 对应的会计账号id';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.ps3 is '证券账户属性3 理财产品账号对应的理财产品的外部资金账号';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.ps4 is '证券账户属性4';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.status is '账户状态 0新建 11 正常 3已停用';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.trdgrp_auto is '是否自动创建交易组';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.is_lock is '是否锁定';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.lockstatus is '锁定状态';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.accfiscasubject is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.ps5 is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.ps6 is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.ps7 is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.ps8 is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.invest_type is '0自有资产（自营业务）、1客户资产（代客、理财）';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.acting_type is '会计分类:1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.i_id is '机构号';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.unit_id is '';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_acc_secu.etl_timestamp is 'ETL处理时间戳';
