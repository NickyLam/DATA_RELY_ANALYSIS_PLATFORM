/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_tax_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_tax_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_tax_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_tax_data(
    serialno varchar2(64) -- 流水号
    ,taxseqno varchar2(100) -- 涉税流水号
    ,corptaxbursite varchar2(10) -- 企业税务局所在地(1-广东；2-深圳)
    ,taxburauthseqnum varchar2(200) -- 税局授权流水号
    ,taxpayerid varchar2(64) -- 纳税人识别号
    ,callcnt number(12,0) -- 调用次数
    ,fkseqno varchar2(100) -- 放款流水号
    ,inputuserid varchar2(20) -- 登记人
    ,inputorgid varchar2(20) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(20) -- 更新人
    ,updateorgid varchar2(20) -- 更新机构
    ,updatedate date -- 更新日期
    ,wzurl varchar2(800) -- 微众url
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
grant select on ${iol_schema}.icms_wyd_tax_data to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_tax_data to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_tax_data to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_tax_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_tax_data is '微业贷涉税数据表';
comment on column ${iol_schema}.icms_wyd_tax_data.serialno is '流水号';
comment on column ${iol_schema}.icms_wyd_tax_data.taxseqno is '涉税流水号';
comment on column ${iol_schema}.icms_wyd_tax_data.corptaxbursite is '企业税务局所在地(1-广东；2-深圳)';
comment on column ${iol_schema}.icms_wyd_tax_data.taxburauthseqnum is '税局授权流水号';
comment on column ${iol_schema}.icms_wyd_tax_data.taxpayerid is '纳税人识别号';
comment on column ${iol_schema}.icms_wyd_tax_data.callcnt is '调用次数';
comment on column ${iol_schema}.icms_wyd_tax_data.fkseqno is '放款流水号';
comment on column ${iol_schema}.icms_wyd_tax_data.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_tax_data.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wyd_tax_data.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wyd_tax_data.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_tax_data.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_tax_data.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_tax_data.wzurl is '微众url';
comment on column ${iol_schema}.icms_wyd_tax_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wyd_tax_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wyd_tax_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wyd_tax_data.etl_timestamp is 'ETL处理时间戳';
