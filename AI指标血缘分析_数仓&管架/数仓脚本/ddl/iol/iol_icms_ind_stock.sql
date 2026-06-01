/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_stock
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_stock
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_stock purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_stock(
    serialno varchar2(64) -- 流水号
    ,remark varchar2(1000) -- 备注
    ,stockmount number(22) -- 股票数量
    ,inputdate date -- 登记日期
    ,stockname varchar2(160) -- 股票名称
    ,inputuserid varchar2(64) -- 登记人
    ,stockcurrency varchar2(3) -- 股票币种股票币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
    ,marketvalue number(24,6) -- 股票市值
    ,uptodate date -- 统计截止日期
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,migtflag varchar2(80) -- 
    ,updateorgid varchar2(64) -- 更新机构
    ,stockno varchar2(64) -- 股票代码
    ,stocktype varchar2(36) -- 股票类型股票类型（代码：1-法人股2-流通股）
    ,corporgid varchar2(64) -- 法人机构编号
    ,customerid varchar2(16) -- 客户编号
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
grant select on ${iol_schema}.icms_ind_stock to ${iml_schema};
grant select on ${iol_schema}.icms_ind_stock to ${icl_schema};
grant select on ${iol_schema}.icms_ind_stock to ${idl_schema};
grant select on ${iol_schema}.icms_ind_stock to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_stock is '持有股票持有股票信息';
comment on column ${iol_schema}.icms_ind_stock.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_stock.remark is '备注';
comment on column ${iol_schema}.icms_ind_stock.stockmount is '股票数量';
comment on column ${iol_schema}.icms_ind_stock.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_stock.stockname is '股票名称';
comment on column ${iol_schema}.icms_ind_stock.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_stock.stockcurrency is '股票币种股票币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)';
comment on column ${iol_schema}.icms_ind_stock.marketvalue is '股票市值';
comment on column ${iol_schema}.icms_ind_stock.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_ind_stock.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_stock.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_stock.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_stock.migtflag is '';
comment on column ${iol_schema}.icms_ind_stock.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_stock.stockno is '股票代码';
comment on column ${iol_schema}.icms_ind_stock.stocktype is '股票类型股票类型（代码：1-法人股2-流通股）';
comment on column ${iol_schema}.icms_ind_stock.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_stock.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_stock.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_stock.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_stock.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_stock.etl_timestamp is 'ETL处理时间戳';
