/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbprdbankacc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbprdbankacc
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbprdbankacc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprdbankacc(
    ta_code varchar2(18) -- ta代码
    ,prd_code varchar2(32) -- 产品代码
    ,bank_no varchar2(32) -- 银行编号
    ,open_bank_ver varchar2(48) -- 验资户开户行
    ,open_bank_up varchar2(48) -- 注册登记账户开户行
    ,bank_acc_up varchar2(48) -- 上帐银行帐号
    ,bank_acc_down varchar2(48) -- 下帐银行帐号
    ,bank_acc_ver varchar2(48) -- 募集验资账户
    ,asso_code varchar2(30) -- 基金公司产品代码
    ,square_way varchar2(2) -- 结算方式
    ,bank_name varchar2(250) -- 托管银行名称
    ,branch_name varchar2(375) -- 托管机构名称
    ,prd_name varchar2(375) -- 外部产品名称
    ,bank_acc_up_name varchar2(375) -- 上帐银行帐号名称
    ,bank_acc_down_name varchar2(375) -- 下账银行帐号名称
    ,bank_acc_ver_name varchar2(375) -- 募集验资户账户名称
    ,reserve1 varchar2(375) -- 备用1
    ,reserve2 varchar2(375) -- 备用字段2
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
grant select on ${iol_schema}.nfss_tbprdbankacc to ${iml_schema};
grant select on ${iol_schema}.nfss_tbprdbankacc to ${icl_schema};
grant select on ${iol_schema}.nfss_tbprdbankacc to ${idl_schema};
grant select on ${iol_schema}.nfss_tbprdbankacc to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbprdbankacc is '产品账号表';
comment on column ${iol_schema}.nfss_tbprdbankacc.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbprdbankacc.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbprdbankacc.bank_no is '银行编号';
comment on column ${iol_schema}.nfss_tbprdbankacc.open_bank_ver is '验资户开户行';
comment on column ${iol_schema}.nfss_tbprdbankacc.open_bank_up is '注册登记账户开户行';
comment on column ${iol_schema}.nfss_tbprdbankacc.bank_acc_up is '上帐银行帐号';
comment on column ${iol_schema}.nfss_tbprdbankacc.bank_acc_down is '下帐银行帐号';
comment on column ${iol_schema}.nfss_tbprdbankacc.bank_acc_ver is '募集验资账户';
comment on column ${iol_schema}.nfss_tbprdbankacc.asso_code is '基金公司产品代码';
comment on column ${iol_schema}.nfss_tbprdbankacc.square_way is '结算方式';
comment on column ${iol_schema}.nfss_tbprdbankacc.bank_name is '托管银行名称';
comment on column ${iol_schema}.nfss_tbprdbankacc.branch_name is '托管机构名称';
comment on column ${iol_schema}.nfss_tbprdbankacc.prd_name is '外部产品名称';
comment on column ${iol_schema}.nfss_tbprdbankacc.bank_acc_up_name is '上帐银行帐号名称';
comment on column ${iol_schema}.nfss_tbprdbankacc.bank_acc_down_name is '下账银行帐号名称';
comment on column ${iol_schema}.nfss_tbprdbankacc.bank_acc_ver_name is '募集验资户账户名称';
comment on column ${iol_schema}.nfss_tbprdbankacc.reserve1 is '备用1';
comment on column ${iol_schema}.nfss_tbprdbankacc.reserve2 is '备用字段2';
comment on column ${iol_schema}.nfss_tbprdbankacc.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbprdbankacc.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbprdbankacc.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbprdbankacc.etl_timestamp is 'ETL处理时间戳';
