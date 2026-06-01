/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_receivable_exportrebates
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_receivable_exportrebates
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_receivable_exportrebates purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_receivable_exportrebates(
    clrid varchar2(32) -- 押品编号
    ,exportmoney number(24,6) -- 出口退税款金额
    ,tdcurrency varchar2(3) -- 币种
    ,startdate date -- 债务履行起始日
    ,duedate date -- 债务履行到期日
    ,account varchar2(60) -- 专用账户号码
    ,accountname varchar2(100) -- 专用账户名称
    ,accountowner varchar2(60) -- 账户所有者
    ,customno varchar2(60) -- 报关单编号
    ,usedtime number(38) -- 账龄
    ,isproduce varchar2(2) -- 是否由销售、出租、或提供服务产生债权
    ,isrelation2 varchar2(2) -- 是否与证券化、从属参与或信用衍生工具相关
    ,remark varchar2(4000) -- 其他说明
    ,migtflag varchar2(80) -- 迁移标识：rsrcrilcuplmim
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
grant select on ${iol_schema}.icms_clr_asset_receivable_exportrebates to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_exportrebates to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_exportrebates to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_exportrebates to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_receivable_exportrebates is '应收账款类之出口退税账户信息表';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.exportmoney is '出口退税款金额';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.startdate is '债务履行起始日';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.duedate is '债务履行到期日';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.account is '专用账户号码';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.accountname is '专用账户名称';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.accountowner is '账户所有者';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.customno is '报关单编号';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.usedtime is '账龄';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.isproduce is '是否由销售、出租、或提供服务产生债权';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.isrelation2 is '是否与证券化、从属参与或信用衍生工具相关';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.migtflag is '迁移标识：rsrcrilcuplmim';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_receivable_exportrebates.etl_timestamp is 'ETL处理时间戳';
