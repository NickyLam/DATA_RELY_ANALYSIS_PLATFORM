/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_gold
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_gold
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_gold purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_gold(
    clrid varchar2(32) -- 押品编号
    ,ismaterial varchar2(2) -- 是否为实物贵金属
    ,voucherno varchar2(100) -- 实物入库凭证号
    ,registno varchar2(200) -- 交易所质押登记号
    ,collorg varchar2(100) -- 非实物托管单位名称
    ,quality number(24,6) -- 质量
    ,unit varchar2(2) -- 质量单位
    ,unitprice number(24,6) -- 贵金属单位价值(元)
    ,currency varchar2(3) -- 币种
    ,remark varchar2(4000) -- 其他说明
    ,goldtype varchar2(30) -- 贵金属类别
    ,grade varchar2(4) -- 品种/等级
    ,graderemark varchar2(100) -- 品种/等级描述
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_asset_finance_gold to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_gold to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_gold to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_gold to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_gold is '金融质押品之贵金属信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.ismaterial is '是否为实物贵金属';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.voucherno is '实物入库凭证号';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.registno is '交易所质押登记号';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.collorg is '非实物托管单位名称';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.quality is '质量';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.unit is '质量单位';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.unitprice is '贵金属单位价值(元)';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.currency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.goldtype is '贵金属类别';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.grade is '品种/等级';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.graderemark is '品种/等级描述';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_gold.etl_timestamp is 'ETL处理时间戳';
