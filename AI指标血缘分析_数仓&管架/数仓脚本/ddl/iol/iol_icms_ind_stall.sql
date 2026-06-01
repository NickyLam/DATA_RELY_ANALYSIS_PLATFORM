/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_stall
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_stall
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_stall purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_stall(
    serialno varchar2(64) -- 流水号
    ,updatedate date -- 更新日期
    ,purchaseprice number(24,6) -- 买入/租赁价格
    ,updateorgid varchar2(64) -- 更新机构
    ,certificateno varchar2(64) -- 产权证号
    ,stallname varchar2(64) -- 摊位/厂房名称
    ,evaluatevalue number(24,6) -- 评估价格
    ,inputuserid varchar2(64) -- 登记人
    ,uptodate date -- 统计截止时间
    ,inputdate date -- 登记日期
    ,insurecompany varchar2(64) -- 投保公司
    ,stallarea number(18,2) -- 摊位/厂房面积
    ,remark varchar2(1000) -- 备注
    ,pledgestatus varchar2(1000) -- 抵押情况抵押情况（代码：1-有抵押2-无抵押）
    ,updateuserid varchar2(64) -- 更新人
    ,corporgid varchar2(64) -- 法人机构编号
    ,stallnature varchar2(36) -- 摊位/厂房性质摊位/厂房性质（代码：1-自有2-租赁）
    ,stalladd varchar2(400) -- 摊位/厂房地址
    ,inputorgid varchar2(64) -- 登记机构
    ,customerid varchar2(16) -- 客户编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,purchasedate date -- 买入/租赁日期
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
grant select on ${iol_schema}.icms_ind_stall to ${iml_schema};
grant select on ${iol_schema}.icms_ind_stall to ${icl_schema};
grant select on ${iol_schema}.icms_ind_stall to ${idl_schema};
grant select on ${iol_schema}.icms_ind_stall to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_stall is '个人摊位厂房信息个人摊位厂房信息';
comment on column ${iol_schema}.icms_ind_stall.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_stall.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_stall.purchaseprice is '买入/租赁价格';
comment on column ${iol_schema}.icms_ind_stall.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_stall.certificateno is '产权证号';
comment on column ${iol_schema}.icms_ind_stall.stallname is '摊位/厂房名称';
comment on column ${iol_schema}.icms_ind_stall.evaluatevalue is '评估价格';
comment on column ${iol_schema}.icms_ind_stall.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_stall.uptodate is '统计截止时间';
comment on column ${iol_schema}.icms_ind_stall.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_stall.insurecompany is '投保公司';
comment on column ${iol_schema}.icms_ind_stall.stallarea is '摊位/厂房面积';
comment on column ${iol_schema}.icms_ind_stall.remark is '备注';
comment on column ${iol_schema}.icms_ind_stall.pledgestatus is '抵押情况抵押情况（代码：1-有抵押2-无抵押）';
comment on column ${iol_schema}.icms_ind_stall.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_stall.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_stall.stallnature is '摊位/厂房性质摊位/厂房性质（代码：1-自有2-租赁）';
comment on column ${iol_schema}.icms_ind_stall.stalladd is '摊位/厂房地址';
comment on column ${iol_schema}.icms_ind_stall.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_stall.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_stall.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ind_stall.purchasedate is '买入/租赁日期';
comment on column ${iol_schema}.icms_ind_stall.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_stall.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_stall.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_stall.etl_timestamp is 'ETL处理时间戳';
