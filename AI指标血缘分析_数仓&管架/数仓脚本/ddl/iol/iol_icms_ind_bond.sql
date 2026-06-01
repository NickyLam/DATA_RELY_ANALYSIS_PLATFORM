/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_bond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_bond
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_bond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_bond(
    serialno varchar2(64) -- 流水号
    ,inputorgid varchar2(64) -- 登记机构
    ,bondsum number(24,6) -- 购买总价格
    ,enddate date -- 债券到期日期
    ,bondtype varchar2(2) -- 债券类型债券类型（代码：1-企业债券2-公司债券3-金融债券4-可转换债券5-国际债券6-离岸债券）
    ,customerid varchar2(16) -- 客户编号
    ,uptodate date -- 统计截止日期
    ,bondno varchar2(64) -- 债券号债券编号
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新时间
    ,remark varchar2(1000) -- 备注
    ,bondcurrency varchar2(3) -- 币种币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
    ,corporgid varchar2(64) -- 法人机构编号
    ,bondname varchar2(160) -- 债券名称
    ,begindate date -- 债券起始日期
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
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
grant select on ${iol_schema}.icms_ind_bond to ${iml_schema};
grant select on ${iol_schema}.icms_ind_bond to ${icl_schema};
grant select on ${iol_schema}.icms_ind_bond to ${idl_schema};
grant select on ${iol_schema}.icms_ind_bond to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_bond is '持有债券持有债券情况';
comment on column ${iol_schema}.icms_ind_bond.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_bond.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_bond.bondsum is '购买总价格';
comment on column ${iol_schema}.icms_ind_bond.enddate is '债券到期日期';
comment on column ${iol_schema}.icms_ind_bond.bondtype is '债券类型债券类型（代码：1-企业债券2-公司债券3-金融债券4-可转换债券5-国际债券6-离岸债券）';
comment on column ${iol_schema}.icms_ind_bond.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_bond.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_ind_bond.bondno is '债券号债券编号';
comment on column ${iol_schema}.icms_ind_bond.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_bond.updatedate is '更新时间';
comment on column ${iol_schema}.icms_ind_bond.remark is '备注';
comment on column ${iol_schema}.icms_ind_bond.bondcurrency is '币种币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)';
comment on column ${iol_schema}.icms_ind_bond.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_bond.bondname is '债券名称';
comment on column ${iol_schema}.icms_ind_bond.begindate is '债券起始日期';
comment on column ${iol_schema}.icms_ind_bond.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_bond.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_bond.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_bond.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_bond.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_bond.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_bond.etl_timestamp is 'ETL处理时间戳';
