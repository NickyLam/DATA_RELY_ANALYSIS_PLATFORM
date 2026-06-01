/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_tax_bank_data_query
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_tax_bank_data_query
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_tax_bank_data_query purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_tax_bank_data_query(
    serialno varchar2(64) -- 流水号
    ,taxsno varchar2(64) -- 税务数据查询流水
    ,taxpayerid varchar2(64) -- 纳税人识别号
    ,enterprisename varchar2(200) -- 企业名称
    ,tokenid varchar2(100) -- 令牌
    ,biztype varchar2(20) -- 业务类型
    ,taxqueryflag varchar2(10) -- 税务查询标志(深圳/广东税务局)
    ,taxdatamajormsg varchar2(4000) -- 税务数据大报文
    ,taxdatacallrcrddtl varchar2(4000) -- 税务数据调用记录明细
    ,iscratefile varchar2(10) -- 是否生成回盘文件
    ,isinform varchar2(10) -- 是否已通知合作方
    ,filepath varchar2(1000) -- SFTP上的文件路径
    ,filename varchar2(200) -- 文件名称
    ,inputuserid varchar2(20) -- 登记人
    ,inputorgid varchar2(20) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(20) -- 更新人
    ,updateorgid varchar2(20) -- 更新机构
    ,updatedate date -- 更新日期
    ,noncestr varchar2(100) -- 请求微众流水
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
grant select on ${iol_schema}.icms_wyd_tax_bank_data_query to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_tax_bank_data_query to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_tax_bank_data_query to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_tax_bank_data_query to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_tax_bank_data_query is '微业贷税银数据查询表';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.serialno is '流水号';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.taxsno is '税务数据查询流水';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.taxpayerid is '纳税人识别号';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.enterprisename is '企业名称';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.tokenid is '令牌';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.biztype is '业务类型';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.taxqueryflag is '税务查询标志(深圳/广东税务局)';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.taxdatamajormsg is '税务数据大报文';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.taxdatacallrcrddtl is '税务数据调用记录明细';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.iscratefile is '是否生成回盘文件';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.isinform is '是否已通知合作方';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.filepath is 'SFTP上的文件路径';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.filename is '文件名称';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.noncestr is '请求微众流水';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wyd_tax_bank_data_query.etl_timestamp is 'ETL处理时间戳';
