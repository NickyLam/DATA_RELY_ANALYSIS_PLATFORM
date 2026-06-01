/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_receivable_rent
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_receivable_rent
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_receivable_rent purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_receivable_rent(
    clrid varchar2(32) -- 押品编号
    ,renttime number(38,0) -- 每年收租次数
    ,renttype varchar2(2) -- 租金类型
    ,tdcurrency varchar2(3) -- 币种
    ,rentmoney number(24,6) -- 每次收取的固定租金金额
    ,descibe varchar2(400) -- 每次收取的浮动租金金额描述
    ,startdate date -- 租约开始日期
    ,duedate date -- 租约结束日期
    ,isnotice varchar2(2) -- 是否通知应收账款义务人
    ,isproduce varchar2(2) -- 是否由销售、出租、或提供服务产生债权
    ,isrelation2 varchar2(2) -- 是否与证券化、从属参与或信用衍生工具相关
    ,remark varchar2(4000) -- 其他说明
    ,leasecontract varchar2(50) -- 租约合同号
    ,frequency varchar2(100) -- 收租频率
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,guarantyregno varchar2(32) -- 抵押登记编号
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
grant select on ${iol_schema}.icms_clr_asset_receivable_rent to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_rent to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_rent to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_rent to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_receivable_rent is '应收账款类之应收租金信息表';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.renttime is '每年收租次数';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.renttype is '租金类型';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.rentmoney is '每次收取的固定租金金额';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.descibe is '每次收取的浮动租金金额描述';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.startdate is '租约开始日期';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.duedate is '租约结束日期';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.isnotice is '是否通知应收账款义务人';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.isproduce is '是否由销售、出租、或提供服务产生债权';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.isrelation2 is '是否与证券化、从属参与或信用衍生工具相关';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.leasecontract is '租约合同号';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.frequency is '收租频率';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.guarantyregno is '抵押登记编号';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_receivable_rent.etl_timestamp is 'ETL处理时间戳';
