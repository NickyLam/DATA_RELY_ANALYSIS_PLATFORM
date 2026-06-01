/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_receivable_accounts
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_receivable_accounts
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_receivable_accounts purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_receivable_accounts(
    clrid varchar2(32) -- 押品编号
    ,creditno varchar2(30) -- 信用证号码
    ,faceamount number(24,6) -- 应收账款金额/信用证金额(票面金额)
    ,tdcurrency varchar2(3) -- 币种
    ,billno varchar2(60) -- 发票编号
    ,startdate date -- 发票日期
    ,duedate date -- 发票到期日
    ,payor varchar2(100) -- 付款人名称
    ,payoraccount varchar2(120) -- 付款人账号
    ,ishandle varchar2(2) -- 是否被破产清算
    ,isnotice varchar2(2) -- 是否通知应收账款义务人
    ,isproduce varchar2(2) -- 是否由销售、出租、或提供服务产生债权
    ,isrelation2 varchar2(2) -- 是否与证券化、从属参与或信用衍生工具相关
    ,remark varchar2(4000) -- 其他说明
    ,usedtime number(38,0) -- 账龄
    ,payee number(24,6) -- 应收账款收款人名称
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,applyusername varchar2(200) -- 开证申请人名称
    ,benefitusername varchar2(200) -- 受益人名称
    ,registcountry varchar2(60) -- 开证行所在国家或地区
    ,guarantyregno varchar2(32) -- 人行质押登记证明编号
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
grant select on ${iol_schema}.icms_clr_asset_receivable_accounts to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_accounts to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_accounts to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_accounts to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_receivable_accounts is '应收账款类之应收账款信息表';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.creditno is '信用证号码';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.faceamount is '应收账款金额/信用证金额(票面金额)';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.billno is '发票编号';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.startdate is '发票日期';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.duedate is '发票到期日';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.payor is '付款人名称';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.payoraccount is '付款人账号';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.ishandle is '是否被破产清算';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.isnotice is '是否通知应收账款义务人';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.isproduce is '是否由销售、出租、或提供服务产生债权';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.isrelation2 is '是否与证券化、从属参与或信用衍生工具相关';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.usedtime is '账龄';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.payee is '应收账款收款人名称';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.applyusername is '开证申请人名称';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.benefitusername is '受益人名称';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.registcountry is '开证行所在国家或地区';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.guarantyregno is '人行质押登记证明编号';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_receivable_accounts.etl_timestamp is 'ETL处理时间戳';
