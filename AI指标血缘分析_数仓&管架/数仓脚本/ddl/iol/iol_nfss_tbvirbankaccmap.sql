/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbvirbankaccmap
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbvirbankaccmap
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbvirbankaccmap purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbvirbankaccmap(
    vir_bank_acc varchar2(48) -- 北向通账号
    ,bank_no varchar2(32) -- 内部银行编号
    ,bank_acc varchar2(64) -- 银行帐号
    ,in_client_no varchar2(30) -- 内部客户号
    ,open_branch varchar2(80) -- 开户机构
    ,open_date number(22,0) -- 开户日期
    ,channel varchar2(2) -- 渠道
    ,vir_type varchar2(5) -- 虚拟帐号类型
    ,amt1 number(22,3) -- 金额1
    ,amt2 number(22,3) -- 金额2
    ,reserve1 varchar2(375) -- 备注1
    ,reserve2 varchar2(375) -- 备注2
    ,reserve3 varchar2(375) -- 备注3
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
grant select on ${iol_schema}.nfss_tbvirbankaccmap to ${iml_schema};
grant select on ${iol_schema}.nfss_tbvirbankaccmap to ${icl_schema};
grant select on ${iol_schema}.nfss_tbvirbankaccmap to ${idl_schema};
grant select on ${iol_schema}.nfss_tbvirbankaccmap to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbvirbankaccmap is '虚拟账户映射表';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.vir_bank_acc is '北向通账号';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.bank_no is '内部银行编号';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.bank_acc is '银行帐号';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.in_client_no is '内部客户号';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.open_branch is '开户机构';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.open_date is '开户日期';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.channel is '渠道';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.vir_type is '虚拟帐号类型';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.amt1 is '金额1';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.amt2 is '金额2';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.reserve1 is '备注1';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.reserve2 is '备注2';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.reserve3 is '备注3';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbvirbankaccmap.etl_timestamp is 'ETL处理时间戳';
